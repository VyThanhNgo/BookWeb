package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import dao.UserDAO;
import model.User;

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Get current user from session
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute("loggedInUser");

		if (currentUser == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		// Show change password form
		request.setAttribute("pageTitle", "Đổi mật khẩu");
		request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
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
		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		// Validation
		StringBuilder errors = new StringBuilder();

		// Check if all fields are filled
		if (currentPassword == null || currentPassword.isEmpty()) {
			errors.append("Vui lòng nhập mật khẩu hiện tại. ");
		}

		if (newPassword == null || newPassword.isEmpty()) {
			errors.append("Vui lòng nhập mật khẩu mới. ");
		} else if (newPassword.length() < 6) {
			errors.append("Mật khẩu mới phải có ít nhất 6 ký tự. ");
		}

		if (confirmPassword == null || confirmPassword.isEmpty()) {
			errors.append("Vui lòng xác nhận mật khẩu mới. ");
		} else if (!newPassword.equals(confirmPassword)) {
			errors.append("Mật khẩu xác nhận không khớp. ");
		}

		// If basic validation fails
		if (errors.length() > 0) {
			request.setAttribute("error", errors.toString());
			request.setAttribute("pageTitle", "Đổi mật khẩu");
			request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
			return;
		}

		// Verify current password
		UserDAO userDAO = new UserDAO();
		User dbUser = userDAO.findById(currentUser.getId());

		if (dbUser == null || !BCrypt.checkpw(currentPassword, dbUser.getPassword())) {
			request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
			request.setAttribute("pageTitle", "Đổi mật khẩu");
			request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
			return;
		}

		// Check if new password is same as old password
		if (BCrypt.checkpw(newPassword, dbUser.getPassword())) {
			request.setAttribute("error", "Mật khẩu mới không được trùng với mật khẩu hiện tại.");
			request.setAttribute("pageTitle", "Đổi mật khẩu");
			request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
			return;
		}

		// Hash new password
		String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

		// Update password in database
		boolean success = userDAO.updatePassword(currentUser.getId(), hashedNewPassword);

		if (success) {
			// Password changed successfully
			request.setAttribute("success", "Đổi mật khẩu thành công!");
			request.setAttribute("pageTitle", "Đổi mật khẩu");
			request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
		} else {
			// Update failed
			request.setAttribute("error", "Đổi mật khẩu thất bại. Vui lòng thử lại.");
			request.setAttribute("pageTitle", "Đổi mật khẩu");
			request.getRequestDispatcher("/WEB-INF/views/user/change-password.jsp").forward(request, response);
		}
	}
}
