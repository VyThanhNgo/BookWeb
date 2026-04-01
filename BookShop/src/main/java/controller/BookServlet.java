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
                if(!id.isEmpty()) categoryIds.add(Integer.parseInt(id));
            }
        }

        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        Double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : null;
        Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : null;
        int totalBooks = dao.countBooks(keyword, categoryIds, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalBooks / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;
        
        List<Book> list;
        if((keyword != null && !keyword.isEmpty()) || 
           (categoryIds != null && !categoryIds.isEmpty()) ||
           (minPrice != null) || (maxPrice != null))
            list = dao.searchBooks(keyword, categoryIds, minPrice, maxPrice, sort, page, PAGE_SIZE);

        else
            list = dao.searchBooks(keyword, categoryIds, minPrice, maxPrice, sort, page, PAGE_SIZE);


        List<Category> categories = dao.getAllCategories();

        request.setAttribute("books", list);
        request.setAttribute("keyword", keyword);
        request.setAttribute("pageTitle", "Danh Sách Sách");
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBooks", totalBooks);
        request.getRequestDispatcher("/WEB-INF/views/book/book-list.jsp").forward(request, response);
    }
}