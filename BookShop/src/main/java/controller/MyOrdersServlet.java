package controller;

import dao.OrderDAO;
import model.Order;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("loggedInUser");

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getOrdersByUserId(user.getId());

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order detail = orderDAO.getOrderById(orderId);
                if (detail != null && detail.getUserId() == user.getId()) {
                    request.setAttribute("orderDetail", detail);
                    request.setAttribute("orderItems", orderDAO.getOrderItems(orderId));
                    request.setAttribute("statusLogs", orderDAO.getStatusLogs(orderId));
                }
            } catch (NumberFormatException ignored) {}
        }

     //dữ liệu tab đánh giá
        List<Map<String, Object>> unreviewedBooks = orderDAO.getUnreviewedBooks(user.getId());
        List<Map<String, Object>> reviewedBooks   = orderDAO.getReviewedBooks(user.getId());
        request.setAttribute("unreviewedBooks", unreviewedBooks);
        request.setAttribute("reviewedBooks",   reviewedBooks);
        
        request.setAttribute("orders", orders);
        request.setAttribute("pageTitle", "Đơn hàng của tôi");
        request.getRequestDispatcher("/WEB-INF/views/order/my-orders.jsp").forward(request, response);
    }
}
