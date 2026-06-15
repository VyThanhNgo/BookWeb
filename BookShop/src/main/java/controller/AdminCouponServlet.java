package controller;

import dao.CouponDAO;
import model.Coupon;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/admin/coupons")
public class AdminCouponServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        List<Coupon> list = new CouponDAO().getAllCoupons();
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            Coupon c = list.get(i);
            if (i > 0) sb.append(",");
            sb.append("{")
              .append("\"id\":").append(c.getCouponId()).append(",")
              .append("\"code\":\"").append(esc(c.getCode())).append("\",")
              .append("\"type\":\"").append(c.getDiscountType()).append("\",")
              .append("\"value\":").append(c.getDiscountValue()).append(",")
              .append("\"minOrder\":").append(c.getMinOrderAmount()).append(",")
              .append("\"maxDiscount\":").append(c.getMaxDiscount() != null ? c.getMaxDiscount() : "null").append(",")
              .append("\"usageLimit\":").append(c.getUsageLimit() != null ? c.getUsageLimit() : "null").append(",")
              .append("\"usedCount\":").append(c.getUsedCount()).append(",")
              .append("\"expiresAt\":\"").append(c.getExpiresAt() != null ? c.getExpiresAt().toString().substring(0,16) : "").append("\",")
              .append("\"active\":").append(c.isActive())
              .append("}");
        }
        sb.append("]");
        response.getWriter().write(sb.toString());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        CouponDAO dao = new CouponDAO();

        try {
            if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.toggleActive(id);
                response.getWriter().write("{\"success\":" + ok + "}");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.deleteCoupon(id);
                response.getWriter().write("{\"success\":" + ok + "}");

            } else if ("create".equals(action) || "update".equals(action)) {
                Coupon c = new Coupon();
                if ("update".equals(action)) c.setCouponId(Integer.parseInt(request.getParameter("id")));
                c.setCode(request.getParameter("code"));
                c.setDiscountType(request.getParameter("discountType"));
                c.setDiscountValue(Double.parseDouble(request.getParameter("discountValue")));
                c.setMinOrderAmount(parseDoubleOrZero(request.getParameter("minOrderAmount")));
                String maxStr = request.getParameter("maxDiscount");
                c.setMaxDiscount((maxStr != null && !maxStr.isEmpty()) ? Double.parseDouble(maxStr) : null);
                String limStr = request.getParameter("usageLimit");
                c.setUsageLimit((limStr != null && !limStr.isEmpty()) ? Integer.parseInt(limStr) : null);
                String expStr = request.getParameter("expiresAt");
                c.setExpiresAt((expStr != null && !expStr.isEmpty()) ? Timestamp.valueOf(expStr.replace("T", " ") + ":00") : null);

                boolean ok = "create".equals(action) ? dao.createCoupon(c) : dao.updateCoupon(c);
                response.getWriter().write("{\"success\":" + ok + "}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Unknown action\"}");
            }
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"message\":\"" + esc(e.getMessage()) + "\"}");
        }
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private double parseDoubleOrZero(String s) {
        try { return Double.parseDouble(s); } catch (Exception e) { return 0; }
    }
}
