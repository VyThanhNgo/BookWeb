package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.BookDAO;
import model.Book;
import model.Category;

@WebServlet("/books")
public class BookServlet extends HttpServlet {
	private static final int PAGE_SIZE = 12;
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDAO dao = new BookDAO();

        
        
        String keyword = request.getParameter("keyword");
        String sort = request.getParameter("sort");
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }
        
        String[] catIds = request.getParameterValues("categoryId");
        List<Integer> categoryIds = null;
        if(catIds != null) {
            categoryIds = new ArrayList<>();
            for(String id : catIds) {
            	//  kiểm tra không rỗng VÀ là số hợp lệ
            	if (id != null && !id.trim().isEmpty()) {
                    try {
                        categoryIds.add(Integer.parseInt(id.trim()));
                    } catch (NumberFormatException e) {
                        // bỏ qua giá trị không hợp lệ
                    }
                }
            }
            if (categoryIds.isEmpty()) categoryIds = null;
        }

        double dbMaxPrice = dao.getMaxPrice();
        
        
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        Double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : 0.0;
        Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : dbMaxPrice;
        
     // năm xuất bản 
        String[] yearParams = request.getParameterValues("publishYear");
        List<Integer> publishYears = null;
        if (yearParams != null) {
            publishYears = new ArrayList<>();
            for (String y : yearParams) {
                if (y != null && !y.trim().isEmpty()) {
                    try { publishYears.add(Integer.parseInt(y.trim())); } catch (NumberFormatException e) {}
                }
            }
            if (publishYears.isEmpty()) publishYears = null;
        }

        //tác giả 
        String[] authorParams = request.getParameterValues("authorId");
        List<Integer> authorIds = null;
        if (authorParams != null) {
            authorIds = new ArrayList<>();
            for (String a : authorParams) {
                if (a != null && !a.trim().isEmpty()) {
                    try { authorIds.add(Integer.parseInt(a.trim())); } catch (NumberFormatException e) {}
                }
            }
            if (authorIds.isEmpty()) authorIds = null;
        }

        //nhà xuất bản
        String[] publisherParams = request.getParameterValues("publisher");
        List<String> publishers = null;
        if (publisherParams != null) {
            publishers = new ArrayList<>();
            for (String p : publisherParams) {
                if (p != null && !p.trim().isEmpty()) publishers.add(p.trim());
            }
            if (publishers.isEmpty()) publishers = null;
        }
        
        int totalBooks = dao.countBooks(keyword, categoryIds, minPrice, maxPrice, publishYears, authorIds, publishers);
        int totalPages = (int) Math.ceil((double) totalBooks / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;
        
        List<Book> list = dao.searchBooks(keyword, categoryIds, minPrice, maxPrice, sort, page, PAGE_SIZE, publishYears, authorIds, publishers);

        List<Category> categories = dao.getAllCategories();

        request.setAttribute("dbMaxPrice", dbMaxPrice);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("books", list);
        request.setAttribute("keyword", keyword);
        request.setAttribute("pageTitle", "Danh Sách Sách");
        request.setAttribute("categories", categories);
        request.setAttribute("authors", dao.getAllAuthors());
        request.setAttribute("distinctYears", dao.getDistinctPublishYears());
        request.setAttribute("distinctPublishers", dao.getDistinctPublishers());
        request.setAttribute("selectedYears", publishYears);
        request.setAttribute("selectedAuthorIds", authorIds);
        request.setAttribute("selectedPublishers", publishers);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBooks", totalBooks);
        request.getRequestDispatcher("/WEB-INF/views/book/book-list.jsp").forward(request, response);
    }
}