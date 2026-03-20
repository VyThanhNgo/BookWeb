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
}
