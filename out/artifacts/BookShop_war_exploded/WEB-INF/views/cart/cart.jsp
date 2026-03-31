<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="cart" value="${sessionScope.cart}" />

<%@ include file="/WEB-INF/views/base/header.jsp"%>

<div class="bl-cart-page">
    <section class="bl-cart-hero">
        <div class="container">
            <div class="bl-cart-hero-inner">
                <h1>Cart</h1>
                <div class="bl-cart-breadcrumb">
                    <a href="${ctx}/books">HOME</a>
                    <span>›</span>
                    <span>CART</span>
                </div>
            </div>
        </div>
    </section>

    <section class="bl-cart-content">
        <div class="container">

            <c:choose>
                <c:when test="${cart != null && not empty cart.items}">
                    <form action="${ctx}/cart" method="post">
                        <input type="hidden" name="action" value="update">

                        <table class="table">
                            <tbody>
                            <c:forEach var="item" items="${cart.items}">
                                <tr>
                                    <td>${item.title}</td>

                                    <td>
                                        <input type="hidden" name="bookId" value="${item.bookId}">
                                        <input type="number"
                                               name="quantity_${item.bookId}"
                                               value="${item.quantity}"
                                               min="1"
                                               class="form-control">
                                    </td>

                                    <td>${item.price}</td>
                                    <td>${item.total}</td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>

                        <button type="submit" class="btn btn-primary btnhover">Update Cart</button>
                    </form>
                    <div class="row bl-cart-bottom">
                        <div class="col-lg-6">
                            <div class="bl-cart-box">
                                <h3>CALCULATE SHIPPING</h3>

                                <select class="form-control mb-4">
                                    <option>Credit Card Type</option>
                                </select>

                                <div class="row">
                                    <div class="col-md-6 mb-4">
                                        <input type="text" class="form-control" placeholder="Credit Card Number">
                                    </div>
                                    <div class="col-md-6 mb-4">
                                        <input type="text" class="form-control" placeholder="Card Verification Number">
                                    </div>
                                </div>

                                <input type="text" class="form-control mb-4" placeholder="Coupon Code">

                                <button type="button" class="btn btn-primary btnhover">
                                    Apply Coupon
                                </button>
                            </div>
                        </div>

                        <div class="col-lg-6">
                            <div class="bl-cart-box">
                                <h3>CART SUBTOTAL</h3>

                                <table class="bl-cart-total-table">
                                    <tbody>
                                    <tr>
                                        <th>Order Subtotal</th>
                                        <table class="bl-cart-total-table">
                                            <tbody>
                                            <tr>
                                                <th>Subtotal</th>
                                                <td><fmt:formatNumber value="${cart.totalPrice}" pattern="#,###"/> đ</td>
                                            </tr>
                                            <tr>
                                                <th>Shipping</th>
                                                <td>0 đ</td>
                                            </tr>
                                            <tr>
                                                <th>Total</th>
                                                <td><strong><fmt:formatNumber value="${cart.totalPrice}" pattern="#,###"/> đ</strong></td>
                                            </tr>
                                            </tbody>
                                        </table>                                    </tr>
                                    <tr>
                                        <th>Shipping</th>
                                        <td>Free Shipping</td>
                                    </tr>
                                    <tr>
                                        <th>Coupon</th>
                                        <td>0 đ</td>
                                    </tr>
                                    <tr>
                                        <th>Total</th>
                                        <td><strong><fmt:formatNumber value="${cart.totalPrice}" pattern="#,###"/> đ</strong></td>
                                    </tr>
                                    </tbody>
                                </table>

                                <a href="${ctx}/order" class="btn btn-primary btnhover bl-cart-checkout-btn">
                                    Proceed To Checkout
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-warning text-center">
                        Giỏ hàng của bạn đang trống.
                    </div>
                    <div class="text-center mt-4">
                        <a href="${ctx}/books" class="btn btn-primary btnhover">Đến trang sách</a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </section>
</div>

<%@ include file="/WEB-INF/views/base/footer.jsp"%>