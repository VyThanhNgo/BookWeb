package controller;

import dao.BookDAO;
import dao.OrderDAO;
import dao.UserDAO;
import model.Author;
import model.Book;
import model.Category;
import util.AdminJsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class HomeAdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDAO bookDAO   = new BookDAO();
        OrderDAO orderDAO = new OrderDAO();
        UserDAO userDAO   = new UserDAO();

        List<Book>     books             = bookDAO.getAllBooks();
        List<Book>     deletedBooks      = bookDAO.getDeletedBooks();
        List<Category> categories        = bookDAO.getAllCategories();
        List<Category> deletedCategories = bookDAO.getDeletedCategories();
        List<Author>   authors           = bookDAO.getAllAuthors();
        List<Author>   deletedAuthors    = bookDAO.getDeletedAuthors();

        // Attributes dùng cho JSTL (nếu cần)
        request.setAttribute("books",             books);
        request.setAttribute("deletedBooks",      deletedBooks);
        request.setAttribute("categories",        categories);
        request.setAttribute("deletedCategories", deletedCategories);
        request.setAttribute("authors",           authors);
        request.setAttribute("deletedAuthors",    deletedAuthors);

        // Attributes JSON cho JS trong admin.jsp
        request.setAttribute("booksJson",             AdminJsonUtil.serializeBooks(books));
        request.setAttribute("deletedBooksJson",      AdminJsonUtil.serializeBooks(deletedBooks));
        request.setAttribute("categoriesJson",        AdminJsonUtil.serializeCategories(categories));
        request.setAttribute("deletedCategoriesJson", AdminJsonUtil.serializeCategories(deletedCategories));
        request.setAttribute("authorsJson",           AdminJsonUtil.serializeAuthors(authors));
        request.setAttribute("deletedAuthorsJson",    AdminJsonUtil.serializeAuthors(deletedAuthors));

        // Số liệu dashboard
        request.setAttribute("totalRevenue",  orderDAO.getTotalRevenue());
        request.setAttribute("totalOrders",   orderDAO.getTotalOrders());
        request.setAttribute("pendingOrders", orderDAO.getPendingOrders());
        request.setAttribute("recentOrders",  orderDAO.getAllOrders());
        request.setAttribute("totalUsers",    userDAO.getUserCount());
        request.setAttribute("usersToday",    userDAO.getUsersToday());
        request.setAttribute("totalBooks",    books.size());

        // Chart: doanh thu 6 tháng gần nhất
        double[] rev = orderDAO.getRevenueByMonth(6);
        StringBuilder revJson = new StringBuilder("[");
        for (int i = 0; i < rev.length; i++) {
            if (i > 0) revJson.append(",");
            revJson.append(Math.round(rev[i] / 1000.0));
        }
        revJson.append("]");
        request.setAttribute("monthlyRevenueJson", revJson.toString());

        // Chart: top 5 sách bán chạy
        List<Book> bestSellers = bookDAO.getBestSellers(5);
        StringBuilder bsJson = new StringBuilder("[");
        for (int i = 0; i < bestSellers.size(); i++) {
            Book b = bestSellers.get(i);
            if (i > 0) bsJson.append(",");
            bsJson.append("{\"title\":\"")
                  .append(b.getTitle().replace("\"", "\\\""))
                  .append("\",\"sold\":").append(b.getSoldQuantity()).append("}");
        }
        bsJson.append("]");
        request.setAttribute("bestSellersJson", bsJson.toString());

        request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
    }
}