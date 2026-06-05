<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="vi_VN" />

<%@ include file="/WEB-INF/views/base/header.jsp"%>

<div class="page-content">
		<!-- inner page banner -->
		<div class="dz-bnr-inr overlay-secondary-dark dz-bnr-inr-sm" style="background-image:url(images/background/bg3.jpg);">
			<div class="container">
				<div class="dz-bnr-inr-entry">
					<h1>Wishlist</h1>
					<nav aria-label="breadcrumb" class="breadcrumb-row">
						<ul class="breadcrumb">
							<li class="breadcrumb-item"><a href="index.html"> Home</a></li>
							<li class="breadcrumb-item">Wishlist</li>
						</ul>
					</nav>
				</div>
			</div>
		</div>
		<!-- inner page banner End-->
		<div class="content-inner-1">
			<div class="container">
				<div class="row">
					<div class="col-lg-12">
						<div class="table-responsive">
							<table class="table check-tbl">
									<thead>
										<tr>
											<th>Product</th>
											<th>Product name</th>
											<th>Unit Price</th>
											<th>Quantity</th>
											<th>Add to cart </th>
											<th>Close</th>
										</tr>
									</thead>
								<tbody>
    <c:choose>
        <c:when test="${empty wishlistBooks}">
            <tr>
                <td colspan="6" class="text-center p-5">
                    <h5>Danh sách yêu thích trống</h5>
                    <a href="${pageContext.request.contextPath}/books"
                       class="btn btn-primary mt-3">Khám phá sách</a>
                </td>
            </tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="b" items="${wishlistBooks}">
                <tr id="wishlist-row-${b.id}">
                    <td class="product-item-img">
                        <img src="${not empty b.image ? b.image :
                            pageContext.request.contextPath.concat('/assets/images/books/default-book.png')}"
                             alt="${b.title}" style="width:60px;">
                    </td>
                    <td class="product-item-name">
                        <a href="${pageContext.request.contextPath}/books/${b.slug}-${b.id}">
                            ${b.title}
                        </a>
                    </td>
                    <td class="product-item-price">
                        <fmt:formatNumber value="${b.price}" pattern="#,###"/> ₫
                    </td>
                    <td class="product-item-quantity">—</td>
                    <td class="product-item-totle">
                        <a href="${pageContext.request.contextPath}/cart?action=add&id=${b.id}&quantity=1"
                           class="btn btn-primary btnhover">Thêm vào giỏ</a>
                    </td>
                    <td class="product-item-close">
                        <a href="javascript:void(0);"
                           class="ti-close remove-wishlist-btn"
                           data-book-id="${b.id}"></a>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script>
document.querySelectorAll('.remove-wishlist-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        const bookId = this.dataset.bookId;
        const row = document.getElementById('wishlist-row-' + bookId);
        const ctx = '${pageContext.request.contextPath}';

        fetch(ctx + '/wishlist', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'bookId=' + bookId
        })
        .then(res => res.json())
        .then(data => {
            if (data.status === 'removed' && row) {
                row.remove();
            }
        });
    });
});
</script>

<%@ include file="/WEB-INF/views/base/footer.jsp"%>