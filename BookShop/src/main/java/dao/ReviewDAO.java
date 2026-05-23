package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Review;
import util.DBConnection;

public class ReviewDAO {

    public void addReview(Review review, List<String> imageUrls) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Dùng Transaction để đảm bảo lưu đủ cả review và ảnh

            // Lưu vào bảng reviews
            String sqlReview = "INSERT INTO reviews (book_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sqlReview, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, review.getBookId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            ps.executeUpdate();

            // Lấy ID của review vừa tạo
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int reviewId = rs.getInt(1);

                // 2. Lưu danh sách ảnh vào bảng review_images
                if (imageUrls != null && !imageUrls.isEmpty()) {
                    String sqlImg = "INSERT INTO review_images (review_id, image_url) VALUES (?, ?)";
                    PreparedStatement psImg = conn.prepareStatement(sqlImg);
                    for (String url : imageUrls) {
                        psImg.setInt(1, reviewId);
                        psImg.setString(2, url);
                        psImg.addBatch(); // Dùng batch để nhanh hơn
                    }
                    psImg.executeBatch();
                }
            }
            conn.commit();
        } catch (Exception e) {
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
            e.printStackTrace();
        }
    }

    public List<Review> getReviewsByBookId(int bookId) {
        List<Review> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            // Join với bảng users để lấy tên và ảnh đại diện
            String sql = "SELECT r.*, u.full_name, u.avatar FROM reviews r " +
                         "JOIN users u ON r.user_id = u.user_id " +
                         "WHERE r.book_id = ? ORDER BY r.created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                int rId = rs.getInt("review_id");
                r.setReviewId(rId);
                r.setBookId(rs.getInt("book_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setUserName(rs.getString("full_name"));
                r.setUserAvatar(rs.getString("avatar"));
                
                // Lấy ảnh của review
                r.setImages(getImagesByReviewId(rId));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private List<String> getImagesByReviewId(int reviewId) {
        List<String> images = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT image_url FROM review_images WHERE review_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                images.add(rs.getString("image_url"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return images;
    }
    
 //đếm tổng review theo filter(dùng cho phân trang)
    public int countReviews(int bookId, int starFilter, boolean hasImageFilter) {
        try {
            Connection conn = DBConnection.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM reviews r WHERE r.book_id = ?");
            
            if (starFilter > 0) {
                sql.append(" AND r.rating = ").append(starFilter);
            }
            if (hasImageFilter) {
                sql.append(" AND EXISTS (SELECT 1 FROM review_images ri WHERE ri.review_id = r.review_id)");
            }
            
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    //lấy review có lọc +phân trang
    public List<Review> getReviewsFiltered(int bookId, int starFilter, 
                                            boolean hasImageFilter, int page, int pageSize) {
        List<Review> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            StringBuilder sql = new StringBuilder(
                "SELECT r.*, u.full_name, u.avatar FROM reviews r " +
                "JOIN users u ON r.user_id = u.user_id " +
                "WHERE r.book_id = ?");
            
            if (starFilter > 0) {
                sql.append(" AND r.rating = ").append(starFilter);
            }
            if (hasImageFilter) {
                sql.append(" AND EXISTS (SELECT 1 FROM review_images ri WHERE ri.review_id = r.review_id)");
            }
            
            sql.append(" ORDER BY r.created_at DESC");
            sql.append(" LIMIT ? OFFSET ?");
            
            PreparedStatement ps = conn.prepareStatement(sql.toString());
            ps.setInt(1, bookId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Review r = new Review();
                int rId = rs.getInt("review_id");
                r.setReviewId(rId);
                r.setBookId(rs.getInt("book_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setUserName(rs.getString("full_name"));
                r.setUserAvatar(rs.getString("avatar"));
                r.setImages(getImagesByReviewId(rId));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}