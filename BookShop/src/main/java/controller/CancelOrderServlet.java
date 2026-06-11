package controller;

import dao.OrderDAO;
import model.Order;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("loggedInUser");

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);

            // Kiểm tra đơn tồn tại và thuộc về user hiện tại
            if (order == null || order.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/my-orders?error=not_found");
                return;
            }

            // User chỉ được huỷ đơn ở trạng thái PENDING hoặc PAYMENT_FAILED
            String status = order.getStatus();
            if (!"PENDING".equals(status) && !"PAYMENT_FAILED".equals(status)) {
                response.sendRedirect(request.getContextPath()
                        + "/my-orders?orderId=" + orderId + "&error=cannot_cancel");
                return;
            }

            boolean ok = orderDAO.cancelOrder(orderId, user.getUsername());
            if (ok) {
                response.sendRedirect(request.getContextPath()
                        + "/my-orders?orderId=" + orderId + "&cancelled=true");
            } else {
                response.sendRedirect(request.getContextPath()
                        + "/my-orders?orderId=" + orderId + "&error=cancel_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }
}
