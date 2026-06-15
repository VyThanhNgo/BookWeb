package controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import util.FileUploadValidator;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import dao.BookDAO;
import java.util.Map;

@WebServlet("/admin/authors")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 10)
public class AuthorAdminServlet extends HttpServlet {

	private static final Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap("cloud_name", "dqiefayjh", "api_key",
			"496728741237697", "api_secret", "S9lcM_6dRXMrWBiUKLMPPQD1kjQ", "secure", true));

	private String saveImage(Part filePart) throws IOException {
		try (InputStream is = filePart.getInputStream(); ByteArrayOutputStream os = new ByteArrayOutputStream()) {
			byte[] buffer = new byte[1024];
			int len;
			while ((len = is.read(buffer)) != -1)
				os.write(buffer, 0, len);
			Map uploadResult = cloudinary.uploader().upload(os.toByteArray(), ObjectUtils.asMap("folder", "authors"));
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

	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		String action = req.getParameter("action");
		BookDAO dao = new BookDAO();

		if ("delete".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			if (dao.canDeleteAuthor(id)) {
				dao.deleteAuthor(id);
				json(res, true, "deleted");
			} else {
				json(res, false, "has_books");
			}

		} else if ("restore".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			dao.restoreAuthor(id);
			json(res, true, "updated");

		} else if ("hardDelete".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			// kiểm tra còn sách liên kết không (kể cả sách đã ẩn)
			if (dao.canHardDeleteAuthor(id)) {
				dao.hardDeleteAuthor(id);
				json(res, true, "deleted");
			} else {
				json(res, false, "has_books");
			}

		} else if ("edit".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			req.setAttribute("editAuthor", dao.getAuthorById(id));
			req.setAttribute("authors", dao.getAllAuthors());
			res.sendRedirect(req.getContextPath() + "/admin");

		} else {
			req.setAttribute("authors", dao.getAllAuthors());
			res.sendRedirect(req.getContextPath() + "/admin");
		}
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");
		String action = req.getParameter("action");
		BookDAO dao = new BookDAO();

		if ("add".equals(action)) {
			String name = req.getParameter("name");
			if (name == null || name.trim().isEmpty()) {
			    json(res, false, "empty_name");
			    return;
			}
			name = name.trim();
			
			String imageUrl = null;
			Part filePart = req.getPart("image");
			if (filePart != null && filePart.getSize() > 0) {
				String validationError = FileUploadValidator.validate(filePart);
				if (validationError != null) {
					json(res, false, "invalid_file");
					return;
				}
				imageUrl = saveImage(filePart);
			}
			int newId = dao.addAuthor(name, imageUrl);
		    String safeImage = imageUrl != null ? imageUrl : "";
		    res.setContentType("application/json; charset=UTF-8");
		    res.getWriter().write("{\"success\":true,\"message\":\"added\",\"id\":" + newId + ",\"name\":\"" + name + "\",\"image\":\"" + safeImage + "\"}");

		} else if ("edit".equals(action)) {
			int id = Integer.parseInt(req.getParameter("id"));
			String name = req.getParameter("name");
			if (name == null || name.trim().isEmpty()) {
			    json(res, false, "empty_name");
			    return;
			}
			name = name.trim();
			
			String imageUrl = req.getParameter("oldImage");
			Part filePart = req.getPart("image");
			if (filePart != null && filePart.getSize() > 0) {
				String validationError = FileUploadValidator.validate(filePart);
				if (validationError != null) {
					json(res, false, "invalid_file");
					return;
				}
				imageUrl = saveImage(filePart);
			}
			dao.updateAuthor(id, name, imageUrl);
			json(res, true, "updated");
		}
	}
}