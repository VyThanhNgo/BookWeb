package controller;

import com.google.gson.Gson;
import dao.BookDAO;
import model.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

//servlet này trả về list sách dưới dạng json thay vì chuyển trang như thông thường
// Đường dẫn này phải khớp với hàm fetch() trong JavaScript ở Header 
@WebServlet("/api/search-suggest")
public class SearchSuggestServlet extends HttpServlet {
    
    private BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Lấy từ khóa người dùng gõ từ tham số "keyword"
        String keyword = request.getParameter("keyword");
        
        // 2. Thiết lập kiểu dữ liệu trả về là JSON và hỗ trợ tiếng Việt
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Nếu từ khóa quá ngắn thì không cần tìm
        if (keyword == null || keyword.trim().length() < 2) {
            response.getWriter().write("[]");
            return;
        }

        // 3. Gọi DAO lấy danh sách sách (lấy tối đa 6 kết quả)
        List<Book> list = bookDAO.getSearchSuggestions(keyword, 6);

        // 4. Dùng GSON biến List<Book> thành chuỗi JSON
        Gson gson = new Gson();
        String jsonResult = gson.toJson(list);

        // 5. Gửi chuỗi JSON này về cho trình duyệt
        response.getWriter().write(jsonResult);
    }
}