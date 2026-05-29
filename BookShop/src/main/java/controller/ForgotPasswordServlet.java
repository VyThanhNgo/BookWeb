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

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO = new UserDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show forgot password form
        request.getRequestDispatcher("/WEB-INF/views/user/forgot-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("verify-email".equals(action)) {
            handleVerifyEmail(request, response);
        } else if ("reset-password".equals(action)) {
            handleResetPassword(request, response);
        }
    }
    
    private void handleVerifyEmail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        
        // Validate email
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email");
            request.getRequestDispatcher("/WEB-INF/views/user/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Check if email exists
        User user = userDAO.findByEmail(email);
        
        if (user == null) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống");
            request.getRequestDispatcher("/WEB-INF/views/user/forgot-password.jsp").forward(request, response);
            return;
        }
        
        // Store email in session for reset password step
        HttpSession session = request.getSession();
        session.setAttribute("resetEmail", email);
        session.setAttribute("resetUserId", user.getId());
        
        // Redirect to reset password page
        response.sendRedirect(request.getContextPath() + "/reset-password");
    }
    
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("resetUserId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate passwords
        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập mật khẩu mới");
            request.getRequestDispatcher("/WEB-INF/views/user/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (newPassword.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("/WEB-INF/views/user/reset-password.jsp").forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp");
            request.getRequestDispatcher("/WEB-INF/views/user/reset-password.jsp").forward(request, response);
            return;
        }
        
        // Hash new password
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        
        // Update password
        boolean success = userDAO.updatePassword(userId, hashedPassword);
        
        if (success) {
            // Clear session
            session.removeAttribute("resetEmail");
            session.removeAttribute("resetUserId");
            
            // Redirect to login with success message
            session.setAttribute("message", "Đặt lại mật khẩu thành công. Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra. Vui lòng thử lại.");
            request.getRequestDispatcher("/WEB-INF/views/user/reset-password.jsp").forward(request, response);
        }
    }
}
