<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%@ include file="/WEB-INF/views/base/header.jsp" %>

<div class="page-content bg-white">
    <div class="dz-bnr-inr overlay-secondary-dark dz-bnr-inr-sm"
         style="background-image:url(${ctx}/assets/images/background/bg3.jpg);">
        <div class="container">
            <div class="dz-bnr-inr-entry"><h1>Đơn Hàng Của Tôi</h1></div>
        </div>
    </div>

    <div class="container" style="padding: 40px 15px; max-width: 960px;">

        <c:choose>
            <c:when test="${not empty orderDetail}">
                <%-- Chi tiết một đơn hàng --%>
                <a href="${ctx}/my-orders" style="display:inline-block;margin-bottom:20px;color:#1e3a5f;">
                    ← Quay lại danh sách
                </a>
                <h2 style="margin-bottom:8px;">Đơn hàng #${orderDetail.orderCode}</h2>
                <p style="color:#666;margin-bottom:20px;">
                    Đặt lúc: <fmt:formatDate value="${orderDetail.createdAt}" pattern="HH:mm dd/MM/yyyy"/>
                </p>

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:24px;margin-bottom:24px;">
                    <div style="background:#f9f9f9;padding:20px;border-radius:8px;">
                        <h4 style="margin-bottom:12px;color:#1e3a5f;">Thông tin giao hàng</h4>
                        <p><strong>${orderDetail.customerName}</strong></p>
                        <p>${orderDetail.phone}</p>
                        <p>${orderDetail.email}</p>
                        <p>${orderDetail.fullAddress}</p>
                    </div>
                    <div style="background:#f9f9f9;padding:20px;border-radius:8px;">
                        <h4 style="margin-bottom:12px;color:#1e3a5f;">Thanh toán</h4>
                        <p>Phương thức: <strong>${orderDetail.paymentMethod}</strong></p>
                        <p>Tiền hàng: <strong><fmt:formatNumber value="${orderDetail.subtotal}" pattern="#,###"/>đ</strong></p>
                        <p>Phí ship: <strong><fmt:formatNumber value="${orderDetail.shippingFee}" pattern="#,###"/>đ</strong></p>
                        <p style="font-size:1.1em;color:#1e3a5f;">
                            Tổng: <strong><fmt:formatNumber value="${orderDetail.totalAmount}" pattern="#,###"/>đ</strong>
                        </p>
                        <p>Trạng thái:
                            <span style="padding:3px 10px;border-radius:12px;font-size:.85em;font-weight:600;
                                background:${orderDetail.status == 'PENDING' ? '#fff3cd' : orderDetail.status == 'COMPLETED' ? '#d1fae5' : orderDetail.status == 'CANCELLED' ? '#fee2e2' : '#dbeafe'};
                                color:${orderDetail.status == 'PENDING' ? '#92400e' : orderDetail.status == 'COMPLETED' ? '#065f46' : orderDetail.status == 'CANCELLED' ? '#991b1b' : '#1e40af'};">
                                ${orderDetail.status}
                            </span>
                        </p>
                    </div>
                </div>

                <h4 style="margin-bottom:12px;color:#1e3a5f;">Sản phẩm đã đặt</h4>
                <table style="width:100%;border-collapse:collapse;">
                    <thead>
                        <tr style="background:#1e3a5f;color:#fff;">
                            <th style="padding:10px 14px;text-align:left;">Sách</th>
                            <th style="padding:10px 14px;text-align:center;">Số lượng</th>
                            <th style="padding:10px 14px;text-align:right;">Đơn giá</th>
                            <th style="padding:10px 14px;text-align:right;">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${orderItems}">
                            <tr style="border-bottom:1px solid #eee;">
                                <td style="padding:10px 14px;">
                                    <div style="display:flex;align-items:center;gap:12px;">
                                        <c:if test="${not empty item.image}">
                                            <img src="${item.image}" alt="${item.bookTitle}"
                                                 style="width:52px;height:70px;object-fit:cover;border-radius:4px;flex-shrink:0;">
                                        </c:if>
                                        <span>${item.bookTitle}</span>
                                    </div>
                                </td>
                                <td style="padding:10px 14px;text-align:center;">${item.quantity}</td>
                                <td style="padding:10px 14px;text-align:right;"><fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/>đ</td>
                                <td style="padding:10px 14px;text-align:right;"><fmt:formatNumber value="${item.lineTotal}" pattern="#,###"/>đ</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>

            <c:otherwise>
                <%-- Danh sách đơn hàng --%>
                <h2 style="margin-bottom:24px;">Lịch sử đơn hàng</h2>
                <c:choose>
                    <c:when test="${empty orders}">
                        <div style="text-align:center;padding:60px 0;color:#999;">
                            <i class="fa-solid fa-box-open" style="font-size:3rem;margin-bottom:16px;display:block;"></i>
                            <p>Bạn chưa có đơn hàng nào.</p>
                            <a href="${ctx}/books" style="display:inline-block;margin-top:16px;padding:10px 24px;background:#1e3a5f;color:#fff;border-radius:6px;text-decoration:none;">
                                Mua sắm ngay
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table style="width:100%;border-collapse:collapse;">
                            <thead>
                                <tr style="background:#1e3a5f;color:#fff;">
                                    <th style="padding:12px 14px;text-align:left;">Mã đơn</th>
                                    <th style="padding:12px 14px;text-align:left;">Ngày đặt</th>
                                    <th style="padding:12px 14px;text-align:right;">Tổng tiền</th>
                                    <th style="padding:12px 14px;text-align:center;">Trạng thái</th>
                                    <th style="padding:12px 14px;text-align:center;">Chi tiết</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr style="border-bottom:1px solid #eee;">
                                        <td style="padding:12px 14px;font-weight:600;">${order.orderCode}</td>
                                        <td style="padding:12px 14px;color:#666;">
                                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </td>
                                        <td style="padding:12px 14px;text-align:right;font-weight:600;">
                                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ
                                        </td>
                                        <td style="padding:12px 14px;text-align:center;">
                                            <span style="padding:3px 10px;border-radius:12px;font-size:.82em;font-weight:600;
                                                background:${order.status == 'PENDING' ? '#fff3cd' : order.status == 'COMPLETED' ? '#d1fae5' : order.status == 'CANCELLED' ? '#fee2e2' : '#dbeafe'};
                                                color:${order.status == 'PENDING' ? '#92400e' : order.status == 'COMPLETED' ? '#065f46' : order.status == 'CANCELLED' ? '#991b1b' : '#1e40af'};">
                                                ${order.status}
                                            </span>
                                        </td>
                                        <td style="padding:12px 14px;text-align:center;">
                                            <a href="${ctx}/my-orders?orderId=${order.orderId}"
                                               style="color:#1e3a5f;font-size:.9em;text-decoration:underline;">Xem</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="/WEB-INF/views/base/footer.jsp" %>
