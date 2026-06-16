package controller;

import dao.OrderDAO;
import model.Order;
import model.OrderItem;
import util.MomoUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

// MoMo chuyển người dùng về đây sau khi thanh toán.
// Kiểm tra chữ ký, cập nhật trạng thái đơn rồi hiện kết quả.
@WebServlet("/momo/return")
public class MomoReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String orderId    = request.getParameter("orderId");    // = orderCode
        String resultCode = request.getParameter("resultCode"); // "0" = thành công
        String transId    = request.getParameter("transId");

        OrderDAO dao = new OrderDAO();

        boolean signatureOk;
        try {
            signatureOk = MomoUtil.verifyReturn(request);
        } catch (Exception e) {
            e.printStackTrace();
            signatureOk = false;
        }

        boolean paymentSuccess = signatureOk && "0".equals(resultCode);

        // Lấy trạng thái hiện tại để khỏi cập nhật lại khi người dùng F5 trang
        Order existing = dao.getOrderByCode(orderId);
        String currentStatus = (existing != null) ? existing.getStatus() : null;

        if (paymentSuccess) {
            if (!"CONFIRMED".equals(currentStatus)) {
                dao.updateOrderPayment(orderId, "CONFIRMED", "SUCCESS");
            }

            Order order = dao.getOrderByCode(orderId);
            List<OrderItem> items = order != null ? dao.getOrderItems(order.getOrderId()) : null;

            // Chỉ gửi email ở lần xác nhận đầu tiên, tránh gửi lại khi F5
            if (!"CONFIRMED".equals(currentStatus)) {
                util.MailUtil.sendOrderConfirmationAsync(order, items);
            }

            HttpSession session = request.getSession();
            session.removeAttribute("pendingPaymentOrderCode");

            request.setAttribute("pageTitle", "Thanh toán thành công");
            request.setAttribute("placedOrder", order);
            request.setAttribute("placedOrderItems", items);
            request.setAttribute("paymentSuccess", true);
            request.setAttribute("transactionNo", transId);
            request.getRequestDispatcher("/WEB-INF/views/order/order-success.jsp")
                   .forward(request, response);
        } else {
            // Đơn đã xác nhận thì không hạ xuống thất bại; đã thất bại rồi thì thôi
            if (!"CONFIRMED".equals(currentStatus) && !"PAYMENT_FAILED".equals(currentStatus)) {
                dao.updateOrderPayment(orderId, "PAYMENT_FAILED", "FAILED");
            }

            request.setAttribute("orderCode", orderId);
            request.setAttribute("errorMessage", getMomoErrorMessage(resultCode));
            request.setAttribute("paymentMethod", "MoMo");
            request.getRequestDispatcher("/WEB-INF/views/order/payment-failed.jsp")
                   .forward(request, response);
        }
    }

    private String getMomoErrorMessage(String code) {
        if (code == null) return "Thanh toán thất bại.";
        switch (code) {
            case "1001": return "Thanh toán thất bại do tài khoản người dùng không đủ tiền.";
            case "1002": return "Thanh toán bị từ chối bởi nhà cung cấp dịch vụ thanh toán.";
            case "1003": return "Đơn hàng đã bị hủy.";
            case "1004": return "Số tiền giao dịch vượt quá hạn mức thanh toán của người dùng.";
            case "1005": return "Link thanh toán hết hạn hoặc đã được thanh toán.";
            case "1006": return "Người dùng từ chối giao dịch.";
            case "1007": return "Tài khoản MoMo bị khóa.";
            case "1026": return "Giao dịch bị hạn chế theo chính sách của MoMo.";
            case "1080": return "Hoàn tiền bị từ chối.";
            case "1081": return "Số tiền hoàn lại không hợp lệ.";
            case "2019": return "requestType không hợp lệ.";
            case "4001": return "Người dùng chưa xác minh danh tính.";
            case "4010": return "OTP xác thực không chính xác.";
            case "4011": return "OTP quá hạn.";
            case "4100": return "Người dùng chưa đăng nhập.";
            default:     return "Thanh toán không thành công (Mã lỗi: " + code + ").";
        }
    }
}
