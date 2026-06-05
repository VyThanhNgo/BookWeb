package controller;

import config.MomoConfig;
import dao.OrderDAO;
import model.Order;
import util.MomoUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * Gọi MoMo API tạo link thanh toán và redirect người dùng đến MoMo.
 * Return URL và IPN URL được tính động từ request.
 */
@WebServlet("/momo/pay")
public class MomoPaymentServlet extends HttpServlet {

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
            long amount      = (long) order.getTotalAmount();
            String orderInfo = "Thanh toan don hang " + orderCode;

            // Tính URL động
            String baseUrl  = request.getScheme() + "://"
                    + request.getServerName() + ":" + request.getServerPort()
                    + request.getContextPath();
            String returnUrl = baseUrl + "/momo/return";
            String ipnUrl    = baseUrl + "/momo/ipn";

            String payUrl = MomoUtil.createPaymentUrl(orderCode, amount, orderInfo, returnUrl, ipnUrl);

            if (payUrl == null || payUrl.isEmpty()) {
                throw new Exception("MoMo không trả về payUrl");
            }

            response.sendRedirect(payUrl);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể kết nối tới MoMo. Vui lòng thử lại.");
            request.setAttribute("orderCode", orderCode);
            request.setAttribute("paymentMethod", "MoMo");
            request.getRequestDispatcher("/WEB-INF/views/order/payment-failed.jsp")
                   .forward(request, response);
        }
    }
}
