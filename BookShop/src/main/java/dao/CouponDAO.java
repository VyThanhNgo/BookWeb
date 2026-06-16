package dao;

import util.DBConnection;
import model.Coupon;

import java.sql.*;

public class CouponDAO {

    public Coupon findByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.toUpperCase().trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Coupon c = new Coupon();
                c.setCouponId(rs.getInt("coupon_id"));
                c.setCode(rs.getString("code"));
                c.setDiscountType(rs.getString("discount_type"));
                c.setDiscountValue(rs.getDouble("discount_value"));
                c.setMinOrderAmount(rs.getDouble("min_order_amount"));
                double max = rs.getDouble("max_discount");
                c.setMaxDiscount(rs.wasNull() ? null : max);
                int limit = rs.getInt("usage_limit");
                c.setUsageLimit(rs.wasNull() ? null : limit);
                c.setUsedCount(rs.getInt("used_count"));
                c.setExpiresAt(rs.getTimestamp("expires_at"));
                c.setActive(rs.getBoolean("is_active"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Trả về số tiền giảm thực tế, 0 nếu không hợp lệ
    public double computeDiscount(Coupon coupon, double subtotal) {
        if (coupon == null || !coupon.isActive()) return 0;
        if (subtotal < coupon.getMinOrderAmount()) return 0;
        if (coupon.getExpiresAt() != null && coupon.getExpiresAt().before(new Timestamp(System.currentTimeMillis()))) return 0;
        if (coupon.getUsageLimit() != null && coupon.getUsedCount() >= coupon.getUsageLimit()) return 0;

        double discount;
        if ("PERCENT".equals(coupon.getDiscountType())) {
            discount = subtotal * coupon.getDiscountValue() / 100.0;
            if (coupon.getMaxDiscount() != null) discount = Math.min(discount, coupon.getMaxDiscount());
        } else {
            discount = coupon.getDiscountValue();
        }
        return Math.min(discount, subtotal);
    }

    public java.util.List<Coupon> getAllCoupons() {
        java.util.List<Coupon> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM coupons ORDER BY coupon_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Coupon c = new Coupon();
                c.setCouponId(rs.getInt("coupon_id"));
                c.setCode(rs.getString("code"));
                c.setDiscountType(rs.getString("discount_type"));
                c.setDiscountValue(rs.getDouble("discount_value"));
                c.setMinOrderAmount(rs.getDouble("min_order_amount"));
                double max = rs.getDouble("max_discount");
                c.setMaxDiscount(rs.wasNull() ? null : max);
                int lim = rs.getInt("usage_limit");
                c.setUsageLimit(rs.wasNull() ? null : lim);
                c.setUsedCount(rs.getInt("used_count"));
                c.setExpiresAt(rs.getTimestamp("expires_at"));
                c.setActive(rs.getBoolean("is_active"));
                list.add(c);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean createCoupon(Coupon c) {
        String sql = "INSERT INTO coupons (code, discount_type, discount_value, min_order_amount, max_discount, usage_limit, expires_at, is_active) VALUES (?,?,?,?,?,?,?,1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCode().toUpperCase().trim());
            ps.setString(2, c.getDiscountType());
            ps.setDouble(3, c.getDiscountValue());
            ps.setDouble(4, c.getMinOrderAmount());
            if (c.getMaxDiscount() != null) ps.setDouble(5, c.getMaxDiscount()); else ps.setNull(5, java.sql.Types.DECIMAL);
            if (c.getUsageLimit() != null) ps.setInt(6, c.getUsageLimit()); else ps.setNull(6, java.sql.Types.INTEGER);
            ps.setTimestamp(7, c.getExpiresAt());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateCoupon(Coupon c) {
        String sql = "UPDATE coupons SET code=?, discount_type=?, discount_value=?, min_order_amount=?, max_discount=?, usage_limit=?, expires_at=? WHERE coupon_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCode().toUpperCase().trim());
            ps.setString(2, c.getDiscountType());
            ps.setDouble(3, c.getDiscountValue());
            ps.setDouble(4, c.getMinOrderAmount());
            if (c.getMaxDiscount() != null) ps.setDouble(5, c.getMaxDiscount()); else ps.setNull(5, java.sql.Types.DECIMAL);
            if (c.getUsageLimit() != null) ps.setInt(6, c.getUsageLimit()); else ps.setNull(6, java.sql.Types.INTEGER);
            ps.setTimestamp(7, c.getExpiresAt());
            ps.setInt(8, c.getCouponId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteCoupon(int id) {
        String sql = "DELETE FROM coupons WHERE coupon_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean toggleActive(int id) {
        String sql = "UPDATE coupons SET is_active = 1 - is_active WHERE coupon_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    // Tăng số lần đã dùng của mã, chỉ tăng khi mã vẫn còn lượt
    // Trả về true nếu tăng được, false nếu hết lượt hoặc lỗi
    public boolean incrementUsed(String code) {
        String sql = "UPDATE coupons SET used_count = used_count + 1 " +
                     "WHERE code = ? AND (usage_limit IS NULL OR used_count < usage_limit)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.toUpperCase().trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Trả lại 1 lượt dùng mã (khi huỷ đơn), không cho xuống dưới 0
    public void decrementUsed(String code) {
        if (code == null || code.trim().isEmpty()) return;
        String sql = "UPDATE coupons SET used_count = used_count - 1 WHERE code = ? AND used_count > 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.toUpperCase().trim());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
