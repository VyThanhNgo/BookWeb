package controller;

import dao.BookDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin")
public class HomeAdminServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		BookDAO dao = new BookDAO();
		request.setAttribute("books", dao.getAllBooks());
		request.setAttribute("categories", dao.getAllCategories());
		request.setAttribute("authors", dao.getAllAuthors());
		request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
	}
}