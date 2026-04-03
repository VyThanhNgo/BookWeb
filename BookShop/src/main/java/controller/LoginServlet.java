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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Show login form
		request.setAttribute("pageTitle", "Đăng nhập");
		request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Set UTF-8 encoding
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		// Get form parameters
		String usernameOrEmail = request.getParameter("usernameOrEmail");
		String password = request.getParameter("password");

		// Validation
		if (usernameOrEmail == null || usernameOrEmail.trim().isEmpty() || password == null || password.isEmpty()) {
			request.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập/email và mật khẩu.");
			request.setAttribute("usernameOrEmail", usernameOrEmail);
			request.setAttribute("pageTitle", "Đăng nhập");
			request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
			return;
		}

		// Find user by username or email
		UserDAO userDAO = new UserDAO();
		User user = null;

		// Check if input is email or username
		if (usernameOrEmail.contains("@")) {
			user = userDAO.findByEmail(usernameOrEmail);
		} else {
			user = userDAO.findByUsername(usernameOrEmail);
		}

		// Check if user exists and password matches
		if (user != null && BCrypt.checkpw(password, user.getPassword())) {
			// Login successful - create session
			HttpSession session = request.getSession();
			session.setAttribute("loggedInUser", user);
			session.setAttribute("userId", user.getId());
			session.setAttribute("userEmail", user.getEmail());
			session.setAttribute("username", user.getUsername());
			session.setAttribute("userRole", user.getRole());
			session.setMaxInactiveInterval(30 * 60); // 30 minutes

			// Redirect to home or intended page
			String redirectUrl = request.getParameter("redirect");
			if (redirectUrl != null && !redirectUrl.isEmpty()) {
				response.sendRedirect(redirectUrl);
			} else {
				response.sendRedirect(request.getContextPath() + "/books");
			}
		} else {
			// Login failed
			request.setAttribute("error", "Tên đăng nhập/Email hoặc mật khẩu không đúng.");
			request.setAttribute("usernameOrEmail", usernameOrEmail);
			request.setAttribute("pageTitle", "Đăng nhập");
			request.getRequestDispatcher("/WEB-INF/views/user/login.jsp").forward(request, response);
		}
	}
}
