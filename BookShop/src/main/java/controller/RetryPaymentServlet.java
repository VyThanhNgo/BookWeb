package controller;

import dao.OrderDAO;
import model.Order;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

// Xử lý khi người dùng bấm thanh toán lại cho đơn bị thất bại.
// Đặt trạng thái đơn về PENDING rồi chuyển sang cổng thanh toán tương ứng.
@WebServlet("/retry-payment")
public class RetryPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdStr = request.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO dao = new OrderDAO();
            Order order  = dao.getOrderById(orderId);

            // Kiểm tra đơn hàng tồn tại và thuộc về user hiện tại
            if (order == null || order.getUserId() != user.getId()) {
                response.sendRedirect(request.getContextPath() + "/my-orders");
                return;
            }

            // Chỉ cho phép thanh toán khi trạng thái là PAYMENT_FAILED hoặc PENDING
            String status = order.getStatus();
            if (!"PAYMENT_FAILED".equals(status) && !"PENDING".equals(status)) {
                request.setAttribute("errorMessage",
                        "Đơn hàng này không thể thanh toán lại (trạng thái: " + status + ").");
                request.setAttribute("orderCode", order.getOrderCode());
                request.setAttribute("paymentMethod", order.getPaymentMethod());
                request.getRequestDispatcher("/WEB-INF/views/order/payment-failed.jsp")
                        .forward(request, response);
                return;
            }

            // Chỉ hỗ trợ thanh toán lại cho VNPAY và MOMO
            String method = order.getPaymentMethod();
            if (!"VNPAY".equals(method) && !"MOMO".equals(method)) {
                response.sendRedirect(request.getContextPath() + "/my-orders?orderId=" + orderId);
                return;
            }

            // Reset trạng thái đơn hàng về PENDING
            dao.updateOrderStatus(orderId, "PENDING");

            // Tạo TxnRef mới = orderCode + "_" + timestamp
            // VNPay không cho dùng lại TxnRef cũ đã từng gửi
            String newTxnRef = order.getOrderCode() + "_" + System.currentTimeMillis();

            // Lưu cả orderCode gốc và TxnRef mới vào session
            session.setAttribute("pendingPaymentOrderCode", order.getOrderCode());
            session.setAttribute("pendingPaymentTxnRef", newTxnRef);

            // Redirect tới cổng thanh toán tương ứng
            if ("VNPAY".equals(method)) {
                response.sendRedirect(request.getContextPath() + "/vnpay/pay");
            } else {
                response.sendRedirect(request.getContextPath() + "/momo/pay");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/my-orders");
        }
    }
}
