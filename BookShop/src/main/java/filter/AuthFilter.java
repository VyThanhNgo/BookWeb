package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(urlPatterns = {"/profile", "/change-password", "/cart", "/checkout", "/orders"})
public class AuthFilter implements Filter {

	public void init(FilterConfig fConfig) throws ServletException {
		
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;

		HttpSession session = httpRequest.getSession(false);

		// Check if user is logged in
		boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);

		if (isLoggedIn) {
			// User is logged in, allow request to proceed
			chain.doFilter(request, response);
		} else {
			// User not logged in, redirect to login page
			String requestedUrl = httpRequest.getRequestURI();
			String contextPath = httpRequest.getContextPath();
			
			// Save the requested URL to redirect back after login
			String redirectUrl = requestedUrl.substring(contextPath.length());
			
			// Redirect to login with the original URL as parameter
			httpResponse.sendRedirect(contextPath + "/login?redirect=" + redirectUrl);
		}
	}

	public void destroy() {

	}
}
