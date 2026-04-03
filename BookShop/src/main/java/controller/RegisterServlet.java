package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.mindrot.jbcrypt.BCrypt;

import dao.UserDAO;
import model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Show registration form
		request.setAttribute("pageTitle", "Đăng ký tài khoản");
		request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Set UTF-8 encoding for Vietnamese characters
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		// Get form parameters
		String username = request.getParameter("username");
		String fullName = request.getParameter("fullName");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");

		// Validation
		StringBuilder errors = new StringBuilder();

		if (username == null || username.trim().isEmpty()) {
			errors.append("Tên đăng nhập không được để trống. ");
		} else if (username.length() < 3) {
			errors.append("Tên đăng nhập phải có ít nhất 3 ký tự. ");
		} else if (!username.matches("^[a-zA-Z0-9_]+$")) {
			errors.append("Tên đăng nhập chỉ được chứa chữ cái, số và dấu gạch dưới. ");
		}

		if (fullName == null || fullName.trim().isEmpty()) {
			errors.append("Họ tên không được để trống. ");
		}

		if (email == null || email.trim().isEmpty()) {
			errors.append("Email không được để trống. ");
		} else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
			errors.append("Email không hợp lệ. ");
		}

		if (password == null || password.length() < 6) {
			errors.append("Mật khẩu phải có ít nhất 6 ký tự. ");
		}

		if (confirmPassword == null || !password.equals(confirmPassword)) {
			errors.append("Mật khẩu xác nhận không khớp. ");
		}

		// Check if username and email already exist
		UserDAO userDAO = new UserDAO();
		if (username != null && !username.trim().isEmpty() && userDAO.usernameExists(username)) {
			errors.append("Tên đăng nhập đã được sử dụng. ");
		}
		if (email != null && !email.trim().isEmpty() && userDAO.emailExists(email)) {
			errors.append("Email đã được sử dụng. ");
		}

		// If validation fails
		if (errors.length() > 0) {
			request.setAttribute("error", errors.toString());
			request.setAttribute("username", username);
			request.setAttribute("fullName", fullName);
			request.setAttribute("email", email);
			request.setAttribute("phone", phone);
			request.setAttribute("address", address);
			request.setAttribute("pageTitle", "Đăng ký tài khoản");
			request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
			return;
		}

		// Hash password with BCrypt (12 rounds)
		String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

		// Create user object
		User newUser = new User();
		newUser.setUsername(username);
		newUser.setFullName(fullName);
		newUser.setEmail(email);
		newUser.setPassword(hashedPassword);
		newUser.setPhone(phone);
		newUser.setAddress(address);
		newUser.setRole("user");  // Default role

		// Insert into database
		boolean success = userDAO.insertUser(newUser);

		if (success) {
			request.setAttribute("success", "Đăng ký thành công! Vui lòng đăng nhập.");
			request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
		} else {
			request.setAttribute("error", "Đăng ký thất bại. Vui lòng thử lại.");
			request.setAttribute("username", username);
			request.setAttribute("fullName", fullName);
			request.setAttribute("email", email);
			request.setAttribute("phone", phone);
			request.setAttribute("address", address);
			request.setAttribute("pageTitle", "Đăng ký tài khoản");
			request.getRequestDispatcher("/WEB-INF/views/user/register.jsp").forward(request, response);
		}
	}
}
