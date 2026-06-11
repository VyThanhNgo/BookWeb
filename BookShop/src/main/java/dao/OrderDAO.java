package dao;

import util.DBConnection;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.OrderStatusLog;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

public class OrderDAO {

    public boolean createFullOrder(Order order, Collection<CartItem> items) {
        Connection conn = null;
        PreparedStatement orderPs = null;
        PreparedStatement detailPs = null;
        ResultSet rs = null;

        String insertOrderSql = "INSERT INTO orders (" +
                "user_id, order_code, customer_name, email, phone, address_line, ward, district, province, note, " +
                "payment_method, status, subtotal, shipping_fee, discount_amount, total_amount" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String insertDetailSql = "INSERT INTO order_details (" +
                "order_id, book_id, book_title, quantity, unit_price, line_total" +
                ") VALUES (?, ?, ?, ?, ?, ?)";

        String updateStockSql = "UPDATE books SET stock = stock - ?, sold_quantity = sold_quantity + ? WHERE book_id = ? AND stock >= ?";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if (order.getOrderCode() == null || order.getOrderCode().trim().isEmpty()) {
                order.setOrderCode(generateOrderCode());
            }

            orderPs = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            orderPs.setInt(1, order.getUserId());
            orderPs.setString(2, order.getOrderCode());
            orderPs.setString(3, order.getCustomerName());
            orderPs.setString(4, order.getEmail());
            orderPs.setString(5, order.getPhone());
            orderPs.setString(6, order.getAddressLine());
            orderPs.setString(7, order.getWard());
            orderPs.setString(8, order.getDistrict());
            orderPs.setString(9, order.getProvince());
            orderPs.setString(10, order.getNote());
            orderPs.setString(11, order.getPaymentMethod());
            orderPs.setString(12, order.getStatus());
            orderPs.setDouble(13, order.getSubtotal());
            orderPs.setDouble(14, order.getShippingFee());
            orderPs.setDouble(15, order.getDiscountAmount());
            orderPs.setDouble(16, order.getTotalAmount());

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
            PreparedStatement stockPs = conn.prepareStatement(updateStockSql);

            for (CartItem item : items) {
                detailPs.setInt(1, orderId);
                detailPs.setInt(2, item.getBookId());
                detailPs.setString(3, item.getTitle());
                detailPs.setInt(4, item.getQuantity());
                detailPs.setDouble(5, item.getPrice());
                detailPs.setDouble(6, item.getPrice() * item.getQuantity());
                detailPs.addBatch();

                stockPs.setInt(1, item.getQuantity());
                stockPs.setInt(2, item.getQuantity());
                stockPs.setInt(3, item.getBookId());
                stockPs.setInt(4, item.getQuantity());
                stockPs.addBatch();
            }

            detailPs.executeBatch();
            stockPs.executeBatch();
            stockPs.close();
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

    private Order mapOrder(ResultSet rs) throws Exception {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setOrderCode(rs.getString("order_code"));
        o.setCustomerName(rs.getString("customer_name"));
        o.setEmail(rs.getString("email"));
        o.setPhone(rs.getString("phone"));
        o.setAddressLine(rs.getString("address_line"));
        o.setWard(rs.getString("ward"));
        o.setDistrict(rs.getString("district"));
        o.setProvince(rs.getString("province"));
        o.setNote(rs.getString("note"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setStatus(rs.getString("status"));
        o.setSubtotal(rs.getDouble("subtotal"));
        o.setShippingFee(rs.getDouble("shipping_fee"));
        o.setDiscountAmount(rs.getDouble("discount_amount"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setConfirmedAt(rs.getTimestamp("confirmed_at"));
        o.setShippedAt(rs.getTimestamp("shipped_at"));
        o.setDeliveredAt(rs.getTimestamp("delivered_at"));
        o.setCancelledAt(rs.getTimestamp("cancelled_at"));
        return o;
    }

    // ── Helper nội bộ: ghi log thay đổi trạng thái (dùng chung connection đang mở) ──
    private void insertStatusLog(Connection conn, int orderId,
                                 String oldStatus, String newStatus, String changedBy) throws Exception {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO order_status_logs (order_id, old_status, new_status, changed_by) VALUES (?, ?, ?, ?)");
        ps.setInt(1, orderId);
        ps.setString(2, oldStatus);
        ps.setString(3, newStatus);
        ps.setString(4, changedBy != null ? changedBy : "system");
        ps.executeUpdate();
        ps.close();
    }

    // ── Helper: xác định cột timestamp ứng với status ──
    private String timestampClause(String status) {
        switch (status) {
            case "CONFIRMED":  return ", confirmed_at = NOW()";
            case "SHIPPING":   return ", shipped_at = NOW()";
            case "COMPLETED":  return ", delivered_at = NOW()";
            case "CANCELLED":  return ", cancelled_at = NOW()";
            default:           return "";
        }
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapOrder(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapOrder(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapOrder(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT od.*, b.image FROM order_details od " +
                     "LEFT JOIN books b ON od.book_id = b.book_id " +
                     "WHERE od.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem(
                    rs.getInt("book_id"),
                    rs.getString("book_title"),
                    rs.getString("image"),
                    rs.getInt("quantity"),
                    rs.getDouble("unit_price")
                );
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Cập nhật trạng thái đơn, đồng thời ghi timestamp tracking và audit log. */
    public boolean updateOrderStatus(int orderId, String status, String changedBy) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Lấy trạng thái cũ để ghi log
            PreparedStatement checkPs = conn.prepareStatement(
                "SELECT status FROM orders WHERE order_id = ?");
            checkPs.setInt(1, orderId);
            ResultSet rs = checkPs.executeQuery();
            String oldStatus = rs.next() ? rs.getString("status") : null;
            checkPs.close();

            PreparedStatement updatePs = conn.prepareStatement(
                "UPDATE orders SET status = ?" + timestampClause(status) + " WHERE order_id = ?");
            updatePs.setString(1, status);
            updatePs.setInt(2, orderId);
            int affected = updatePs.executeUpdate();
            updatePs.close();

            if (affected == 0) { conn.rollback(); return false; }

            insertStatusLog(conn, orderId, oldStatus, status, changedBy);
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception ignored) {}
        }
    }

    /** Overload giữ backward-compat với các caller không truyền changedBy. */
    public boolean updateOrderStatus(int orderId, String status) {
        return updateOrderStatus(orderId, status, "system");
    }

    /**
     * Huỷ đơn hàng: hoàn tồn kho + set CANCELLED + ghi audit log.
     * Không cho phép huỷ đơn đã COMPLETED hoặc đã CANCELLED.
     */
    public boolean cancelOrder(int orderId, String changedBy) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement checkPs = conn.prepareStatement(
                "SELECT status FROM orders WHERE order_id = ?");
            checkPs.setInt(1, orderId);
            ResultSet checkRs = checkPs.executeQuery();
            if (!checkRs.next()) { conn.rollback(); return false; }
            String currentStatus = checkRs.getString("status");
            checkPs.close();

            if ("COMPLETED".equals(currentStatus) || "CANCELLED".equals(currentStatus)) {
                conn.rollback(); return false;
            }

            // Hoàn lại tồn kho
            PreparedStatement detailPs = conn.prepareStatement(
                "SELECT book_id, quantity FROM order_details WHERE order_id = ?");
            detailPs.setInt(1, orderId);
            ResultSet detailRs = detailPs.executeQuery();
            PreparedStatement stockPs = conn.prepareStatement(
                "UPDATE books SET stock = stock + ? WHERE book_id = ?");
            while (detailRs.next()) {
                stockPs.setInt(1, detailRs.getInt("quantity"));
                stockPs.setInt(2, detailRs.getInt("book_id"));
                stockPs.addBatch();
            }
            stockPs.executeBatch();
            detailPs.close();
            stockPs.close();

            // Cập nhật status + timestamp
            PreparedStatement updatePs = conn.prepareStatement(
                "UPDATE orders SET status = 'CANCELLED', cancelled_at = NOW() WHERE order_id = ?");
            updatePs.setInt(1, orderId);
            updatePs.executeUpdate();
            updatePs.close();

            insertStatusLog(conn, orderId, currentStatus, "CANCELLED", changedBy);
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception ignored) {}
        }
    }

    /** Overload backward-compat. */
    public boolean cancelOrder(int orderId) {
        return cancelOrder(orderId, "system");
    }

    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status != 'CANCELLED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPendingOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'PENDING'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Order getOrderByCode(String orderCode) {
        String sql = "SELECT * FROM orders WHERE order_code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, orderCode);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapOrder(rs);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cập nhật trạng thái đơn hàng và ghi nhận thanh toán vào bảng payments.
     * Dùng sau khi nhận kết quả từ cổng thanh toán (VNPay / MoMo).
     */
    public boolean updateOrderPayment(String orderCode, String orderStatus, String paymentStatus) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Lấy orderId + oldStatus để ghi log
            PreparedStatement getPs = conn.prepareStatement(
                "SELECT order_id, status FROM orders WHERE order_code = ?");
            getPs.setString(1, orderCode);
            ResultSet getRs = getPs.executeQuery();
            int orderId = 0;
            String oldStatus = null;
            if (getRs.next()) {
                orderId   = getRs.getInt("order_id");
                oldStatus = getRs.getString("status");
            }
            getPs.close();

            PreparedStatement ps1 = conn.prepareStatement(
                "UPDATE orders SET status = ?" + timestampClause(orderStatus) + " WHERE order_code = ?");
            ps1.setString(1, orderStatus);
            ps1.setString(2, orderCode);
            ps1.executeUpdate();
            ps1.close();

            PreparedStatement ps2 = conn.prepareStatement(
                "INSERT INTO payments (order_id, method, status, paid_at) " +
                "SELECT order_id, payment_method, ?, ? FROM orders WHERE order_code = ?");
            ps2.setString(1, paymentStatus);
            ps2.setTimestamp(2, "SUCCESS".equals(paymentStatus)
                    ? new java.sql.Timestamp(System.currentTimeMillis()) : null);
            ps2.setString(3, orderCode);
            ps2.executeUpdate();
            ps2.close();

            if (orderId > 0) {
                insertStatusLog(conn, orderId, oldStatus, orderStatus, "payment_gateway");
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            try { if (conn != null) conn.rollback(); } catch (Exception ignored) {}
            return false;
        } finally {
            try { if (conn != null) { conn.setAutoCommit(true); conn.close(); } } catch (Exception ignored) {}
        }
    }

    /** Lấy toàn bộ lịch sử thay đổi trạng thái của một đơn hàng. */
    public List<OrderStatusLog> getStatusLogs(int orderId) {
        List<OrderStatusLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM order_status_logs WHERE order_id = ? ORDER BY changed_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderStatusLog log = new OrderStatusLog();
                log.setId(rs.getInt("id"));
                log.setOrderId(rs.getInt("order_id"));
                log.setOldStatus(rs.getString("old_status"));
                log.setNewStatus(rs.getString("new_status"));
                log.setChangedBy(rs.getString("changed_by"));
                log.setChangedAt(rs.getTimestamp("changed_at"));
                logs.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return logs;
    }
}