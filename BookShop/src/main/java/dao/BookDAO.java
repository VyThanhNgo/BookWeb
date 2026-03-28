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
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname " +
                    "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getDouble("price"));
                
                Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
                b.setCategory(cat);
                
                list.add(b);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // detail book
    public Book getBookById(int id) {
        Book b = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, a.author_name " +
                    "FROM books b " +
                    "LEFT JOIN categories c ON b.category_id = c.category_id " +
                    "LEFT JOIN authors a ON b.author_id = a.author_id " +
                    "WHERE b.book_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getDouble("price"));
                b.setPublishYear(rs.getInt("publish_year"));
                Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
                b.setCategory(cat);
                Author author = new Author(rs.getInt("author_id"), rs.getString("author_name"));
                b.setAuthor(author);
                
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return b;
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
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname " +
                         "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id " +
                         "WHERE 1=1";
            if(keyword != null && !keyword.isEmpty())
                sql += " AND b.title LIKE ?";
            if(categoryIds != null && !categoryIds.isEmpty()) {
                sql += " AND b.category_id IN (";
                for(int j = 0; j < categoryIds.size(); j++) {
                    sql += j == 0 ? "?" : ",?";
                }
                sql += ")";
            }
            if(minPrice != null)
                sql += " AND b.price >= ?";
            if(maxPrice != null)
                sql += " AND b.price <= ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            int i = 1;
            if(keyword != null && !keyword.isEmpty())
                ps.setString(i++, "%" + keyword + "%");
            if(categoryIds != null && !categoryIds.isEmpty()) {
                for(Integer catId : categoryIds) {
                    ps.setInt(i++, catId);
                }
            }
            if(minPrice != null)
                ps.setDouble(i++, minPrice);
            if(maxPrice != null)
                ps.setDouble(i++, maxPrice);

            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getDouble("price"));
                Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
                b.setCategory(cat);
                list.add(b);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // related book
    public List<Book> getRelatedBooks(int categoryId, int excludeBookId) {
        List<Book> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname " +
                         "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id " +
                         "WHERE b.category_id = ? AND b.book_id != ? LIMIT 3";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setInt(2, excludeBookId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getDouble("price"));
                Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
                b.setCategory(cat);
                list.add(b);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Book> getNewBooks(int limit) {
        List<Book> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, a.author_name " +
                    "FROM books b " +
                    "LEFT JOIN categories c ON b.category_id = c.category_id " +
                    "LEFT JOIN authors a ON b.author_id = a.author_id " +
                    "ORDER BY b.book_id DESC LIMIT ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getDouble("price"));
                b.setStock(rs.getInt("stock"));
                b.setImage(rs.getString("image"));
                b.setDescription(rs.getString("description"));

                Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
                b.setCategory(cat);

                Author author = new Author(rs.getInt("author_id"), rs.getString("author_name"));
                b.setAuthor(author);

                list.add(b);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Book> getBestSellers(int limit) {
        List<Book> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, a.author_name " +
                    "FROM books b " +
                    "LEFT JOIN categories c ON b.category_id = c.category_id " +
                    "LEFT JOIN authors a ON b.author_id = a.author_id " +
                    "ORDER BY RAND() LIMIT ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Book b = new Book();
                b.setId(rs.getInt("book_id"));
                b.setTitle(rs.getString("title"));
                b.setPrice(rs.getDouble("price"));
                b.setStock(rs.getInt("stock"));
                b.setImage(rs.getString("image"));
                b.setDescription(rs.getString("description"));

                Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
                b.setCategory(cat);

                Author author = new Author(rs.getInt("author_id"), rs.getString("author_name"));
                b.setAuthor(author);

                list.add(b);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countBooksByCategory(int categoryId) {
        int count = 0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) as total FROM books WHERE category_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                count = rs.getInt("total");
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return count;
    }
}
