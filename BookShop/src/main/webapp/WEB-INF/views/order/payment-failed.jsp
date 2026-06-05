<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%@ include file="/WEB-INF/views/base/header.jsp" %>

<div class="page-content bg-white">
    <section class="content-inner-1">
        <div class="container">
            <div class="fail-box">

                <div class="fail-head">
                    <div class="fail-icon"><i class="fa fa-times"></i></div>
                    <h2>Thanh toán thất bại</h2>
                    <p>${not empty errorMessage ? errorMessage : 'Đã xảy ra lỗi trong quá trình thanh toán.'}</p>
                </div>

                <c:if test="${not empty orderCode}">
                    <div class="fail-info">
                        <div><span>Mã đơn hàng</span><strong>${orderCode}</strong></div>
                        <c:if test="${not empty paymentMethod}">
                            <div><span>Phương thức</span><strong>${paymentMethod}</strong></div>
                        </c:if>
                        <div><span>Trạng thái đơn</span><strong style="color:#dc3545">Thanh toán thất bại</strong></div>
                    </div>
                </c:if>

                <div class="fail-note">
                    <i class="fa fa-info-circle"></i>
                    Đơn hàng của bạn đã được ghi nhận trong hệ thống nhưng chưa được thanh toán.
                    Bạn có thể liên hệ hỗ trợ để được hướng dẫn hoặc đặt lại đơn mới.
                </div>

                <div class="fail-actions">
                    <a href="${ctx}/books" class="btn btn-primary btnhover">Tiếp tục mua sắm</a>
                    <a href="${ctx}/my-orders" class="btn btn-outline-secondary ms-2">Xem đơn hàng của tôi</a>
                </div>

            </div>
        </div>
    </section>
</div>

<style>
    .fail-box {
        max-width: 600px;
        margin: 50px auto;
        background: #fff;
        border: 1px solid #ececec;
        border-radius: 16px;
        padding: 40px 32px;
        box-shadow: 0 10px 30px rgba(0,0,0,.04);
        text-align: center;
    }
    .fail-head { margin-bottom: 28px; }
    .fail-icon {
        width: 70px;
        height: 70px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        font-size: 28px;
        color: #fff;
        background: #dc3545;
        margin-bottom: 14px;
    }
    .fail-head h2 { color: #dc3545; margin-bottom: 8px; }
    .fail-head p  { color: #555; }
    .fail-info {
        border: 1px solid #eee;
        border-radius: 10px;
        padding: 16px 20px;
        text-align: left;
        margin-bottom: 20px;
    }
    .fail-info div {
        display: flex;
        justify-content: space-between;
        padding: 8px 0;
        border-bottom: 1px solid #f5f5f5;
    }
    .fail-info div:last-child { border-bottom: none; }
    .fail-info span { color: #666; }
    .fail-note {
        background: #fff8e1;
        border: 1px solid #ffe082;
        border-radius: 8px;
        padding: 12px 16px;
        font-size: 14px;
        color: #555;
        margin-bottom: 24px;
        text-align: left;
    }
    .fail-note i { color: #f59e0b; margin-right: 6px; }
    .fail-actions { display: flex; justify-content: center; flex-wrap: wrap; gap: 10px; }
</style>

<%@ include file="/WEB-INF/views/base/footer.jsp" %>
