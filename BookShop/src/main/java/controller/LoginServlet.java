package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;

import dao.CartDAO;
import dao.UserDAO;
import model.Cart;
import model.CartItem;
import dao.WishlistDAO;
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

			// Gộp giỏ trong DB với giỏ session (đồ khách thêm khi chưa đăng nhập)
			CartDAO cartDAO = new CartDAO();
			Cart sessionCart = (Cart) session.getAttribute("cart");
			if (sessionCart == null) sessionCart = new Cart();

			List<CartItem> dbItems = cartDAO.loadItems(user.getId());
			for (CartItem dbItem : dbItems) {
				sessionCart.addItem(dbItem); // nếu trùng sách thì cộng dồn số lượng
			}
			session.setAttribute("cart", sessionCart);
			// Lưu giỏ đã gộp ngược lại vào DB
			cartDAO.saveFullCart(user.getId(), sessionCart.getItems());

			WishlistDAO wishlistDAO = new WishlistDAO();
			session.setAttribute("wishlistCount", wishlistDAO.countWishlist(user.getId()));
			
			// Redirect to home or intended page — validate to prevent Open Redirect
			String redirectUrl = request.getParameter("redirect");
			String contextPath = request.getContextPath();
			if (redirectUrl != null && !redirectUrl.isEmpty()
					&& redirectUrl.startsWith("/")
					&& !redirectUrl.startsWith("//")) {
				response.sendRedirect(contextPath + redirectUrl);
			} else {
				response.sendRedirect(contextPath + "/books");
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
