package controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig; // bắt buộc có để nhiều ảnh
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import dao.ReviewDAO;
import model.Review;
import model.User;

@WebServlet("/add-review")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 25
)
public class ReviewServlet extends HttpServlet {
    
    // Cấu hình Cloudinary
    private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
        "cloud_name", "dqiefayjh", 
        "api_key", "496728741237697", 
        "api_secret", "S9lcM_6dRXMrWBiUKLMPPQD1kjQ", 
        "secure", true
    ));

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login"); // Nên dùng contextPath
            return;
        }

        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        //  Xử lý upload nhiều ảnh lên Cloudinary
        List<String> imageUrls = new ArrayList<>();
        for (Part part : request.getParts()) {
            // reviewPhotos là tên name của input file trong trang jsp
            if ("reviewPhotos".equals(part.getName()) && part.getSize() > 0) {
                String url = uploadToCloudinary(part);
                if (url != null) {
                    imageUrls.add(url);
                }
            }
        }

        //  Tạo đối tượng Review
        Review rev = new Review();
        rev.setBookId(bookId);
        rev.setUserId(user.getId()); 
        rev.setRating(rating);
        rev.setComment(comment);

       
        new ReviewDAO().addReview(rev, imageUrls);
        
        response.sendRedirect(request.getContextPath() + "/books/detail?id=" + bookId);
    }

    // Hàm phụ trợ upload 
    private String uploadToCloudinary(Part part) throws IOException {
        try (InputStream is = part.getInputStream();
             ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[1024];
            int len;
            while ((len = is.read(buffer)) != -1) {
                os.write(buffer, 0, len);
            }
            Map uploadResult = cloudinary.uploader().upload(os.toByteArray(), 
                ObjectUtils.asMap("folder", "reviews")); // Lưu vào thư mục reviews
            return (String) uploadResult.get("url");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}