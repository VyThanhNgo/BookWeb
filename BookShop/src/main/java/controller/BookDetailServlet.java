package controller;

import dao.BookDAO;
import dao.ReviewDAO;
import model.Book;
import model.Review;

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

            // Kiểm tra book ngay lập tức
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            // Nếu book tồn tại, mới làm các việc tiếp theo
            ReviewDAO reviewDAO = new ReviewDAO();
            List<Review> reviews = reviewDAO.getReviewsByBookId(id);
            
            List<Book> relatedBooks = Collections.emptyList();
            if (book.getCategory() != null) {
                relatedBooks = dao.getRelatedBooks(book.getCategory().getId(), book.getId());
            }

            request.setAttribute("book", book);
            request.setAttribute("reviews", reviews);
            request.setAttribute("relatedBooks", relatedBooks);
            request.setAttribute("pageTitle", book.getTitle());
            
            request.getRequestDispatcher("/WEB-INF/views/book/book-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }
}