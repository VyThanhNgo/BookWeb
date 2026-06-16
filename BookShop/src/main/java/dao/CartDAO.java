package dao;

import model.CartItem;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class CartDAO {

    // Thêm 1 sách vào giỏ trong DB, nếu đã có thì cập nhật lại số lượng
    public void syncItem(int userId, int bookId, int quantity) {
        String sql = "INSERT INTO cart_items (user_id, book_id, quantity) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE quantity = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            ps.setInt(4, quantity);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xoá 1 sách khỏi giỏ trong DB
    public void removeItem(int userId, int bookId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ? AND book_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Xoá hết giỏ hàng của user trong DB
    public void clearCart(int userId) {
        String sql = "DELETE FROM cart_items WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy giỏ hàng của user từ DB (nối với bảng books để có tên, giá, ảnh)
    public List<CartItem> loadItems(int userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.book_id, ci.quantity, b.title, b.price, b.image, b.stock " +
                     "FROM cart_items ci JOIN books b ON ci.book_id = b.book_id " +
                     "WHERE ci.user_id = ? AND b.is_deleted = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int qty   = rs.getInt("quantity");
                int stock = rs.getInt("stock");
                // Không cho số lượng vượt quá tồn kho hiện tại
                if (stock > 0 && qty > stock) qty = stock;
                items.add(new CartItem(
                    rs.getInt("book_id"),
                    rs.getString("title"),
                    rs.getDouble("price"),
                    Math.max(qty, 1),
                    rs.getString("image")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    // Lưu cả giỏ hàng xuống DB (xoá hết cũ rồi thêm lại)
    public void saveFullCart(int userId, Collection<CartItem> items) {
        clearCart(userId);
        for (CartItem item : items) {
            syncItem(userId, item.getBookId(), item.getQuantity());
        }
    }
}
