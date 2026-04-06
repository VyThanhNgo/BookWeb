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

	// list books
	public List<Book> getAllBooks() {
		List<Book> list = new ArrayList<>();
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname "
					+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Book b = new Book();
				b.setId(rs.getInt("book_id"));
				b.setTitle(rs.getString("title"));
				b.setPrice(rs.getDouble("price"));
				b.setStock(rs.getInt("stock"));
				b.setImage(rs.getString("image"));

				Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
				b.setCategory(cat);

				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// detail book
	public Book getBookById(int id) {
		Book b = null;
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, a.author_name, a.image as author_image "
					+ "FROM books b " + "LEFT JOIN categories c ON b.category_id = c.category_id "
					+ "LEFT JOIN authors a ON b.author_id = a.author_id " + "WHERE b.book_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				b = new Book();
				b.setId(rs.getInt("book_id"));
				b.setTitle(rs.getString("title"));
				b.setDescription(rs.getString("description"));
				b.setPrice(rs.getDouble("price"));
				b.setStock(rs.getInt("stock"));
				b.setPublishYear(rs.getInt("publish_year"));
				b.setImage(rs.getString("image"));
				b.setIsbn(rs.getString("isbn"));
	            b.setPublisher(rs.getString("publisher"));
	            b.setLanguage(rs.getString("language"));
	            b.setCoverType(rs.getString("cover_type"));
	            b.setSoldQuantity(rs.getInt("sold_quantity"));

				Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
				b.setCategory(cat);
				Author author = new Author(rs.getInt("author_id"), rs.getString("author_name"));
				author.setImage(rs.getString("author_image"));
				b.setAuthor(author);

			}
		} catch (Exception e) {
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
			while (rs.next()) {
				Category c = new Category(rs.getInt("category_id"), rs.getString("category_name"));
				list.add(c);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	//lấy ds ảnh phụ 
	public List<String> getSubImagesByBookId(int bookId) {
	    List<String> images = new ArrayList<>();
	    try {
	        Connection conn = DBConnection.getConnection();
	        String sql = "SELECT image_url FROM book_images WHERE book_id = ?";
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setInt(1, bookId);
	        ResultSet rs = ps.executeQuery();
	        while (rs.next()) {
	            images.add(rs.getString("image_url"));
	        }
	    } catch (Exception e) { e.printStackTrace(); }
	    return images;
	}
	
	// search book
	public List<Book> searchBooks(String keyword, List<Integer> categoryIds, Double minPrice, Double maxPrice,
			String sort) {
		List<Book> list = new ArrayList<>();
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname "
					+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id " + "WHERE 1=1";
			if (keyword != null && !keyword.isEmpty())
				sql += " AND b.title LIKE ?";
			if (categoryIds != null && !categoryIds.isEmpty()) {
				sql += " AND b.category_id IN (";
				for (int j = 0; j < categoryIds.size(); j++) {
					sql += j == 0 ? "?" : ",?";
				}
				sql += ")";
			}
			if (minPrice != null)
				sql += " AND b.price >= ?";
			if (maxPrice != null)
				sql += " AND b.price <= ?";

			if ("name_asc".equals(sort))
				sql += " ORDER BY b.title ASC";
			else if ("name_desc".equals(sort))
				sql += " ORDER BY b.title DESC";
			else if ("price_asc".equals(sort))
				sql += " ORDER BY b.price ASC";
			else if ("price_desc".equals(sort))
				sql += " ORDER BY b.price DESC";
			else
				sql += " ORDER BY b.book_id DESC"; // mặc định: mới nhất

			PreparedStatement ps = conn.prepareStatement(sql);
			int i = 1;
			if (keyword != null && !keyword.isEmpty())
				ps.setString(i++, "%" + keyword + "%");
			if (categoryIds != null && !categoryIds.isEmpty()) {
				for (Integer catId : categoryIds) {
					ps.setInt(i++, catId);
				}
			}
			if (minPrice != null)
				ps.setDouble(i++, minPrice);
			if (maxPrice != null)
				ps.setDouble(i++, maxPrice);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Book b = new Book();
				b.setId(rs.getInt("book_id"));
				b.setTitle(rs.getString("title"));
				b.setPrice(rs.getDouble("price"));
				b.setImage(rs.getString("image"));

				Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
				b.setCategory(cat);
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// related book
	public List<Book> getRelatedBooks(int categoryId, int excludeBookId) {
		List<Book> list = new ArrayList<>();
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname "
					+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id "
					+ "WHERE b.category_id = ? AND b.book_id != ? LIMIT 3";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, categoryId);
			ps.setInt(2, excludeBookId);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Book b = new Book();
				b.setId(rs.getInt("book_id"));
				b.setTitle(rs.getString("title"));
				b.setPrice(rs.getDouble("price"));
				b.setImage(rs.getString("image"));

				Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
				b.setCategory(cat);
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// add book
	public int addBook(String title, double price, int categoryId, int authorId, int publishYear, String description,
	        int stock, String image, String isbn, String publisher, String language, String coverType) {
	    int generatedId = -1;
	    try {
	        Connection conn = DBConnection.getConnection();
	        String sql = "INSERT INTO books (title, price, category_id, author_id, publish_year, "
	                + "description, stock, image, isbn, publisher, language, cover_type) "
	                + "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
	        
	        // Thêm RETURN_GENERATED_KEYS
	        PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
	        ps.setString(1, title);
	        ps.setDouble(2, price);
	        ps.setInt(3, categoryId);
	        ps.setInt(4, authorId);
	        ps.setInt(5, publishYear);
	        ps.setString(6, description);
	        ps.setInt(7, stock);
	        ps.setString(8, image);
	        ps.setString(9, isbn);
	        ps.setString(10, publisher);
	        ps.setString(11, language);
	        ps.setString(12, coverType);
	        
	        ps.executeUpdate();
	        
	        // Lấy ID vừa tạo
	        ResultSet rs = ps.getGeneratedKeys();
	        if (rs.next()) {
	            generatedId = rs.getInt(1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return generatedId;
	}
	
	//thêm ảnh phụ
	public void addBookImage(int bookId, String imageUrl) {
	    try {
	        Connection conn = DBConnection.getConnection();
	        String sql = "INSERT INTO book_images (book_id, image_url) VALUES (?, ?)";
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setInt(1, bookId);
	        ps.setString(2, imageUrl);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
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
	// get author list
	public List<Author> getAllAuthors() {
		List<Author> list = new ArrayList<>();
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("SELECT * FROM authors");
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Author a = new Author(rs.getInt("author_id"), rs.getString("author_name"));
				a.setImage(rs.getString("image"));
				list.add(a);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// update book
	public void updateBook(int bookId, String title, double price, int categoryId, int authorId, int publishYear,
	        String description, int stock, String image, String isbn, String publisher, String language, String coverType) {
	    try {
	        Connection conn = DBConnection.getConnection();
	        String sql = "UPDATE books SET title=?, price=?, category_id=?, author_id=?, "
	                + "publish_year=?, description=?, stock=?, image=?, isbn=?, publisher=?, "
	                + "language=?, cover_type=? WHERE book_id=?";
	        PreparedStatement ps = conn.prepareStatement(sql);
	        ps.setString(1, title);
	        ps.setDouble(2, price);
	        ps.setInt(3, categoryId);
	        ps.setInt(4, authorId);
	        ps.setInt(5, publishYear);
	        ps.setString(6, description);
	        ps.setInt(7, stock);
	        ps.setString(8, image);
	        ps.setString(9, isbn);
	        ps.setString(10, publisher);
	        ps.setString(11, language);
	        ps.setString(12, coverType);
	        ps.setInt(13, bookId);
	        ps.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

// xóa sách
	public void deleteBook(int bookId) {
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "DELETE FROM books WHERE book_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, bookId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// phân trang
	public int countBooks(String keyword, List<Integer> categoryIds, Double minPrice, Double maxPrice) {
		int total = 0;
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT COUNT(*) FROM books b WHERE 1=1";
			if (keyword != null && !keyword.isEmpty())
				sql += " AND b.title LIKE ?";
			if (categoryIds != null && !categoryIds.isEmpty()) {
				sql += " AND b.category_id IN (";
				for (int j = 0; j < categoryIds.size(); j++)
					sql += j == 0 ? "?" : ",?";
				sql += ")";
			}
			if (minPrice != null)
				sql += " AND b.price >= ?";
			if (maxPrice != null)
				sql += " AND b.price <= ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			int i = 1;
			if (keyword != null && !keyword.isEmpty())
				ps.setString(i++, "%" + keyword + "%");
			if (categoryIds != null && !categoryIds.isEmpty())
				for (Integer catId : categoryIds)
					ps.setInt(i++, catId);
			if (minPrice != null)
				ps.setDouble(i++, minPrice);
			if (maxPrice != null)
				ps.setDouble(i++, maxPrice);

			ResultSet rs = ps.executeQuery();
			if (rs.next())
				total = rs.getInt(1);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return total;
	}

	public List<Book> searchBooks(String keyword, List<Integer> categoryIds, Double minPrice, Double maxPrice,
			String sort, int page, int pageSize) {
		List<Book> list = new ArrayList<>();
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname "
					+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id WHERE 1=1";
			if (keyword != null && !keyword.isEmpty())
				sql += " AND b.title LIKE ?";
			if (categoryIds != null && !categoryIds.isEmpty()) {
				sql += " AND b.category_id IN (";
				for (int j = 0; j < categoryIds.size(); j++)
					sql += j == 0 ? "?" : ",?";
				sql += ")";
			}
			if (minPrice != null)
				sql += " AND b.price >= ?";
			if (maxPrice != null)
				sql += " AND b.price <= ?";

			if ("name_asc".equals(sort))
				sql += " ORDER BY b.title ASC";
			else if ("name_desc".equals(sort))
				sql += " ORDER BY b.title DESC";
			else if ("price_asc".equals(sort))
				sql += " ORDER BY b.price ASC";
			else if ("price_desc".equals(sort))
				sql += " ORDER BY b.price DESC";
			else
				sql += " ORDER BY b.book_id DESC";

			sql += " LIMIT ? OFFSET ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			int i = 1;
			if (keyword != null && !keyword.isEmpty())
				ps.setString(i++, "%" + keyword + "%");
			if (categoryIds != null && !categoryIds.isEmpty())
				for (Integer catId : categoryIds)
					ps.setInt(i++, catId);
			if (minPrice != null)
				ps.setDouble(i++, minPrice);
			if (maxPrice != null)
				ps.setDouble(i++, maxPrice);
			ps.setInt(i++, pageSize);
			ps.setInt(i++, (page - 1) * pageSize);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				Book b = new Book();
				b.setId(rs.getInt("book_id"));
				b.setTitle(rs.getString("title"));
				b.setPrice(rs.getDouble("price"));
				b.setImage(rs.getString("image"));
				Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
				b.setCategory(cat);
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// get author
	public Author getAuthorById(int id) {
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("SELECT * FROM authors WHERE author_id = ?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				Author a = new Author(rs.getInt("author_id"), rs.getString("author_name"));
				a.setImage(rs.getString("image"));
				return a;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	// crud Author

	public void addAuthor(String name, String image) {
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("INSERT INTO authors (author_name, image) VALUES (?, ?)");
			ps.setString(1, name);
			ps.setString(2, image);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void deleteAuthor(int id) {
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("DELETE FROM authors WHERE author_id = ?");
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void updateAuthor(int id, String name, String image) {
		try {
			Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("UPDATE authors SET author_name=?, image=? WHERE author_id=?");
			ps.setString(1, name);
			ps.setString(2, image);
			ps.setInt(3, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
