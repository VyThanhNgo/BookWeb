package controller;
import dao.BookDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/categories")
public class CategoryAdminServlet extends HttpServlet {

    private void json(HttpServletResponse res, boolean success, String message) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        res.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookDAO dao = new BookDAO();
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.canDeleteCategory(id)) {
                dao.deleteCategory(id);
                json(response, true, "deleted");
            } else {
                json(response, false, "has_books");
            }
        } else if ("restore".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.restoreCategory(id);
            json(response, true, "updated");

        } else if ("hardDelete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.canHardDeleteCategory(id)) {
                dao.hardDeleteCategory(id);
                json(response, true, "deleted");
            } else {
                json(response, false, "has_books");
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
                json(response, false, "duplicate");
                return;
            }
            int newId = dao.addCategory(name);
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"message\":\"added\",\"id\":" + newId + ",\"name\":\"" + name + "\"}");

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.isCategoryNameExists(name, id)) {
                json(response, false, "duplicate");
                return;
            }
            dao.updateCategory(id, name);
            json(response, true, "updated");
        }
    }
}