package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import dao.BookDAO;
import java.util.Map;

@WebServlet("/admin/authors")
@MultipartConfig(fileSizeThreshold=1024*1024, maxFileSize=1024*1024*5, maxRequestSize=1024*1024*10)
public class AuthorAdminServlet extends HttpServlet {

    private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
        "cloud_name", "dqiefayjh",
        "api_key", "496728741237697",
        "api_secret", "S9lcM_6dRXMrWBiUKLMPPQD1kjQ",
        "secure", true
    ));

    private String saveImage(Part filePart) throws IOException {
        try (InputStream is = filePart.getInputStream();
             ByteArrayOutputStream os = new ByteArrayOutputStream()) {
            byte[] buffer = new byte[1024]; int len;
            while ((len = is.read(buffer)) != -1) os.write(buffer, 0, len);
            Map uploadResult = cloudinary.uploader().upload(os.toByteArray(),
                ObjectUtils.asMap("folder", "authors"));
            return (String) uploadResult.get("url");
        } catch (Exception e) { e.printStackTrace(); return null; }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        BookDAO dao = new BookDAO();

        if ("delete".equals(action)) {
            dao.deleteAuthor(Integer.parseInt(req.getParameter("id")));
            res.sendRedirect(req.getContextPath() + "/admin/authors?success=deleted");

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("editAuthor", dao.getAuthorById(id));
            req.setAttribute("authors", dao.getAllAuthors());
            req.getRequestDispatcher("/WEB-INF/views/admin/book/author.jsp")
               .forward(req, res);

        } else {
            req.setAttribute("authors", dao.getAllAuthors());
            req.getRequestDispatcher("/WEB-INF/views/admin/book/author.jsp")
               .forward(req, res);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        BookDAO dao = new BookDAO();

        if ("add".equals(action)) {
            String name = req.getParameter("name");
            String imageUrl = null;
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                imageUrl = saveImage(filePart);
            }
            dao.addAuthor(name, imageUrl);
            res.sendRedirect(req.getContextPath() + "/admin/authors?success=added");

        } else if ("edit".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String name = req.getParameter("name");
            String imageUrl = req.getParameter("oldImage");
            Part filePart = req.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                imageUrl = saveImage(filePart);
            }
            dao.updateAuthor(id, name, imageUrl);
            res.sendRedirect(req.getContextPath() + "/admin/authors?success=updated");
        }
    }
}