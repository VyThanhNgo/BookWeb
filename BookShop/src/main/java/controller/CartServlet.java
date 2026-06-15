package controller;

import dao.BookDAO;
import dao.CartDAO;
import model.Book;
import model.Cart;
import model.CartItem;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private Cart getOrCreateCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private User getLoggedInUser(HttpSession session) {
        if (session == null) return null;
        return (User) session.getAttribute("loggedInUser");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        // doGet chỉ hiển thị giỏ hàng. Các hành động thay đổi trạng thái
        // (remove/clear) đã chuyển sang doPost để tránh thay đổi dữ liệu qua GET.
        BookDAO dao = new BookDAO();

        // Tồn kho hiện tại của từng sách trong giỏ (để hiển thị trạng thái + giới hạn số lượng)
        java.util.Map<Integer, Integer> stockMap = new java.util.HashMap<>();
        for (CartItem item : cart.getItems()) {
            Book book = dao.getBookById(item.getBookId());
            stockMap.put(item.getBookId(), book != null ? book.getStock() : 0);
        }
        request.setAttribute("stockMap", stockMap);

        request.setAttribute("categories", dao.getAllCategories());
        request.setAttribute("pageTitle", "Giỏ hàng");
        request.getRequestDispatcher("/WEB-INF/views/cart/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);
        User user = getLoggedInUser(session);
        CartDAO cartDAO = new CartDAO();

        String action = request.getParameter("action");
        String ctx = request.getContextPath();

        try {
            if ("add".equals(action)) {
                int bookId   = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity <= 0) quantity = 1;

                BookDAO dao = new BookDAO();
                Book book = dao.getBookById(bookId);

                if (book != null) {
                    if (book.getStock() <= 0) {
                        String requestedWith = request.getHeader("X-Requested-With");
                        if ("XMLHttpRequest".equals(requestedWith)) {
                            response.setContentType("application/json;charset=UTF-8");
                            response.getWriter().write("{\"success\":false,\"message\":\"Sản phẩm đã hết hàng\"}");
                        } else {
                            response.sendRedirect(ctx + "/books");
                        }
                        return;
                    }
                    if (quantity > book.getStock()) {
                        quantity = book.getStock();
                    }
                    cart.addItem(new CartItem(book.getId(), book.getTitle(),
                            book.getPrice(), quantity, book.getImage()));

                    // Sync item mới vào DB nếu đã đăng nhập
                    if (user != null) {
                        int newQty = 0;
                        for (CartItem ci : cart.getItems()) {
                            if (ci.getBookId() == book.getId()) { newQty = ci.getQuantity(); break; }
                        }
                        cartDAO.syncItem(user.getId(), bookId, newQty);
                    }
                }

                String requestedWith = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith)) {
                    response.setContentType("application/json;charset=UTF-8");
                    CartItem currentItem = null;
                    for (CartItem ci : cart.getItems()) {
                        if (ci.getBookId() == book.getId()) { currentItem = ci; break; }
                    }
                    String image = book.getImage() != null ? book.getImage() : "";
                    String title = book.getTitle() != null ? book.getTitle().replace("\"", "\\\"") : "";
                    response.getWriter().write("{\"success\":true,"
                            + "\"totalItems\":" + cart.getTotalItems() + ","
                            + "\"totalPrice\":" + cart.getTotalPrice() + ","
                            + "\"item\":{\"id\":" + book.getId() + ",\"title\":\"" + title + "\","
                            + "\"price\":" + book.getPrice() + ","
                            + "\"quantity\":" + (currentItem != null ? currentItem.getQuantity() : quantity) + ","
                            + "\"image\":\"" + image + "\"}}");
                    return;
                }

                String referer = request.getHeader("referer");
                response.sendRedirect(referer != null && !referer.isEmpty() ? referer : ctx + "/books");
                return;
            }

            else if ("syncOne".equals(action)) {
                int bookId   = Integer.parseInt(request.getParameter("bookId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                if (quantity < 1) quantity = 1;

                BookDAO dao = new BookDAO();
                Book book = dao.getBookById(bookId);
                if (book != null && book.getStock() > 0 && quantity > book.getStock()) {
                    quantity = book.getStock();
                }

                cart.updateItem(bookId, quantity);
                if (user != null) cartDAO.syncItem(user.getId(), bookId, quantity);

                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":true,\"quantity\":" + quantity
                        + ",\"totalItems\":" + cart.getTotalItems()
                        + ",\"totalPrice\":" + cart.getTotalPrice() + "}");
                return;
            }

            else if ("update".equals(action)) {
                for (CartItem item : cart.getItems()) {
                    String qtyStr = request.getParameter("quantity_" + item.getBookId());
                    if (qtyStr != null) {
                        try {
                            cart.updateItem(item.getBookId(), Integer.parseInt(qtyStr));
                        } catch (NumberFormatException ignored) {}
                    }
                }
                // Sync toàn bộ trạng thái giỏ sau khi update (bao gồm cả item bị remove qty=0)
                if (user != null) cartDAO.saveFullCart(user.getId(), cart.getItems());
                response.sendRedirect(ctx + "/cart");
                return;
            }

            else if ("remove".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("id"));
                cart.removeItem(bookId);
                if (user != null) cartDAO.removeItem(user.getId(), bookId);

                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\":true,\"totalItems\":"
                            + cart.getTotalItems() + ",\"totalPrice\":" + cart.getTotalPrice() + "}");
                    return;
                }
                response.sendRedirect(ctx + "/cart");
                return;
            }

            else if ("clear".equals(action)) {
                cart.clear();
                if (user != null) cartDAO.clearCart(user.getId());

                if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"success\":true,\"totalItems\":0,\"totalPrice\":0}");
                    return;
                }
                response.sendRedirect(ctx + "/cart");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getHeader("referer"));
    }
}
