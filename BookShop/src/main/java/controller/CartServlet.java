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
                            quantity
                    );
                    cart.addItem(item);
                }

                response.sendRedirect(ctx + "/cart");
                return;
            }

            if ("update".equals(action)) {
                String[] bookIds = request.getParameterValues("bookId");
                if (bookIds != null) {
                    for (String idStr : bookIds) {
                        int bookId = Integer.parseInt(idStr);
                        int quantity = Integer.parseInt(request.getParameter("quantity_" + bookId));
                        cart.updateItem(bookId, quantity);
                    }
                }
                response.sendRedirect(ctx + "/cart");
                return;
            }

            if ("remove".equals(action)) {
                int bookId = Integer.parseInt(request.getParameter("id"));
                cart.removeItem(bookId);
                response.sendRedirect(ctx + "/cart");
                return;
            }

            if ("clear".equals(action)) {
                cart.clear();
                response.sendRedirect(ctx + "/cart");
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(ctx + "/cart");
    }
}