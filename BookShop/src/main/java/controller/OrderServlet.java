package controller;

import dao.BookDAO;
import dao.CartDAO;
import dao.CouponDAO;
import dao.OrderDAO;
import model.Book;
import model.Cart;
import model.CartItem;
import model.Coupon;
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
import java.util.regex.Pattern;

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

    // Tập bookId người dùng đã chọn để thanh toán (lưu trong session từ trang giỏ hàng)
    @SuppressWarnings("unchecked")
    private java.util.Set<Integer> getSelectedIds(HttpSession session) {
        Object o = session.getAttribute("checkoutSelectedIds");
        return (o instanceof java.util.Set) ? (java.util.Set<Integer>) o : null;
    }

    // Danh sách sản phẩm sẽ thanh toán = giỏ hàng đã lọc theo lựa chọn.
    // Nếu không có lựa chọn (hoặc lọc ra rỗng) → dùng toàn bộ giỏ (tương thích cũ).
    private List<CartItem> getCheckoutItems(Cart cart, java.util.Set<Integer> selected) {
        List<CartItem> all = new ArrayList<>(cart.getItems());
        if (selected == null || selected.isEmpty()) return all;
        List<CartItem> picked = new ArrayList<>();
        for (CartItem ci : all) {
            if (selected.contains(ci.getBookId())) picked.add(ci);
        }
        return picked.isEmpty() ? all : picked;
    }

    private double sumItems(Collection<CartItem> items) {
        double s = 0;
        for (CartItem i : items) s += i.getTotal();
        return s;
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

        // Lựa chọn sản phẩm để thanh toán (từ trang giỏ hàng) → lưu vào session
        String selParam = request.getParameter("selectedIds");
        if (selParam != null) {
            java.util.Set<Integer> sel = new java.util.HashSet<>();
            for (String s : selParam.split(",")) {
                try { sel.add(Integer.parseInt(s.trim())); } catch (Exception ignored) {}
            }
            if (!sel.isEmpty()) session.setAttribute("checkoutSelectedIds", sel);
            else session.removeAttribute("checkoutSelectedIds");
        }

        List<CartItem> items = getCheckoutItems(cart, getSelectedIds(session));

        BookDAO bookDAO = new BookDAO();
        for (CartItem item : items) {
            Book book = bookDAO.getBookById(item.getBookId());
            if (book == null || book.getStock() < item.getQuantity()) {
                String msg = (book == null)
                        ? "Sản phẩm \"" + item.getTitle() + "\" không còn tồn tại."
                        : "Sản phẩm \"" + item.getTitle() + "\" chỉ còn " + book.getStock() + " cuốn trong kho.";
                session.setAttribute("checkoutStockError", msg);
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        double subtotal = sumItems(items);
        double shippingFee = 0;
        double discount = 0;

        // Mã giảm giá áp từ trang giỏ hàng (nếu có) → áp sẵn vào trang thanh toán
        String couponCode = request.getParameter("coupon");
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            CouponDAO couponDAO = new CouponDAO();
            Coupon coupon = couponDAO.findByCode(couponCode.trim());
            discount = Math.round(couponDAO.computeDiscount(coupon, subtotal));
            if (discount > 0) {
                request.setAttribute("couponCode", couponCode.trim().toUpperCase());
                request.setAttribute("old_couponCode", couponCode.trim().toUpperCase());
            }
        }

        double total = subtotal + shippingFee - discount;

        request.setAttribute("pageTitle", "Thanh toán");
        request.setAttribute("orderItems", mapOrderItems(items));
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

        // Chỉ thanh toán những sản phẩm đã được chọn ở trang giỏ hàng
        List<CartItem> items = getCheckoutItems(cart, getSelectedIds(session));
        double itemsSubtotal = sumItems(items);

        String paymentMethodEarly = request.getParameter("paymentMethod");

        // ZaloPay chưa được tích hợp — chặn sớm trước khi tạo đơn
        if ("ZALOPAY".equals(paymentMethodEarly)) {
            double subtotalE = itemsSubtotal;
            request.setAttribute("pageTitle", "Thanh toán");
            request.setAttribute("error", "ZaloPay hiện chưa được hỗ trợ. Vui lòng chọn phương thức thanh toán khác.");
            request.setAttribute("orderItems", mapOrderItems(items));
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
                double subtotalE = itemsSubtotal;
                request.setAttribute("pageTitle", "Thanh toán");
                request.setAttribute("error", "Vui lòng xác nhận đã chuyển khoản trước khi đặt hàng.");
                request.setAttribute("orderItems", mapOrderItems(items));
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
        String couponCode = request.getParameter("couponCode");

        Integer sessionFee = (Integer) session.getAttribute("calculatedShippingFee");
        double shippingFee = (sessionFee != null) ? sessionFee.doubleValue()
                : parseDoubleOrZero(request.getParameter("shippingFee"));
        double subtotalForCoupon = itemsSubtotal;
        double discount = 0;
        if (!isBlank(couponCode)) {
            CouponDAO couponDAO = new CouponDAO();
            Coupon coupon = couponDAO.findByCode(couponCode.trim());
            discount = couponDAO.computeDiscount(coupon, subtotalForCoupon);
        }
        // Làm tròn về số nguyên VND để tránh số tiền lẻ (gây lệch amount khi đối soát VNPay/MoMo)
        discount = Math.round(discount);

        String validationError = null;
        if (isBlank(customerName) || isBlank(phone) || isBlank(addressLine) || isBlank(paymentMethod)) {
            validationError = "Vui lòng nhập đầy đủ họ tên, số điện thoại, địa chỉ và chọn phương thức thanh toán.";
        } else if (!Pattern.matches("^(0[3-9][0-9]{8})$", phone.trim())) {
            validationError = "Số điện thoại không hợp lệ (phải là số di động Việt Nam 10 chữ số, bắt đầu bằng 03-09).";
        } else if (!isBlank(email) && !Pattern.matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$", email.trim())) {
            validationError = "Địa chỉ email không hợp lệ.";
        }

        if (validationError != null) {
            double subtotal = itemsSubtotal;
            double total = subtotal + shippingFee - discount;

            request.setAttribute("pageTitle", "Thanh toán");
            request.setAttribute("error", validationError);
            request.setAttribute("orderItems", mapOrderItems(items));
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("discount", discount);
            request.setAttribute("total", total);
            request.setAttribute("old_customerName", customerName);
            request.setAttribute("old_phone", phone);
            request.setAttribute("old_email", email);
            request.setAttribute("old_addressLine", addressLine);
            request.setAttribute("old_note", note);

            request.getRequestDispatcher("/WEB-INF/views/order/order.jsp").forward(request, response);
            return;
        }

        double subtotal = itemsSubtotal;
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
        boolean success = orderDAO.createFullOrder(order, items);

        if (!success) {
            request.setAttribute("pageTitle", "Thanh toán");
            request.setAttribute("error", "Không thể tạo đơn hàng. Vui lòng thử lại.");
            request.setAttribute("orderItems", mapOrderItems(items));
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingFee", shippingFee);
            request.setAttribute("discount", discount);
            request.setAttribute("total", total);

            request.getRequestDispatcher("/WEB-INF/views/order/order.jsp").forward(request, response);
            return;
        }

        // Chỉ tính lượt coupon ngay với phương thức nhận hàng/chuyển khoản (đơn đã chốt).
        // Với VNPAY/MOMO, lượt coupon được tính khi thanh toán thành công (trong updateOrderPayment),
        // tránh trừ oan lượt khi khách bỏ ngang hoặc thanh toán thất bại.
        if (!isBlank(couponCode) && discount > 0
                && ("COD".equals(paymentMethod) || "BANK_TRANSFER".equals(paymentMethod))) {
            new CouponDAO().incrementUsed(couponCode.trim());
        }

        List<OrderItem> placedItems = mapOrderItems(items);
        // Chỉ xóa khỏi giỏ những sản phẩm đã đặt (giữ lại các sản phẩm không được chọn)
        CartDAO cartDAO = new CartDAO();
        for (CartItem it : items) {
            cart.removeItem(it.getBookId());
            if (userId > 0) cartDAO.removeItem(userId, it.getBookId());
        }
        session.removeAttribute("checkoutSelectedIds");

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

        // COD / BANK_TRANSFER — đơn đã chốt → gửi email xác nhận (nền, no-op nếu chưa cấu hình SMTP)
        util.MailUtil.sendOrderConfirmationAsync(order, placedItems);

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