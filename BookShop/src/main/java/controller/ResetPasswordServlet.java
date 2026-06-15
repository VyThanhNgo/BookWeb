package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String resetEmail = (String) session.getAttribute("resetEmail");
        
        // If no email in session, redirect to forgot password
        if (resetEmail == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }
        
        // Show reset password form
        request.getRequestDispatcher("/WEB-INF/views/user/reset-password.jsp").forward(request, response);
    }
}
