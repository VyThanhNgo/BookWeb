package controller;

import com.google.gson.Gson;
import dao.WishlistDAO;
import model.Book;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        WishlistDAO dao = new WishlistDAO();
        List<Book> wishlistBooks = dao.getWishlistBooks(user.getId());
        request.setAttribute("wishlistBooks", wishlistBooks);
        request.setAttribute("pageTitle", "Danh sách yêu thích");
        request.getRequestDispatcher("/WEB-INF/views/wishlist/wishlist.jsp")
               .forward(request, response);
    }

   // toggle thêm/xóa, trả về JSON
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"notLoggedIn\"}");
            return;
        }

        int bookId;
        try {
            bookId = Integer.parseInt(request.getParameter("bookId"));
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"invalidBookId\"}");
            return;
        }

        WishlistDAO dao = new WishlistDAO();
        Map<String, Object> result = new HashMap<>();

        if (dao.isInWishlist(user.getId(), bookId)) {
            dao.removeFromWishlist(user.getId(), bookId);
            result.put("status", "removed");
        } else {
            dao.addToWishlist(user.getId(), bookId);
            result.put("status", "added");
        }

        // Đếm lại số lượng wishlist sau khi toggle
        int count = dao.getWishlistBookIds(user.getId()).size();
        request.getSession().setAttribute("wishlistCount", count);
        result.put("wishlistCount", count);

        response.getWriter().write(new Gson().toJson(result));
    }
}