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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Get current user from session
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute("loggedInUser");

		if (currentUser == null) {
			// Shouldn't happen because of AuthFilter, but just in case
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		// Reload user data from database to ensure it's up-to-date
		UserDAO userDAO = new UserDAO();
		User user = userDAO.findById(currentUser.getId());

		if (user == null) {
			// User no longer exists in database
			session.invalidate();
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		// Set user data in request for JSP
		request.setAttribute("user", user);
		request.setAttribute("pageTitle", "Thông tin cá nhân");
		request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Set UTF-8 encoding
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		// Get current user from session
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute("loggedInUser");

		if (currentUser == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		// Get form parameters
		String fullName = request.getParameter("fullName");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");

		// Validation
		StringBuilder errors = new StringBuilder();

		if (fullName == null || fullName.trim().isEmpty()) {
			errors.append("Họ tên không được để trống. ");
		}

		if (email == null || email.trim().isEmpty()) {
			errors.append("Email không được để trống. ");
		} else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
			errors.append("Email không hợp lệ. ");
		}

		// Check if email is already used by another user
		UserDAO userDAO = new UserDAO();
		if (email != null && !email.trim().isEmpty() && 
			!email.equals(currentUser.getEmail()) && 
			userDAO.emailExistsForOtherUser(email, currentUser.getId())) {
			errors.append("Email này đã được sử dụng bởi tài khoản khác. ");
		}

		// If validation fails
		if (errors.length() > 0) {
			request.setAttribute("error", errors.toString());
			request.setAttribute("fullName", fullName);
			request.setAttribute("email", email);
			request.setAttribute("phone", phone);
			request.setAttribute("address", address);
			request.setAttribute("user", currentUser);
			request.setAttribute("pageTitle", "Thông tin cá nhân");
			request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
			return;
		}

		// Update user object
		currentUser.setFullName(fullName);
		currentUser.setEmail(email);
		currentUser.setPhone(phone);
		currentUser.setAddress(address);

		// Update in database
		boolean success = userDAO.updateUser(currentUser);

		if (success) {
			// Update session with new user data
			User updatedUser = userDAO.findById(currentUser.getId());
			session.setAttribute("loggedInUser", updatedUser);
			session.setAttribute("userEmail", updatedUser.getEmail());

			// Redirect to profile with success message
			request.setAttribute("success", "Cập nhật thông tin thành công!");
			request.setAttribute("user", updatedUser);
			request.setAttribute("pageTitle", "Thông tin cá nhân");
			request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
		} else {
			// Update failed
			request.setAttribute("error", "Cập nhật thông tin thất bại. Vui lòng thử lại.");
			request.setAttribute("user", currentUser);
			request.setAttribute("pageTitle", "Thông tin cá nhân");
			request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
		}
	}
}
