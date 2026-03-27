package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Author;
import model.Book;
import model.Category;
import util.DBConnection;

public class BookDAO {

	//list books
    public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT b.*, " +
                "c.category_id AS cid, c.category_name AS cname, " +
                "a.author_id, a.author_name " +
                "FROM books b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN authors a ON b.author_id = a.author_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapBook(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    // detail book
    public Book getBookById(int id) {
        String sql = "SELECT b.*, c.category_id AS cid, c.category_name AS cname, " +
                "a.author_id, a.author_name " +
                "FROM books b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN authors a ON b.author_id = a.author_id " +
                "WHERE b.book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBook(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // list category
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM categories";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Category c = new Category(rs.getInt("category_id"), rs.getString("category_name"));
                list.add(c);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //search book
    public List<Book> searchBooks(String keyword, List<Integer> categoryIds, Double minPrice, Double maxPrice) {
        List<Book> list = new ArrayList<>();

        String sql = "SELECT b.*, " +
                "c.category_id AS cid, c.category_name AS cname, " +
                "a.author_id, a.author_name " +
                "FROM books b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN authors a ON b.author_id = a.author_id " +
                "WHERE 1=1";

        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND b.title LIKE ?";
        }

        if (categoryIds != null && !categoryIds.isEmpty()) {
            sql += " AND b.category_id IN (";
            for (int j = 0; j < categoryIds.size(); j++) {
                sql += (j == 0 ? "?" : ",?");
            }
            sql += ")";
        }

        if (minPrice != null) {
            sql += " AND b.price >= ?";
        }

        if (maxPrice != null) {
            sql += " AND b.price <= ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(i++, "%" + keyword + "%");
            }

            if (categoryIds != null && !categoryIds.isEmpty()) {
                for (Integer catId : categoryIds) {
                    ps.setInt(i++, catId);
                }
            }

            if (minPrice != null) {
                ps.setDouble(i++, minPrice);
            }

            if (maxPrice != null) {
                ps.setDouble(i++, maxPrice);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBook(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    // related book
    public List<Book> getRelatedBooks(int categoryId, int excludeBookId) {
        List<Book> list = new ArrayList<>();

        String sql = "SELECT b.*, " +
                "c.category_id AS cid, c.category_name AS cname, " +
                "a.author_id, a.author_name " +
                "FROM books b " +
                "LEFT JOIN categories c ON b.category_id = c.category_id " +
                "LEFT JOIN authors a ON b.author_id = a.author_id " +
                "WHERE b.category_id = ? AND b.book_id != ? " +
                "LIMIT 3";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, excludeBookId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapBook(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }    private Book mapBook(ResultSet rs) throws Exception {
        Book b = new Book();
        b.setId(rs.getInt("book_id"));
        b.setTitle(rs.getString("title"));
        b.setPrice(rs.getDouble("price"));
        b.setStock(rs.getInt("stock"));
        b.setDescription(rs.getString("description"));
        b.setImage(rs.getString("image"));
        b.setPublishYear(rs.getInt("publish_year"));

        int cid = rs.getInt("cid");
        String cname = rs.getString("cname");
        if (cname != null) {
            b.setCategory(new Category(cid, cname));
        }

        int authorId = rs.getInt("author_id");
        String authorName = rs.getString("author_name");
        if (authorName != null) {
            b.setAuthor(new Author(authorId, authorName));
        }

        return b;
    }
}
