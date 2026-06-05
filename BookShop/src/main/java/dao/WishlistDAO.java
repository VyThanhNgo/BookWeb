package dao;

import model.Author;
import model.Book;
import model.Category;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public boolean addToWishlist(int userId, int bookId) {
        String sql = "INSERT IGNORE INTO wishlist (user_id, book_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeFromWishlist(int userId, int bookId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND book_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isInWishlist(int userId, int bookId) {
        String sql = "SELECT 1 FROM wishlist WHERE user_id = ? AND book_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách book_id trong wishlist của user (dùng để check trạng thái tim)
    public List<Integer> getWishlistBookIds(int userId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT book_id FROM wishlist WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ids.add(rs.getInt("book_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    // Lấy danh sách sách đầy đủ trong wishlist (dùng cho trang wishlist.jsp)
    public List<Book> getWishlistBooks(int userId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.book_id,b.title,b.price,b.origin_price,b.image,b.slug,a.author_name,c.category_name "
                + "FROM wishlist w "
                + "JOIN books b ON w.book_id=b.book_id "
                + "LEFT JOIN authors a ON b.author_id=a.author_id "
                + "LEFT JOIN categories c ON b.category_id=c.category_id "
                + "WHERE w.user_id=? AND b.is_deleted=0 "
                + "ORDER BY w.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book b = new Book();
                    b.setId(rs.getInt("book_id"));
                    b.setTitle(rs.getString("title"));
                    b.setPrice(rs.getDouble("price"));
                    b.setOriginPrice(rs.getDouble("origin_price"));
                    b.setImage(rs.getString("image"));
                    b.setSlug(rs.getString("slug"));

                   Author author = new Author();
                    author.setName(rs.getString("author_name"));
                    b.setAuthor(author);

                   Category cat = new Category();
                    cat.setName(rs.getString("category_name"));
                    b.setCategory(cat);

                    books.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return books;
    }
    
    public int countWishlist(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}