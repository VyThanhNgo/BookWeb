package dao;

import util.DBConnection;
import model.CartItem;
import model.Order;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Collection;
import java.util.UUID;

public class OrderDAO {

    public boolean createFullOrder(Order order, Collection<CartItem> items) {
        Connection conn = null;
        PreparedStatement orderPs = null;
        PreparedStatement detailPs = null;
        ResultSet rs = null;

        String insertOrderSql = "INSERT INTO orders (" +
                "order_code, customer_name, email, phone, address_line, ward, district, province, note, " +
                "payment_method, status, subtotal, shipping_fee, discount_amount, total_amount" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String insertDetailSql = "INSERT INTO order_details (" +
                "order_id, book_id, book_title, quantity, unit_price, line_total" +
                ") VALUES (?, ?, ?, ?, ?, ?)";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if (order.getOrderCode() == null || order.getOrderCode().trim().isEmpty()) {
                order.setOrderCode(generateOrderCode());
            }

            orderPs = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            orderPs.setString(1, order.getOrderCode());
            orderPs.setString(2, order.getCustomerName());
            orderPs.setString(3, order.getEmail());
            orderPs.setString(4, order.getPhone());
            orderPs.setString(5, order.getAddressLine());
            orderPs.setString(6, order.getWard());
            orderPs.setString(7, order.getDistrict());
            orderPs.setString(8, order.getProvince());
            orderPs.setString(9, order.getNote());
            orderPs.setString(10, order.getPaymentMethod());
            orderPs.setString(11, order.getStatus());
            orderPs.setDouble(12, order.getSubtotal());
            orderPs.setDouble(13, order.getShippingFee());
            orderPs.setDouble(14, order.getDiscountAmount());
            orderPs.setDouble(15, order.getTotalAmount());

            int affected = orderPs.executeUpdate();
            if (affected == 0) {
                conn.rollback();
                return false;
            }

            rs = orderPs.getGeneratedKeys();
            int orderId = 0;
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

            if (orderId <= 0) {
                conn.rollback();
                return false;
            }

            detailPs = conn.prepareStatement(insertDetailSql);

            for (CartItem item : items) {
                detailPs.setInt(1, orderId);
                detailPs.setInt(2, item.getBookId());
                detailPs.setString(3, item.getTitle());
                detailPs.setInt(4, item.getQuantity());
                detailPs.setDouble(5, item.getPrice());
                detailPs.setDouble(6, item.getPrice() * item.getQuantity());
                detailPs.addBatch();
            }

            detailPs.executeBatch();
            conn.commit();

            order.setOrderId(orderId);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return false;
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignored) {}
            try { if (orderPs != null) orderPs.close(); } catch (Exception ignored) {}
            try { if (detailPs != null) detailPs.close(); } catch (Exception ignored) {}
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (Exception ignored) {}
        }
    }

    private String generateOrderCode() {
        return "ORD-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}