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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class OrderDAO {

    public boolean createFullOrder(Order order, Collection<CartItem> items) {
        Connection conn = null;
        PreparedStatement orderPs = null;
        PreparedStatement detailPs = null;
        ResultSet rs = null;

        String insertOrderSql = "INSERT INTO orders (" +
                "user_id, order_code, customer_name, email, phone, address_line, ward, district, province, note, " +
                "payment_method, status, subtotal, shipping_fee, discount_amount, total_amount, coupon_code" +
                ") VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
            String couponCode = order.getCouponCode();
            orderPs.setString(17, (couponCode != null && !couponCode.trim().isEmpty())
                    ? couponCode.trim().toUpperCase() : null);

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
            int[] stockResults = stockPs.executeBatch();
            stockPs.close();

            for (int r : stockResults) {
                if (r == 0) {
                    conn.rollback();
                    return false;
                }
            }

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
        o.setCouponCode(rs.getString("coupon_code"));
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
                "SELECT status, payment_method, coupon_code FROM orders WHERE order_id = ?");
            checkPs.setInt(1, orderId);
            ResultSet checkRs = checkPs.executeQuery();
            if (!checkRs.next()) { conn.rollback(); return false; }
            String currentStatus = checkRs.getString("status");
            String method        = checkRs.getString("payment_method");
            String couponCode    = checkRs.getString("coupon_code");
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

            // Hoàn lượt coupon nếu coupon đã thực sự được tính cho đơn này:
            //  - COD / BANK_TRANSFER: tính ngay khi tạo đơn
            //  - VNPAY / MOMO: chỉ tính khi đã thanh toán thành công (CONFIRMED/SHIPPING)
            if (couponCode != null && !couponCode.trim().isEmpty()) {
                boolean couponCounted = "COD".equals(method) || "BANK_TRANSFER".equals(method)
                        || "CONFIRMED".equals(currentStatus) || "SHIPPING".equals(currentStatus);
                if (couponCounted) new CouponDAO().decrementUsed(couponCode);
            }
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
        // Doanh thu chỉ tính đơn hợp lệ đã/đang được xử lý — loại đơn chưa thanh toán & thất bại
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                     "WHERE status NOT IN ('PENDING', 'PAYMENT_FAILED', 'CANCELLED')";
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

    public double[] getRevenueByMonth(int lastNMonths) {
        double[] result = new double[lastNMonths];
        String sql = "SELECT PERIOD_DIFF(DATE_FORMAT(NOW(),'%Y%m'), DATE_FORMAT(created_at,'%Y%m')) AS months_ago, " +
                     "SUM(total_amount) AS revenue FROM orders " +
                     "WHERE status NOT IN ('PENDING', 'PAYMENT_FAILED', 'CANCELLED') " +
                     "AND created_at >= DATE_SUB(NOW(), INTERVAL ? MONTH) GROUP BY months_ago";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, lastNMonths);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int idx = rs.getInt("months_ago");
                if (idx >= 0 && idx < lastNMonths)
                    result[lastNMonths - 1 - idx] = rs.getDouble("revenue");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
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

            // Lấy orderId + oldStatus + coupon để ghi log và xử lý lượt coupon
            PreparedStatement getPs = conn.prepareStatement(
                "SELECT order_id, status, coupon_code FROM orders WHERE order_code = ?");
            getPs.setString(1, orderCode);
            ResultSet getRs = getPs.executeQuery();
            int orderId = 0;
            String oldStatus = null;
            String couponCode = null;
            if (getRs.next()) {
                orderId    = getRs.getInt("order_id");
                oldStatus  = getRs.getString("status");
                couponCode = getRs.getString("coupon_code");
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
            // Cột paid_at là NOT NULL → luôn ghi thời điểm xử lý (kể cả khi FAILED)
            ps2.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));
            ps2.setString(3, orderCode);
            ps2.executeUpdate();
            ps2.close();

            if (orderId > 0) {
                insertStatusLog(conn, orderId, oldStatus, orderStatus, "payment_gateway");
            }

            conn.commit();

            // Thanh toán online thành công lần đầu (oldStatus chưa CONFIRMED) → mới tính lượt coupon.
            // Tránh tính trùng khi Return + IPN cùng chạy hoặc khi thanh toán lại.
            if ("SUCCESS".equals(paymentStatus)
                    && !"CONFIRMED".equals(oldStatus)
                    && couponCode != null && !couponCode.trim().isEmpty()) {
                new CouponDAO().incrementUsed(couponCode);
            }
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

    /**
     * Lấy danh sách sách trong đơn COMPLETED (trong vòng 30 ngày) mà user chưa review.
     * Gom theo từng đơn hàng, mỗi đơn chứa list sách chưa review.
     */
    public List<Map<String, Object>> getUnreviewedBooks(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.order_id, o.order_code, o.created_at AS order_date, "
                + "DATEDIFF(DATE_ADD(o.created_at, INTERVAL 30 DAY), NOW()) AS days_left, "
                + "od.id AS detail_id, od.book_id, od.book_title, b.image "
                + "FROM orders o "
                + "JOIN order_details od ON o.order_id = od.order_id "
                + "JOIN books b ON od.book_id = b.book_id "
                + "WHERE o.user_id = ? AND o.status = 'COMPLETED' "
                + "  AND o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) "
                + "  AND NOT EXISTS ( "
                + "    SELECT 1 FROM reviews r "
                + "    WHERE r.user_id = ? AND r.order_detail_id = od.id "
                + "  ) "
                + "ORDER BY o.created_at DESC, od.id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                Map<Integer, Map<String, Object>> orderMap = new java.util.LinkedHashMap<>();
                while (rs.next()) {
                    int orderId = rs.getInt("order_id");
                    if (!orderMap.containsKey(orderId)) {
                        Map<String, Object> order = new HashMap<>();
                        order.put("orderId", orderId);
                        order.put("orderCode", rs.getString("order_code"));
                        order.put("orderDate", rs.getTimestamp("order_date"));
                        order.put("daysLeft", rs.getInt("days_left"));
                        order.put("books", new ArrayList<Map<String, Object>>());
                        orderMap.put(orderId, order);
                    }
                    Map<String, Object> book = new HashMap<>();
                    book.put("detailId", rs.getInt("detail_id"));
                    book.put("bookId", rs.getInt("book_id"));
                    book.put("bookTitle", rs.getString("book_title"));
                    book.put("image", rs.getString("image"));
                    ((List<Map<String, Object>>) orderMap.get(orderId).get("books")).add(book);
                }
                list.addAll(orderMap.values());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy danh sách sách user đã review (kèm ảnh review).
     */
    public List<Map<String, Object>> getReviewedBooks(int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.review_id, r.rating, r.comment, r.created_at, "
                + "b.book_id, b.image AS book_image, od.book_title "
                + "FROM reviews r "
                + "JOIN order_details od ON od.book_id = r.book_id "
                + "JOIN orders o ON o.order_id = od.order_id AND o.user_id = ? "
                + "JOIN books b ON b.book_id = r.book_id "
                + "WHERE r.user_id = ? "
                + "GROUP BY r.review_id, r.rating, r.comment, r.created_at, b.book_id, b.image, od.book_title "
                + "ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> item = new HashMap<>();
                    int reviewId = rs.getInt("review_id");
                    item.put("reviewId", reviewId);
                    item.put("bookId", rs.getInt("book_id"));
                    item.put("bookTitle", rs.getString("book_title"));
                    item.put("image", rs.getString("book_image"));
                    item.put("rating", rs.getInt("rating"));
                    item.put("comment", rs.getString("comment"));
                    item.put("createdAt", rs.getTimestamp("created_at"));
                    item.put("reviewImages", getReviewImages(conn, reviewId));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy danh sách URL ảnh đính kèm của một review. */
    private List<String> getReviewImages(Connection conn, int reviewId) {
        List<String> imgs = new ArrayList<>();
        String sql = "SELECT image_url FROM review_images WHERE review_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reviewId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) imgs.add(rs.getString("image_url"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return imgs;
    }
}