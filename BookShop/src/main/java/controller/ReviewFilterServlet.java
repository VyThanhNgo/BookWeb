package controller;

import com.google.gson.Gson;
import dao.ReviewDAO;
import model.Review;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/reviews/filter")
public class ReviewFilterServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        try {
            int bookId    = Integer.parseInt(request.getParameter("bookId"));
            int star      = parseIntOrZero(request.getParameter("star"));
            boolean hasImg = "1".equals(request.getParameter("hasImage"));
            int page      = parseIntOrDefault(request.getParameter("page"), 1);

            ReviewDAO dao = new ReviewDAO();
            int total     = dao.countReviews(bookId, star, hasImg);
            int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
            if (totalPages < 1) totalPages = 1;
            if (page > totalPages) page = totalPages;

            List<Review> reviews = dao.getReviewsFiltered(bookId, star, hasImg, page, PAGE_SIZE);

            // Build JSON thủ công để không cần thêm thư viện Gson
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"total\":").append(total).append(",");
            json.append("\"totalPages\":").append(totalPages).append(",");
            json.append("\"currentPage\":").append(page).append(",");
            json.append("\"reviews\":[");

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

            for (int i = 0; i < reviews.size(); i++) {
                Review r = reviews.get(i);
                if (i > 0) json.append(",");
                json.append("{");
                json.append("\"reviewId\":").append(r.getReviewId()).append(",");
                json.append("\"userName\":\"").append(escapeJson(r.getUserName())).append("\",");
                json.append("\"userAvatar\":\"").append(escapeJson(
                    r.getUserAvatar() != null ? r.getUserAvatar() : "")).append("\",");
                json.append("\"rating\":").append(r.getRating()).append(",");
                json.append("\"comment\":\"").append(escapeJson(r.getComment())).append("\",");
                json.append("\"createdAt\":\"").append(
                    r.getCreatedAt() != null ? sdf.format(r.getCreatedAt()) : "").append("\",");
                json.append("\"images\":[");
                List<String> imgs = r.getImages();
                if (imgs != null) {
                    for (int j = 0; j < imgs.size(); j++) {
                        if (j > 0) json.append(",");
                        json.append("\"").append(escapeJson(imgs.get(j))).append("\"");
                    }
                }
                json.append("]}");
            }

            json.append("]}");
            response.getWriter().write(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\":\"Lỗi server\"}");
        }
    }

    private int parseIntOrZero(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return 0; }
    }

    private int parseIntOrDefault(String s, int def) {
        try {
            int v = Integer.parseInt(s);
            return v < 1 ? def : v;
        } catch (Exception e) { return def; }
    }

    // Escape ký tự đặc biệt trong JSON
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}