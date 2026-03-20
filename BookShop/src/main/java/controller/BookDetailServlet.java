package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BookDAO;
import model.Book;

@WebServlet("/books/detail")
public class BookDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        BookDAO dao = new BookDAO();
        Book book = dao.getBookById(id);
        request.setAttribute("book", book);
        request.setAttribute("pageTitle", book.getTitle());
        request.getRequestDispatcher("/WEB-INF/views/book/book-detail.jsp").forward(request, response);
    }
}