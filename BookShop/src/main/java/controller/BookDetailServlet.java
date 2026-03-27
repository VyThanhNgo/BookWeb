package controller;

import dao.BookDAO;
import model.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/books/detail")
public class BookDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            BookDAO dao = new BookDAO();
            Book book = dao.getBookById(id);

            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            List<Book> relatedBooks = Collections.emptyList();
            if (book.getCategory() != null) {
                relatedBooks = dao.getRelatedBooks(book.getCategory().getId(), book.getId());
            }

            request.setAttribute("book", book);
            request.setAttribute("relatedBooks", relatedBooks);
            request.setAttribute("pageTitle", book.getTitle());
            request.getRequestDispatcher("/WEB-INF/views/book/book-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }
}