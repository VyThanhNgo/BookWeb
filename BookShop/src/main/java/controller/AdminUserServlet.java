package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

	private static final int PAGE_SIZE = 10;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Set UTF-8 encoding
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		UserDAO userDAO = new UserDAO();

		// Get parameters
		String searchKeyword = request.getParameter("search");
		String roleFilter = request.getParameter("role");
		String statusFilter = request.getParameter("status");
		String pageParam = request.getParameter("page");

		int currentPage = 1;
		if (pageParam != null && !pageParam.isEmpty()) {
			try {
				currentPage = Integer.parseInt(pageParam);
			} catch (NumberFormatException e) {
				currentPage = 1;
			}
		}

		List<User> users;
		int totalUsers;

		// Apply filters
		if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
			// Search mode
			users = userDAO.searchUsers(searchKeyword.trim());
			totalUsers = users.size();
			request.setAttribute("searchKeyword", searchKeyword);
		} else if (roleFilter != null && !roleFilter.equals("all")) {
			// Filter by role
			users = userDAO.filterUsersByRole(roleFilter);
			totalUsers = users.size();
			request.setAttribute("roleFilter", roleFilter);
		} else if (statusFilter != null && !statusFilter.equals("all")) {
			// Filter by status
			boolean isActive = "active".equals(statusFilter);
			users = userDAO.filterUsersByStatus(isActive);
			totalUsers = users.size();
			request.setAttribute("statusFilter", statusFilter);
		} else {
			// No filter - paginated list
			users = userDAO.getAllUsersPaginated(currentPage, PAGE_SIZE);
			totalUsers = userDAO.getUserCount();
		}

		// Calculate pagination
		int totalPages = (int) Math.ceil((double) totalUsers / PAGE_SIZE);

		// Set attributes for JSP
		request.setAttribute("users", users);
		request.setAttribute("currentPage", currentPage);
		request.setAttribute("totalPages", totalPages);
		request.setAttribute("totalUsers", totalUsers);
		request.setAttribute("pageTitle", "Quản lý Người dùng");

		// Forward to JSP
		request.getRequestDispatcher("/WEB-INF/views/admin/admin-users.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Set UTF-8 encoding
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action");
		String userIdParam = request.getParameter("userId");

		if (action == null || userIdParam == null) {
			response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid request");
			return;
		}

		int userId;
		try {
			userId = Integer.parseInt(userIdParam);
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
			return;
		}

		// Get current admin user
		HttpSession session = request.getSession();
		User currentAdmin = (User) session.getAttribute("loggedInUser");

		if (currentAdmin == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		UserDAO userDAO = new UserDAO();

		if ("toggle".equals(action)) {
			// Toggle user status (lock/unlock)

			// Prevent admin from locking themselves
			if (userId == currentAdmin.getId()) {
				response.sendRedirect(request.getContextPath() + "/admin/users?error=You cannot lock your own account");
				return;
			}

			// Get user to check if they're admin
			User targetUser = userDAO.findById(userId);
			if (targetUser == null) {
				response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
				return;
			}

			// Check if this is the last active admin
			if (targetUser.isAdmin() && targetUser.isActive()) {
				int adminCount = userDAO.getAdminCount();
				if (adminCount <= 1) {
					response.sendRedirect(request.getContextPath() + "/admin/users?error=Cannot lock the last admin account");
					return;
				}
			}

			// Toggle status
			boolean success = userDAO.toggleUserStatus(userId);

			if (success) {
				String status = targetUser.isActive() ? "locked" : "unlocked";
				response.sendRedirect(request.getContextPath() + "/admin/users?success=User successfully " + status);
			} else {
				response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to update user status");
			}

		} else if ("delete".equals(action)) {
			// Delete user (optional feature)

			// Prevent admin from deleting themselves
			if (userId == currentAdmin.getId()) {
				response.sendRedirect(request.getContextPath() + "/admin/users?error=You cannot delete your own account");
				return;
			}

			// Check if target is admin
			User targetUser = userDAO.findById(userId);
			if (targetUser != null && targetUser.isAdmin()) {
				int adminCount = userDAO.getAdminCount();
				if (adminCount <= 1) {
					response.sendRedirect(request.getContextPath() + "/admin/users?error=Cannot delete the last admin account");
					return;
				}
			}

			// Delete user
			boolean success = userDAO.deleteUser(userId);

			if (success) {
				response.sendRedirect(request.getContextPath() + "/admin/users?success=User deleted successfully");
			} else {
				response.sendRedirect(request.getContextPath() + "/admin/users?error=Failed to delete user");
			}

		} else {
			response.sendRedirect(request.getContextPath() + "/admin/users?error=Unknown action");
		}
	}
}
