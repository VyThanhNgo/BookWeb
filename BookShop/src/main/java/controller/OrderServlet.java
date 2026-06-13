package controller;

import dao.CartDAO;
import dao.OrderDAO;
import model.Cart;
import model.CartItem;
import model.Order;
import model.OrderItem;
import model.User;

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

        String paymentMethodEarly = request.getParameter("paymentMethod");

        // ZaloPay chưa được tích hợp — chặn sớm trước khi tạo đơn
        if ("ZALOPAY".equals(paymentMethodEarly)) {
            double subtotalE = cart.getTotalPrice();
            request.setAttribute("pageTitle", "Thanh toán");
            request.setAttribute("error", "ZaloPay hiện chưa được hỗ trợ. Vui lòng chọn phương thức thanh toán khác.");
            request.setAttribute("orderItems", mapOrderItems(cart.getItems()));
            request.setAttribute("subtotal", subtotalE);
            request.setAttribute("shippingFee", 0.0);
            request.setAttribute("discount", 0.0);
            request.setAttribute("total", subtotalE);
            request.getRequestDispatcher("/WEB-INF/views/order/order.jsp").forward(request, response);
            return;
        }

        // Bank Transfer — yêu cầu xác nhận đã chuyển khoản
        if ("BANK_TRANSFER".equals(paymentMethodEarly)) {
            String bankConfirmed = request.getParameter("bankConfirmed");
            if (!"1".equals(bankConfirmed)) {
                double subtotalE = cart.getTotalPrice();
                request.setAttribute("pageTitle", "Thanh toán");
                request.setAttribute("error", "Vui lòng xác nhận đã chuyển khoản trước khi đặt hàng.");
                request.setAttribute("orderItems", mapOrderItems(cart.getItems()));
                request.setAttribute("subtotal", subtotalE);
                request.setAttribute("shippingFee", 0.0);
                request.setAttribute("discount", 0.0);
                request.setAttribute("total", subtotalE);
                request.getRequestDispatcher("/WEB-INF/views/order/order.jsp").forward(request, response);
                return;
            }
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

        String couponCode = request.getParameter("couponCode");

        double shippingFee = parseDoubleOrZero(shippingFeeStr);
        // discount luôn = 0 cho đến khi có logic validate coupon server-side
        double discount = 0;

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

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = (loggedInUser != null) ? loggedInUser.getId() : 0;

        Order order = new Order();
        order.setUserId(userId);
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

        List<OrderItem> placedItems = mapOrderItems(cart.getItems());
        cart.clear();
        if (userId > 0) {
            new CartDAO().clearCart(userId);
        }

        // Điều hướng theo phương thức thanh toán
        if ("VNPAY".equals(paymentMethod)) {
            session.setAttribute("pendingPaymentOrderCode", order.getOrderCode());
            response.sendRedirect(request.getContextPath() + "/vnpay/pay");
            return;
        }

        if ("MOMO".equals(paymentMethod)) {
            session.setAttribute("pendingPaymentOrderCode", order.getOrderCode());
            response.sendRedirect(request.getContextPath() + "/momo/pay");
            return;
        }

        // COD / BANK_TRANSFER — hiển thị trang thành công ngay
        request.setAttribute("pageTitle", "Đặt hàng thành công");
        request.setAttribute("placedOrder", order);
        request.setAttribute("placedOrderItems", placedItems);
        if ("BANK_TRANSFER".equals(paymentMethod)) {
            request.setAttribute("bankTransfer", true);
        }

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