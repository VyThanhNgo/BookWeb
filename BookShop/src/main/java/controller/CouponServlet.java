package controller;

import dao.CouponDAO;
import model.Coupon;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/coupon/apply")
public class CouponServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String code = request.getParameter("code");
        String subtotalStr = request.getParameter("subtotal");

        if (code == null || code.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"Vui lòng nhập mã giảm giá.\"}");
            return;
        }

        double subtotal = 0;
        try { subtotal = Double.parseDouble(subtotalStr); } catch (Exception ignored) {}

        CouponDAO dao = new CouponDAO();
        Coupon coupon = dao.findByCode(code.trim());

        if (coupon == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Mã giảm giá không tồn tại hoặc đã bị vô hiệu hóa.\"}");
            return;
        }

        if (coupon.getExpiresAt() != null && coupon.getExpiresAt().before(new java.sql.Timestamp(System.currentTimeMillis()))) {
            response.getWriter().write("{\"success\":false,\"message\":\"Mã giảm giá đã hết hạn.\"}");
            return;
        }

        if (coupon.getUsageLimit() != null && coupon.getUsedCount() >= coupon.getUsageLimit()) {
            response.getWriter().write("{\"success\":false,\"message\":\"Mã giảm giá đã được sử dụng hết.\"}");
            return;
        }

        if (subtotal < coupon.getMinOrderAmount()) {
            long min = Math.round(coupon.getMinOrderAmount());
            response.getWriter().write("{\"success\":false,\"message\":\"Đơn hàng tối thiểu "
                    + String.format("%,d", min).replace(',', '.') + "đ để dùng mã này.\"}");
            return;
        }

        double discount = dao.computeDiscount(coupon, subtotal);
        String msg;
        if ("PERCENT".equals(coupon.getDiscountType())) {
            msg = "Áp dụng thành công! Giảm " + (int) coupon.getDiscountValue() + "%";
            if (coupon.getMaxDiscount() != null)
                msg += " (tối đa " + String.format("%,.0f", coupon.getMaxDiscount()).replace(',', '.') + "đ)";
        } else {
            msg = "Áp dụng thành công! Giảm " + String.format("%,.0f", coupon.getDiscountValue()).replace(',', '.') + "đ";
        }

        response.getWriter().write("{\"success\":true,\"discount\":" + Math.round(discount)
                + ",\"message\":\"" + msg + "\"}");
    }
}
