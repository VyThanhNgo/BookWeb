package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BookDAO;
import model.Book;
import model.Category;

@WebServlet(urlPatterns = {"/home", ""})
public class HomeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDAO bookDAO = new BookDAO();

        List<Book> newBooks = bookDAO.getNewBooks(8);
        request.setAttribute("newBooks", newBooks);

        List<Book> bestSellers = bookDAO.getBestSellers(8);
        request.setAttribute("bestSellers", bestSellers);

        List<Category> categories = bookDAO.getAllCategories();
        request.setAttribute("categories", categories);

        request.setAttribute("pageTitle", "BookShop - Nhà sách trực tuyến");
        request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
    }
}
