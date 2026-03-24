package controller;

import dao.OrderDAO;
import model.OrderDetail;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<OrderDetail> cart = (List<OrderDetail>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        double total = 0;
        for (OrderDetail item : cart) {
            total += item.getPrice() * item.getQuantity();
        }

        OrderDAO dao = new OrderDAO();
        int orderId = dao.createOrder(userId, total);

        dao.insertOrderDetail(orderId, cart);

        session.removeAttribute("cart");

        response.sendRedirect("success.jsp");
    }
}