package controller;

import dao.BookDAO;
import model.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/admin/books")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB
    maxFileSize       = 1024 * 1024 * 5,  // 5MB
    maxRequestSize    = 1024 * 1024 * 10  // 10MB
)
public class BookAdminServlet extends HttpServlet {

    private String saveImage(Part filePart) throws IOException {
        String fileName = System.currentTimeMillis() + "_" +     //thêm  tên unique tránh không trùng 
            Paths.get(filePart.getSubmittedFileName()).getFileName().toString();   // tên gốc of image
        String uploadDir = getServletContext().getRealPath("") +   //đường dẫn lưu image
            File.separator + "assets" +
            File.separator + "images" +
            File.separator + "books";
        
        filePart.write(uploadDir + File.separator + fileName);  //luu ảnh
        return fileName;
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

            // Xóa ảnh vật lý trên server luôn (nếu có)
            Book book = dao.getBookById(bookId);
            if (book != null && book.getImage() != null && !book.getImage().isEmpty()) {
                String imagePath = getServletContext().getRealPath("") +
                    File.separator + "assets" +
                    File.separator + "images" +
                    File.separator + "books" +
                    File.separator + book.getImage();
                File imageFile = new File(imagePath);
                if (imageFile.exists()) {
                    imageFile.delete();
                }
            }

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

            String fileName = null;
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                fileName = saveImage(filePart);
            }

            dao.addBook(title, price, categoryId, authorId,
                        publishYear, description, stock, fileName);

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

            // Giữ ảnh cũ nếu không upload ảnh mới
            String fileName = request.getParameter("oldImage");
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                fileName = saveImage(filePart); // ghi đè ảnh mới
            }

            dao.updateBook(bookId, title, price, categoryId, authorId,
                           publishYear, description, stock, fileName);

            response.sendRedirect(request.getContextPath() + "/admin/books?success=updated");
        }
    }
}