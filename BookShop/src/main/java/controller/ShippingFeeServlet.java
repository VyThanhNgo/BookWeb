package controller;

import config.GhnConfig;
import model.Cart;
import util.GhnApiUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/shipping-fee")
public class ShippingFeeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        Cart cart = (session != null) ? (Cart) session.getAttribute("cart") : null;

        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Giỏ hàng đang trống\"}");
            return;
        }

        String toDistrictId = request.getParameter("toDistrictId");
        String toWardCode = request.getParameter("toWardCode");
        String serviceIdStr = request.getParameter("serviceId");

        if (toDistrictId == null || toDistrictId.trim().isEmpty()
                || toWardCode == null || toWardCode.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Thiếu quận/huyện hoặc phường/xã\"}");
            return;
        }

        int serviceId = GhnApiUtil.parseInt(serviceIdStr, 0);
        if (serviceId <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"Không lấy được serviceId từ GHN\"}");
            return;
        }

        int totalQuantity = cart.getTotalItems();
        int weight = Math.max(500, totalQuantity * 500);
        int length = 20;
        int width = 15;
        int height = Math.max(5, totalQuantity * 2);

        int subtotal = (int) Math.round(cart.getTotalPrice());
        int discount = 0;

        String jsonBody = "{"
                + "\"service_type_id\":2,"
                + "\"insurance_value\":" + subtotal + ","
                + "\"coupon\":null,"
                + "\"from_district_id\":" + GhnConfig.FROM_DISTRICT_ID + ","
                + "\"from_ward_code\":\"" + GhnApiUtil.escapeJson(GhnConfig.FROM_WARD_CODE) + "\","
                + "\"to_district_id\":" + toDistrictId + ","
                + "\"to_ward_code\":\"" + GhnApiUtil.escapeJson(toWardCode) + "\","
                + "\"length\":" + length + ","
                + "\"width\":" + width + ","
                + "\"height\":" + height + ","
                + "\"weight\":" + weight
                + "}";

        try {
            System.out.println("=== GHN SHIPPING DEBUG ===");
            System.out.println("toDistrictId = " + toDistrictId);
            System.out.println("toWardCode = " + toWardCode);
            System.out.println("serviceId = " + serviceId);
            System.out.println("FROM_DISTRICT_ID = " + GhnConfig.FROM_DISTRICT_ID);
            System.out.println("FROM_WARD_CODE = " + GhnConfig.FROM_WARD_CODE);
            System.out.println("jsonBody = " + jsonBody);

            String ghnResult = GhnApiUtil.doPost("/v2/shipping-order/fee", jsonBody, true);

            System.out.println("ghnResult = " + ghnResult);

            if (ghnResult == null || ghnResult.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\":false,\"message\":\"GHN không trả dữ liệu\"}");
                return;
            }

            if (!ghnResult.contains("\"code\":200")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"GHN trả lỗi\",\"raw\":\""
                                + GhnApiUtil.escapeJson(ghnResult) + "\"}"
                );
                return;
            }

            int shippingFee = extractTotalFee(ghnResult);

            if (shippingFee <= 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Không lấy được phí vận chuyển từ GHN\",\"raw\":\""
                                + GhnApiUtil.escapeJson(ghnResult) + "\"}"
                );
                return;
            }

            int total = subtotal + shippingFee - discount;

            String result = "{"
                    + "\"success\":true,"
                    + "\"shippingFee\":" + shippingFee + ","
                    + "\"subtotal\":" + subtotal + ","
                    + "\"discount\":" + discount + ","
                    + "\"total\":" + total
                    + "}";

            response.getWriter().write(result);

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"" + GhnApiUtil.escapeJson(e.getMessage()) + "\"}");
        }
    }

    private int extractTotalFee(String json) {
        if (json == null || json.trim().isEmpty()) return 0;
        Pattern p = Pattern.compile("\"total\"\\s*:\\s*(\\d+)");
        Matcher m = p.matcher(json);
        if (m.find()) {
            return Integer.parseInt(m.group(1));
        }
        return 0;
    }
}