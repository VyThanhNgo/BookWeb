<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%@ include file="/WEB-INF/views/base/header.jsp"%>

<div class="page-content bg-white checkout-page">

    <!-- BANNER -->
    <div class="dz-bnr-inr overlay-secondary-dark dz-bnr-inr-sm"
         style="background-image:url(${ctx}/assets/images/background/bg3.jpg);">
        <div class="container">
            <div class="dz-bnr-inr-entry">
                <h1>Thanh toán</h1>
            </div>
        </div>
    </div>

    <!-- CONTENT -->
    <div class="container checkout-container">

        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-4">${error}</div>
        </c:if>

        <form id="orderForm" action="${ctx}/order" method="post">

            <div class="checkout-grid">

                <!-- LEFT -->
                <div class="checkout-left">

                    <!-- SHIPPING -->
                    <div class="checkout-card">
                        <h3 class="checkout-title">Thông tin giao hàng</h3>

                        <div class="form-grid">
                            <input type="text" name="customerName" placeholder="Họ và tên *" required
                                   value="${not empty old_customerName ? old_customerName : ''}">
                            <input type="text" name="phone" placeholder="Số điện thoại *" required
                                   value="${not empty old_phone ? old_phone : ''}">

                            <input type="email" name="email" placeholder="Email"
                                   value="${not empty old_email ? old_email : ''}">
                            <select id="provinceSelect" name="province" required>
                                <option value="">Chọn Tỉnh/Thành phố</option>
                            </select>

                            <select id="districtSelect" name="district" required disabled>
                                <option value="">Chọn Quận/Huyện</option>
                            </select>

                            <select id="wardSelect" name="ward" required disabled>
                                <option value="">Chọn Phường/Xã</option>
                            </select>

                            <input type="hidden" id="toDistrictId" name="toDistrictId">
                            <input type="hidden" id="toWardCode" name="toWardCode">
                            <input type="hidden" id="selectedServiceId" name="selectedServiceId">

                            <!-- THÊM 3 INPUT NÀY -->
                            <input type="hidden" id="provinceNameInput" name="provinceName">
                            <input type="hidden" id="districtNameInput" name="districtName">
                            <input type="hidden" id="wardNameInput" name="wardName">

                            <!-- THÊM 2 INPUT NÀY -->
                            <input type="hidden" id="couponCodeInput" name="couponCode" value="${couponCode}">
                            <input type="hidden" id="discountAmountInput" name="discountAmount" value="${discount}">

                            <input type="hidden" id="shippingFeeInput" name="shippingFee" value="${shippingFee}">
                            <input type="hidden" id="subtotalValue" value="${subtotal}">
                            <input type="hidden" id="discountValue" value="${discount}">
                            <input type="hidden" id="bankConfirmedInput" name="bankConfirmed" value="0">

                            <input type="text" name="addressLine" placeholder="Địa chỉ cụ thể *" required class="full"
                                   value="${not empty old_addressLine ? old_addressLine : ''}">

                            <textarea name="note" placeholder="Ghi chú đơn hàng">${not empty old_note ? old_note : ''}</textarea>
                        </div>
                    </div>

                    <!-- PAYMENT -->
                    <div class="checkout-card">
                        <h3 class="checkout-title">Phương thức thanh toán</h3>

                        <div class="payment-list">

                            <label class="payment-option" id="lbl-COD">
                                <input type="radio" name="paymentMethod" value="COD" checked onchange="onPaymentChange(this)">
                                <span class="pm-icon">🚚</span>
                                <span class="pm-info">
                                    <strong>COD — Thanh toán khi nhận hàng</strong>
                                    <small>Trả tiền mặt khi giao hàng tận nơi</small>
                                </span>
                            </label>

                            <label class="payment-option" id="lbl-BANK_TRANSFER">
                                <input type="radio" name="paymentMethod" value="BANK_TRANSFER" onchange="onPaymentChange(this)">
                                <span class="pm-icon">🏦</span>
                                <span class="pm-info">
                                    <strong>Chuyển khoản ngân hàng</strong>
                                    <small>Quét QR — xác nhận sau khi đã chuyển tiền</small>
                                </span>
                            </label>

                            <label class="payment-option" id="lbl-MOMO">
                                <input type="radio" name="paymentMethod" value="MOMO" onchange="onPaymentChange(this)">
                                <span class="pm-icon pm-logo" style="display:flex;align-items:center;justify-content:center;width:40px;height:40px;">
                                    <span style="display:inline-flex;align-items:center;justify-content:center;
                                                 background:#a50064;color:#fff;font-weight:900;font-size:12px;
                                                 border-radius:8px;width:36px;height:36px;letter-spacing:.5px;
                                                 font-family:Arial,sans-serif;flex-shrink:0;">
                                        MoMo
                                    </span>
                                </span>
                                <span class="pm-info">
                                    <strong>Ví MoMo</strong>
                                    <small>Thanh toán qua ứng dụng MoMo — nhanh chóng &amp; an toàn</small>
                                </span>
                            </label>

                            <label class="payment-option" id="lbl-VNPAY">
                                <input type="radio" name="paymentMethod" value="VNPAY" onchange="onPaymentChange(this)">
                                <span class="pm-icon pm-logo">
                                    <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Icon-VNPAY-QR.png" alt="VNPay" style="height:28px;border-radius:6px;">
                                </span>
                                <span class="pm-info">
                                    <strong>VNPay</strong>
                                    <small>Thanh toán qua VNPay — hỗ trợ ATM / thẻ quốc tế / QR</small>
                                </span>
                            </label>

                            <label class="payment-option disabled-pm" id="lbl-ZALOPAY" title="Tính năng đang được phát triển">
                                <input type="radio" name="paymentMethod" value="ZALOPAY" disabled>
                                <span class="pm-icon pm-logo">
                                    <img src="https://cdn.haitrieu.com/wp-content/uploads/2022/10/Logo-ZaloPay-Square.png" alt="ZaloPay" style="height:28px;border-radius:6px;filter:grayscale(60%);">
                                </span>
                                <span class="pm-info">
                                    <strong style="color:#aaa">ZaloPay</strong>
                                    <small>Thanh toán qua ví ZaloPay</small>
                                </span>
                                <span class="pm-badge">Sắp có</span>
                            </label>

                        </div>

                        <!-- Bank info preview (hiện khi chọn BANK_TRANSFER) -->
                        <div id="bankInfo" class="bank-info-box" style="display:none">
                            <div class="bank-info-row"><span>🏦 Ngân hàng</span><strong>Vietcombank (VCB)</strong></div>
                            <div class="bank-info-row"><span>💳 Số tài khoản</span><strong>1234567890</strong></div>
                            <div class="bank-info-row"><span>👤 Chủ tài khoản</span><strong>CÔNG TY TNHH GÓC SÁCH</strong></div>
                            <div style="margin-top:12px;text-align:center">
                                <button type="button" class="btn-show-qr" onclick="showBankModal()">
                                    📱 Xem mã QR & xác nhận chuyển khoản
                                </button>
                            </div>
                            <p style="font-size:12px;color:#777;margin-top:8px;text-align:center">
                                Vui lòng chuyển khoản và xác nhận trước khi đặt hàng
                            </p>
                        </div>

                    </div>

                </div>

                <!-- RIGHT -->
                <div class="checkout-right">

                    <div class="checkout-card sticky">

                        <h3 class="checkout-title">Đơn hàng của bạn</h3>

                        <!-- LIST -->
                        <div class="order-list">
                            <c:forEach var="item" items="${orderItems}">
                                <div class="order-item">

                                    <img src="${not empty item.image ? item.image : ctx.concat('/assets/images/books/default-book.png')}">

                                    <div class="info">
                                        <div class="name">${item.bookTitle}</div>
                                        <div class="qty">SL: ${item.quantity}</div>
                                    </div>

                                    <div class="price">
                                        <fmt:formatNumber value="${item.lineTotal}" pattern="#,###"/> đ
                                    </div>

                                </div>
                            </c:forEach>
                        </div>

                        <!-- COUPON -->
                        <div class="coupon-box" style="margin-bottom:12px;">
                            <div style="display:flex;gap:8px;">
                                <input type="text" id="couponInput" placeholder="Nhập mã giảm giá"
                                    style="flex:1;border:1px solid #ddd;border-radius:8px;padding:8px 12px;font-size:14px;"
                                    value="${not empty old_couponCode ? old_couponCode : ''}">
                                <button type="button" onclick="applyCoupon()"
                                    style="background:#1a3352;color:#fff;border:none;border-radius:8px;padding:8px 16px;font-size:14px;cursor:pointer;white-space:nowrap;">
                                    Áp dụng
                                </button>
                            </div>
                            <p id="couponMsg" style="font-size:13px;margin-top:6px;"></p>
                        </div>

                        <!-- TOTAL -->
                        <div class="total-box">
                            <div>
                                <span>Tạm tính</span>
                                <b id="subtotalText"><fmt:formatNumber value="${subtotal}" pattern="#,###"/> đ</b>
                            </div>
                            <div>
                                <span>Phí vận chuyển</span>
                                <b id="shippingFeeText"><fmt:formatNumber value="${shippingFee}" pattern="#,###"/> đ</b>
                            </div>
                            <div>
                                <span>Giảm giá</span>
                                <b id="discountText"><fmt:formatNumber value="${discount}" pattern="#,###"/> đ</b>
                            </div>

                            <div class="grand">
                                <span>Tổng thanh toán</span>
                                <b id="grandTotalText"><fmt:formatNumber value="${total}" pattern="#,###"/> đ</b>
                            </div>
                        </div>
                        <button class="btn btn-primary w-100">Xác nhận đặt hàng</button>

                    </div>

                </div>

            </div>

        </form>

    </div>
</div>

<!-- Bank Transfer QR Modal -->
<div id="bankTransferModal" class="bt-overlay" style="display:none" onclick="handleOverlayClick(event)">
    <div class="bt-modal">
        <button class="bt-close" onclick="closeBankModal()" aria-label="Đóng">✕</button>
        <h3 class="bt-title">Thanh toán chuyển khoản</h3>

        <div class="bt-body">
            <!-- QR -->
            <div class="bt-qr-section">
                <img id="bankQRImg" src="" alt="QR thanh toán" class="bt-qr-img">
                <p class="bt-qr-caption">Quét mã bằng app ngân hàng hoặc MoMo / ZaloPay</p>
            </div>

            <!-- Bank info -->
            <div class="bt-info-section">
                <div class="bt-info-row">
                    <span>Ngân hàng</span>
                    <strong>Vietcombank (VCB)</strong>
                </div>
                <div class="bt-info-row">
                    <span>Số tài khoản</span>
                    <strong>1234567890</strong>
                </div>
                <div class="bt-info-row">
                    <span>Chủ tài khoản</span>
                    <strong>CÔNG TY TNHH GÓC SÁCH</strong>
                </div>
                <div class="bt-info-row amount-row">
                    <span>Số tiền</span>
                    <strong id="btAmount" class="bt-amount"></strong>
                </div>
                <div class="bt-info-row ref-row">
                    <span>Nội dung CK</span>
                    <strong id="btRef" class="bt-ref"></strong>
                </div>
            </div>
        </div>

        <div class="bt-steps">
            <p><strong>📋 Hướng dẫn thanh toán:</strong></p>
            <ol>
                <li>Quét mã QR hoặc chuyển khoản theo thông tin trên</li>
                <li>Ghi <strong>đúng nội dung chuyển khoản</strong> để hệ thống xác nhận tự động</li>
                <li>Nhấn <em>"Tôi đã chuyển khoản thành công"</em> để hoàn tất đặt hàng</li>
                <li>Đơn hàng sẽ được xử lý trong <strong>1–2 giờ làm việc</strong></li>
            </ol>
        </div>

        <div class="bt-actions">
            <button class="btn-confirm-bank" onclick="confirmBankTransfer()">
                ✅ Tôi đã chuyển khoản thành công
            </button>
            <button class="btn-back-bank" onclick="closeBankModal()">↩ Quay lại</button>
        </div>
    </div>
</div>

<!-- CSS -->
<style>

    /* PAGE */
    .checkout-page {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
    }

    /* GRID */
    .checkout-grid {
        display: grid;
        grid-template-columns: 1.6fr 1fr;
        gap: 24px;
        margin: 40px 0;
    }

    /* CARD */
    .checkout-card {
        background: #fff;
        border: 1px solid #eee;
        border-radius: 10px;
        padding: 20px;
    }

    /* TITLE */
    .checkout-title {
        font-size: 22px;
        margin-bottom: 16px;
    }

    /* FORM */
    .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 12px;
    }

    .form-grid input,
    .form-grid textarea {
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
    }

    .form-grid textarea {
        grid-column: 1 / -1;
        height: 100px;
    }

    .form-grid .full {
        grid-column: 1 / -1;
    }

    /* PAYMENT */
    .payment-list { display: flex; flex-direction: column; gap: 10px; }

    .payment-option {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 14px 16px;
        border: 2px solid #eee;
        border-radius: 10px;
        cursor: pointer;
        transition: border-color .2s, background .2s;
    }
    .payment-option:hover { border-color: #c5b8ff; background: #faf8ff; }
    .payment-option.selected { border-color: #241c7a; background: #f5f3ff; }
    .payment-option input[type=radio] { display: none; }

    .pm-icon { font-size: 24px; width: 36px; text-align: center; flex-shrink: 0; }
    .pm-logo { display: flex; align-items: center; }

    .pm-info { display: flex; flex-direction: column; gap: 2px; }
    .pm-info strong { font-size: 14px; color: #222; }
    .pm-info small  { font-size: 12px; color: #888; }

    /* Disabled payment option (ZaloPay) */
    .payment-option.disabled-pm {
        opacity: .55;
        cursor: not-allowed;
        pointer-events: none;
        position: relative;
    }
    .pm-badge {
        margin-left: auto;
        background: #f59e0b;
        color: #fff;
        font-size: 10px;
        font-weight: 700;
        padding: 2px 8px;
        border-radius: 20px;
        white-space: nowrap;
        flex-shrink: 0;
    }

    /* Bank info preview */
    .bank-info-box {
        margin-top: 12px;
        background: #f0f7ff;
        border: 1px solid #bee3f8;
        border-radius: 8px;
        padding: 14px 16px;
        font-size: 14px;
        color: #333;
    }
    .bank-info-row {
        display: flex;
        justify-content: space-between;
        padding: 5px 0;
        border-bottom: 1px solid #e3f0fb;
    }
    .bank-info-row:last-of-type { border-bottom: none; }
    .bank-info-row span { color: #666; }

    .btn-show-qr {
        background: #1565c0;
        color: #fff;
        border: none;
        padding: 10px 20px;
        border-radius: 8px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 600;
        transition: background .2s;
    }
    .btn-show-qr:hover { background: #0d47a1; }

    /* Bank Transfer Modal */
    .bt-overlay {
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,.6);
        z-index: 9999;
        align-items: center;
        justify-content: center;
        padding: 16px;
    }
    .bt-overlay.show {
        display: flex;
    }
    .bt-modal {
        background: #fff;
        border-radius: 16px;
        padding: 28px 28px 20px;
        max-width: 680px;
        width: 100%;
        max-height: 90vh;
        overflow-y: auto;
        position: relative;
        box-shadow: 0 20px 60px rgba(0,0,0,.3);
    }
    .bt-close {
        position: absolute;
        top: 12px; right: 16px;
        background: none;
        border: none;
        font-size: 20px;
        cursor: pointer;
        color: #666;
        line-height: 1;
        padding: 4px 8px;
    }
    .bt-close:hover { color: #000; }
    .bt-title {
        font-size: 20px;
        color: #241c7a;
        margin-bottom: 20px;
        text-align: center;
    }
    .bt-body {
        display: grid;
        grid-template-columns: auto 1fr;
        gap: 20px;
        margin-bottom: 16px;
    }
    .bt-qr-section { text-align: center; }
    .bt-qr-img {
        width: 180px;
        height: 180px;
        object-fit: contain;
        border: 1px solid #eee;
        border-radius: 8px;
        background: #fafafa;
    }
    .bt-qr-caption { font-size: 11px; color: #888; margin-top: 6px; }
    .bt-info-section { display: flex; flex-direction: column; gap: 4px; }
    .bt-info-row {
        display: flex;
        justify-content: space-between;
        gap: 12px;
        padding: 8px 0;
        border-bottom: 1px solid #f0f0f0;
        font-size: 14px;
    }
    .bt-info-row:last-child { border-bottom: none; }
    .bt-info-row span { color: #777; min-width: 120px; }
    .bt-info-row strong { text-align: right; word-break: break-all; }
    .bt-amount { color: #d32f2f; font-size: 18px; }
    .bt-ref    { color: #1565c0; letter-spacing: .5px; }
    .amount-row { margin-top: 4px; }
    .bt-steps {
        background: #fffde7;
        border: 1px solid #fff176;
        border-radius: 8px;
        padding: 12px 16px;
        font-size: 13px;
        margin-bottom: 16px;
        line-height: 1.8;
    }
    .bt-steps ol { margin: 6px 0 0 16px; padding: 0; }
    .bt-actions { display: flex; flex-direction: column; gap: 10px; }
    .btn-confirm-bank {
        background: #2e7d32;
        color: #fff;
        border: none;
        padding: 14px;
        border-radius: 10px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: background .2s;
    }
    .btn-confirm-bank:hover { background: #1b5e20; }
    .btn-back-bank {
        background: none;
        border: 1px solid #ccc;
        padding: 10px;
        border-radius: 8px;
        font-size: 14px;
        cursor: pointer;
        color: #555;
    }
    .btn-back-bank:hover { background: #f5f5f5; }
    @media (max-width: 560px) {
        .bt-body { grid-template-columns: 1fr; }
        .bt-qr-img { width: 140px; height: 140px; }
    }

    /* ORDER LIST */
    .order-list {
        max-height: 300px;
        overflow-y: auto;
    }

    /* ITEM */
    .order-item {
        display: flex;
        gap: 10px;
        padding: 10px 0;
        border-bottom: 1px solid #eee;
        align-items: flex-start;
    }

    .order-item img {
        width: 50px;
        height: 70px;
        object-fit: cover;
    }

    .order-item .info {
        flex: 1;
    }

    .order-item .name {
        font-weight: 600;
        font-size: 14px;

        display: -webkit-box;
        -webkit-line-clamp: 2;
        overflow: hidden;
        -webkit-box-orient: vertical;
    }

    .order-item .qty {
        font-size: 12px;
        color: #777;
    }

    .order-item .price {
        white-space: nowrap;
        font-weight: 600;
    }

    /* TOTAL */
    .total-box {
        margin-top: 15px;
    }

    .total-box div {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;
    }

    .total-box .grand {
        font-size: 18px;
        border-top: 1px solid #eee;
        padding-top: 10px;
        color: #241c7a;
    }

    /* STICKY */
    .sticky {
        position: sticky;
        top: 100px;
    }

    /* RESPONSIVE */
    @media (max-width: 991px) {
        .checkout-grid {
            grid-template-columns: 1fr;
        }
    }

</style>
<script>
    (function() {
        const ctx = '${ctx}';

        const provinceSelect = document.getElementById('provinceSelect');
        const districtSelect = document.getElementById('districtSelect');
        const wardSelect = document.getElementById('wardSelect');

        const toDistrictIdInput = document.getElementById('toDistrictId');
        const toWardCodeInput = document.getElementById('toWardCode');
        const selectedServiceIdInput = document.getElementById('selectedServiceId');
        const shippingFeeInput = document.getElementById('shippingFeeInput');

        /* THÊM 3 BIẾN NÀY */
        const provinceNameInput = document.getElementById('provinceNameInput');
        const districtNameInput = document.getElementById('districtNameInput');
        const wardNameInput = document.getElementById('wardNameInput');

        const subtotalValue = Number(document.getElementById('subtotalValue').value || 0);
        const discountValue = Number(document.getElementById('discountValue').value || 0);

        const shippingFeeText = document.getElementById('shippingFeeText');
        const grandTotalText = document.getElementById('grandTotalText');

        function formatMoney(v) {
            return Number(v || 0).toLocaleString('vi-VN') + ' đ';
        }

        async function fetchJson(url) {
            const res = await fetch(url, {
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            });
            if (!res.ok) throw new Error('HTTP ' + res.status);
            return await res.json();
        }

        function resetSelect(selectEl, placeholder) {
            selectEl.innerHTML = '<option value="">' + placeholder + '</option>';
            selectEl.disabled = true;
        }

        async function loadProvinces() {
            const json = await fetchJson(ctx + '/ghn/provinces');
            const data = json.data || [];
            data.forEach(p => {
                const opt = document.createElement('option');
                opt.value = p.ProvinceID;
                opt.textContent = p.ProvinceName;
                provinceSelect.appendChild(opt);
            });
        }

        async function loadDistricts(provinceId) {
            resetSelect(districtSelect, 'Chọn Quận/Huyện');
            resetSelect(wardSelect, 'Chọn Phường/Xã');
            toDistrictIdInput.value = '';
            toWardCodeInput.value = '';
            selectedServiceIdInput.value = '';

            if (!provinceId) return;

            const json = await fetchJson(ctx + '/ghn/districts?province_id=' + encodeURIComponent(provinceId));
            const data = json.data || [];

            data.forEach(d => {
                const opt = document.createElement('option');
                opt.value = d.DistrictID;
                opt.textContent = d.DistrictName;
                districtSelect.appendChild(opt);
            });

            districtSelect.disabled = false;
        }

        async function loadWards(districtId) {
            resetSelect(wardSelect, 'Chọn Phường/Xã');
            toWardCodeInput.value = '';

            if (!districtId) return;

            const json = await fetchJson(ctx + '/ghn/wards?district_id=' + encodeURIComponent(districtId));
            const data = json.data || [];

            data.forEach(w => {
                const opt = document.createElement('option');
                opt.value = w.WardCode;
                opt.textContent = w.WardName;
                wardSelect.appendChild(opt);
            });

            wardSelect.disabled = false;
        }

        async function loadAvailableService(toDistrictId) {
            selectedServiceIdInput.value = '';
            if (!toDistrictId) return;

            const json = await fetchJson(ctx + '/ghn/services?to_district=' + encodeURIComponent(toDistrictId));
            console.log('SERVICE RESPONSE =', json);

            const data = json.data || [];
            if (data.length > 0) {
                console.log('SERVICE LIST =', data);
                selectedServiceIdInput.value = data[0].service_id;
            }
        }

        async function calculateShippingFee() {
            const toDistrictId = toDistrictIdInput.value;
            const toWardCode = toWardCodeInput.value;
            const serviceId = selectedServiceIdInput.value;

            if (!toDistrictId || !toWardCode || !serviceId) return;

            shippingFeeText.textContent = 'Đang tính...';

            const body = new URLSearchParams();
            body.append('toDistrictId', toDistrictId);
            body.append('toWardCode', toWardCode);
            body.append('serviceId', serviceId);

            const res = await fetch(ctx + '/shipping-fee', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: body.toString()
            });

            const json = await res.json();

            if (json.success) {
                shippingFeeInput.value = json.shippingFee;
                shippingFeeText.textContent = formatMoney(json.shippingFee);
                grandTotalText.textContent = formatMoney(json.total);
            } else {
                shippingFeeText.textContent = 'Không tính được phí';
                console.error(json);
            }
        }

        /* THÊM GÁN TÊN TỈNH */
        provinceSelect.addEventListener('change', async function() {
            provinceNameInput.value = this.options[this.selectedIndex]?.text || '';
            districtNameInput.value = '';
            wardNameInput.value = '';

            await loadDistricts(this.value);
            shippingFeeInput.value = 0;
            shippingFeeText.textContent = formatMoney(0);
            grandTotalText.textContent = formatMoney(subtotalValue - discountValue);
        });

        /* THÊM GÁN TÊN QUẬN */
        districtSelect.addEventListener('change', async function() {
            toDistrictIdInput.value = this.value;
            districtNameInput.value = this.options[this.selectedIndex]?.text || '';
            wardNameInput.value = '';

            await loadWards(this.value);
            await loadAvailableService(this.value);

            shippingFeeInput.value = 0;
            shippingFeeText.textContent = formatMoney(0);
            grandTotalText.textContent = formatMoney(subtotalValue - discountValue);
        });

        /* THÊM GÁN TÊN PHƯỜNG */
        wardSelect.addEventListener('change', async function() {
            toWardCodeInput.value = this.value;
            wardNameInput.value = this.options[this.selectedIndex]?.text || '';

            if (!selectedServiceIdInput.value) {
                console.warn("Chưa có serviceId, đang load lại...");
                await loadAvailableService(toDistrictIdInput.value);
            }

            console.log("CALL SHIPPING:", {
                district: toDistrictIdInput.value,
                ward: toWardCodeInput.value,
                service: selectedServiceIdInput.value
            });

            await calculateShippingFee();
        });

        // Định dạng lại số tiền hiển thị ban đầu (server render ra số thô như "740000.0")
        (function formatInitialTotals() {
            var s = document.getElementById('subtotalText');   if (s) s.textContent = formatMoney(subtotalValue);
            var d = document.getElementById('discountText');   if (d) d.textContent = formatMoney(discountValue);
            var f = document.getElementById('shippingFeeText'); if (f) f.textContent = formatMoney(Number(shippingFeeInput.value || 0));
            var g = document.getElementById('grandTotalText');  if (g) g.textContent = formatMoney(Math.max(0, subtotalValue + Number(shippingFeeInput.value || 0) - discountValue));
        })();

        loadProvinces();
    })();

    // ---- Payment method UI ----
    function onPaymentChange(radio) {
        document.querySelectorAll('.payment-option:not(.disabled-pm)').forEach(el => el.classList.remove('selected'));
        radio.closest('.payment-option').classList.add('selected');
        document.getElementById('bankInfo').style.display =
            radio.value === 'BANK_TRANSFER' ? 'block' : 'none';
    }

    document.addEventListener('DOMContentLoaded', function() {
        // Mark COD selected by default
        const defaultRadio = document.querySelector('input[name="paymentMethod"]:checked');
        if (defaultRadio) onPaymentChange(defaultRadio);

        document.getElementById('orderForm').addEventListener('submit', function(e) {
            const method = document.querySelector('input[name="paymentMethod"]:checked')?.value;
            if (method === 'BANK_TRANSFER') {
                const confirmed = document.getElementById('bankConfirmedInput').value;
                if (confirmed !== '1') {
                    e.preventDefault();
                    showBankModal();
                    return;
                }
            }
            const btn = this.querySelector('button[type="submit"], button:not([type="button"])');
            if (btn) {
                btn.disabled = true;
                btn.textContent = 'Đang xử lý...';
            }
        });
    });

    // ---- Bank Transfer Modal ----
    function getGrandTotal() {
        const subtotal = parseFloat(document.getElementById('subtotalValue').value || 0);
        const shipping = parseFloat(document.getElementById('shippingFeeInput').value || 0);
        const discount = parseFloat(document.getElementById('discountValue').value || 0);
        return Math.round(subtotal + shipping - discount);
    }

    function showBankModal() {
        const total  = getGrandTotal();
        const phone  = (document.querySelector('input[name="phone"]')?.value || '').replace(/\s/g, '');
        const ref    = 'GOCSACH ' + (phone || 'KHACH HANG');

        // Update modal info
        document.getElementById('btAmount').textContent = total.toLocaleString('vi-VN') + ' đ';
        document.getElementById('btRef').textContent    = ref;

        // Generate VietQR image (free, no API key needed)
        const qrUrl = 'https://img.vietqr.io/image/VCB-1234567890-compact2.png'
            + '?amount='      + encodeURIComponent(total)
            + '&addInfo='     + encodeURIComponent(ref)
            + '&accountName=' + encodeURIComponent('CONG TY TNHH GOC SACH');
        document.getElementById('bankQRImg').src = qrUrl;

        document.getElementById('bankTransferModal').classList.add('show');
        document.body.style.overflow = 'hidden';
    }

    function closeBankModal() {
        document.getElementById('bankTransferModal').classList.remove('show');
        document.body.style.overflow = '';
    }

    function handleOverlayClick(e) {
        if (e.target.id === 'bankTransferModal') closeBankModal();
    }

    function applyCoupon() {
        const code = (document.getElementById('couponInput').value || '').trim();
        const msg  = document.getElementById('couponMsg');
        if (!code) { msg.style.color = '#c00'; msg.textContent = 'Vui lòng nhập mã giảm giá.'; return; }

        const subtotal = Number(document.getElementById('subtotalValue').value || 0);
        msg.style.color = '#666'; msg.textContent = 'Đang áp dụng...';
        fetch(ctx + '/coupon/apply?code=' + encodeURIComponent(code) + '&subtotal=' + subtotal, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(function(r) { return r.json(); })
        .then(function(data) {
            if (data.success) {
                document.getElementById('couponCodeInput').value = code;
                document.getElementById('discountAmountInput').value = data.discount;
                document.getElementById('discountValue').value = data.discount;
                document.getElementById('discountText').textContent = formatMoney(data.discount);
                const shipping = Number(document.getElementById('shippingFeeInput').value || 0);
                document.getElementById('grandTotalText').textContent = formatMoney(subtotal + shipping - data.discount);
                msg.style.color = '#1a7a1a';
            } else {
                document.getElementById('couponCodeInput').value = '';
                document.getElementById('discountAmountInput').value = 0;
                document.getElementById('discountValue').value = 0;
                document.getElementById('discountText').textContent = formatMoney(0);
                const shipping = Number(document.getElementById('shippingFeeInput').value || 0);
                document.getElementById('grandTotalText').textContent = formatMoney(subtotal + shipping);
                msg.style.color = '#c00';
            }
            msg.textContent = data.message;
        })
        .catch(function() { msg.style.color = '#c00'; msg.textContent = 'Lỗi kết nối, thử lại.'; });
    }

    function confirmBankTransfer() {
        document.getElementById('bankConfirmedInput').value = '1';
        closeBankModal();
        const btn = document.querySelector('#orderForm button:not([type="button"])');
        if (btn) {
            btn.disabled = true;
            btn.textContent = 'Đang xử lý...';
        }
        document.getElementById('orderForm').submit();
    }
</script>
<%@ include file="/WEB-INF/views/base/footer.jsp"%>