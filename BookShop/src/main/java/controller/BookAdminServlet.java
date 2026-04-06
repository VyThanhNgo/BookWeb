package controller;

import dao.BookDAO;
import model.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.util.Map;

@WebServlet("/admin/books")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      //  file nhỏ hơn 1MB thì lưu tạm vào RAM, lớn hơn thì ghi ra ổ đĩa tạm. Tránh tốn RAM khi upload file lớn.
    maxFileSize       = 1024 * 1024 * 5,  // giới hạn 1 file tối đa 5MB. Upload file lớn hơn sẽ báo lỗi.
    maxRequestSize    = 1024 * 1024 * 50  //  giới hạn toàn bộ request tối đa 50MB. Nếu form có nhiều file thì tổng dung lượng không vượt quá 50MB.
)
public class BookAdminServlet extends HttpServlet {

	private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
	        "cloud_name", "dqiefayjh", 
	        "api_key", "496728741237697", 
	        "api_secret", "S9lcM_6dRXMrWBiUKLMPPQD1kjQ", 
	        "secure", true
	    ));
	
    private String saveImage(Part filePart, String folder) throws IOException {
    	try (InputStream is = filePart.getInputStream();
    	         ByteArrayOutputStream os = new ByteArrayOutputStream()) {
    	        
    	        // Chuyển file thành mảng Byte
    	        byte[] buffer = new byte[1024];
    	        int len;
    	        while ((len = is.read(buffer)) != -1) {
    	            os.write(buffer, 0, len);
    	        }
    	        
    	        Map uploadResult = cloudinary.uploader().upload(os.toByteArray(),
    	            ObjectUtils.asMap("folder", "books"));
    	            
    	        return (String) uploadResult.get("url");
    	    } catch (Exception e) {
    	        e.printStackTrace();
    	        return null;
    	    }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        BookDAO dao = new BookDAO();
        request.setAttribute("categories", dao.getAllCategories());
        request.setAttribute("authors", dao.getAllAuthors());

        String action = request.getParameter("action");

        // edit sách
        if ("edit".equals(action)) {
            int bookId = Integer.parseInt(request.getParameter("id"));
            Book book = dao.getBookById(bookId);
            request.setAttribute("book", book);
            request.getRequestDispatcher("/WEB-INF/views/admin/book/edit-book.jsp")
                   .forward(request, response);
            // xóa sách
            
        } else if ("delete".equals(action)) {
            int bookId = Integer.parseInt(request.getParameter("id"));

          
            dao.deleteBook(bookId);
            response.sendRedirect(request.getContextPath() + "/admin/books?success=deleted");

        }else {
            // Trang danh sách sách admin
            request.setAttribute("books", dao.getAllBooks());
            request.getRequestDispatcher("/WEB-INF/views/admin/book/add-book.jsp")
                   .forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        BookDAO dao = new BookDAO();

        // thêm sách
        if ("add".equals(action)) {
            String title       = request.getParameter("title");
            double price       = Double.parseDouble(request.getParameter("price"));
            int categoryId     = Integer.parseInt(request.getParameter("categoryId"));
            int authorId       = Integer.parseInt(request.getParameter("authorId"));
            int publishYear    = Integer.parseInt(request.getParameter("publishYear"));
            String description = request.getParameter("description");
            int stock          = Integer.parseInt(request.getParameter("stock"));
            String isbn = request.getParameter("isbn");
            String publisher = request.getParameter("publisher");
            String language = request.getParameter("language");
            String coverType = request.getParameter("coverType");
            
            String imageUrl = null;
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                imageUrl = saveImage(filePart, "books");
            }

            int bookId = dao.addBook(title, price, categoryId, authorId, publishYear, description, stock, imageUrl, isbn, publisher, language, coverType);

            for (Part part : request.getParts()) {
                if ("subImages".equals(part.getName()) && part.getSize() > 0) {
                    String subImageUrl = saveImage(part, "books");
                    if (subImageUrl != null) {
                        // bookId là ID vừa lấy được ở trên
                        dao.addBookImage(bookId, subImageUrl); 
                    }
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/books?success=added");
            
        // sửa sách
        } else if ("edit".equals(action)) {
            int bookId         = Integer.parseInt(request.getParameter("bookId"));
            String title       = request.getParameter("title");
            double price       = Double.parseDouble(request.getParameter("price"));
            int categoryId     = Integer.parseInt(request.getParameter("categoryId"));
            int authorId       = Integer.parseInt(request.getParameter("authorId"));
            int publishYear    = Integer.parseInt(request.getParameter("publishYear"));
            String description = request.getParameter("description");
            int stock          = Integer.parseInt(request.getParameter("stock"));
            String isbn = request.getParameter("isbn");
            String publisher = request.getParameter("publisher");
            String language = request.getParameter("language");
            String coverType = request.getParameter("coverType");
            
            // Giữ ảnh cũ nếu không upload ảnh mới
            String imageUrl = request.getParameter("oldImage");
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                imageUrl = saveImage(filePart, "books"); // ghi đè ảnh mới
            }

            dao.updateBook(bookId, title, price, categoryId, authorId, publishYear, description, stock, imageUrl, isbn, publisher, language, coverType);

            for (Part part : request.getParts()) {
                if ("subImages".equals(part.getName()) && part.getSize() > 0) {
                    String subImageUrl = saveImage(part, "books");
                    if (subImageUrl != null) {
                        // bookId là ID vừa lấy được ở trên
                        dao.addBookImage(bookId, subImageUrl); 
                    }
                }
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/books?success=updated");
          
        }
    }
}