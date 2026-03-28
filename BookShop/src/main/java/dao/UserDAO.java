package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.User;
import util.DBConnection;

public class UserDAO {

	private User mapResultSetToUser(ResultSet rs) throws SQLException {
		User user = new User();
		user.setId(rs.getInt("user_id"));
		user.setUsername(rs.getString("username"));
		user.setPassword(rs.getString("password"));
		user.setEmail(rs.getString("email"));
		user.setFullName(rs.getString("full_name"));
		user.setPhone(rs.getString("phone"));
		user.setAddress(rs.getString("address"));
		user.setRole(rs.getString("role"));
		user.setActive(rs.getBoolean("is_active"));
		user.setCreatedAt(rs.getTimestamp("created_at"));
		return user;
	}

	// Insert new user
	public boolean insertUser(User user) {
		String sql = "INSERT INTO users (username, password, email, full_name, phone, address, role) VALUES (?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, user.getUsername());
			ps.setString(2, user.getPassword()); // Already hashed by servlet
			ps.setString(3, user.getEmail());
			ps.setString(4, user.getFullName());
			ps.setString(5, user.getPhone());
			ps.setString(6, user.getAddress());
			ps.setString(7, user.getRole() != null ? user.getRole() : "user");

			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			System.out.println("Error inserting user: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	// Find user by email
	public User findByEmail(String email) {
		String sql = "SELECT * FROM users WHERE email = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, email);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToUser(rs);
				}
			}
		} catch (SQLException e) {
			System.out.println("Error finding user by email: " + e.getMessage());
			e.printStackTrace();
		}
		return null;
	}

	// Find user by username
	public User findByUsername(String username) {
		String sql = "SELECT * FROM users WHERE username = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToUser(rs);
				}
			}
		} catch (SQLException e) {
			System.out.println("Error finding user by username: " + e.getMessage());
			e.printStackTrace();
		}
		return null;
	}

	// Find user by ID
	public User findById(int userId) {
		String sql = "SELECT * FROM users WHERE user_id = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					return mapResultSetToUser(rs);
				}
			}
		} catch (SQLException e) {
			System.out.println("Error finding user by ID: " + e.getMessage());
			e.printStackTrace();
		}
		return null;
	}

	// Check if email exists
	public boolean emailExists(String email) {
		return findByEmail(email) != null;
	}

	// Check if username exists
	public boolean usernameExists(String username) {
		return findByUsername(username) != null;
	}

	// Update user information
	public boolean updateUser(User user) {
		String sql = "UPDATE users SET full_name = ?, email = ?, phone = ?, address = ? WHERE user_id = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, user.getFullName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPhone());
			ps.setString(4, user.getAddress());
			ps.setInt(5, user.getId());

			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			System.out.println("Error updating user: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	// Update user password
	public boolean updatePassword(int userId, String newHashedPassword) {
		String sql = "UPDATE users SET password = ? WHERE user_id = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, newHashedPassword);
			ps.setInt(2, userId);

			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			System.out.println("Error updating password: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	// Check if email exists for another user
	public boolean emailExistsForOtherUser(String email, int currentUserId) {
		String sql = "SELECT user_id FROM users WHERE email = ? AND user_id != ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, email);
			ps.setInt(2, currentUserId);

			try (ResultSet rs = ps.executeQuery()) {
				return rs.next();
			}
		} catch (SQLException e) {
			System.out.println("Error checking email existence: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	// Get all users
	public List<User> getAllUsers() {
		String sql = "SELECT * FROM users ORDER BY created_at DESC";
		List<User> users = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				users.add(mapResultSetToUser(rs));
			}
		} catch (SQLException e) {
			System.out.println("Error getting all users: " + e.getMessage());
			e.printStackTrace();
		}
		return users;
	}

	// Get users with pagination
	public List<User> getAllUsersPaginated(int page, int pageSize) {
		String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ? OFFSET ?";
		List<User> users = new ArrayList<>();
		int offset = (page - 1) * pageSize;

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, pageSize);
			ps.setInt(2, offset);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					users.add(mapResultSetToUser(rs));
				}
			}
		} catch (SQLException e) {
			System.out.println("Error getting paginated users: " + e.getMessage());
			e.printStackTrace();
		}
		return users;
	}

	// Search users by keyword
	public List<User> searchUsers(String keyword) {
		String sql = "SELECT * FROM users WHERE username LIKE ? OR email LIKE ? OR full_name LIKE ? ORDER BY created_at DESC";
		List<User> users = new ArrayList<>();
		String searchPattern = "%" + keyword + "%";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, searchPattern);
			ps.setString(2, searchPattern);
			ps.setString(3, searchPattern);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					users.add(mapResultSetToUser(rs));
				}
			}
		} catch (SQLException e) {
			System.out.println("Error searching users: " + e.getMessage());
			e.printStackTrace();
		}
		return users;
	}

	// Filter users by role
	public List<User> filterUsersByRole(String role) {
		String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
		List<User> users = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, role);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					users.add(mapResultSetToUser(rs));
				}
			}
		} catch (SQLException e) {
			System.out.println("Error filtering users by role: " + e.getMessage());
			e.printStackTrace();
		}
		return users;
	}

	// Filter users by status
	public List<User> filterUsersByStatus(boolean isActive) {
		String sql = "SELECT * FROM users WHERE is_active = ? ORDER BY created_at DESC";
		List<User> users = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setBoolean(1, isActive);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					users.add(mapResultSetToUser(rs));
				}
			}
		} catch (SQLException e) {
			System.out.println("Error filtering users by status: " + e.getMessage());
			e.printStackTrace();
		}
		return users;
	}

	// Get total user count
	public int getUserCount() {
		String sql = "SELECT COUNT(*) as count FROM users";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			if (rs.next()) {
				return rs.getInt("count");
			}
		} catch (SQLException e) {
			System.out.println("Error getting user count: " + e.getMessage());
			e.printStackTrace();
		}
		return 0;
	}

	// Toggle user status
	public boolean toggleUserStatus(int userId) {
		String sql = "UPDATE users SET is_active = NOT is_active WHERE user_id = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			System.out.println("Error toggling user status: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	// Set user status explicitly
	public boolean setUserStatus(int userId, boolean isActive) {
		String sql = "UPDATE users SET is_active = ? WHERE user_id = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setBoolean(1, isActive);
			ps.setInt(2, userId);
			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			System.out.println("Error setting user status: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	// Delete user
	public boolean deleteUser(int userId) {
		String sql = "DELETE FROM users WHERE user_id = ?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			int rowsAffected = ps.executeUpdate();
			return rowsAffected > 0;

		} catch (SQLException e) {
			System.out.println("Error deleting user: " + e.getMessage());
			e.printStackTrace();
			return false;
		}
	}

	// Get admin count
	public int getAdminCount() {
		String sql = "SELECT COUNT(*) as count FROM users WHERE role = 'admin'";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			if (rs.next()) {
				return rs.getInt("count");
			}
		} catch (SQLException e) {
			System.out.println("Error getting admin count: " + e.getMessage());
			e.printStackTrace();
		}
		return 0;
	}
}
