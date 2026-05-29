package controller;

import config.GhnConfig;
import util.GhnApiUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ghn/services")
public class GhnServiceServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        String toDistrict = request.getParameter("to_district");
        if (toDistrict == null || toDistrict.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"code\":400,\"message\":\"Missing to_district\"}");
            return;
        }

        String endpoint = "/v2/shipping-order/available-services"
                + "?shop_id=" + GhnConfig.SHOP_ID
                + "&from_district=" + GhnConfig.FROM_DISTRICT_ID
                + "&to_district=" + toDistrict;

        try {
            String result = GhnApiUtil.doGet(endpoint);
            response.getWriter().write(result);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"code\":500,\"message\":\"" + GhnApiUtil.escapeJson(e.getMessage()) + "\"}");
        }
    }
}