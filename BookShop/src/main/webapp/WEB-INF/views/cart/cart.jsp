<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="cart" value="${sessionScope.cart}" />

<%@ include file="/WEB-INF/views/base/header.jsp"%>

<div class="page-content bg-white">
    <!-- Banner giống style template -->
    <div class="dz-bnr-inr overlay-secondary-dark dz-bnr-inr-sm"
         style="background-image:url(${ctx}/assets/images/background/bg3.jpg);">
        <div class="container">
            <div class="dz-bnr-inr-entry">
                <h1>Giỏ hàng</h1>
                <nav aria-label="breadcrumb" class="breadcrumb-row">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${ctx}/books"> Trang chủ</a></li>
                        <li class="breadcrumb-item">Giỏ hàng</li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <section class="content-inner-1">
        <div class="container">

            <c:if test="${not empty sessionScope.checkoutStockError}">
                <div class="alert alert-warning alert-dismissible mt-3" role="alert">
                    ${sessionScope.checkoutStockError}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="checkoutStockError" scope="session"/>
            </c:if>

            <c:choose>
                <c:when test="${cart != null && not empty cart.items}">
                    <form action="javascript:void(0);" method="post" id="cartForm">

                        <div class="table-responsive">
                            <table class="table check-tbl cart-table">
                                <thead>
                                <tr>
                                    <th><input type="checkbox" id="select-all" checked title="Chọn tất cả"></th>
                                    <th>Ảnh</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Đơn giá</th>
                                    <th>Số lượng</th>
                                    <th>Thành tiền</th>
                                    <th>Xóa</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${cart.items}">
                                    <tr class="cart-row" data-book-id="${item.bookId}" data-stock="${stockMap[item.bookId]}">
                                        <td class="product-item-select">
                                            <input type="checkbox" class="row-select" data-book-id="${item.bookId}"
                                                   ${stockMap[item.bookId] <= 0 ? '' : 'checked'} ${stockMap[item.bookId] <= 0 ? 'disabled' : ''}>
                                        </td>
                                        <td class="product-item-img">
                                            <img
                                                    src="${not empty item.image ? item.image : pageContext.request.contextPath.concat('/assets/images/books/default-book.png')}"
                                                    alt="${item.title}">
                                        </td>

                                        <td class="product-item-name">
                                            <input type="hidden" name="bookId" value="${item.bookId}">
                                            <h6 class="title mb-0">
                                                <a href="${ctx}/books/detail?id=${item.bookId}">
                                                        ${item.title}
                                                </a>
                                            </h6>
                                            <c:choose>
                                                <c:when test="${stockMap[item.bookId] <= 0}">
                                                    <span class="stock-status out">Hết hàng</span>
                                                </c:when>
                                                <c:when test="${stockMap[item.bookId] <= 5}">
                                                    <span class="stock-status low">Sắp hết (còn ${stockMap[item.bookId]})</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="stock-status ok">Còn hàng</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td class="product-item-price">
                                            <fmt:formatNumber value="${item.price}" pattern="#,###"/> đ
                                        </td>

                                        <td class="product-item-quantity">
                                            <div class="quantity btn-quantity style-1">
                                                <input type="button" value="-" class="qty-btn minus" data-target="qty-${item.bookId}">
                                                <input id="qty-${item.bookId}"
                                                       type="text"
                                                       name="quantity_${item.bookId}"
                                                       value="${item.quantity}">
                                                <input type="button" value="+" class="qty-btn plus" data-target="qty-${item.bookId}">
                                            </div>
                                        </td>

                                        <td class="product-item-total">
    <span class="line-total"
          data-price="${item.price}">
        <fmt:formatNumber value="${item.total}" pattern="#,###"/>
    </span> đ
                                        </td>
                                        <td class="product-item-close">
                                            <a href="${ctx}/cart"
                                               class="remove-btn js-remove-cart-item"
                                               data-id="${item.bookId}">
                                                <i class="fas fa-times"></i>
                                            </a>                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <div class="row cart-actions-wrap">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <a href="${ctx}/cart" class="btn btn-outline-danger js-clear-cart">
                                    Xóa giỏ hàng
                                </a>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <a href="${ctx}/books" class="btn btn-secondary btnhover">
                                    Tiếp tục mua sắm
                                </a>
                            </div>
                        </div>
                    </form>

                    <div class="row mt-5">
                        <div class="col-xl-6 col-lg-6 offset-xl-6 offset-lg-6">
                            <div class="cart-detail">
                                <h4 class="widget-title">Tổng giỏ hàng</h4>
                                <table>
                                    <tbody>
                                    <tr>
                                        <td>Tạm tính</td>
                                        <td class="price">
    <span id="cart-subtotal" data-value="${cart.totalPrice}">
        <fmt:formatNumber value="${cart.totalPrice}" pattern="#,###"/>
    </span> đ
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Phí vận chuyển</td>
                                        <td class="price">Tính khi thanh toán</td>
                                    </tr>
                                    <tr id="cart-discount-row" style="display:none;">
                                        <td>Giảm giá</td>
                                        <td class="price">− <span id="cart-discount" data-value="0">0</span> đ</td>
                                    </tr>
                                    <tr>
                                        <td>Tổng cộng</td>
                                        <td class="price total-price">
    <span id="cart-total" data-value="${cart.totalPrice}">
        <fmt:formatNumber value="${cart.totalPrice}" pattern="#,###"/>
    </span> đ
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>

                                <div class="cart-coupon">
                                    <div class="cart-coupon-input">
                                        <input type="text" id="cart-coupon-code" placeholder="Nhập mã giảm giá">
                                        <button type="button" id="cart-coupon-apply" class="btn btn-primary btn-sm">Áp dụng</button>
                                    </div>
                                    <div id="cart-coupon-msg" class="cart-coupon-msg"></div>
                                </div>

                                <a href="${ctx}/order" id="checkout-btn" class="btn btn-primary btnhover w-100">
                                    Tiến hành thanh toán
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="text-center py-5">
                        <h4 class="mb-3">Giỏ hàng của bạn đang trống</h4>
                        <a href="${ctx}/books" class="btn btn-primary btnhover">
                            Đến trang sách
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </section>
</div>

<style>
    .cart-table thead th {
        background: #241c7a;
        color: #fff;
        font-size: 22px;
        font-weight: 600;
        padding: 20px 16px;
        vertical-align: middle;
        border: none;
        white-space: nowrap;
    }

    .cart-table tbody td {
        vertical-align: middle;
        padding: 18px 16px;
        border-color: #ececec;
    }

    .product-item-img img {
        width: 85px;
        height: 115px;
        object-fit: cover;
        border-radius: 6px;
        border: 1px solid #eee;
        background: #fff;
    }

    .product-item-name .title {
        font-size: 28px;
        line-height: 1.35;
        margin: 0;
    }

    .product-item-name .title a {
        color: #1f1f1f;
        text-decoration: none;
    }

    .product-item-name .title a:hover {
        color: #f5a623;
    }

    .product-item-price,
    .product-item-total {
        font-size: 24px;
        font-weight: 500;
        color: #1f1f1f;
        white-space: nowrap;
    }

    .quantity.style-1 {
        display: inline-flex;
        align-items: center;
        border: 1px solid #e8e8e8;
        border-radius: 8px;
        overflow: hidden;
        background: #fff;
    }

    .quantity.style-1 input[type="text"] {
        width: 70px;
        height: 52px;
        border: none;
        text-align: center;
        font-size: 22px;
        outline: none;
    }

    .quantity.style-1 .qty-btn {
        width: 52px;
        height: 52px;
        border: none;
        background: #f5f5f5;
        font-size: 28px;
        line-height: 1;
        color: #666;
        cursor: pointer;
    }

    .quantity.style-1 .qty-btn:hover {
        background: #ececec;
    }

    .remove-btn {
        width: 52px;
        height: 52px;
        border-radius: 10px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: #ff2c7d;
        color: #fff;
        font-size: 20px;
        text-decoration: none;
    }

    .remove-btn:hover {
        color: #fff;
        opacity: 0.9;
    }

    .cart-actions-wrap {
        margin-top: 24px;
        align-items: center;
    }

    .shop-form,
    .cart-detail {
        background: #fff;
        border: 1px solid #ececec;
        padding: 30px;
        border-radius: 10px;
        height: 100%;
    }

    .widget-title {
        font-size: 34px;
        margin-bottom: 22px;
        color: #241c7a;
    }

    .cart-detail table {
        width: 100%;
        margin-bottom: 24px;
    }

    .cart-detail table td {
        padding: 12px 0;
        border-bottom: 1px solid #ececec;
        font-size: 18px;
    }

    .cart-detail table td.price {
        text-align: right;
        font-weight: 600;
    }

    .cart-detail .total-price {
        color: #241c7a;
        font-size: 22px;
        font-weight: 700;
    }

    @media (max-width: 991px) {
        .product-item-name .title {
            font-size: 20px;
        }

        .product-item-price,
        .product-item-total {
            font-size: 18px;
        }

        .cart-table thead th {
            font-size: 16px;
            padding: 14px 10px;
        }
    }

    /* Trạng thái tồn kho */
    .stock-status { display:inline-block; margin-top:4px; font-size:12px; font-weight:600; padding:1px 8px; border-radius:10px; }
    .stock-status.ok  { color:#1a7a1a; background:#e6f7e6; }
    .stock-status.low { color:#9c5700; background:#fff3cd; }
    .stock-status.out { color:#991b1b; background:#fee2e2; }
    .cart-row.is-out td { opacity:.6; }

    /* Ô nhập mã giảm giá ở giỏ */
    .cart-coupon { margin: 6px 0 12px; }
    .cart-coupon-input { display:flex; gap:8px; }
    .cart-coupon-input input { flex:1; border:1px solid #ddd; border-radius:8px; padding:8px 12px; font-size:14px; }
    .cart-coupon-input button { white-space:nowrap; }
    .cart-coupon-msg { font-size:13px; margin-top:6px; min-height:18px; }

    /* Toast */
    #toast-wrap { position:fixed; top:20px; right:20px; z-index:99999; display:flex; flex-direction:column; gap:8px; }
    .toast-item { min-width:240px; max-width:340px; padding:12px 16px; border-radius:10px; color:#fff;
        font-size:14px; box-shadow:0 6px 20px rgba(0,0,0,.18); opacity:0; transform:translateX(20px);
        transition:opacity .25s, transform .25s; }
    .toast-item.show { opacity:1; transform:translateX(0); }
    .toast-item.success { background:#2e7d32; }
    .toast-item.error   { background:#c62828; }
    .toast-item.info    { background:#1565c0; }

    /* Loading overlay nhỏ cho nút/khu vực */
    .is-loading { position:relative; pointer-events:none; opacity:.75; }
    .is-loading::after { content:''; position:absolute; top:50%; left:50%; width:16px; height:16px;
        margin:-8px 0 0 -8px; border:2px solid rgba(255,255,255,.5); border-top-color:#fff;
        border-radius:50%; animation:cartspin .6s linear infinite; }
    @keyframes cartspin { to { transform:rotate(360deg); } }
</style>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const ctx = '${pageContext.request.contextPath}';

        function formatMoney(value) {
            return Number(value || 0).toLocaleString('vi-VN');
        }

        // ---- Toast ----
        var toastWrap = document.getElementById('toast-wrap');
        if (!toastWrap) { toastWrap = document.createElement('div'); toastWrap.id = 'toast-wrap'; document.body.appendChild(toastWrap); }
        function toast(msg, type) {
            var el = document.createElement('div');
            el.className = 'toast-item ' + (type || 'info');
            el.textContent = msg;
            toastWrap.appendChild(el);
            requestAnimationFrame(function () { el.classList.add('show'); });
            setTimeout(function () { el.classList.remove('show'); setTimeout(function () { el.remove(); }, 300); }, 2600);
        }
        function setLoading(el, on) { if (el) el.classList.toggle('is-loading', !!on); }

        // ---- Trạng thái mã giảm giá áp tại giỏ ----
        var appliedCoupon = '';
        var appliedDiscount = 0;
        function getStock(row) { return Number(row.getAttribute('data-stock') || 0); }
        function revalidate() { if (appliedCoupon) applyCartCoupon(appliedCoupon, true); else recalcCartUI(); }

        function recalcCartUI() {
            let subtotal = 0;
            let selectedCount = 0;

            document.querySelectorAll('.cart-row').forEach(function (row) {
                const qtyInput = row.querySelector('input[type="text"]');
                const totalEl = row.querySelector('.line-total');
                if (!qtyInput || !totalEl) return;

                const price = Number(totalEl.getAttribute('data-price') || 0);
                const qty = Number(qtyInput.value || 0);
                const lineTotal = price * qty;
                totalEl.textContent = formatMoney(lineTotal);

                // Chỉ cộng vào tổng những sản phẩm đang được chọn
                const cb = row.querySelector('.row-select');
                if (cb && cb.checked) { subtotal += lineTotal; selectedCount++; }
            });

            const discount = Math.min(appliedDiscount, subtotal);
            const total = Math.max(0, subtotal - discount);

            const subtotalEl = document.getElementById('cart-subtotal');
            const totalEl = document.getElementById('cart-total');
            if (subtotalEl) subtotalEl.textContent = formatMoney(subtotal);
            if (totalEl) totalEl.textContent = formatMoney(total);

            const discRow = document.getElementById('cart-discount-row');
            const discEl = document.getElementById('cart-discount');
            if (discRow) discRow.style.display = discount > 0 ? '' : 'none';
            if (discEl) discEl.textContent = formatMoney(discount);

            const checkoutBtn = document.getElementById('checkout-btn');
            if (checkoutBtn) checkoutBtn.classList.toggle('disabled', selectedCount === 0);

            syncSelectAllState();
        }

        // ---- Áp / bỏ mã giảm giá tại giỏ ----
        function applyCartCoupon(code, silent) {
            var subtotal = 0;
            document.querySelectorAll('.cart-row').forEach(function (row) {
                var cb = row.querySelector('.row-select');
                var totalEl = row.querySelector('.line-total');
                var qtyInput = row.querySelector('input[type="text"]');
                if (totalEl && qtyInput && cb && cb.checked)
                    subtotal += Number(totalEl.getAttribute('data-price') || 0) * Number(qtyInput.value || 0);
            });
            var applyBtn = document.getElementById('cart-coupon-apply');
            var msg = document.getElementById('cart-coupon-msg');
            setLoading(applyBtn, true);
            return fetch(ctx + '/coupon/apply?code=' + encodeURIComponent(code) + '&subtotal=' + subtotal, {
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            })
            .then(function (r) { return r.json(); })
            .then(function (data) {
                setLoading(applyBtn, false);
                if (data.success) {
                    appliedCoupon = code.toUpperCase();
                    appliedDiscount = Number(data.discount) || 0;
                    if (msg) { msg.style.color = '#1a7a1a'; msg.textContent = data.message + ' — bấm để bỏ'; msg.style.cursor = 'pointer'; msg.dataset.applied = '1'; }
                    if (!silent) toast('Áp dụng mã giảm giá thành công', 'success');
                } else {
                    appliedCoupon = ''; appliedDiscount = 0;
                    if (msg) { msg.style.color = '#c00'; msg.textContent = data.message; msg.style.cursor = 'default'; msg.dataset.applied = ''; }
                    if (!silent) toast(data.message || 'Mã giảm giá không hợp lệ', 'error');
                }
                recalcCartUI();
            })
            .catch(function () { setLoading(applyBtn, false); if (!silent) toast('Lỗi kết nối, thử lại', 'error'); });
        }
        function clearCartCoupon() {
            appliedCoupon = ''; appliedDiscount = 0;
            var msg = document.getElementById('cart-coupon-msg');
            if (msg) { msg.textContent = ''; msg.dataset.applied = ''; msg.style.cursor = 'default'; }
            var input = document.getElementById('cart-coupon-code');
            if (input) input.value = '';
            recalcCartUI();
        }

        function syncSelectAllState() {
            const all = document.querySelectorAll('.row-select');
            const checked = document.querySelectorAll('.row-select:checked');
            const selectAll = document.getElementById('select-all');
            if (selectAll) {
                selectAll.checked = all.length > 0 && checked.length === all.length;
                selectAll.indeterminate = checked.length > 0 && checked.length < all.length;
            }
        }

        function updateBadge(totalItems) {
            const badge = document.getElementById('cart-badge');
            if (badge) {
                badge.textContent = totalItems;
            }
        }

        function removeRow(bookId) {
            const row = document.querySelector('.cart-row[data-book-id="' + bookId + '"]');
            if (row) {
                row.remove();
            }
        }

        function removeMiniCartItem(bookId) {
            const miniItem = document.querySelector('#mini-cart-list .cart-item[data-id="' + bookId + '"]');
            if (miniItem) {
                miniItem.remove();
            }
        }

        function updateMiniCartAfterRemove(totalPrice) {
            const list = document.getElementById('mini-cart-list');
            if (!list) return;

            const totalRow = list.querySelector('.mini-cart-total');
            if (totalRow) {
                totalRow.innerHTML =
                    '<h6 class="text-secondary mb-0">Tổng = ' + formatMoney(totalPrice) + ' đ</h6>';
            }

            const remainItems = list.querySelectorAll('.cart-item[data-id]');
            if (remainItems.length === 0) {
                list.innerHTML =
                    '<li class="cart-item text-center">' +
                    '<p class="mb-0">Giỏ hàng đang trống.</p>' +
                    '</li>' +
                    '<li class="text-center d-flex cart-actions-mini">' +
                    '<a href="' + ctx + '/cart" class="btn btn-sm btn-primary me-2 btnhover w-100">Xem giỏ</a>' +
                    '<a href="' + ctx + '/order" class="btn btn-sm btn-outline-primary btnhover w-100">Thanh toán</a>' +
                    '</li>';
            }
        }

        function showEmptyCartIfNeeded() {
            const rows = document.querySelectorAll('.cart-row');
            if (rows.length === 0) {
                const container = document.querySelector('.content-inner-1 .container');
                if (container) {
                    container.innerHTML =
                        '<div class="text-center py-5">' +
                        '<h4 class="mb-3">Giỏ hàng của bạn đang trống</h4>' +
                        '<a href="' + ctx + '/books" class="btn btn-primary btnhover">Đến trang sách</a>' +
                        '</div>';
                }
            }
        }

        var qtyTimers = {};

        function saveQtyToServer(bookId, qty) {
            clearTimeout(qtyTimers[bookId]);
            qtyTimers[bookId] = setTimeout(function () {
                var formData = new FormData();
                formData.append('action', 'syncOne');
                formData.append('bookId', bookId);
                formData.append('quantity', qty);

                fetch(ctx + '/cart', {
                    method: 'POST',
                    headers: { 'X-Requested-With': 'XMLHttpRequest' },
                    body: formData
                })
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (data && data.success) {
                        updateBadge(data.totalItems);
                        revalidate();
                    }
                })
                .catch(function (err) { console.error('Sync qty error:', err); });
            }, 400);
        }

        document.querySelectorAll('.qty-btn.minus').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var input = document.getElementById(this.getAttribute('data-target'));
                var value = parseInt(input.value || '1', 10);
                var bookId = this.closest('.cart-row').getAttribute('data-book-id');
                if (value > 1) {
                    input.value = value - 1;
                    recalcCartUI();
                    saveQtyToServer(bookId, value - 1);
                } else {
                    // Đang ở số 1 thì hỏi xác nhận xoá thay vì để số lượng về 0
                    if (confirm('Bạn có muốn xóa sản phẩm này khỏi giỏ hàng không?')) removeItem(bookId);
                }
            });
        });

        document.querySelectorAll('.qty-btn.plus').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var input = document.getElementById(this.getAttribute('data-target'));
                var row = this.closest('.cart-row');
                var stock = getStock(row);
                var value = parseInt(input.value || '1', 10);
                if (stock > 0 && value >= stock) {
                    toast('Bạn đã chọn tối đa số lượng hiện có (' + stock + ')', 'error');
                    return;
                }
                input.value = value + 1;
                recalcCartUI();
                saveQtyToServer(row.getAttribute('data-book-id'), value + 1);
            });
        });

        // Chọn từng sản phẩm hoặc chọn tất cả; tính lại mã giảm giá theo sản phẩm đang chọn
        document.querySelectorAll('.row-select').forEach(function (cb) {
            cb.addEventListener('change', revalidate);
        });
        var selectAllEl = document.getElementById('select-all');
        if (selectAllEl) {
            selectAllEl.addEventListener('change', function () {
                document.querySelectorAll('.row-select').forEach(function (cb) {
                    if (!cb.disabled) cb.checked = selectAllEl.checked;
                });
                revalidate();
            });
        }

        // Ô mã giảm giá tại giỏ
        var couponApplyBtn = document.getElementById('cart-coupon-apply');
        if (couponApplyBtn) {
            couponApplyBtn.addEventListener('click', function () {
                var code = (document.getElementById('cart-coupon-code').value || '').trim();
                if (!code) { toast('Vui lòng nhập mã giảm giá', 'error'); return; }
                applyCartCoupon(code, false);
            });
        }
        var couponCodeInput = document.getElementById('cart-coupon-code');
        if (couponCodeInput) {
            couponCodeInput.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') { e.preventDefault(); if (couponApplyBtn) couponApplyBtn.click(); }
            });
        }
        var couponMsgEl = document.getElementById('cart-coupon-msg');
        if (couponMsgEl) {
            couponMsgEl.addEventListener('click', function () {
                if (this.dataset.applied === '1') { clearCartCoupon(); toast('Đã bỏ mã giảm giá', 'info'); }
            });
        }

        // Nút thanh toán: gửi các sản phẩm được chọn (kèm mã giảm giá) sang trang checkout
        var checkoutBtnEl = document.getElementById('checkout-btn');
        if (checkoutBtnEl) {
            checkoutBtnEl.addEventListener('click', function (e) {
                e.preventDefault();
                var ids = Array.prototype.slice
                    .call(document.querySelectorAll('.row-select:checked'))
                    .map(function (cb) { return cb.getAttribute('data-book-id'); });
                if (ids.length === 0) {
                    toast('Vui lòng chọn ít nhất một sản phẩm để thanh toán', 'error');
                    return;
                }
                var url = ctx + '/order?selectedIds=' + encodeURIComponent(ids.join(','));
                if (appliedCoupon && appliedDiscount > 0) url += '&coupon=' + encodeURIComponent(appliedCoupon);
                window.location.href = url;
            });
        }

        // Đánh dấu các dòng hết hàng
        document.querySelectorAll('.cart-row').forEach(function (row) {
            if (getStock(row) <= 0) row.classList.add('is-out');
        });

        recalcCartUI(); // tính tổng ban đầu theo các sản phẩm đang chọn

        document.querySelectorAll('.product-item-quantity input[type="text"]').forEach(function (input) {
            input.addEventListener('input', function () {
                var row = this.closest('.cart-row');
                var stock = getStock(row);
                var value = parseInt(this.value || '1', 10);
                if (isNaN(value) || value < 1) value = 1;
                if (stock > 0 && value > stock) { value = stock; toast('Chỉ còn ' + stock + ' sản phẩm trong kho', 'error'); }
                this.value = value;
                recalcCartUI();
                saveQtyToServer(row.getAttribute('data-book-id'), value);
            });
        });

        function removeItem(bookId) {
            fetch(ctx + '/cart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8', 'X-Requested-With': 'XMLHttpRequest' },
                body: 'action=remove&id=' + encodeURIComponent(bookId)
            })
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (!data || !data.success) return;
                    removeRow(bookId);
                    removeMiniCartItem(bookId);
                    recalcCartUI();
                    revalidate();
                    updateBadge(data.totalItems);
                    updateMiniCartAfterRemove(data.totalPrice);
                    showEmptyCartIfNeeded();
                    toast('Đã xóa sản phẩm khỏi giỏ hàng', 'success');
                })
                .catch(function (err) { console.error('Remove cart item error:', err); toast('Lỗi khi xóa sản phẩm', 'error'); });
        }

        document.querySelectorAll('.js-remove-cart-item').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();
                var bookId = this.getAttribute('data-id');
                if (confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng không?')) removeItem(bookId);
            });
        });

        const clearBtn = document.querySelector('.js-clear-cart');
        if (clearBtn) {
            clearBtn.addEventListener('click', function (e) {
                e.preventDefault();
                if (!confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng không?')) return;

                fetch(ctx + '/cart', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                        'X-Requested-With': 'XMLHttpRequest'
                    },
                    body: 'action=clear'
                })
                    .then(function (res) {
                        return res.json();
                    })
                    .then(function (data) {
                        if (!data || !data.success) return;

                        updateBadge(0);

                        const miniCartList = document.getElementById('mini-cart-list');
                        if (miniCartList) miniCartList.innerHTML =
                            '<li class="cart-item text-center">' +
                            '<p class="mb-0">Giỏ hàng đang trống.</p>' +
                            '</li>' +
                            '<li class="text-center d-flex cart-actions-mini">' +
                            '<a href="' + ctx + '/cart" class="btn btn-sm btn-primary me-2 btnhover w-100">Xem giỏ</a>' +
                            '<a href="' + ctx + '/order" class="btn btn-sm btn-outline-primary btnhover w-100">Thanh toán</a>' +
                            '</li>';
                        toast('Đã xóa toàn bộ giỏ hàng', 'success');
                        const container = document.querySelector('.content-inner-1 .container');
                        if (container) {
                            container.innerHTML =
                                '<div class="text-center py-5">' +
                                '<h4 class="mb-3">Giỏ hàng của bạn đang trống</h4>' +
                                '<a href="' + ctx + '/books" class="btn btn-primary btnhover">Đến trang sách</a>' +
                                '</div>';
                        }
                    })
                    .catch(function (err) {
                        console.error('Clear cart error:', err);
                        toast('Lỗi khi xóa giỏ hàng', 'error');
                    });
            });
        }
    });
</script>
<%@ include file="/WEB-INF/views/base/footer.jsp"%>