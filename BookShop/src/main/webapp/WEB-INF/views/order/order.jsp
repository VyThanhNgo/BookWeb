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

        <form action="${ctx}/order" method="post">

            <div class="checkout-grid">

                <!-- LEFT -->
                <div class="checkout-left">

                    <!-- SHIPPING -->
                    <div class="checkout-card">
                        <h3 class="checkout-title">Thông tin giao hàng</h3>

                        <div class="form-grid">
                            <input type="text" name="customerName" placeholder="Họ và tên *" required>
                            <input type="text" name="phone" placeholder="Số điện thoại *" required>

                            <input type="email" name="email" placeholder="Email">
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

                            <input type="text" name="addressLine" placeholder="Địa chỉ cụ thể *" required class="full">

                            <textarea name="note" placeholder="Ghi chú đơn hàng"></textarea>
                        </div>
                    </div>

                    <!-- PAYMENT -->
                    <div class="checkout-card">
                        <h3 class="checkout-title">Phương thức thanh toán</h3>

                        <div class="payment-list">
                            <label><input type="radio" name="paymentMethod" value="COD" checked> COD</label>
                            <label><input type="radio" name="paymentMethod" value="BANK_TRANSFER"> Bank</label>
                            <label><input type="radio" name="paymentMethod" value="MOMO"> MoMo</label>
                            <label><input type="radio" name="paymentMethod" value="ZALOPAY"> ZaloPay</label>
                            <label><input type="radio" name="paymentMethod" value="VNPAY"> VNPay</label>
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
    .payment-list label {
        display: block;
        padding: 10px;
        border: 1px solid #eee;
        border-radius: 6px;
        margin-bottom: 8px;
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
                alert("Không tính được phí ship: " + json.message);
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

        loadProvinces();
    })();
</script>
<%@ include file="/WEB-INF/views/base/footer.jsp"%>