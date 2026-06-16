<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
/* Tabs điều hướng */
.review-tabs { display:flex; border-bottom:2px solid #eee; margin-bottom:30px; background:#fff; padding:0 10px; border-radius:8px 8px 0 0; }
.tab-item { padding:15px 20px; font-weight:500; cursor:pointer; color:#666; border-bottom:3px solid transparent; transition:all .3s; }
.tab-item.active { color:#e9a44a; border-bottom-color:#e9a44a; font-weight:700; }
.tab-content { display:none; }
.tab-content.active { display:block; }

/* Card sách chưa đánh giá */
.unreviewed-card { display:flex; background:#fff; border:1px solid #eee; border-radius:8px; padding:16px; margin-bottom:16px; box-shadow:0 2px 4px rgba(0,0,0,.02); align-items:center; justify-content:space-between; }
.unreviewed-left { display:flex; align-items:center; gap:20px; }
.unreviewed-img { width:80px; height:115px; object-fit:cover; border-radius:4px; border:1px solid #ddd; flex-shrink:0; }
.unreviewed-info h4 { margin:0 0 6px 0; font-size:16px; color:#1e3a5f; font-weight:600; }
.unreviewed-deadline { font-size:13px; color:#dc3545; font-weight:500; margin-bottom:4px; }
.btn-primary-custom { background-color:#1e3a5f; color:#fff; border:none; padding:10px 20px; font-size:14px; font-weight:500; border-radius:4px; cursor:pointer; transition:all .2s; white-space:nowrap; }
.btn-primary-custom:hover { background-color:#11253f; }

/* Danh sách đã đánh giá */
.comment-list { padding:0; list-style:none; background:#fff; border-radius:8px; border:1px solid #eee; }
.comment-list li { padding:24px; border-bottom:1px solid #eee; }
.comment-list li:last-child { border-bottom:none; }
.comment-body { position:relative; }
.comment-author { margin-bottom:10px; position:relative; padding-left:65px; }
.comment-author .avatar { width:50px; height:50px; border-radius:50%; position:absolute; left:0; top:0; object-fit:cover; }
.comment-author .fn { font-style:normal; font-weight:600; color:#1e3a5f; font-size:15px; display:inline-block; }
.dz-rating { list-style:none; padding:0; margin:4px 0 0 0; display:flex; gap:3px; }
.text-yellow { color:#ffc107; }
.text-muted { color:#ced4da; }
.comment-body p { margin:12px 0 12px 65px; font-size:14.5px; line-height:1.6; color:#444; }
.review-attach-images { display:flex; gap:10px; margin:12px 0 16px 65px; flex-wrap:wrap; }
.review-attach-images img { width:100px; height:100px; object-fit:cover; border-radius:4px; border:1px solid #ddd; }
.reviewed-product-footer { display:flex; align-items:center; gap:12px; padding:10px 14px; background:#f8f9fa; border-radius:6px; border:1px solid #f1f1f1; }
.reviewed-product-footer img { width:40px; height:55px; object-fit:cover; border-radius:3px; border:1px solid #ddd; }
.reviewed-product-footer span { font-size:13.5px; font-weight:500; color:#555; }

/* Modal đánh giá */
.modal-overlay { position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,.5); display:flex; align-items:center; justify-content:center; z-index:9999; visibility:hidden; opacity:0; transition:all .3s ease; }
.modal-overlay.open { visibility:visible; opacity:1; }
.modal-box { background:#fff; width:100%; max-width:600px; border-radius:8px; box-shadow:0 5px 20px rgba(0,0,0,.15); overflow:hidden; animation:slideDown .3s ease; }
@keyframes slideDown { from { transform:translateY(-30px); opacity:0; } to { transform:translateY(0); opacity:1; } }
.modal-header { background:#1e3a5f; padding:16px 20px; color:#fff; display:flex; justify-content:space-between; align-items:center; }
.modal-header h4 { margin:0; font-size:16px; font-weight:600; }
.modal-close { font-size:24px; cursor:pointer; color:#fff; opacity:.8; }
.modal-close:hover { opacity:1; }
.comment-respond { padding:24px; }
.comment-form-rating { margin-bottom:15px; display:flex; align-items:center; gap:10px; }
.mb-3 { margin-bottom:16px; }
.mt-2 { margin-top:12px; }

/* Toast */
.toast-noti { position:fixed; top:24px; right:24px; z-index:99999; background:#1e3a5f; color:#fff; padding:14px 22px; border-radius:8px; font-size:15px; font-weight:500; box-shadow:0 4px 16px rgba(0,0,0,.18); display:flex; align-items:center; gap:10px; opacity:0; transform:translateY(-16px); transition:opacity .3s, transform .3s; pointer-events:none; }
.toast-noti.show { opacity:1; transform:translateY(0); }
.toast-noti.success { border-left:4px solid #22c55e; }
.toast-noti.error { border-left:4px solid #ef4444; }
</style>

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
                <%-- Danh sách đơn hàng — 3 tab --%>
                <c:set var="totalUnreviewed" value="0"/>
                <c:forEach var="og" items="${unreviewedBooks}">
                    <c:set var="totalUnreviewed" value="${totalUnreviewed + og.books.size()}"/>
                </c:forEach>

                <div class="review-tabs">
                    <div class="tab-item active" onclick="switchTab('order-history-tab', this)">Lịch sử đơn hàng</div>
                    <div class="tab-item" onclick="switchTab('unreviewed-tab', this)">Chưa đánh giá (${totalUnreviewed})</div>
                    <div class="tab-item" onclick="switchTab('reviewed-tab', this)">Đã đánh giá (${reviewedBooks.size()})</div>
                </div>

                <%-- Tab 1: Lịch sử đơn hàng --%>
                <div id="order-history-tab" class="tab-content active">
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
                                                <%-- Nút thanh toán lại nhanh --%>
                                                <c:if test="${(order.status == 'PAYMENT_FAILED' or order.status == 'PENDING') and
                                                             (order.paymentMethod == 'VNPAY' or order.paymentMethod == 'MOMO')}">
                                                    <form action="${ctx}/retry-payment" method="post" style="display:inline;">
                                                        <input type="hidden" name="orderId" value="${order.orderId}"/>
                                                        <button type="submit"
                                                            style="margin-left:8px;padding:4px 10px;color:#fff;border:none;border-radius:4px;
                                                                   font-size:.82em;cursor:pointer;font-weight:600;
                                                                   background:${order.status == 'PAYMENT_FAILED' ? '#dc2626' : '#d97706'};">
                                                            ${order.status == 'PAYMENT_FAILED' ? 'Thanh toán lại' : 'Tiếp tục TT'}
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <%-- Nút huỷ đơn nhanh --%>
                                                <c:if test="${order.status == 'PENDING' or order.status == 'PAYMENT_FAILED'}">
                                                    <form action="${ctx}/cancel-order" method="post" style="display:inline;"
                                                          onsubmit="return confirm('Huỷ đơn hàng ${order.orderCode}?');">
                                                        <input type="hidden" name="orderId" value="${order.orderId}"/>
                                                        <button type="submit"
                                                            style="margin-left:6px;padding:4px 10px;color:#dc2626;border:1px solid #dc2626;
                                                                   border-radius:4px;background:#fff;font-size:.82em;cursor:pointer;font-weight:600;">
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
                </div>

                <%-- Tab 2: Chưa đánh giá --%>
                <div id="unreviewed-tab" class="tab-content">
                    <c:choose>
                        <c:when test="${empty unreviewedBooks}">
                            <div style="text-align:center;padding:60px 0;color:#999;">
                                <i class="fa-solid fa-star" style="font-size:2.5rem;margin-bottom:12px;display:block;color:#e9a44a;"></i>
                                <p>Bạn không có sách nào cần đánh giá.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="og" items="${unreviewedBooks}">
                                <div class="order-group-wrapper" id="order-group-${og.orderId}"
                                     style="background:#fff;border:1px solid #eee;border-radius:8px;margin-bottom:24px;
                                            box-shadow:0 2px 4px rgba(0,0,0,.02);overflow:hidden;">
                                    <div style="background:#f8f9fa;padding:12px 20px;border-bottom:1px solid #eee;
                                                display:flex;justify-content:space-between;align-items:center;">
                                        <span style="font-weight:600;color:#1e3a5f;">Đơn hàng: #${og.orderCode}</span>
                                        <span style="font-size:13px;color:#666;">
                                            Còn <strong style="color:#dc3545;">${og.daysLeft} ngày</strong> để đánh giá
                                        </span>
                                    </div>
                                    <div style="padding:0 20px;">
                                        <c:forEach var="bk" items="${og.books}" varStatus="bkStatus">
                                            <div class="unreviewed-card" id="card-detail-${bk.detailId}"
                                                 style="box-shadow:none;border:none;
                                                        ${bkStatus.last ? '' : 'border-bottom:1px solid #f1f1f1;'}
                                                        border-radius:0;margin-bottom:0;padding:16px 0;">
                                                <div class="unreviewed-left">
                                                    <img src="${not empty bk.image ? bk.image : ctx.concat('/assets/images/books/default-book.png')}"
                                                         class="unreviewed-img" alt="${bk.bookTitle}">
                                                    <div class="unreviewed-info">
                                                        <h4>${bk.bookTitle}</h4>
                                                        <div class="unreviewed-deadline">Chỉ còn ${og.daysLeft} ngày để đánh giá</div>
                                                    </div>
                                                </div>
                                                <button class="btn-primary-custom"
                                                    onclick="openReviewModal('${bk.bookTitle}', 'card-detail-${bk.detailId}', ${bk.bookId}, 'order-group-${og.orderId}', ${bk.detailId})">
                                                    Đánh giá
                                                </button>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <%-- Tab 3: Đã đánh giá --%>
                <div id="reviewed-tab" class="tab-content">
                    <c:choose>
                        <c:when test="${empty reviewedBooks}">
                            <div style="text-align:center;padding:60px 0;color:#999;">
                                <p>Bạn chưa có đánh giá nào.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <ol class="comment-list">
                                <c:forEach var="rv" items="${reviewedBooks}">
                                    <li class="comment even thread-even depth-1">
                                        <div class="comment-body">
                                            <div class="comment-author vcard">
                                                <img src="${not empty sessionScope.loggedInUser.avatar
                                                           ? sessionScope.loggedInUser.avatar
                                                           : ctx.concat('/assets/images/users/default.png')}"
                                                     alt="Avatar" class="avatar">
                                                <cite class="fn">${sessionScope.loggedInUser.fullName}</cite>
                                                <span style="display:block;font-size:11px;color:#aaa;font-weight:400;margin-top:2px;">
                                                    <i class="fa-regular fa-clock" style="margin-right:3px;"></i>
                                                    <fmt:formatDate value="${rv.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </span>
                                                <div class="dz-rating" style="margin-top:5px;">
                                                    <c:forEach begin="1" end="5" var="s">
                                                        <i class="fa fa-star ${s <= rv.rating ? 'text-yellow' : 'text-muted'}"></i>
                                                    </c:forEach>
                                                </div>
                                            </div>
                                            <p>${rv.comment}</p>
                                            <c:if test="${not empty rv.reviewImages}">
                                                <div class="review-attach-images">
                                                    <c:forEach var="rImg" items="${rv.reviewImages}">
                                                        <a href="${rImg}" target="_blank"><img src="${rImg}" alt="Ảnh review"></a>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                            <div class="reviewed-product-footer">
                                                <img src="${not empty rv.image ? rv.image : ctx.concat('/assets/images/books/default-book.png')}"
                                                     alt="${rv.bookTitle}">
                                                <span>${rv.bookTitle}</span>
                                            </div>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ol>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- Modal viết đánh giá --%>
<div class="modal-overlay" id="reviewModal">
    <div class="modal-box">
        <div class="modal-header">
            <h4 style="color:#fff;" id="modalBookTitle">Viết đánh giá của bạn</h4>
            <span class="modal-close" onclick="closeReviewModal()">&times;</span>
        </div>
        <div class="comment-respond" id="respond">
            <form id="reviewForm" action="${ctx}/add-review" method="post" enctype="multipart/form-data" class="comment-form">
                <input type="hidden" name="bookId" id="modalBookId" value="">
                <input type="hidden" name="orderDetailId" id="modalOrderDetailId" value="">
                <div class="comment-form-rating">
                    <label style="font-weight:500;">Số sao: </label>
                    <select name="rating" id="reviewRating" class="form-control" style="width:160px;display:inline-block;">
                        <option value="5">⭐⭐⭐⭐⭐ (5 sao)</option>
                        <option value="4">⭐⭐⭐⭐ (4 sao)</option>
                        <option value="3">⭐⭐⭐ (3 sao)</option>
                        <option value="2">⭐⭐ (2 sao)</option>
                        <option value="1">⭐ (1 sao)</option>
                    </select>
                </div>
                <div class="form-group mb-3">
                    <label style="font-weight:500;display:block;margin-bottom:6px;">Hình ảnh thực tế (có thể chọn nhiều ảnh):</label>
                    <input type="file" name="reviewPhotos" id="reviewPhotos" class="form-control" multiple accept="image/*">
                </div>
                <div class="comment-form-comment mb-3">
                    <textarea name="comment" id="reviewComment"
                              placeholder="Bạn thấy cuốn sách này thế nào? Chia sẻ cảm nhận của bạn nhé..."
                              class="form-control" rows="4" required></textarea>
                </div>
                <div class="form-submit mt-2" style="text-align:right;">
                    <button type="submit" class="btn-primary-custom" style="background-color:#e9a44a;padding:12px 30px;">
                        Gửi Đánh Giá
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
let currentTargetCardId = null;
let currentGroupId = null;

function switchTab(tabId, clickedEl) {
    document.querySelectorAll('.tab-item').forEach(el => el.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
    clickedEl.classList.add('active');
    document.getElementById(tabId).classList.add('active');
}

function openReviewModal(bookTitle, cardId, bookId, groupId, detailId) {
    currentTargetCardId = cardId;
    currentGroupId = groupId;
    document.getElementById('modalBookTitle').innerText = "Đánh giá: " + bookTitle;
    document.getElementById('reviewForm').reset();
    document.getElementById('modalBookId').value = bookId;
    document.getElementById('modalOrderDetailId').value = detailId;
    document.getElementById('reviewModal').classList.add('open');
}

function closeReviewModal() {
    document.getElementById('reviewModal').classList.remove('open');
}

document.querySelector('#reviewForm .btn-primary-custom').addEventListener('click', function(e) {
    e.preventDefault();
    const form = document.getElementById('reviewForm');
    const formData = new FormData(form);
    fetch(form.action, { method: 'POST', body: formData })
    .then(() => {
        closeReviewModal();
        if (currentTargetCardId) {
            const card = document.getElementById(currentTargetCardId);
            if (card) card.remove();
        }
        if (currentGroupId) {
            const group = document.getElementById(currentGroupId);
            if (group && group.querySelectorAll('.unreviewed-card').length === 0) group.remove();
        }
        showToast('Cảm ơn bạn đã gửi đánh giá!', 'success');
        setTimeout(() => location.reload(), 1800);
    })
    .catch(() => showToast('❌ Có lỗi xảy ra, vui lòng thử lại.', 'error'));
});

function showToast(msg, type = 'success') {
    let toast = document.getElementById('global-toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'global-toast';
        toast.className = 'toast-noti';
        document.body.appendChild(toast);
    }
    toast.textContent = msg;
    toast.className = 'toast-noti ' + type;
    void toast.offsetWidth;
    toast.classList.add('show');
    clearTimeout(toast._timer);
    toast._timer = setTimeout(() => toast.classList.remove('show'), 2500);
}
</script>

<%@ include file="/WEB-INF/views/base/footer.jsp" %>
