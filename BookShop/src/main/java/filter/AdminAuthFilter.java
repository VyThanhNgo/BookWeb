//package filter;
//
//import java.io.IOException;
//
//import javax.servlet.Filter;
//import javax.servlet.FilterChain;
//import javax.servlet.FilterConfig;
//import javax.servlet.ServletException;
//import javax.servlet.ServletRequest;
//import javax.servlet.ServletResponse;
//import javax.servlet.annotation.WebFilter;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//import model.User;
//
//@WebFilter(urlPatterns = {"/admin/*"})
//public class AdminAuthFilter implements Filter {
//
//	public void init(FilterConfig fConfig) throws ServletException {
//
//	}
//
//	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//			throws IOException, ServletException {
//
//		HttpServletRequest httpRequest = (HttpServletRequest) request;
//		HttpServletResponse httpResponse = (HttpServletResponse) response;
//
//		// Get session (don't create if doesn't exist)
//		HttpSession session = httpRequest.getSession(false);
//
//		// Check if user is logged in
//		boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);
//
//		if (!isLoggedIn) {
//			// Not logged in - redirect to login page
//			String contextPath = httpRequest.getContextPath();
//			httpResponse.sendRedirect(contextPath + "/login?error=Please login to access admin panel");
//			return;
//		}
//
//		// Check if user has admin role
//		User user = (User) session.getAttribute("loggedInUser");
//		String userRole = (String) session.getAttribute("userRole");
//
//		boolean isAdmin = (user != null && user.isAdmin()) || "admin".equalsIgnoreCase(userRole);
//
//		if (isAdmin) {
//			// User is admin, allow request to proceed
//			chain.doFilter(request, response);
//		} else {
//			// User is logged in but not admin - show access denied
//			httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, 
//				"Access Denied: You do not have permission to access admin panel.");
//		}
//	}
//
//	public void destroy() {
//		
//	}
//}
