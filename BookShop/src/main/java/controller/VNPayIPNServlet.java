package controller;

import dao.OrderDAO;
import model.Order;
import util.VNPayUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * VNPay gọi IPN (webhook) từ server của họ đến URL này để xác nhận thanh toán.
 * Hoạt động trên môi trường có IP public; localhost cần dùng ngrok hoặc tương đương để test.
 */
@WebServlet("/vnpay/ipn")
public class VNPayIPNServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        // vnp_TxnRef có thể là "ORD-XXXX" hoặc "ORD-XXXX_timestamp" (thanh toán lại)
        String txnRef       = request.getParameter("vnp_TxnRef");
        String orderCode    = (txnRef != null && txnRef.contains("_"))
                ? txnRef.substring(0, txnRef.lastIndexOf("_"))
                : txnRef;
        String responseCode = request.getParameter("vnp_ResponseCode");
        String amount       = request.getParameter("vnp_Amount");

        try {
            boolean signatureOk = VNPayUtil.verifyReturn(request);
            if (!signatureOk) {
                out.print("{\"RspCode\":\"97\",\"Message\":\"Invalid Signature\"}");
                return;
            }

            OrderDAO dao = new OrderDAO();
            Order order = dao.getOrderByCode(orderCode);

            if (order == null) {
                out.print("{\"RspCode\":\"01\",\"Message\":\"Order not found\"}");
                return;
            }

            // Kiểm tra số tiền khớp — tính giống VNPayPaymentServlet: ((long)total) * 100
            long expectedAmount = (long) order.getTotalAmount() * 100;
            if (!String.valueOf(expectedAmount).equals(amount)) {
                out.print("{\"RspCode\":\"04\",\"Message\":\"Invalid Amount\"}");
                return;
            }

            // Tránh cập nhật lại nếu đã xử lý xong
            if ("CONFIRMED".equals(order.getStatus()) || "PAYMENT_FAILED".equals(order.getStatus())) {
                out.print("{\"RspCode\":\"02\",\"Message\":\"Order already updated\"}");
                return;
            }

            if ("00".equals(responseCode)) {
                dao.updateOrderPayment(orderCode, "CONFIRMED", "SUCCESS");
                out.print("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            } else {
                dao.updateOrderPayment(orderCode, "PAYMENT_FAILED", "FAILED");
                out.print("{\"RspCode\":\"00\",\"Message\":\"Confirm Success\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"RspCode\":\"99\",\"Message\":\"Unknown error\"}");
        }
    }
}
