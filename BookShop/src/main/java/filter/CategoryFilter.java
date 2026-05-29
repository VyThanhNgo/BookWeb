package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;  // cần import FilterConfig
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;

import dao.BookDAO;

@WebFilter("/*")
public class CategoryFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        if (request.getServletContext().getAttribute("categories") == null) {
            BookDAO dao = new BookDAO();
            request.getServletContext().setAttribute("categories", dao.getAllCategories());
        }
        chain.doFilter(req, res);
    }

    @Override
    public void destroy() {
    }
}