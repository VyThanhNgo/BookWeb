package controller;

import dao.BookDAO;
import dao.OrderDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin")
public class HomeAdminServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		BookDAO bookDAO = new BookDAO();
		OrderDAO orderDAO = new OrderDAO();

		request.setAttribute("books", bookDAO.getAllBooks());
		request.setAttribute("categories", bookDAO.getAllCategories());
		request.setAttribute("authors", bookDAO.getAllAuthors());
		request.setAttribute("deletedBooks", bookDAO.getDeletedBooks());
		request.setAttribute("deletedCategories", bookDAO.getDeletedCategories());
		request.setAttribute("deletedAuthors", bookDAO.getDeletedAuthors());

		// Số liệu thực từ DB
		request.setAttribute("totalRevenue", orderDAO.getTotalRevenue());
		request.setAttribute("totalOrders", orderDAO.getTotalOrders());
		request.setAttribute("pendingOrders", orderDAO.getPendingOrders());
		request.setAttribute("recentOrders", orderDAO.getAllOrders());

		request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
	}
}
