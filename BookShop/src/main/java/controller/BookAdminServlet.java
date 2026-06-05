package controller;

import dao.BookDAO;
import model.Author;
import model.Book;
import model.Category;
import util.AdminJsonUtil;
import util.FileUploadValidator;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import java.util.List;
import java.util.Map;

@WebServlet("/admin/books")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize       = 1024 * 1024 * 5,
    maxRequestSize    = 1024 * 1024 * 50
)
public class BookAdminServlet extends HttpServlet {

    private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
        "cloud_name", "dqiefayjh",
        "api_key",    "496728741237697",
        "api_secret", "S9lcM_6dRXMrWBiUKLMPPQD1kjQ",
        "secure",     true
    ));

    private String saveImage(Part filePart, String folder) throws IOException {
        try (InputStream is = filePart.getInputStream();
             ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[1024];
            int len;
            while ((len = is.read(buffer)) != -1) os.write(buffer, 0, len);
            Map uploadResult = cloudinary.uploader().upload(os.toByteArray(),
                ObjectUtils.asMap("folder", folder));
            return (String) uploadResult.get("url");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void json(HttpServletResponse res, boolean success, String message) throws IOException {
        res.setContentType("application/json; charset=UTF-8");
        res.getWriter().write("{\"success\":" + success + ",\"message\":\"" + message + "\"}");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDAO dao = new BookDAO();
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.canDeleteBook(id)) {
                dao.deleteBook(id);
                json(response, true, "deleted");
            } else {
                json(response, false, "book_has_orders");
            }

        } else if ("restore".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.restoreBook(id);
            json(response, true, "updated");

        } else if ("hardDelete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (dao.canHardDeleteBook(id)) {
                dao.hardDeleteBook(id);
                json(response, true, "deleted");
            } else {
                json(response, false, "book_has_orders");
            }

        } else {
            // Trang danh sách sách — dùng chung AdminJsonUtil
            List<Book>     books             = dao.getAllBooks();
            List<Book>     deletedBooks      = dao.getDeletedBooks();
            List<Category> categories        = dao.getAllCategories();
            List<Category> deletedCategories = dao.getDeletedCategories();
            List<Author>   authors           = dao.getAllAuthors();
            List<Author>   deletedAuthors    = dao.getDeletedAuthors();

            request.setAttribute("books",             books);
            request.setAttribute("deletedBooks",      deletedBooks);
            request.setAttribute("categories",        categories);
            request.setAttribute("authors",           authors);

            request.setAttribute("booksJson",             AdminJsonUtil.serializeBooks(books));
            request.setAttribute("deletedBooksJson",      AdminJsonUtil.serializeBooks(deletedBooks));
            request.setAttribute("categoriesJson",        AdminJsonUtil.serializeCategories(categories));
            request.setAttribute("deletedCategoriesJson", AdminJsonUtil.serializeCategories(deletedCategories));
            request.setAttribute("authorsJson",           AdminJsonUtil.serializeAuthors(authors));
            request.setAttribute("deletedAuthorsJson",    AdminJsonUtil.serializeAuthors(deletedAuthors));

            request.getRequestDispatcher("/WEB-INF/views/admin/admin.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        BookDAO dao = new BookDAO();

        if ("add".equals(action)) {
            String title       = request.getParameter("title");
            double price       = Double.parseDouble(request.getParameter("price"));
            int categoryId     = Integer.parseInt(request.getParameter("categoryId"));
            int authorId       = Integer.parseInt(request.getParameter("authorId"));
            int publishYear    = Integer.parseInt(request.getParameter("publishYear"));
            String description = request.getParameter("description");
            int stock          = Integer.parseInt(request.getParameter("stock"));
            String isbn        = request.getParameter("isbn");
            String publisher   = request.getParameter("publisher");
            String language    = request.getParameter("language");
            String coverType   = request.getParameter("coverType");
            double originPrice = Double.parseDouble(request.getParameter("originPrice"));

            if (price < 0 || stock < 0) { json(response, false, "invalid_value"); return; }

            String imageUrl = null;
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String err = FileUploadValidator.validate(filePart);
                if (err != null) { json(response, false, "invalid_file"); return; }
                imageUrl = saveImage(filePart, "books");
            }

            int bookId = dao.addBook(title, price, originPrice, categoryId, authorId,
                publishYear, description, stock, imageUrl, isbn, publisher, language, coverType);

            for (Part part : request.getParts()) {
                if ("subImages".equals(part.getName()) && part.getSize() > 0) {
                    String subUrl = saveImage(part, "books");
                    if (subUrl != null) dao.addBookImage(bookId, subUrl);
                }
            }

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"message\":\"added\",\"id\":" + bookId + "}");

        } else if ("edit".equals(action)) {
            int bookId         = Integer.parseInt(request.getParameter("bookId"));
            String title       = request.getParameter("title");
            double price       = Double.parseDouble(request.getParameter("price"));
            int categoryId     = Integer.parseInt(request.getParameter("categoryId"));
            int authorId       = Integer.parseInt(request.getParameter("authorId"));
            int publishYear    = Integer.parseInt(request.getParameter("publishYear"));
            String description = request.getParameter("description");
            int stock          = Integer.parseInt(request.getParameter("stock"));
            String isbn        = request.getParameter("isbn");
            String publisher   = request.getParameter("publisher");
            String language    = request.getParameter("language");
            String coverType   = request.getParameter("coverType");
            double originPrice = Double.parseDouble(request.getParameter("originPrice"));

            if (price < 0 || stock < 0) { json(response, false, "invalid_value"); return; }

            String imageUrl = request.getParameter("oldImage");
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String err = FileUploadValidator.validate(filePart);
                if (err != null) { json(response, false, "invalid_file"); return; }
                imageUrl = saveImage(filePart, "books");
            }

            dao.updateBook(bookId, title, price, originPrice, categoryId, authorId,
                publishYear, description, stock, imageUrl, isbn, publisher, language, coverType);

            for (Part part : request.getParts()) {
                if ("subImages".equals(part.getName()) && part.getSize() > 0) {
                    String subUrl = saveImage(part, "books");
                    if (subUrl != null) dao.addBookImage(bookId, subUrl);
                }
            }

            json(response, true, "updated");
            return;
        }
    }
}