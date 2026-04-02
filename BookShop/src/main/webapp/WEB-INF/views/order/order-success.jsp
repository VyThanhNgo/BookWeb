<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%@ include file="/WEB-INF/views/base/header.jsp"%>

<div class="page-content bg-white">
    <section class="content-inner-1">
        <div class="container">
            <div class="success-box">
                <div class="success-head">
                    <div class="success-icon"><i class="fa fa-check"></i></div>
                    <h2>Đặt hàng thành công</h2>
                    <p>Cảm ơn bạn đã mua sách tại Góc Sách.</p>
                </div>

                <div class="success-grid">
                    <div class="success-panel">
                        <h4>Thông tin đơn hàng</h4>
                        <div class="info-list">
                            <div><span>Mã đơn hàng</span><strong>${placedOrder.orderCode}</strong></div>
                            <div><span>Khách hàng</span><strong>${placedOrder.customerName}</strong></div>
                            <div><span>Số điện thoại</span><strong>${placedOrder.phone}</strong></div>
                            <div><span>Email</span><strong><c:out value="${empty placedOrder.email ? '—' : placedOrder.email}"/></strong></div>
                            <div><span>Địa chỉ nhận hàng</span><strong><c:out value="${placedOrder.fullAddress}"/></strong></div>
                            <div><span>Phương thức thanh toán</span><strong>${placedOrder.paymentMethod}</strong></div>
                            <c:if test="${not empty placedOrder.note}">
                                <div><span>Ghi chú</span><strong><c:out value="${placedOrder.note}"/></strong></div>
                            </c:if>
                            <c:if test="${not empty placedOrder.couponCode}">
                                <div><span>Coupon áp dụng</span><strong>${placedOrder.couponCode}</strong></div>
                            </c:if>
                        </div>
                    </div>

                    <div class="success-panel">
                        <h4>Tóm tắt thanh toán</h4>
                        <div class="summary-list">
                            <div><span>Tạm tính</span><strong><fmt:formatNumber value="${placedOrder.subtotal}" pattern="#,#00"/> đ</strong></div>
                            <div><span>Phí vận chuyển</span><strong><fmt:formatNumber value="${placedOrder.shippingFee}" pattern="#,#00"/> đ</strong></div>
                            <div><span>Giảm giá</span><strong>- <fmt:formatNumber value="${placedOrder.discountAmount}" pattern="#,#00"/> đ</strong></div>
                            <div class="grand"><span>Tổng thanh toán</span><strong><fmt:formatNumber value="${placedOrder.totalAmount}" pattern="#,#00"/> đ</strong></div>
                        </div>
                    </div>
                </div>

                <div class="success-order-list">
                    <h4>Sản phẩm đã đặt</h4>
                    <c:forEach var="item" items="${placedOrderItems}">
                        <div class="success-order-item">
                            <img src="${not empty item.image ? item.image : ctx.concat('/assets/images/books/default-book.png')}" alt="${item.bookTitle}">

                            <div class="item-info">
                                <div class="item-name">${item.bookTitle}</div>
                                <div class="item-meta">Số lượng: ${item.quantity}</div>
                                <div class="item-meta">Đơn giá: <fmt:formatNumber value="${item.unitPrice}" pattern="#,#00"/> đ</div>
                            </div>

                            <div class="item-total">
                                <fmt:formatNumber value="${item.lineTotal}" pattern="#,#00"/> đ
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div class="success-actions">
                    <a href="${ctx}/books" class="btn btn-primary btnhover">Tiếp tục mua sắm</a>
                    <a href="${ctx}/cart" class="btn btn-outline-secondary ms-2">Về giỏ hàng</a>
                </div>
            </div>
        </div>
    </section>
</div>

<style>
    .success-box {
        max-width: 980px;
        margin: 40px auto;
        background: #fff;
        border: 1px solid #ececec;
        border-radius: 16px;
        padding: 32px;
        box-shadow: 0 10px 30px rgba(0,0,0,.04);
    }
    .success-head {
        text-align: center;
        margin-bottom: 28px;
    }
    .success-icon {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 28px;
        color: #fff;
        background: #28a745;
        margin-bottom: 12px;
    }
    .success-head h2 {
        color: #241c7a;
        margin-bottom: 8px;
    }
    .success-grid {
        display: grid;
        grid-template-columns: 1.3fr 1fr;
        gap: 20px;
        margin-bottom: 24px;
    }
    .success-panel {
        border: 1px solid #ececec;
        border-radius: 12px;
        padding: 20px;
        background: #fff;
    }
    .success-panel h4 {
        margin-bottom: 16px;
        color: #241c7a;
    }
    .info-list div,
    .summary-list div {
        display: flex;
        justify-content: space-between;
        gap: 16px;
        padding: 10px 0;
        border-bottom: 1px solid #f2f2f2;
    }
    .info-list div span,
    .summary-list div span {
        color: #666;
        min-width: 140px;
    }
    .info-list div strong,
    .summary-list div strong {
        text-align: right;
        flex: 1;
        word-break: break-word;
    }
    .summary-list .grand {
        border-bottom: 0;
        padding-top: 14px;
        margin-top: 6px;
        font-size: 18px;
    }
    .summary-list .grand strong,
    .summary-list .grand span {
        color: #241c7a;
    }
    .success-order-list {
        text-align: left;
        border-top: 1px solid #ececec;
        padding-top: 22px;
    }
    .success-order-list h4 {
        margin-bottom: 16px;
        color: #241c7a;
    }
    .success-order-item {
        display: flex;
        align-items: center;
        gap: 16px;
        padding: 14px 0;
        border-bottom: 1px solid #f3f3f3;
    }
    .success-order-item img {
        width: 72px;
        height: 100px;
        object-fit: cover;
        border-radius: 8px;
        border: 1px solid #eee;
        background: #fafafa;
        flex-shrink: 0;
    }
    .item-info {
        flex: 1;
        min-width: 0;
    }
    .item-name {
        font-weight: 700;
        margin-bottom: 6px;
    }
    .item-meta {
        color: #666;
        font-size: 14px;
    }
    .item-total {
        font-weight: 700;
        white-space: nowrap;
    }
    .success-actions {
        margin-top: 28px;
        text-align: center;
    }
    @media (max-width: 991px) {
        .success-box {
            padding: 22px;
        }
        .success-grid {
            grid-template-columns: 1fr;
        }
        .info-list div,
        .summary-list div {
            flex-direction: column;
            gap: 6px;
        }
        .info-list div strong,
        .summary-list div strong {
            text-align: left;
        }
        .success-order-item {
            align-items: flex-start;
        }
        .item-total {
            margin-left: auto;
        }
    }
</style>

<%@ include file="/WEB-INF/views/base/footer.jsp"%>