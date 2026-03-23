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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookDAO dao = new BookDAO();

        String keyword = request.getParameter("keyword");
        
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

        List<Book> list;
        if((keyword != null && !keyword.isEmpty()) || 
           (categoryIds != null && !categoryIds.isEmpty()) ||
           (minPrice != null) || (maxPrice != null))
            list = dao.searchBooks(keyword, categoryIds, minPrice, maxPrice);
        else
            list = dao.getAllBooks();

        List<Category> categories = dao.getAllCategories();

        request.setAttribute("books", list);
        request.setAttribute("keyword", keyword);
        request.setAttribute("pageTitle", "Danh Sách Sách");
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/WEB-INF/views/book/book-list.jsp").forward(request, response);
    }
}