package controller;

import dao.BookDAO;
import dao.ReviewDAO;
import dao.WishlistDAO;
import model.Book;
import model.Review;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet("/books/*")
public class BookDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // "/ten-sach-id"

        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        String slug = pathInfo.substring(1); // bỏ dấu / đầu -> "ten-sach-id"

        // Tách id ở cuối slug sau dấu - cuối cùng
        int lastDash = slug.lastIndexOf("-");
        if (lastDash == -1) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(slug.substring(lastDash + 1));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        BookDAO dao = new BookDAO();
        Book book = dao.getBookById(id);

        if (book == null) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        // Nếu slug trên URL không khớp -> redirect về URL chuẩn
        String expectedSlug = book.getSlug() + "-" + id;
        if (!slug.equals(expectedSlug)) {
            response.sendRedirect(request.getContextPath() + "/books/" + expectedSlug);
            return;
        }

        ReviewDAO reviewDAO = new ReviewDAO();
        List<Review> reviews = reviewDAO.getReviewsByBookId(id);

        List<Book> relatedBooks = Collections.emptyList();
        if (book.getCategory() != null) {
            relatedBooks = dao.getRelatedBooks(book.getCategory().getId(), id);
        }

        request.setAttribute("book", book);
        request.setAttribute("reviews", reviews);
        request.setAttribute("relatedBooks", relatedBooks);
        request.setAttribute("pageTitle", book.getTitle());

     //kiểm tra wishlist
        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        boolean isInWishlist = false;
        if (loggedInUser != null) {
            WishlistDAO wishlistDAO = new WishlistDAO();
            isInWishlist = wishlistDAO.isInWishlist(loggedInUser.getId(), id);
        }
        request.setAttribute("isInWishlist", isInWishlist);
        
     
        
        request.getRequestDispatcher("/WEB-INF/views/book/book-detail.jsp")
               .forward(request, response);
    }
}