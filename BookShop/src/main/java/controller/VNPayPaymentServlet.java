package controller;

import config.VNPayConfig;
import dao.OrderDAO;
import model.Order;
import util.VNPayUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

/**
 * Nhận orderCode từ session, xây dựng URL VNPay và redirect người dùng đến cổng thanh toán.
 * Return URL được tính động từ request để hoạt động đúng trên mọi môi trường (local / server).
 */
@WebServlet("/vnpay/pay")
public class VNPayPaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String orderCode = (String) session.getAttribute("pendingPaymentOrderCode");

        if (orderCode == null || orderCode.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        OrderDAO dao = new OrderDAO();
        Order order = dao.getOrderByCode(orderCode);

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            long amount     = (long) order.getTotalAmount();
            String createDate = VNPayUtil.formatDate(new Date());

            // Tính Return URL động — hoạt động đúng ở mọi môi trường
            String returnUrl = request.getScheme() + "://"
                    + request.getServerName() + ":" + request.getServerPort()
                    + request.getContextPath() + "/vnpay/return";

            // Khi thanh toán lại: dùng TxnRef mới để tránh lỗi "Giao dịch đã tồn tại" (code 01)
            String txnRef = session.getAttribute("pendingPaymentTxnRef") != null
                    ? (String) session.getAttribute("pendingPaymentTxnRef")
                    : orderCode;
            session.removeAttribute("pendingPaymentTxnRef"); // dùng 1 lần rồi xóa

            Map<String, String> params = new LinkedHashMap<>();
            params.put("vnp_Version",   VNPayConfig.VERSION);
            params.put("vnp_Command",   VNPayConfig.COMMAND);
            params.put("vnp_TmnCode",   VNPayConfig.TMN_CODE);
            params.put("vnp_Amount",    String.valueOf(amount * 100));
            params.put("vnp_CurrCode",  VNPayConfig.CURR_CODE);
            params.put("vnp_TxnRef",    txnRef);
            params.put("vnp_OrderInfo", "Thanh toan don hang " + orderCode);
            params.put("vnp_OrderType", VNPayConfig.ORDER_TYPE);
            params.put("vnp_Locale",    VNPayConfig.LOCALE);
            params.put("vnp_ReturnUrl", returnUrl);
            params.put("vnp_IpAddr",    VNPayUtil.getClientIp(request));
            params.put("vnp_CreateDate", createDate);

            String payUrl = VNPayUtil.buildPaymentUrl(params);
            response.sendRedirect(payUrl);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể kết nối tới VNPay. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/order/payment-failed.jsp").forward(request, response);
        }
    }
}
