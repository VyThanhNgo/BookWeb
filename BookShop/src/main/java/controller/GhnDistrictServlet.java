package controller;

import util.GhnApiUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ghn/districts")
public class GhnDistrictServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        String provinceId = request.getParameter("province_id");
        if (provinceId == null || provinceId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"code\":400,\"message\":\"Missing province_id\"}");
            return;
        }

        try {
            String result = GhnApiUtil.doGet("/master-data/district?province_id=" + provinceId);
            response.getWriter().write(result);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"code\":500,\"message\":\"" + GhnApiUtil.escapeJson(e.getMessage()) + "\"}");
        }
    }
}