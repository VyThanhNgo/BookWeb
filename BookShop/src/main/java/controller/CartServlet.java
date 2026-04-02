package controller;

import dao.BookDAO;
import model.Book;
import model.Cart;
import model.CartItem;

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        String action = request.getParameter("action");
        String ctx = request.getContextPath();
        String requestedWith = request.getHeader("X-Requested-With");

        if ("remove".equals(action)) {
            try {
                int bookId = Integer.parseInt(request.getParameter("id"));
                cart.removeItem(bookId);
            } catch (Exception e) {
                e.printStackTrace();
            }

            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json;charset=UTF-8");
                String json = "{"
                        + "\"success\":true,"
                        + "\"totalItems\":" + cart.getTotalItems() + ","
                        + "\"totalPrice\":" + cart.getTotalPrice()
                        + "}";
                response.getWriter().write(json);
                return;
            }

            response.sendRedirect(ctx + "/cart");
            return;
        }

        if ("clear".equals(action)) {
            cart.clear();

            if ("XMLHttpRequest".equals(requestedWith)) {
                response.setContentType("application/json;charset=UTF-8");
                String json = "{"
                        + "\"success\":true,"
                        + "\"totalItems\":0,"
                        + "\"totalPrice\":0"
                        + "}";
                response.getWriter().write(json);
                return;
            }

            response.sendRedirect(ctx + "/cart");
            return;
        }

        BookDAO dao = new BookDAO();
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
        String action = request.getParameter("action");
        String ctx = request.getContextPath();

        try {
            if ("add".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                if (quantity <= 0) quantity = 1;

                BookDAO dao = new BookDAO();
                Book book = dao.getBookById(bookId);

                if (book != null) {
                    if (book.getStock() > 0 && quantity > book.getStock()) {
                        quantity = book.getStock();
                    }

                    CartItem item = new CartItem(
                            book.getId(),
                            book.getTitle(),
                            book.getPrice(),
                            quantity,
                            book.getImage()
                    );
                    cart.addItem(item);
                }

                String requestedWith = request.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith)) {
                    response.setContentType("application/json;charset=UTF-8");

                    CartItem currentItem = null;
                    for (CartItem ci : cart.getItems()) {
                        if (ci.getBookId() == book.getId()) {
                            currentItem = ci;
                            break;
                        }
                    }

                    String image = book.getImage() != null ? book.getImage() : "";
                    String title = book.getTitle() != null ? book.getTitle().replace("\"", "\\\"") : "";

                    String json = "{"
                            + "\"success\":true,"
                            + "\"totalItems\":" + cart.getTotalItems() + ","
                            + "\"totalPrice\":" + cart.getTotalPrice() + ","
                            + "\"item\":{"
                            + "\"id\":" + book.getId() + ","
                            + "\"title\":\"" + title + "\","
                            + "\"price\":" + book.getPrice() + ","
                            + "\"quantity\":" + (currentItem != null ? currentItem.getQuantity() : quantity) + ","
                            + "\"image\":\"" + image + "\""
                            + "}"
                            + "}";

                    response.getWriter().write(json);
                    return;
                }

                String referer = request.getHeader("referer");
                if (referer != null && !referer.isEmpty()) {
                    response.sendRedirect(referer);
                } else {
                    response.sendRedirect(ctx + "/books");
                }
                return;
            }

            else if ("update".equals(action)) {
                for (CartItem item : cart.getItems()) {
                    String qtyStr = request.getParameter("quantity_" + item.getBookId());
                    if (qtyStr != null) {
                        try {
                            int qty = Integer.parseInt(qtyStr);
                            cart.updateItem(item.getBookId(), qty);
                        } catch (NumberFormatException e) {
                            // bỏ qua nếu input lỗi
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getHeader("referer"));    }
}