package controller;

import dao.OrderDAO;
import model.Order;
import model.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        OrderDAO orderDAO = new OrderDAO();
        String orderIdStr = request.getParameter("orderId");

        // JSON mode cho AJAX
        if (orderIdStr != null && "XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setContentType("application/json;charset=UTF-8");
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);
                if (order == null) {
                    response.getWriter().write("{\"success\":false,\"message\":\"Không tìm thấy đơn hàng\"}");
                    return;
                }
                List<OrderItem> items = orderDAO.getOrderItems(orderId);
                StringBuilder sb = new StringBuilder();
                sb.append("{\"success\":true,\"order\":{");
                sb.append("\"orderCode\":\"").append(esc(order.getOrderCode())).append("\",");
                sb.append("\"customerName\":\"").append(esc(order.getCustomerName())).append("\",");
                sb.append("\"phone\":\"").append(esc(order.getPhone())).append("\",");
                sb.append("\"email\":\"").append(esc(order.getEmail())).append("\",");
                sb.append("\"address\":\"").append(esc(order.getFullAddress())).append("\",");
                sb.append("\"paymentMethod\":\"").append(esc(order.getPaymentMethod())).append("\",");
                sb.append("\"status\":\"").append(esc(order.getStatus())).append("\",");
                sb.append("\"subtotal\":").append(order.getSubtotal()).append(",");
                sb.append("\"shippingFee\":").append(order.getShippingFee()).append(",");
                sb.append("\"totalAmount\":").append(order.getTotalAmount()).append(",");
                sb.append("\"createdAt\":\"").append(order.getCreatedAt() != null ? order.getCreatedAt().toString() : "").append("\"");
                sb.append("},\"items\":[");
                for (int i = 0; i < items.size(); i++) {
                    OrderItem it = items.get(i);
                    if (i > 0) sb.append(",");
                    sb.append("{\"title\":\"").append(esc(it.getBookTitle())).append("\",");
                    sb.append("\"quantity\":").append(it.getQuantity()).append(",");
                    sb.append("\"price\":").append(it.getUnitPrice()).append("}");
                }
                sb.append("]}");
                response.getWriter().write(sb.toString());
            } catch (Exception e) {
                response.getWriter().write("{\"success\":false,\"message\":\"" + esc(e.getMessage()) + "\"}");
            }
            return;
        }

        request.setAttribute("orders", orderDAO.getAllOrders());
        request.setAttribute("pageTitle", "Quản lý đơn hàng");
        request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        String orderIdStr = request.getParameter("orderId");
        String status = request.getParameter("status");

        if (orderIdStr == null || status == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"Thiếu tham số\"}");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO orderDAO = new OrderDAO();
            boolean ok = orderDAO.updateOrderStatus(orderId, status);
            response.getWriter().write("{\"success\":" + ok + "}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }
}
