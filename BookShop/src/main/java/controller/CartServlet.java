package main.java.controller;

import dao.BookDAO;
import main.java.model.*;
import model.Book;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class CartServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        try {
            if ("add".equals(action)) {

                int id = Integer.parseInt(request.getParameter("id"));

                BookDAO dao = new BookDAO();
                Book book = dao.getBookById(id);

                if (book != null) {
                    CartItem item = new CartItem(
                            book.getId(),
                            book.getTitle(),
                            book.getPrice(),
                            1
                    );
                    cart.addItem(item);
                }
            }

            else if ("remove".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                cart.removeItem(id);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("views/cart.jsp");
    }
}