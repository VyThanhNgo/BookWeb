package controller;

import dao.BookDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/categories")
public class CategoryAdminServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookDAO dao = new BookDAO();
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.canDeleteCategory(id)) {
                dao.deleteCategory(id);
                response.sendRedirect(request.getContextPath() + "/admin?success=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin?error=has_books");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        BookDAO dao = new BookDAO();
        String action = request.getParameter("action");
        String name   = request.getParameter("name").trim();

        if ("add".equals(action)) {
            if (dao.isCategoryNameExists(name, -1)) {
                response.sendRedirect(request.getContextPath() + "/admin?error=duplicate");
                return;
            }
            dao.addCategory(name);
            response.sendRedirect(request.getContextPath() + "/admin?success=added");

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.isCategoryNameExists(name, id)) {
                response.sendRedirect(request.getContextPath() + "/admin?error=duplicate");
                return;
            }
            dao.updateCategory(id, name);
            response.sendRedirect(request.getContextPath() + "/admin?success=updated");
        }
    }
}