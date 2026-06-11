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

        <%-- Flash messages --%>
        <c:if test="${param.cancelled == 'true'}">
            <div style="margin-bottom:20px;padding:14px 18px;background:#d1fae5;border:1px solid #6ee7b7;
                        border-radius:8px;color:#065f46;font-weight:600;">
                ✅ Đơn hàng đã được huỷ thành công. Tồn kho sản phẩm đã được hoàn lại.
            </div>
        </c:if>
        <c:if test="${param.error == 'cannot_cancel'}">
            <div style="margin-bottom:20px;padding:14px 18px;background:#fee2e2;border:1px solid #fca5a5;
                        border-radius:8px;color:#991b1b;font-weight:600;">
                ❌ Không thể huỷ đơn hàng này. Chỉ huỷ được đơn đang ở trạng thái <strong>Chờ xử lý</strong> hoặc <strong>Thanh toán thất bại</strong>.
            </div>
        </c:if>
        <c:if test="${param.error == 'cancel_failed'}">
            <div style="margin-bottom:20px;padding:14px 18px;background:#fee2e2;border:1px solid #fca5a5;
                        border-radius:8px;color:#991b1b;font-weight:600;">
                ❌ Huỷ đơn thất bại. Vui lòng thử lại hoặc liên hệ hỗ trợ.
            </div>
        </c:if>

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
                                background:${orderDetail.status == 'PENDING' ? '#fff3cd' : orderDetail.status == 'CONFIRMED' ? '#d1fae5' : orderDetail.status == 'COMPLETED' ? '#d1fae5' : orderDetail.status == 'PAYMENT_FAILED' ? '#fee2e2' : orderDetail.status == 'CANCELLED' ? '#fee2e2' : '#dbeafe'};
                                color:${orderDetail.status == 'PENDING' ? '#92400e' : orderDetail.status == 'CONFIRMED' ? '#065f46' : orderDetail.status == 'COMPLETED' ? '#065f46' : orderDetail.status == 'PAYMENT_FAILED' ? '#991b1b' : orderDetail.status == 'CANCELLED' ? '#991b1b' : '#1e40af'};">
                                ${orderDetail.status == 'PAYMENT_FAILED' ? 'Thanh toán thất bại' :
                                  orderDetail.status == 'PENDING'        ? 'Chờ xử lý' :
                                  orderDetail.status == 'CONFIRMED'      ? 'Đã xác nhận' :
                                  orderDetail.status == 'COMPLETED'      ? 'Hoàn thành' :
                                  orderDetail.status == 'CANCELLED'      ? 'Đã huỷ' : orderDetail.status}
                            </span>
                        </p>

                        <%-- Nút thanh toán — hiện cho PENDING và PAYMENT_FAILED với VNPAY/MOMO --%>
                        <c:if test="${(orderDetail.status == 'PAYMENT_FAILED' or orderDetail.status == 'PENDING') and
                                     (orderDetail.paymentMethod == 'VNPAY' or orderDetail.paymentMethod == 'MOMO')}">
                            <div style="margin-top:16px;padding-top:14px;border-top:1px solid #eee;">
                                <c:choose>
                                    <c:when test="${orderDetail.status == 'PAYMENT_FAILED'}">
                                        <p style="color:#991b1b;font-size:.85em;margin-bottom:10px;">
                                            ⚠️ Thanh toán thất bại. Bạn có thể thử lại.
                                        </p>
                                    </c:when>
                                    <c:otherwise>
                                        <p style="color:#92400e;font-size:.85em;margin-bottom:10px;">
                                            ⏳ Đơn hàng chưa được thanh toán.
                                        </p>
                                    </c:otherwise>
                                </c:choose>
                                <form action="${ctx}/retry-payment" method="post">
                                    <input type="hidden" name="orderId" value="${orderDetail.orderId}"/>
                                    <button type="submit"
                                        style="width:100%;padding:10px 0;background:#1e3a5f;color:#fff;
                                               border:none;border-radius:6px;font-size:.95em;font-weight:600;
                                               cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;">
                                        <c:choose>
                                            <c:when test="${orderDetail.paymentMethod == 'VNPAY'}">
                                                💳 ${orderDetail.status == 'PAYMENT_FAILED' ? 'Thanh toán lại qua VNPay' : 'Tiếp tục thanh toán qua VNPay'}
                                            </c:when>
                                            <c:otherwise>
                                                📱 ${orderDetail.status == 'PAYMENT_FAILED' ? 'Thanh toán lại qua MoMo' : 'Tiếp tục thanh toán qua MoMo'}
                                            </c:otherwise>
                                        </c:choose>
                                    </button>
                                </form>
                            </div>
                        </c:if>

                        <%-- Nút huỷ đơn — hiện cho PENDING và PAYMENT_FAILED --%>
                        <c:if test="${orderDetail.status == 'PENDING' or orderDetail.status == 'PAYMENT_FAILED'}">
                            <div style="margin-top:12px;padding-top:12px;border-top:1px solid #eee;">
                                <form action="${ctx}/cancel-order" method="post"
                                      onsubmit="return confirm('Bạn chắc chắn muốn huỷ đơn hàng này?\nHành động không thể hoàn tác.');">
                                    <input type="hidden" name="orderId" value="${orderDetail.orderId}"/>
                                    <button type="submit"
                                        style="width:100%;padding:9px 0;background:#fff;color:#dc2626;
                                               border:1.5px solid #dc2626;border-radius:6px;font-size:.9em;
                                               font-weight:600;cursor:pointer;">
                                        🗑 Huỷ đơn hàng
                                    </button>
                                </form>
                                <c:if test="${orderDetail.paymentMethod == 'VNPAY' or orderDetail.paymentMethod == 'MOMO'}">
                                    <p style="margin-top:6px;font-size:.78em;color:#6b7280;text-align:center;">
                                        Nếu đã thanh toán, vui lòng liên hệ hỗ trợ để được hoàn tiền.
                                    </p>
                                </c:if>
                            </div>
                        </c:if>
                    </div>
                </div>

                <%-- ===== TIMELINE TRACKING ===== --%>
                <div style="margin-bottom:28px;">
                    <h4 style="margin-bottom:16px;color:#1e3a5f;">Quá trình xử lý đơn hàng</h4>
                    <style>
                        .tl-wrap{display:flex;align-items:flex-start;gap:0;}
                        .tl-step{flex:1;display:flex;flex-direction:column;align-items:center;position:relative;}
                        .tl-step:not(:last-child)::after{content:'';position:absolute;top:18px;left:50%;width:100%;height:2px;background:#e5e7eb;z-index:0;}
                        .tl-step.done:not(:last-child)::after{background:#1e3a5f;}
                        .tl-dot{width:36px;height:36px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:.85em;font-weight:700;z-index:1;border:2px solid #e5e7eb;background:#fff;color:#9ca3af;}
                        .tl-step.done .tl-dot{background:#1e3a5f;border-color:#1e3a5f;color:#fff;}
                        .tl-step.active .tl-dot{background:#fff;border-color:#1e3a5f;color:#1e3a5f;}
                        .tl-step.cancelled .tl-dot{background:#fee2e2;border-color:#dc2626;color:#dc2626;}
                        .tl-label{margin-top:8px;font-size:.78em;font-weight:600;color:#6b7280;text-align:center;}
                        .tl-step.done .tl-label,.tl-step.active .tl-label{color:#1e3a5f;}
                        .tl-step.cancelled .tl-label{color:#dc2626;}
                        .tl-time{margin-top:2px;font-size:.72em;color:#9ca3af;text-align:center;line-height:1.3;}
                    </style>

                    <c:set var="st" value="${orderDetail.status}"/>
                    <div class="tl-wrap">

                        <%-- Bước 1: Đặt hàng (luôn done) --%>
                        <div class="tl-step done">
                            <div class="tl-dot">✓</div>
                            <div class="tl-label">Đặt hàng</div>
                            <div class="tl-time"><fmt:formatDate value="${orderDetail.createdAt}" pattern="HH:mm"/><br/><fmt:formatDate value="${orderDetail.createdAt}" pattern="dd/MM"/></div>
                        </div>

                        <%-- Bước 2: Xác nhận --%>
                        <c:choose>
                            <c:when test="${not empty orderDetail.confirmedAt}">
                                <div class="tl-step done">
                                    <div class="tl-dot">✓</div>
                                    <div class="tl-label">Đã xác nhận</div>
                                    <div class="tl-time"><fmt:formatDate value="${orderDetail.confirmedAt}" pattern="HH:mm"/><br/><fmt:formatDate value="${orderDetail.confirmedAt}" pattern="dd/MM"/></div>
                                </div>
                            </c:when>
                            <c:when test="${st == 'CANCELLED'}">
                                <div class="tl-step"><div class="tl-dot">–</div><div class="tl-label">Xác nhận</div><div class="tl-time"></div></div>
                            </c:when>
                            <c:when test="${st == 'CONFIRMED' or st == 'PROCESSING'}">
                                <div class="tl-step active"><div class="tl-dot">●</div><div class="tl-label">Đang xác nhận</div><div class="tl-time"></div></div>
                            </c:when>
                            <c:otherwise>
                                <div class="tl-step"><div class="tl-dot">2</div><div class="tl-label">Xác nhận</div><div class="tl-time"></div></div>
                            </c:otherwise>
                        </c:choose>

                        <%-- Bước 3: Đang giao --%>
                        <c:choose>
                            <c:when test="${not empty orderDetail.shippedAt}">
                                <div class="tl-step done">
                                    <div class="tl-dot">✓</div>
                                    <div class="tl-label">Đang giao</div>
                                    <div class="tl-time"><fmt:formatDate value="${orderDetail.shippedAt}" pattern="HH:mm"/><br/><fmt:formatDate value="${orderDetail.shippedAt}" pattern="dd/MM"/></div>
                                </div>
                            </c:when>
                            <c:when test="${st == 'SHIPPING'}">
                                <div class="tl-step active"><div class="tl-dot">●</div><div class="tl-label">Đang giao</div><div class="tl-time"></div></div>
                            </c:when>
                            <c:otherwise>
                                <div class="tl-step"><div class="tl-dot">3</div><div class="tl-label">Đang giao</div><div class="tl-time"></div></div>
                            </c:otherwise>
                        </c:choose>

                        <%-- Bước 4: Hoàn thành / Đã huỷ --%>
                        <c:choose>
                            <c:when test="${st == 'COMPLETED' and not empty orderDetail.deliveredAt}">
                                <div class="tl-step done">
                                    <div class="tl-dot">✓</div>
                                    <div class="tl-label">Hoàn thành</div>
                                    <div class="tl-time"><fmt:formatDate value="${orderDetail.deliveredAt}" pattern="HH:mm"/><br/><fmt:formatDate value="${orderDetail.deliveredAt}" pattern="dd/MM"/></div>
                                </div>
                            </c:when>
                            <c:when test="${st == 'COMPLETED'}">
                                <div class="tl-step done"><div class="tl-dot">✓</div><div class="tl-label">Hoàn thành</div><div class="tl-time"></div></div>
                            </c:when>
                            <c:when test="${st == 'CANCELLED'}">
                                <div class="tl-step cancelled">
                                    <div class="tl-dot">✕</div>
                                    <div class="tl-label">Đã huỷ</div>
                                    <c:if test="${not empty orderDetail.cancelledAt}">
                                        <div class="tl-time"><fmt:formatDate value="${orderDetail.cancelledAt}" pattern="HH:mm"/><br/><fmt:formatDate value="${orderDetail.cancelledAt}" pattern="dd/MM"/></div>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="tl-step"><div class="tl-dot">4</div><div class="tl-label">Hoàn thành</div><div class="tl-time"></div></div>
                            </c:otherwise>
                        </c:choose>

                    </div>
                </div>

                <%-- ===== ITEMS TABLE ===== --%>
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
                <%-- ===== LỊCH SỬ THAY ĐỔI TRẠNG THÁI ===== --%>
                <c:if test="${not empty statusLogs}">
                    <div style="margin-top:28px;">
                        <h4 style="margin-bottom:12px;color:#1e3a5f;">Lịch sử cập nhật trạng thái</h4>
                        <table style="width:100%;border-collapse:collapse;font-size:.88em;">
                            <thead>
                                <tr style="background:#f3f4f6;">
                                    <th style="padding:8px 12px;text-align:left;color:#6b7280;font-weight:600;">Thời gian</th>
                                    <th style="padding:8px 12px;text-align:left;color:#6b7280;font-weight:600;">Từ</th>
                                    <th style="padding:8px 12px;text-align:left;color:#6b7280;font-weight:600;">Sang</th>
                                    <th style="padding:8px 12px;text-align:left;color:#6b7280;font-weight:600;">Thực hiện bởi</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="log" items="${statusLogs}">
                                    <tr style="border-bottom:1px solid #f3f4f6;">
                                        <td style="padding:8px 12px;color:#6b7280;">
                                            <fmt:formatDate value="${log.changedAt}" pattern="HH:mm dd/MM/yyyy"/>
                                        </td>
                                        <td style="padding:8px 12px;">
                                            <c:choose>
                                                <c:when test="${empty log.oldStatus}">—</c:when>
                                                <c:otherwise>
                                                    <span style="padding:2px 8px;border-radius:10px;font-size:.8em;font-weight:600;
                                                        background:${log.oldStatus=='PENDING'?'#fff3cd':log.oldStatus=='CONFIRMED'?'#dbeafe':log.oldStatus=='COMPLETED'?'#d1fae5':log.oldStatus=='CANCELLED'?'#fee2e2':'#f3f4f6'};
                                                        color:${log.oldStatus=='PENDING'?'#92400e':log.oldStatus=='CONFIRMED'?'#1e40af':log.oldStatus=='COMPLETED'?'#065f46':log.oldStatus=='CANCELLED'?'#991b1b':'#374151'};">
                                                        ${log.oldStatus}
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="padding:8px 12px;">
                                            <span style="padding:2px 8px;border-radius:10px;font-size:.8em;font-weight:600;
                                                background:${log.newStatus=='PENDING'?'#fff3cd':log.newStatus=='CONFIRMED'?'#dbeafe':log.newStatus=='COMPLETED'?'#d1fae5':log.newStatus=='CANCELLED'?'#fee2e2':log.newStatus=='PAYMENT_FAILED'?'#fee2e2':'#f3f4f6'};
                                                color:${log.newStatus=='PENDING'?'#92400e':log.newStatus=='CONFIRMED'?'#1e40af':log.newStatus=='COMPLETED'?'#065f46':log.newStatus=='CANCELLED'?'#991b1b':log.newStatus=='PAYMENT_FAILED'?'#991b1b':'#374151'};">
                                                ${log.newStatus}
                                            </span>
                                        </td>
                                        <td style="padding:8px 12px;color:#6b7280;">${log.changedBy}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:if>

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
                                                background:${order.status == 'PENDING' ? '#fff3cd' : order.status == 'CONFIRMED' ? '#d1fae5' : order.status == 'COMPLETED' ? '#d1fae5' : order.status == 'PAYMENT_FAILED' ? '#fee2e2' : order.status == 'CANCELLED' ? '#fee2e2' : '#dbeafe'};
                                                color:${order.status == 'PENDING' ? '#92400e' : order.status == 'CONFIRMED' ? '#065f46' : order.status == 'COMPLETED' ? '#065f46' : order.status == 'PAYMENT_FAILED' ? '#991b1b' : order.status == 'CANCELLED' ? '#991b1b' : '#1e40af'};">
                                                ${order.status == 'PAYMENT_FAILED' ? 'TT thất bại' :
                                                  order.status == 'PENDING'        ? 'Chờ xử lý' :
                                                  order.status == 'CONFIRMED'      ? 'Đã xác nhận' :
                                                  order.status == 'COMPLETED'      ? 'Hoàn thành' :
                                                  order.status == 'CANCELLED'      ? 'Đã huỷ' : order.status}
                                            </span>
                                        </td>
                                        <td style="padding:12px 14px;text-align:center;white-space:nowrap;">
                                            <a href="${ctx}/my-orders?orderId=${order.orderId}"
                                               style="color:#1e3a5f;font-size:.9em;text-decoration:underline;">Xem</a>
                                            <%-- Nút thanh toán lại nhanh ngay trong danh sách --%>
                                            <c:if test="${(order.status == 'PAYMENT_FAILED' or order.status == 'PENDING') and
                                                         (order.paymentMethod == 'VNPAY' or order.paymentMethod == 'MOMO')}">
                                                <form action="${ctx}/retry-payment" method="post" style="display:inline;">
                                                    <input type="hidden" name="orderId" value="${order.orderId}"/>
                                                    <button type="submit"
                                                        style="margin-left:8px;padding:4px 10px;color:#fff;
                                                               border:none;border-radius:4px;font-size:.82em;cursor:pointer;font-weight:600;
                                                               background:${order.status == 'PAYMENT_FAILED' ? '#dc2626' : '#d97706'};">
                                                        ${order.status == 'PAYMENT_FAILED' ? 'Thanh toán lại' : 'Tiếp tục TT'}
                                                    </button>
                                                </form>
                                            </c:if>
                                            <%-- Nút huỷ đơn nhanh trong danh sách --%>
                                            <c:if test="${order.status == 'PENDING' or order.status == 'PAYMENT_FAILED'}">
                                                <form action="${ctx}/cancel-order" method="post" style="display:inline;"
                                                      onsubmit="return confirm('Huỷ đơn hàng ${order.orderCode}?');">
                                                    <input type="hidden" name="orderId" value="${order.orderId}"/>
                                                    <button type="submit"
                                                        style="margin-left:6px;padding:4px 10px;color:#dc2626;
                                                               border:1px solid #dc2626;border-radius:4px;background:#fff;
                                                               font-size:.82em;cursor:pointer;font-weight:600;">
                                                        Huỷ
                                                    </button>
                                                </form>
                                            </c:if>
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
