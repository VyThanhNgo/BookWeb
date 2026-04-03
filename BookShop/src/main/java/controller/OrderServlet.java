package controller;

import dao.OrderDAO;
import model.Cart;
import model.CartItem;
import model.Order;
import model.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private Cart getOrCreateCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private List<OrderItem> mapOrderItems(Collection<CartItem> cartItems) {
        List<OrderItem> items = new ArrayList<>();
        for (CartItem item : cartItems) {
            items.add(new OrderItem(
                    item.getBookId(),
                    item.getTitle(),
                    item.getImage(),
                    item.getQuantity(),
                    item.getPrice()
            ));
        }
        return items;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        double subtotal = cart.getTotalPrice();
        double shippingFee = 0;
        double discount = 0;
        double total = subtotal + shippingFee - discount;

        request.setAttribute("pageTitle", "Thanh toán");
        request.setAttribute("orderItems", mapOrderItems(cart.getItems()));
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("discount", discount);
        request.setAttribute("total", total);

        request.getRequestDispatcher("/WEB-INF/views/order/order.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Cart cart = getOrCreateCart(session);

        if (cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String addressLine = request.getParameter("addressLine");

        /* GIỮ CÁCH LẤY TÊN ĐỊA CHỈ */
        String ward = request.getParameter("wardName");
        String district = request.getParameter("districtName");
        String province = request.getParameter("provinceName");

        String note = request.getParameter("note");
        String paymentMethod = request.getParameter("paymentMethod");
        String shippingFeeStr = request.getParameter("shippingFee");

        /* THÊM 2 THAM SỐ NÀY */
        String discountStr = request.getParameter("discountAmount");
        String couponCode = request.getParameter("couponCode");

        double shippingFee = parseDoubleOrZero(shippingFeeStr);
        double discount = parseDoubleOrZero(discountStr);

        if (isBlank(customerName) || isBlank(phone) || isBlank(addressLine) || isBlank(paymentMethod)) {
            double subtotal = cart.getTotalPrice();
            double total = subtotal + shippingFee - discount;

            request.setAttribute("pageTitle", "Thanh toán");
            request.setAttribute("error", "Vui lòng nhập đầy đủ họ tên, số điện thoại, địa chỉ và chọn phương thức thanh toán.");
            request.setAttribute("orderItems", mapOrderItems(cart.getItems()));
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("discount", discount);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/WEB-INF/views/order/order.jsp").forward(request, response);
            return;
        }

        double subtotal = cart.getTotalPrice();
        double total = subtotal + shippingFee - discount;

        Order order = new Order();
        order.setCustomerName(customerName);
        order.setPhone(phone);
        order.setEmail(email);
        order.setAddressLine(addressLine);
        order.setWard(ward);
        order.setDistrict(district);
        order.setProvince(province);
        order.setNote(note);
        order.setPaymentMethod(paymentMethod);
        order.setStatus("PENDING");
        order.setSubtotal(subtotal);
        order.setShippingFee(shippingFee);
        order.setDiscountAmount(discount);
        order.setTotalAmount(total);
        order.setCouponCode(couponCode);

        OrderDAO orderDAO = new OrderDAO();
        boolean success = orderDAO.createFullOrder(order, cart.getItems());

        if (!success) {
            request.setAttribute("pageTitle", "Thanh toán");
            request.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            request.setAttribute("orderItems", mapOrderItems(cart.getItems()));
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("discount", discount);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/WEB-INF/views/order/order.jsp").forward(request, response);
            return;
        }

        request.setAttribute("pageTitle", "Đặt hàng thành công");
        request.setAttribute("placedOrder", order);
        request.setAttribute("placedOrderItems", mapOrderItems(cart.getItems()));

        cart.clear();

        request.getRequestDispatcher("/WEB-INF/views/order/order-success.jsp").forward(request, response);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    /* THÊM HÀM NÀY */
    private double parseDoubleOrZero(String value) {
        try {
            return Double.parseDouble(value);
        } catch (Exception e) {
            return 0;
        }
    }
}