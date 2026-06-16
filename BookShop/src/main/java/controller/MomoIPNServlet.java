package controller;

import dao.OrderDAO;
import model.Order;
import util.MomoUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

// MoMo gọi tới đây (server gọi server) để báo kết quả thanh toán.
// Trả về HTTP 204 khi xử lý xong theo tài liệu MoMo v2.
@WebServlet("/momo/ipn")
public class MomoIPNServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String orderId    = request.getParameter("orderId");
        String resultCode = request.getParameter("resultCode");
        String amount     = request.getParameter("amount");

        try {
            boolean signatureOk = MomoUtil.verifyReturn(request);
            if (!signatureOk) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            OrderDAO dao = new OrderDAO();
            Order order = dao.getOrderByCode(orderId);

            if (order == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // Tránh cập nhật lại nếu đã xử lý
            if ("CONFIRMED".equals(order.getStatus()) || "PAYMENT_FAILED".equals(order.getStatus())) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT);
                return;
            }

            if ("0".equals(resultCode)) {
                dao.updateOrderPayment(orderId, "CONFIRMED", "SUCCESS");
            } else {
                dao.updateOrderPayment(orderId, "PAYMENT_FAILED", "FAILED");
            }

            response.setStatus(HttpServletResponse.SC_NO_CONTENT);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
