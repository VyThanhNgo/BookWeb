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
                <h1>Cart</h1>
                <nav aria-label="breadcrumb" class="breadcrumb-row">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${ctx}/books"> Home</a></li>
                        <li class="breadcrumb-item">Cart</li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <section class="content-inner-1">
        <div class="container">

            <c:choose>
                <c:when test="${cart != null && not empty cart.items}">
                    <form action="javascript:void(0);" method="post" id="cartForm">

                        <div class="table-responsive">
                            <table class="table check-tbl cart-table">
                                <thead>
                                <tr>
                                    <th>Product</th>
                                    <th>Product name</th>
                                    <th>Unit Price</th>
                                    <th>Quantity</th>
                                    <th>Total</th>
                                    <th>Close</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="item" items="${cart.items}">
                                    <tr class="cart-row" data-book-id="${item.bookId}">
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
                                            <a href="${ctx}/cart?action=remove&id=${item.bookId}"
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
                                <a href="${ctx}/cart?action=clear" class="btn btn-outline-danger js-clear-cart">
                                    Clear Cart
                                </a>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <a href="${ctx}/books" class="btn btn-secondary btnhover">
                                    Continue Shopping
                                </a>
                            </div>
                        </div>
                    </form>

                    <div class="row mt-5">
                        <div class="col-xl-6 col-lg-6">
                            <div class="shop-form">
                                <h4 class="widget-title">Calculate Shipping</h4>

                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <input type="text" class="form-control" placeholder="Credit Card Type">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <input type="text" class="form-control" placeholder="Credit Card Number">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <input type="text" class="form-control" placeholder="Card Verification Number">
                                    </div>
                                    <div class="col-md-12 mb-3">
                                        <input type="text" class="form-control" placeholder="Coupon Code">
                                    </div>
                                </div>

                                <button type="button" class="btn btn-primary btnhover">
                                    Apply Coupon
                                </button>
                            </div>
                        </div>

                        <div class="col-xl-6 col-lg-6">
                            <div class="cart-detail">
                                <h4 class="widget-title">Cart Subtotal</h4>
                                <table>
                                    <tbody>
                                    <tr>
                                        <td>Order Subtotal</td>
                                        <td class="price">
    <span id="cart-subtotal" data-value="${cart.totalPrice}">
        <fmt:formatNumber value="${cart.totalPrice}" pattern="#,###"/>
    </span> đ
                                        </td>                                    </tr>
                                    <tr>
                                        <td>Shipping</td>
                                        <td class="price">0 đ</td>
                                    </tr>
                                    <tr>
                                        <td>Coupon</td>
                                        <td class="price">0 đ</td>
                                    </tr>
                                    <tr>
                                        <td>Total</td>
                                        <td class="price total-price">
    <span id="cart-total" data-value="${cart.totalPrice}">
        <fmt:formatNumber value="${cart.totalPrice}" pattern="#,###"/>
    </span> đ
                                        </td>                                    </tr>
                                    </tbody>
                                </table>

                                <a href="${ctx}/order" class="btn btn-primary btnhover w-100">
                                    Proceed To Checkout
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
</style>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const ctx = '${pageContext.request.contextPath}';

        function formatMoney(value) {
            return Number(value || 0).toLocaleString('vi-VN');
        }

        function recalcCartUI() {
            let subtotal = 0;

            document.querySelectorAll('.cart-row').forEach(function (row) {
                const qtyInput = row.querySelector('input[type="text"]');
                const totalEl = row.querySelector('.line-total');
                if (!qtyInput || !totalEl) return;

                const price = Number(totalEl.getAttribute('data-price') || 0);
                const qty = Number(qtyInput.value || 0);
                const lineTotal = price * qty;

                totalEl.textContent = formatMoney(lineTotal);
                subtotal += lineTotal;
            });

            const subtotalEl = document.getElementById('cart-subtotal');
            const totalEl = document.getElementById('cart-total');

            if (subtotalEl) subtotalEl.textContent = formatMoney(subtotal);
            if (totalEl) totalEl.textContent = formatMoney(subtotal);
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
                    '<h6 class="text-secondary mb-0">Total = ' + formatMoney(totalPrice) + ' đ</h6>';
            }

            const remainItems = list.querySelectorAll('.cart-item[data-id]');
            if (remainItems.length === 0) {
                list.innerHTML =
                    '<li class="cart-item text-center">' +
                    '<p class="mb-0">Giỏ hàng đang trống.</p>' +
                    '</li>' +
                    '<li class="text-center d-flex cart-actions-mini">' +
                    '<a href="' + ctx + '/cart" class="btn btn-sm btn-primary me-2 btnhover w-100">View Cart</a>' +
                    '<a href="' + ctx + '/order" class="btn btn-sm btn-outline-primary btnhover w-100">Checkout</a>' +
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

        document.querySelectorAll('.qty-btn.minus').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var input = document.getElementById(this.getAttribute('data-target'));
                var value = parseInt(input.value || '1', 10);
                if (value > 1) {
                    input.value = value - 1;
                    recalcCartUI();
                }
            });
        });

        document.querySelectorAll('.qty-btn.plus').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var input = document.getElementById(this.getAttribute('data-target'));
                var value = parseInt(input.value || '1', 10);
                input.value = value + 1;
                recalcCartUI();
            });
        });

        document.querySelectorAll('.product-item-quantity input[type="text"]').forEach(function (input) {
            input.addEventListener('input', function () {
                let value = parseInt(this.value || '1', 10);
                if (isNaN(value) || value < 1) value = 1;
                this.value = value;
                recalcCartUI();
            });
        });

        document.querySelectorAll('.js-remove-cart-item').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.preventDefault();

                const bookId = this.getAttribute('data-id');
                const url = ctx + '/cart?action=remove&id=' + encodeURIComponent(bookId);

                fetch(url, {
                    method: 'GET',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                    .then(function (res) {
                        return res.json();
                    })
                    .then(function (data) {
                        if (!data || !data.success) return;

                        removeRow(bookId);
                        removeMiniCartItem(bookId);
                        recalcCartUI();
                        updateBadge(data.totalItems);
                        updateMiniCartAfterRemove(data.totalPrice);
                        showEmptyCartIfNeeded();
                    })
                    .catch(function (err) {
                        console.error('Remove cart item error:', err);
                    });
            });
        });

        const clearBtn = document.querySelector('.js-clear-cart');
        if (clearBtn) {
            clearBtn.addEventListener('click', function (e) {
                e.preventDefault();

                fetch(this.href, {
                    method: 'GET',
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                    .then(function (res) {
                        return res.json();
                    })
                    .then(function (data) {
                        if (!data || !data.success) return;

                        updateBadge(0);

                        const miniCartList = document.getElementById('mini-cart-list');
                        miniCartList.innerHTML =
                            '<li class="cart-item text-center">' +
                            '<p class="mb-0">Giỏ hàng đang trống.</p>' +
                            '</li>' +
                            '<li class="text-center d-flex cart-actions-mini">' +
                            '<a href="' + ctx + '/cart" class="btn btn-sm btn-primary me-2 btnhover w-100">View Cart</a>' +
                            '<a href="' + ctx + '/order" class="btn btn-sm btn-outline-primary btnhover w-100">Checkout</a>' +
                            '</li>';
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
                    });
            });
        }
    });
</script>
<%@ include file="/WEB-INF/views/base/footer.jsp"%>