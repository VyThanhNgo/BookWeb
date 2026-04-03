package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserDAO;
import model.User;

@WebServlet("/admin/user-detail")
public class AdminUserDetailServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Set UTF-8 encoding
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		// Get user ID parameter
		String userIdParam = request.getParameter("id");

		if (userIdParam == null || userIdParam.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/admin/users?error=User ID is required");
			return;
		}

		int userId;
		try {
			userId = Integer.parseInt(userIdParam);
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/admin/users?error=Invalid user ID");
			return;
		}

		// Get user from database
		UserDAO userDAO = new UserDAO();
		User user = userDAO.findById(userId);

		if (user == null) {
			response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
			return;
		}

		// Get current admin for comparison
		HttpSession session = request.getSession();
		User currentAdmin = (User) session.getAttribute("loggedInUser");
		boolean isCurrentUser = (currentAdmin != null && currentAdmin.getId() == userId);

		// Set attributes for JSP
		request.setAttribute("user", user);
		request.setAttribute("isCurrentUser", isCurrentUser);
		request.setAttribute("pageTitle", "Chi tiết Người dùng - " + user.getUsername());

		// Forward to JSP
		request.getRequestDispatcher("/WEB-INF/views/admin/admin-user-detail.jsp").forward(request, response);
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

		// Get current admin
		HttpSession session = request.getSession();
		User currentAdmin = (User) session.getAttribute("loggedInUser");

		if (currentAdmin == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		UserDAO userDAO = new UserDAO();

		if ("lock".equals(action) || "unlock".equals(action)) {
			// Lock or unlock user

			// Prevent admin from locking themselves
			if (userId == currentAdmin.getId()) {
				response.sendRedirect(request.getContextPath() + "/admin/user-detail?id=" + userId + "&error=You cannot lock your own account");
				return;
			}

			User targetUser = userDAO.findById(userId);
			if (targetUser == null) {
				response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
				return;
			}

			// Check if locking the last admin
			if (targetUser.isAdmin() && "lock".equals(action) && targetUser.isActive()) {
				int adminCount = userDAO.getAdminCount();
				if (adminCount <= 1) {
					response.sendRedirect(request.getContextPath() + "/admin/user-detail?id=" + userId + "&error=Cannot lock the last admin account");
					return;
				}
			}

			// Set status explicitly
			boolean newStatus = "unlock".equals(action);
			boolean success = userDAO.setUserStatus(userId, newStatus);

			if (success) {
				String message = "unlock".equals(action) ? "User account unlocked successfully" : "User account locked successfully";
				response.sendRedirect(request.getContextPath() + "/admin/user-detail?id=" + userId + "&success=" + message);
			} else {
				response.sendRedirect(request.getContextPath() + "/admin/user-detail?id=" + userId + "&error=Failed to update user status");
			}

		} else {
			response.sendRedirect(request.getContextPath() + "/admin/user-detail?id=" + userId + "&error=Unknown action");
		}
	}
}
