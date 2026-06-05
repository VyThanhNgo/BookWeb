package controller;

import dao.OrderDAO;
import model.Order;
import model.OrderItem;
import util.VNPayUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * VNPay redirect người dùng về đây sau khi thanh toán.
 * Xác minh chữ ký, cập nhật trạng thái đơn hàng, hiển thị kết quả.
 */
@WebServlet("/vnpay/return")
public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // vnp_TxnRef có thể là "ORD-XXXX" (thanh toán lần đầu)
        // hoặc "ORD-XXXX_timestamp" (thanh toán lại) — lấy phần orderCode
        String txnRef    = request.getParameter("vnp_TxnRef");
        String orderCode = (txnRef != null && txnRef.contains("_"))
                ? txnRef.substring(0, txnRef.lastIndexOf("_"))
                : txnRef;
        String responseCode = request.getParameter("vnp_ResponseCode");
        String transactionNo = request.getParameter("vnp_TransactionNo");

        OrderDAO dao = new OrderDAO();

        // --- Xác minh chữ ký ---
        boolean signatureOk;
        try {
            signatureOk = VNPayUtil.verifyReturn(request);
        } catch (Exception e) {
            e.printStackTrace();
            signatureOk = false;
        }

        boolean paymentSuccess = signatureOk && "00".equals(responseCode);

        if (paymentSuccess) {
            dao.updateOrderPayment(orderCode, "CONFIRMED", "SUCCESS");

            Order order = dao.getOrderByCode(orderCode);
            List<OrderItem> items = order != null ? dao.getOrderItems(order.getOrderId()) : null;

            // Xóa pending payment trong session
            HttpSession session = request.getSession();
            session.removeAttribute("pendingPaymentOrderCode");

            request.setAttribute("pageTitle", "Thanh toán thành công");
            request.setAttribute("placedOrder", order);
            request.setAttribute("placedOrderItems", items);
            request.setAttribute("paymentSuccess", true);
            request.setAttribute("transactionNo", transactionNo);
            request.getRequestDispatcher("/WEB-INF/views/order/order-success.jsp")
                   .forward(request, response);
        } else {
            dao.updateOrderPayment(orderCode, "PAYMENT_FAILED", "FAILED");

            String errorMsg = getVNPayErrorMessage(responseCode);
            request.setAttribute("orderCode", orderCode);
            request.setAttribute("errorMessage", errorMsg);
            request.setAttribute("paymentMethod", "VNPay");
            request.getRequestDispatcher("/WEB-INF/views/order/payment-failed.jsp")
                   .forward(request, response);
        }
    }

    private String getVNPayErrorMessage(String code) {
        if (code == null) return "Thanh toán thất bại.";
        switch (code) {
            case "07": return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).";
            case "09": return "Thẻ/Tài khoản chưa đăng ký dịch vụ InternetBanking.";
            case "10": return "Xác thực thông tin thẻ/tài khoản không đúng quá 3 lần.";
            case "11": return "Đã hết hạn chờ thanh toán. Vui lòng thực hiện lại.";
            case "12": return "Thẻ/Tài khoản bị khóa.";
            case "13": return "Nhập sai mật khẩu OTP. Vui lòng thực hiện lại.";
            case "24": return "Khách hàng hủy giao dịch.";
            case "51": return "Tài khoản không đủ số dư để thực hiện giao dịch.";
            case "65": return "Tài khoản đã vượt quá hạn mức giao dịch trong ngày.";
            case "75": return "Ngân hàng thanh toán đang bảo trì.";
            case "79": return "Nhập sai mật khẩu thanh toán quá số lần quy định.";
            default:   return "Thanh toán không thành công (Mã lỗi: " + code + ").";
        }
    }
}
