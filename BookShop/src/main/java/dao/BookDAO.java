package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Author;
import model.Book;
import model.Category;
import util.DBConnection;
import util.StringUtils;

public class BookDAO {

	// list books
	public List<Book> getAllBooks() {
		List<Book> list = new ArrayList<>();
		String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, "
				+ "a.author_id as aid, a.author_name "
				+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id "
				+ "LEFT JOIN authors a ON b.author_id = a.author_id " + "WHERE b.is_deleted = 0";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				Book b = new Book();
				b.setId(rs.getInt("book_id"));
				b.setTitle(rs.getString("title"));
				b.setPrice(rs.getDouble("price"));
				b.setStock(rs.getInt("stock"));
				b.setImage(rs.getString("image"));
				b.setSlug(rs.getString("slug"));
				b.setOriginPrice(rs.getDouble("origin_price"));

				b.setSoldQuantity(rs.getInt("sold_quantity"));
				b.setIsbn(rs.getString("isbn"));
				b.setPublisher(rs.getString("publisher"));
				b.setLanguage(rs.getString("language"));
				b.setCoverType(rs.getString("cover_type"));
				b.setPublishYear(rs.getInt("publish_year"));
				b.setDescription(rs.getString("description"));

				Author author = new Author(rs.getInt("aid"), rs.getString("author_name"));
				b.setAuthor(author);

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
		String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, a.author_name, a.image as author_image, "
				+ "COALESCE(AVG(r.rating),0) as avg_rating, COUNT(r.review_id) as review_count " + "FROM books b "
				+ "LEFT JOIN categories c ON b.category_id = c.category_id "
				+ "LEFT JOIN authors a ON b.author_id = a.author_id " + "LEFT JOIN reviews r ON r.book_id = b.book_id "
				+ "WHERE b.book_id = ? AND b.is_deleted = 0 GROUP BY b.book_id";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					b = new Book();
					b.setId(rs.getInt("book_id"));
					b.setTitle(rs.getString("title"));
					b.setSlug(rs.getString("slug"));
					b.setDescription(rs.getString("description"));
					b.setOriginPrice(rs.getDouble("origin_price"));
					b.setPrice(rs.getDouble("price"));
					b.setStock(rs.getInt("stock"));
					b.setPublishYear(rs.getInt("publish_year"));
					b.setImage(rs.getString("image"));
					b.setIsbn(rs.getString("isbn"));
					b.setPublisher(rs.getString("publisher"));
					b.setLanguage(rs.getString("language"));
					b.setCoverType(rs.getString("cover_type"));
					b.setSoldQuantity(rs.getInt("sold_quantity"));
					b.setAvgRating(rs.getDouble("avg_rating"));
					b.setReviewCount(rs.getInt("review_count"));
					b.setSubImages(this.getSubImagesByBookId(id));

					Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
					b.setCategory(cat);
					Author author = new Author(rs.getInt("author_id"), rs.getString("author_name"));
					author.setImage(rs.getString("author_image"));
					b.setAuthor(author);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return b;
	}

	// list category
	public List<Category> getAllCategories() {
		List<Category> list = new ArrayList<>();
		String sql = "SELECT * FROM categories WHERE is_deleted = 0";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				Category c = new Category(rs.getInt("category_id"), rs.getString("category_name"));
				list.add(c);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// lấy ds ảnh phụ
	public List<String> getSubImagesByBookId(int bookId) {
		List<String> images = new ArrayList<>();
		String sql = "SELECT image_url FROM book_images WHERE book_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					images.add(rs.getString("image_url"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return images;
	}

	// search book
	public List<Book> searchBooks(String keyword, List<Integer> categoryIds, Double minPrice, Double maxPrice,
			String sort) {
		List<Book> list = new ArrayList<>();
		try {
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

			try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						Book b = new Book();
						b.setId(rs.getInt("book_id"));
						b.setTitle(rs.getString("title"));
						b.setPrice(rs.getDouble("price"));
						b.setImage(rs.getString("image"));
						b.setSlug(rs.getString("slug"));
						b.setOriginPrice(rs.getDouble("origin_price"));

						Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
						b.setCategory(cat);
						list.add(b);
					}
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
		String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname "
				+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id "
				+ "WHERE b.category_id = ? AND b.book_id != ? LIMIT 3";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, categoryId);
			ps.setInt(2, excludeBookId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Book b = new Book();
					b.setId(rs.getInt("book_id"));
					b.setTitle(rs.getString("title"));
					b.setPrice(rs.getDouble("price"));
					b.setImage(rs.getString("image"));
					b.setSlug(rs.getString("slug"));
					b.setOriginPrice(rs.getDouble("origin_price"));

					Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
					b.setCategory(cat);
					list.add(b);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// add book
	public int addBook(String title, double price, double originPrice, int categoryId, int authorId, int publishYear,
			String description, int stock, String image, String isbn, String publisher, String language,
			String coverType) {
		int generatedId = -1;
		String sql = "INSERT INTO books (title, price, origin_price, category_id, author_id, publish_year, "
				+ "description, stock, image, isbn, publisher, language, cover_type, slug) "
				+ "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		try (Connection conn = DBConnection.getConnection();
				// Thêm RETURN_GENERATED_KEYS
				PreparedStatement ps = conn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
			ps.setString(1, title);
			ps.setDouble(2, price);
			ps.setDouble(3, originPrice); // THÊM
			ps.setInt(4, categoryId);
			ps.setInt(5, authorId);
			ps.setInt(6, publishYear);
			ps.setString(7, description);
			ps.setInt(8, stock);
			ps.setString(9, image);
			ps.setString(10, isbn);
			ps.setString(11, publisher);
			ps.setString(12, language);
			ps.setString(13, coverType);
			String slug = StringUtils.toSlug(title);
			ps.setString(14, slug);

			ps.executeUpdate();

			// Lấy ID vừa tạo
			try (ResultSet rs = ps.getGeneratedKeys()) {
				if (rs.next()) {
					generatedId = rs.getInt(1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return generatedId;
	}

	// thêm ảnh phụ
	public void addBookImage(int bookId, String imageUrl) {
		String sql = "INSERT INTO book_images (book_id, image_url) VALUES (?, ?)";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookId);
			ps.setString(2, imageUrl);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public List<Book> getNewBooks(int limit) {
		List<Book> list = new ArrayList<>();
		String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, a.author_name " + "FROM books b "
				+ "LEFT JOIN categories c ON b.category_id = c.category_id "
				+ "LEFT JOIN authors a ON b.author_id = a.author_id " + "ORDER BY b.book_id DESC LIMIT ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, limit);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Book b = new Book();
					b.setId(rs.getInt("book_id"));
					b.setTitle(rs.getString("title"));
					b.setPrice(rs.getDouble("price"));
					b.setStock(rs.getInt("stock"));
					b.setImage(rs.getString("image"));
					b.setDescription(rs.getString("description"));
					b.setSlug(rs.getString("slug"));
					b.setOriginPrice(rs.getDouble("origin_price"));

					Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
					b.setCategory(cat);

					Author author = new Author(rs.getInt("author_id"), rs.getString("author_name"));
					b.setAuthor(author);

					list.add(b);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<Book> getBestSellers(int limit) {
		List<Book> list = new ArrayList<>();
		String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, a.author_name " + "FROM books b "
				+ "LEFT JOIN categories c ON b.category_id = c.category_id "
				+ "LEFT JOIN authors a ON b.author_id = a.author_id " + "ORDER BY RAND() LIMIT ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, limit);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Book b = new Book();
					b.setId(rs.getInt("book_id"));
					b.setTitle(rs.getString("title"));
					b.setPrice(rs.getDouble("price"));
					b.setStock(rs.getInt("stock"));
					b.setImage(rs.getString("image"));
					b.setDescription(rs.getString("description"));
					b.setSlug(rs.getString("slug"));
					b.setOriginPrice(rs.getDouble("origin_price"));

					Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
					b.setCategory(cat);

					Author author = new Author(rs.getInt("author_id"), rs.getString("author_name"));
					b.setAuthor(author);

					list.add(b);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// get author list
	public List<Author> getAllAuthors() {
		List<Author> list = new ArrayList<>();
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement("SELECT * FROM authors WHERE is_deleted = 0");
				ResultSet rs = ps.executeQuery()) {
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
	public void updateBook(int bookId, String title, double price, double originPrice, int categoryId, int authorId,
			int publishYear, String description, int stock, String image, String isbn, String publisher,
			String language, String coverType) {
		String sql = "UPDATE books SET title=?, price=?, origin_price=?, category_id=?, author_id=?, "
				+ "publish_year=?, description=?, stock=?, image=?, isbn=?, publisher=?, "
				+ "language=?, cover_type=?, slug=? WHERE book_id=?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, title);
			ps.setDouble(2, price);
			ps.setDouble(3, originPrice); // THÊM
			ps.setInt(4, categoryId);
			ps.setInt(5, authorId);
			ps.setInt(6, publishYear);
			ps.setString(7, description);
			ps.setInt(8, stock);
			ps.setString(9, image);
			ps.setString(10, isbn);
			ps.setString(11, publisher);
			ps.setString(12, language);
			ps.setString(13, coverType);
			String slug = util.StringUtils.toSlug(title);
			ps.setString(14, slug);
			ps.setInt(15, bookId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

// xóa sách
	public void deleteBook(int bookId) {
		String sql = "UPDATE books SET is_deleted = 1 WHERE book_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

			try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next())
						total = rs.getInt(1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return total;
	}

	public int countBooks(String keyword, List<Integer> categoryIds, Double minPrice, Double maxPrice,
			List<Integer> publishYears, List<Integer> authorIds, List<String> publishers) {
		int total = 0;
		try {
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
			if (publishYears != null && !publishYears.isEmpty()) {
				sql += " AND b.publish_year IN (";
				for (int j = 0; j < publishYears.size(); j++)
					sql += j == 0 ? "?" : ",?";
				sql += ")";
			}
			if (authorIds != null && !authorIds.isEmpty()) {
				sql += " AND b.author_id IN (";
				for (int j = 0; j < authorIds.size(); j++)
					sql += j == 0 ? "?" : ",?";
				sql += ")";
			}
			if (publishers != null && !publishers.isEmpty()) {
				sql += " AND b.publisher IN (";
				for (int j = 0; j < publishers.size(); j++)
					sql += j == 0 ? "?" : ",?";
				sql += ")";
			}
			try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
				int i = 1;
				if (keyword != null && !keyword.isEmpty())
					ps.setString(i++, "%" + keyword + "%");
				if (categoryIds != null && !categoryIds.isEmpty())
					for (Integer c : categoryIds)
						ps.setInt(i++, c);
				if (minPrice != null)
					ps.setDouble(i++, minPrice);
				if (maxPrice != null)
					ps.setDouble(i++, maxPrice);
				if (publishYears != null && !publishYears.isEmpty())
					for (Integer y : publishYears)
						ps.setInt(i++, y);
				if (authorIds != null && !authorIds.isEmpty())
					for (Integer a : authorIds)
						ps.setInt(i++, a);
				if (publishers != null && !publishers.isEmpty())
					for (String p : publishers)
						ps.setString(i++, p);
				try (ResultSet rs = ps.executeQuery()) {
					if (rs.next())
						total = rs.getInt(1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return total;
	}

	// tim sach
	public List<Book> searchBooks(String keyword, List<Integer> categoryIds, Double minPrice, Double maxPrice,
			String sort, int page, int pageSize) {
		List<Book> list = new ArrayList<>();
		try {
			String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, "
					+ "COALESCE(AVG(r.rating),0) as avg_rating, COUNT(r.review_id) as review_count "
					+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id "
					+ "LEFT JOIN reviews r ON r.book_id = b.book_id WHERE 1=1";
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

			sql += " GROUP BY b.book_id";
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

			try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						Book b = new Book();
						b.setId(rs.getInt("book_id"));
						b.setTitle(rs.getString("title"));
						b.setPrice(rs.getDouble("price"));
						b.setImage(rs.getString("image"));
						b.setSlug(rs.getString("slug"));
						b.setOriginPrice(rs.getDouble("origin_price"));
						b.setStock(rs.getInt("stock"));
						b.setAvgRating(rs.getDouble("avg_rating"));
						b.setReviewCount(rs.getInt("review_count"));
						Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
						b.setCategory(cat);
						list.add(b);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<Book> searchBooks(String keyword, List<Integer> categoryIds, Double minPrice, Double maxPrice,
			String sort, int page, int pageSize, List<Integer> publishYears, List<Integer> authorIds,
			List<String> publishers) {
		List<Book> list = new ArrayList<>();
		try {
			String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, "
					+ "COALESCE(AVG(r.rating),0) as avg_rating, COUNT(r.review_id) as review_count "
					+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id "
					+ "LEFT JOIN reviews r ON r.book_id = b.book_id WHERE 1=1";
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
			if (publishYears != null && !publishYears.isEmpty()) {
				sql += " AND b.publish_year IN (";
				for (int j = 0; j < publishYears.size(); j++)
					sql += j == 0 ? "?" : ",?";
				sql += ")";
			}
			if (authorIds != null && !authorIds.isEmpty()) {
				sql += " AND b.author_id IN (";
				for (int j = 0; j < authorIds.size(); j++)
					sql += j == 0 ? "?" : ",?";
				sql += ")";
			}
			if (publishers != null && !publishers.isEmpty()) {
				sql += " AND b.publisher IN (";
				for (int j = 0; j < publishers.size(); j++)
					sql += j == 0 ? "?" : ",?";
				sql += ")";
			}
			sql += " GROUP BY b.book_id";
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

			try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
				int i = 1;
				if (keyword != null && !keyword.isEmpty())
					ps.setString(i++, "%" + keyword + "%");
				if (categoryIds != null && !categoryIds.isEmpty())
					for (Integer c : categoryIds)
						ps.setInt(i++, c);
				if (minPrice != null)
					ps.setDouble(i++, minPrice);
				if (maxPrice != null)
					ps.setDouble(i++, maxPrice);
				if (publishYears != null && !publishYears.isEmpty())
					for (Integer y : publishYears)
						ps.setInt(i++, y);
				if (authorIds != null && !authorIds.isEmpty())
					for (Integer a : authorIds)
						ps.setInt(i++, a);
				if (publishers != null && !publishers.isEmpty())
					for (String p : publishers)
						ps.setString(i++, p);
				ps.setInt(i++, pageSize);
				ps.setInt(i++, (page - 1) * pageSize);

				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						Book b = new Book();
						b.setId(rs.getInt("book_id"));
						b.setTitle(rs.getString("title"));
						b.setPrice(rs.getDouble("price"));
						b.setImage(rs.getString("image"));
						b.setSlug(rs.getString("slug"));
						b.setOriginPrice(rs.getDouble("origin_price"));
						b.setStock(rs.getInt("stock"));
						b.setAvgRating(rs.getDouble("avg_rating"));
						b.setReviewCount(rs.getInt("review_count"));
						Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
						b.setCategory(cat);
						list.add(b);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// get author
	public Author getAuthorById(int id) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement("SELECT * FROM authors WHERE author_id = ?")) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					Author a = new Author(rs.getInt("author_id"), rs.getString("author_name"));
					a.setImage(rs.getString("image"));
					return a;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	// crud Author

	public void addAuthor(String name, String image) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn
						.prepareStatement("INSERT INTO authors (author_name, image) VALUES (?, ?)")) {
			ps.setString(1, name);
			ps.setString(2, image);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void deleteAuthor(int id) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement("UPDATE authors SET is_deleted = 1 WHERE author_id = ?")) {
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void updateAuthor(int id, String name, String image) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn
						.prepareStatement("UPDATE authors SET author_name=?, image=? WHERE author_id=?")) {
			ps.setString(1, name);
			ps.setString(2, image);
			ps.setInt(3, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// gợi ý nhanh khi nhập từ khóa tìm kiếm
	public List<Book> getSearchSuggestions(String keyword, int limit) {
		List<Book> list = new ArrayList<>();
		try {
			// Chỉ lấy những cột cần thiết để hiển thị ở thanh tìm kiếm (nhẹ và nhanh)
			String sql = "SELECT book_id, title, price, image, slug FROM books WHERE title LIKE ? LIMIT ?";
			try (Connection conn = util.DBConnection.getConnection();
					PreparedStatement ps = conn.prepareStatement(sql)) {

				ps.setString(1, "%" + keyword + "%"); // Tìm từ khóa ở bất kỳ vị trí nào trong tên
				ps.setInt(2, limit); // Giới hạn số lượng trả về ( 6 cuốn)

				try (ResultSet rs = ps.executeQuery()) {
					while (rs.next()) {
						Book b = new Book();
						b.setId(rs.getInt("book_id"));
						b.setTitle(rs.getString("title"));
						b.setPrice(rs.getDouble("price"));
						b.setImage(rs.getString("image"));
						b.setSlug(rs.getString("slug"));
						list.add(b);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// Soft delete-Kiểm tra danh mục có sách đang bán  không trước khi xóa
	public boolean canDeleteCategory(int categoryId) {
		String sql = "SELECT COUNT(*) FROM books WHERE category_id = ? AND is_deleted = 0";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, categoryId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1) == 0; // Trả về true nếu không có sách nào
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// Soft delete-kiểm tra tác giả có sách đang bán  không trước khi xóa
	public boolean canDeleteAuthor(int authorId) {
		String sql = "SELECT COUNT(*) FROM books WHERE author_id = ? AND is_deleted = 0";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, authorId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1) == 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// Kiểm tra hard delete category — không cho xóa nếu còn bất kỳ sách nào (kể cả đã ẩn)
	public boolean canHardDeleteCategory(int categoryId) {
		String sql = "SELECT COUNT(*) FROM books WHERE category_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, categoryId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1) == 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// Kiểm tra hard delete author — không cho xóa nếu còn bất kỳ sách nào (kể cả đã ẩn)
	public boolean canHardDeleteAuthor(int authorId) {
		String sql = "SELECT COUNT(*) FROM books WHERE author_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, authorId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1) == 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	//  Soft Delete_Kiểm tra sách có trong đơn hàng đang giao không trước khi xóa
	public boolean canDeleteBook(int bookId) {
	    String sql = "SELECT COUNT(*) FROM order_details od "
	               + "JOIN orders o ON od.order_id = o.order_id "
	               + "WHERE od.book_id = ? "
	               + "AND o.status IN ('PENDING','PROCESSING','SHIPPING')";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, bookId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next())
	            return rs.getInt(1) == 0; // true = không có đơn active → cho phép ẩn
		} catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}
	
	//Hard Delete_ không cho xóa nếu sách đã từng nằm trong bất kỳ đơn hàng nào trong quá khứ
	public boolean canHardDeleteBook(int bookId) {
	    String sql = "SELECT COUNT(*) FROM order_details WHERE book_id = ?";
	    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
	        ps.setInt(1, bookId);
	        ResultSet rs = ps.executeQuery();
	        if (rs.next())
	            return rs.getInt(1) == 0; // true = chưa từng có trong đơn nào → cho phép xóa hẳn
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}

	// hàm láy giá cao nhất để set cho filter giá
	public double getMaxPrice() {
		double max = 0;
		String sql = "SELECT MAX(price) FROM books";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			if (rs.next()) {
				max = rs.getDouble(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return max;
	}

	// Lấy danh sách năm xuất bản có sách
	public List<Integer> getDistinctPublishYears() {
		List<Integer> years = new ArrayList<>();
		String sql = "SELECT DISTINCT publish_year FROM books WHERE publish_year IS NOT NULL AND publish_year > 0 ORDER BY publish_year DESC";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next())
				years.add(rs.getInt("publish_year"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return years;
	}

	// Lấy danh sách NXB có sách
	public List<String> getDistinctPublishers() {
		List<String> publishers = new ArrayList<>();
		String sql = "SELECT DISTINCT publisher FROM books WHERE publisher IS NOT NULL AND publisher != '' ORDER BY publisher ASC";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next())
				publishers.add(rs.getString("publisher"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return publishers;
	}

	public Category getCategoryById(int id) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement("SELECT * FROM categories WHERE category_id = ?")) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return new Category(rs.getInt("category_id"), rs.getString("category_name"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public void addCategory(String name) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement("INSERT INTO categories (category_name) VALUES (?)")) {
			ps.setString(1, name);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void updateCategory(int id, String name) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn
						.prepareStatement("UPDATE categories SET category_name = ? WHERE category_id = ?")) {
			ps.setString(1, name);
			ps.setInt(2, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void deleteCategory(int id) {
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn
						.prepareStatement("UPDATE categories SET is_deleted = 1 WHERE category_id = ?")) {
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public boolean isCategoryNameExists(String name, int excludeId) {
		String sql = excludeId == -1 ? "SELECT COUNT(*) FROM categories WHERE LOWER(category_name) = LOWER(?)"
				: "SELECT COUNT(*) FROM categories WHERE LOWER(category_name) = LOWER(?) AND category_id != ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, name);
			if (excludeId != -1)
				ps.setInt(2, excludeId);
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				return rs.getInt(1) > 0;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// soft delete - restore & hard delete

	public void restoreBook(int bookId) {
		String sql = "UPDATE books SET is_deleted = 0 WHERE book_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void restoreCategory(int id) {
		String sql = "UPDATE categories SET is_deleted = 0 WHERE category_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void restoreAuthor(int id) {
		String sql = "UPDATE authors SET is_deleted = 0 WHERE author_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Hard delete thật sự (dùng khi admin chọn "Xóa vĩnh viễn")
	public void hardDeleteBook(int bookId) {
		String sql = "DELETE FROM books WHERE book_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, bookId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void hardDeleteCategory(int id) {
		String sql = "DELETE FROM categories WHERE category_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void hardDeleteAuthor(int id) {
		String sql = "DELETE FROM authors WHERE author_id = ?";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Lấy sách/danh mục/tác giả đã bị ẩn (để hiển thị tab Thùng rác)
	public List<Book> getDeletedBooks() {
		List<Book> list = new ArrayList<>();
		String sql = "SELECT b.*, c.category_id as cid, c.category_name as cname, "
				+ "a.author_id as aid, a.author_name "
				+ "FROM books b LEFT JOIN categories c ON b.category_id = c.category_id "
				+ "LEFT JOIN authors a ON b.author_id = a.author_id " + "WHERE b.is_deleted = 1";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next()) {
				Book b = new Book();
				b.setId(rs.getInt("book_id"));
				b.setTitle(rs.getString("title"));
				b.setPrice(rs.getDouble("price"));
				b.setStock(rs.getInt("stock"));
				b.setImage(rs.getString("image"));
				b.setSlug(rs.getString("slug"));
				b.setOriginPrice(rs.getDouble("origin_price"));
				b.setSoldQuantity(rs.getInt("sold_quantity"));
				b.setIsbn(rs.getString("isbn"));
				b.setPublisher(rs.getString("publisher"));
				b.setLanguage(rs.getString("language"));
				b.setCoverType(rs.getString("cover_type"));
				b.setPublishYear(rs.getInt("publish_year"));
				Author author = new Author(rs.getInt("aid"), rs.getString("author_name"));
				b.setAuthor(author);
				Category cat = new Category(rs.getInt("cid"), rs.getString("cname"));
				b.setCategory(cat);
				list.add(b);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<Category> getDeletedCategories() {
		List<Category> list = new ArrayList<>();
		String sql = "SELECT * FROM categories WHERE is_deleted = 1";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			while (rs.next())
				list.add(new Category(rs.getInt("category_id"), rs.getString("category_name")));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public List<Author> getDeletedAuthors() {
		List<Author> list = new ArrayList<>();
		String sql = "SELECT * FROM authors WHERE is_deleted = 1";
		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
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
}