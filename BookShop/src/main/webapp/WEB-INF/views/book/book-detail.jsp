<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<fmt:setLocale value="vi_VN" />

<%@ include file="/WEB-INF/views/base/header.jsp"%>
<div class="page-content bg-grey">
	<section class="content-inner-1">
		<div class="container">
			<div class="row book-grid-row style-4 m-b60">
				<div class="col">
					<div class="dz-box">
						<div class="dz-media">
							<div class="main-img-container" style="position: relative;">
								<%-- Tag giảm giá góc trên trái --%>
								<c:if
									test="${book.originPrice > 0 && book.originPrice > book.price}">
									<span
										style="position: absolute; top: 10px; left: 10px; background: #e53935; color: #fff; font-size: 13px; font-weight: 700; padding: 4px 10px; border-radius: 4px; z-index: 2;">
										-<fmt:formatNumber
											value="${(1 - book.price/book.originPrice)*100}"
											maxFractionDigits="0" />%
									</span>
								</c:if>
								<img id="main-book-img"
									src="${not empty book.image ? book.image : ctx.concat('/assets/images/books/default-book.png')}"
									alt="${book.title}"
									style="aspect-ratio: 2/3; object-fit: cover; width: 100%; border: 1px solid #eee;">

								<button type="button" class="nav-btn prev"
									onclick="changeSlide(-1)"
									style="position: absolute; left: 10px; top: 50%; transform: translateY(-50%); background: rgba(255, 255, 255, 0.7); border: none; border-radius: 50%; width: 40px; height: 40px; cursor: pointer;">❮</button>
								<button type="button" class="nav-btn next"
									onclick="changeSlide(1)"
									style="position: absolute; right: 10px; top: 50%; transform: translateY(-50%); background: rgba(255, 255, 255, 0.7); border: none; border-radius: 50%; width: 40px; height: 40px; cursor: pointer;">❯</button>
							</div>

							<div class="sub-images-slider"
								style="display: flex; gap: 10px; margin-top: 15px; overflow-x: auto; padding-bottom: 5px;">
								<img
									src="${not empty book.image ? book.image : ctx.concat('/assets/images/books/default-book.png')}"
									class="thumb-item active"
									style="width: 70px; height: 90px; object-fit: cover; cursor: pointer; border: 2px solid #ff7200;"
									onclick="setActiveImg(this, 0)">

								<c:if test="${not empty book.subImages}">
									<c:forEach var="sImg" items="${book.subImages}"
										varStatus="status">
										<img src="${sImg}" class="thumb-item"
											style="width: 70px; height: 90px; object-fit: cover; cursor: pointer; border: 2px solid #eee;"
											onclick="setActiveImg(this, ${status.index + 1})">
									</c:forEach>
								</c:if>
							</div>
						</div>
						<div class="dz-content">
							<div class="dz-header">
								<h3 class="title">${book.title}</h3>
								<div class="shop-item-rating">
									<div
										class="d-lg-flex d-sm-inline-flex d-flex align-items-center">
										<ul class="dz-rating">
											<c:forEach begin="1" end="5" var="star">
												<li><i
													class="flaticon-star ${star <= book.avgRating ? 'text-yellow' : 'text-muted'}"></i></li>
											</c:forEach>
										</ul>
										<h6 class="m-b0">
											<fmt:formatNumber value="${book.avgRating}"
												minFractionDigits="1" maxFractionDigits="1" />
											<span style="font-weight: 400; font-size: 13px; color: #888;">(${book.reviewCount}
												đánh giá)</span>
										</h6>
									</div>
									<!-- Tim -->
									<div class="bookmark-btn style-1">
										<input class="form-check-input" type="checkbox"
											id="flexCheckDefault1"> <label
											class="form-check-label" for="flexCheckDefault1"> <i
											class="flaticon-heart"></i>
										</label>
									</div>
									<div class="social-area">
										<ul class="dz-social-icon style-3">
											<li><a href="https://www.facebook.com/dexignzone"
												target="_blank"><i class="fa-brands fa-facebook-f"></i></a></li>
											<li><a href="https://twitter.com/dexignzones"
												target="_blank"><i class="fa-brands fa-twitter"></i></a></li>
											<li><a href="https://www.whatsapp.com/" target="_blank"><i
													class="fa-brands fa-whatsapp"></i></a></li>
											<li><a
												href="https://www.google.com/intl/en-GB/gmail/about/"
												target="_blank"><i class="fa-solid fa-envelope"></i></a></li>
										</ul>
									</div>
								</div>
							</div>
							<div class="dz-body">
								<div class="book-detail">
									<ul class="book-info">
										<li>
											<div class="writer-info">
												<img
													src="${not empty book.author.image ? book.author.image : ctx.concat('/assets/images/authors/default-author.png')}"
													alt="${book.author.name}">
												<div>
													<span>Viết bới</span>${book.author.name}
												</div>
											</div>
										</li>
										<li><span>Nhà xuất bản</span>${not empty book.publisher ? book.publisher : 'Đang cập nhật'}</li>
										<li><span>Năm</span>${book.publishYear}</li>
									</ul>
								</div>
								<p class="text-1">${book.description}</p>

								<div class="book-footer"
									style="flex-direction: column; align-items: flex-start;">

									<!-- Dòng 1: Giá -->
									<div class="price"
										style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-bottom: 16px;">

										<h5 style="margin: 0;">
											<fmt:formatNumber value="${book.price}" pattern="#,###" />
											&#8363;
										</h5>
										<c:if
											test="${book.originPrice > 0 && book.originPrice > book.price}">
											<p class="p-lr10" style="margin: 0;">
												<fmt:formatNumber value="${book.originPrice}"
													pattern="#,###" />
												&#8363;
											</p>
										</c:if>
									</div>

									<form action="${ctx}/cart" method="post">
										<input type="hidden" name="id" value="${book.id}">

										<!-- Dòng 2: Label + Số lượng -->
										<div
											style="display: flex; align-items: center; gap: 12px; margin-bottom: 16px;">
											<span style="font-weight: 500; color: #555;">Số Lượng</span>
											<div
												style="display: flex; align-items: center; border: 1px solid #ddd; border-radius: 4px; overflow: hidden;">
												<button type="button" onclick="changeQty(${book.id}, -1)"
													style="width: 36px; height: 40px; border: none; background: #fff; font-size: 18px; cursor: pointer; color: #555;">−</button>
												<input id="qty${book.id}" type="text" value="1"
													name="quantity"
													style="width: 50px; height: 40px; border: none; border-left: 1px solid #ddd; border-right: 1px solid #ddd; text-align: center; font-size: 15px;">
												<button type="button" onclick="changeQty(${book.id}, 1)"
													style="width: 36px; height: 40px; border: none; background: #fff; font-size: 18px; cursor: pointer; color: #555;">+</button>
											</div>
										</div>

										<!-- Dòng 3: 2 nút -->
										<div style="display: flex; gap: 12px; align-items: center;">
											<button type="submit" name="action" value="add"
												class="btn btn-outline-primary btnhover btnhover2"
												style="padding: 10px 24px;">
												<i class="flaticon-shopping-cart-1 me-2"></i>Thêm Vào Giỏ
												Hàng
											</button>
											<button type="submit" name="action" value="buy"
												class="btn btn-primary btnhover btnhover2"
												style="padding: 10px 24px;">Mua Ngay</button>
										</div>

									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div class="row">
				<div class="col-xl-8">
					<div class="product-description tabs-site-button">
						<ul class="nav nav-tabs">
							<li><a data-bs-toggle="tab" href="#graphic-design-1"
								class="">Chi Tiết Sách</a></li>
							<li><a data-bs-toggle="tab" href="#developement-1">Đánh
									giá</a></li>
						</ul>
						<div class="tab-content">
							<div id="graphic-design-1" class="tab-pane show active">
								<table class="table border book-overview">
									<tbody>
										<tr>
											<th>Tiêu Đề</th>
											<td>${book.title}</td>
										</tr>
										<tr>
											<th>Tác Giả</th>
											<td>${book.author.name}</td>
										</tr>
										<tr>
											<th>ISBN</th>
											<td>${not empty book.isbn ? book.isbn : 'Đang cập nhật'}</td>
										</tr>
										<tr>
											<th>Ngôn Ngữ</th>
											<td>${not empty book.language ? book.language : 'Đang cập nhật'}</td>
										</tr>
										<tr>
											<th>Hình Thức Sách</th>
											<td>${not empty book.coverType ? book.coverType : 'Đang cập nhật'}</td>
										</tr>
										<tr>
											<th>Năm Xuất Bản</th>
											<td>${book.publishYear}</td>
										</tr>
										<tr>
											<th>Nhà Xuất Bản</th>
											<td>${not empty book.publisher ? book.publisher : 'Đang cập nhật'}</td>
										</tr>
										<tr>
											<th>Số Trang</th>
											<td>520</td>
										</tr>
										<tr>
											<th>Lesson</th>
											<td>7</td>
										</tr>
										<tr>
											<th>Topic</th>
											<td>360</td>
										</tr>
										<tr class="tags">
											<th>Tags</th>
											<td><a href="javascript:void(0);" class="badge">Drama</a>
												<a href="javascript:void(0);" class="badge">Advanture</a> <a
												href="javascript:void(0);" class="badge">Survival</a> <a
												href="javascript:void(0);" class="badge">Biography</a> <a
												href="javascript:void(0);" class="badge">Trending2024</a> <a
												href="javascript:void(0);" class="badge">Bestseller</a></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div id="developement-1" class="tab-pane">
								<div class="clear" id="comment-list">
									<div class="post-comments comments-area style-1 clearfix">
										<h4 class="comments-title">${book.reviewCount}đánhgiá</h4>
										<div id="comment">
											<%-- Bộ lọc --%>
											<div id="review-filter-bar"
												style="display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px; align-items: center;">
												<span style="font-weight: 600; color: #555;">Lọc:</span>
												<button
													class="btn btn-sm btn-outline-secondary filter-star-btn active-filter"
													data-star="0">Tất cả</button>
												<button
													class="btn btn-sm btn-outline-warning filter-star-btn"
													data-star="5">⭐ 5 sao</button>
												<button
													class="btn btn-sm btn-outline-warning filter-star-btn"
													data-star="4">⭐ 4 sao</button>
												<button
													class="btn btn-sm btn-outline-warning filter-star-btn"
													data-star="3">⭐ 3 sao</button>
												<button
													class="btn btn-sm btn-outline-warning filter-star-btn"
													data-star="2">⭐ 2 sao</button>
												<button
													class="btn btn-sm btn-outline-warning filter-star-btn"
													data-star="1">⭐ 1 sao</button>
												<button class="btn btn-sm btn-outline-info"
													id="btn-has-image">📷 Có ảnh</button>
											</div>

											<%-- Danh sách review render bằng JS --%>
											<ol class="comment-list" id="review-ol"
												style="padding: 0; list-style: none;"></ol>
											<div id="review-loading"
												style="display: none; text-align: center; padding: 20px;">Đang
												tải...</div>
											<div id="review-empty"
												style="display: none; padding: 16px; color: #888;">Chưa
												có đánh giá nào phù hợp.</div>

											<%-- Phân trang --%>
											<div id="review-pagination"
												style="display: flex; gap: 6px; align-items: center; flex-wrap: wrap; margin-top: 16px;"></div>
										</div>

										<c:if test="${not empty sessionScope.loggedInUser}">
											<div class="comment-respond" id="respond">
												<h4 class="comment-reply-title" id="reply-title">Viết
													đánh giá của bạn</h4>

												<form action="${ctx}/add-review" method="post"
													enctype="multipart/form-data" class="comment-form">
													<input type="hidden" name="bookId" value="${book.id}">

													<%-- Thông báo lỗi upload ảnh --%>
													<c:if test="${param.error == 'invalid_file'}">
														<div class="alert alert-danger"
															style="margin-bottom: 12px;">
															<i class="fa-solid fa-triangle-exclamation"></i> Ảnh
															không hợp lệ! Chỉ chấp nhận JPG, PNG, GIF, WEBP. File có
															thể đã bị đổi tên để qua mặt hệ thống.
														</div>
													</c:if>

													<div class="comment-form-rating">
														<label>Số sao: </label> <select name="rating"
															class="form-control" style="width: 120px;">
															<option value="5">⭐⭐⭐⭐⭐ (5 sao)</option>
															<option value="4">⭐⭐⭐⭐ (4 sao)</option>
															<option value="3">⭐⭐⭐ (3 sao)</option>
															<option value="2">⭐⭐ (2 sao)</option>
															<option value="1">⭐ (1 sao)</option>
														</select>
													</div>

													<div class="form-group mb-3">
														<label>Hình ảnh thực tế (Bạn có thể chọn nhiều
															ảnh):</label> <input type="file" name="reviewPhotos"
															id="reviewPhotos" class="form-control" multiple
															accept="image/*">
														<div id="file-error"
															style="display: none; color: #dc3545; margin-top: 6px; font-size: 13px;">
															<i class="fa-solid fa-triangle-exclamation"></i> <span
																id="file-error-msg"></span>
														</div>
													</div>

													<div class="comment-form-comment">
														<textarea name="comment"
															placeholder="Bạn thấy cuốn sách này thế nào? Chia sẻ cảm nhận của bạn nhé..."
															class="form-control" rows="4" required></textarea>
													</div>

													<div class="form-submit mt-2">
														<button type="button" class="btn btn-primary btnhover"
															onclick="submitReview(event)">Gửi Đánh Giá</button>
													</div>
												</form>
											</div>
										</c:if>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-xl-4 mt-5 mt-xl-0">
					<div class="widget">
						<h4 class="widget-title">CÓ THỂ BẠN CŨNG THÍCH</h4>
						<div class="row">
							<c:forEach var="rb" items="${relatedBooks}">
								<div class="col-xl-12 col-lg-6">
									<div class="dz-shop-card style-5">
										<div class="dz-media" style="position: relative;">
											<c:if
												test="${rb.originPrice > 0 && rb.originPrice > rb.price}">
												<span
													style="position: absolute; top: 8px; left: 8px; background: #e53935; color: #fff; font-size: 11px; font-weight: 700; padding: 2px 7px; border-radius: 4px; z-index: 2;">
													-<fmt:formatNumber
														value="${(1 - rb.price/rb.originPrice)*100}"
														maxFractionDigits="0" />%
												</span>
											</c:if>
											<img
												src="${not empty rb.image ? rb.image : ctx.concat('/assets/images/books/default-book.png')}"
												alt="${rb.title}">
										</div>
										<div class="dz-content">
											<h5 class="subtitle">
												<a
													href="${pageContext.request.contextPath}/books/${rb.slug}-${rb.id}">${rb.title}</a>
											</h5>
											<ul class="dz-tags">
												<li>${rb.category.name}</li>

											</ul>
											<div class="price">
												<span class="price-num"><fmt:formatNumber
														value="${rb.price}" pattern="#,###" />&#8363;</span>
												<c:if
													test="${rb.originPrice > 0 && rb.originPrice > rb.price}">
													<del>
														<fmt:formatNumber value="${rb.originPrice}"
															pattern="#,###" />
														&#8363;
													</del>
												</c:if>
											</div>
											<button type="submit"
												class="btn btn-primary btnhover btnhover2">
												<i class="flaticon-shopping-cart-1"></i> <span>Thêm
													Vào Giỏ Hàng</span>
											</button>
										</div>
									</div>
								</div>
							</c:forEach>

						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Client Start-->
	<div class="bg-white py-5">
		<div class="container">
			<!--Client Swiper -->
			<div
				class="swiper client-swiper swiper-initialized swiper-horizontal swiper-backface-hidden">
				<div class="swiper-wrapper" id="swiper-wrapper-7cdaae2b34727a6a"
					aria-live="off"
					style="transition-duration: 0ms; transform: translate3d(0px, 0px, 0px); transition-delay: 0ms;">
					<div class="swiper-slide swiper-slide-active" role="group"
						aria-label="1 / 5" style="width: 292.5px;">
						<img src="images/client/client1.svg" alt="client">
					</div>
					<div class="swiper-slide swiper-slide-next" role="group"
						aria-label="2 / 5" style="width: 292.5px;">
						<img src="images/client/client2.svg" alt="client">
					</div>
					<div class="swiper-slide" role="group" aria-label="3 / 5"
						style="width: 292.5px;">
						<img src="images/client/client3.svg" alt="client">
					</div>
					<div class="swiper-slide" role="group" aria-label="4 / 5"
						style="width: 292.5px;">
						<img src="images/client/client4.svg" alt="client">
					</div>
					<div class="swiper-slide" role="group" aria-label="5 / 5"
						style="width: 292.5px;">
						<img src="images/client/client5.svg" alt="client">
					</div>
				</div>
				<span class="swiper-notification" aria-live="assertive"
					aria-atomic="true"></span>
			</div>
		</div>
	</div>
	<!-- Client End-->

	<!-- Feature Box -->
	<section class="content-inner">
		<div class="container">
			<div class="row sp15">
				<div class="col-lg-3 col-md-6 col-sm-6 col-6">
					<div class="icon-bx-wraper style-2 m-b30 text-center">
						<div class="icon-bx-lg">
							<i class="fa-solid fa-users icon-cell"></i>
						</div>
						<div class="icon-content">
							<h2 class="dz-title counter m-b0">125,663</h2>
							<p class="font-20">Happy Customers</p>
						</div>
					</div>
				</div>
				<div class=" col-lg-3 col-md-6 col-sm-6 col-6">
					<div class="icon-bx-wraper style-2 m-b30 text-center">
						<div class="icon-bx-lg">
							<i class="fa-solid fa-book icon-cell"></i>
						</div>
						<div class="icon-content">
							<h2 class="dz-title counter m-b0">50,672</h2>
							<p class="font-20">Book Collections</p>
						</div>
					</div>
				</div>
				<div class="col-lg-3 col-md-6 col-sm-6 col-6">
					<div class="icon-bx-wraper style-2 m-b30 text-center">
						<div class="icon-bx-lg">
							<i class="fa-solid fa-store icon-cell"></i>
						</div>
						<div class="icon-content">
							<h2 class="dz-title counter m-b0">1,562</h2>
							<p class="font-20">Our Stores</p>
						</div>
					</div>
				</div>
				<div class="col-lg-3 col-md-6 col-sm-6 col-6">
					<div class="icon-bx-wraper style-2 m-b30 text-center">
						<div class="icon-bx-lg">
							<i class="fa-solid fa-leaf icon-cell"></i>
						</div>
						<div class="icon-content">
							<h2 class="dz-title counter m-b0">457</h2>
							<p class="font-20">Famous Writers</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- Feature Box End -->

	<!-- Newsletter -->
	<section class="py-5 newsletter-wrapper"
		style="background-image: url('images/background/bg1.jpg'); background-size: cover;">
		<div class="container">
			<div class="subscride-inner">
				<div
					class="row style-1 justify-content-xl-between justify-content-lg-center align-items-center text-xl-start text-center">
					<div class="col-xl-7 col-lg-12">
						<div class="section-head mb-0">
							<h2 class="title text-white my-lg-3 mt-0">Subscribe our
								newsletter for newest books updates</h2>
						</div>
					</div>
					<div class="col-xl-5 col-lg-6">
						<form class="dzSubscribe style-1" action="script/mailchamp.php"
							method="post">
							<div class="dzSubscribeMsg"></div>
							<div class="form-group">
								<div class="input-group mb-0">
									<input name="dzEmail" required="required" type="email"
										class="form-control bg-transparent text-white"
										placeholder="Your Email Address" fdprocessedid="amyxt">
									<div class="input-group-addon">
										<button name="submit" value="Submit" type="submit"
											class="btn btn-primary btnhover" fdprocessedid="vn8wzo">
											<span>SUBSCRIBE</span> <i class="fa-solid fa-paper-plane"></i>
										</button>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- Newsletter End -->
</div>

<!-- js số lượng -->
<script>
function changeQty(bookId, delta) {
    const input = document.getElementById('qty' + bookId);
    let val = parseInt(input.value) + delta;
    if (val < 1) val = 1;
    input.value = val;
}
</script>

<!-- quản lý việc chuyển ảnh thumnail khi bấm nút và active thumnail-->
<script>
    // Khởi tạo danh sách ảnh từ JSP sang JS
    const images = [];
    images.push("${not empty book.image ? book.image : ctx.concat('/assets/images/books/default-book.png')}");
    <c:forEach var="sImg" items="${book.subImages}">
        images.push("${sImg}");
    </c:forEach>

    let currentIndex = 0;

    // Hàm đặt ảnh được chọn
    function setActiveImg(element, index) {
        currentIndex = index;
        updateGallery();
    }

    // Hàm chuyển slide trái/phải
    function changeSlide(direction) {
        currentIndex += direction;
        if (currentIndex >= images.length) currentIndex = 0;
        if (currentIndex < 0) currentIndex = images.length - 1;
        updateGallery();
    }

    // Hàm cập nhật giao diện (Ảnh chính + Viền Thumbnail)
    function updateGallery() {
        // Cập nhật ảnh chính
        document.getElementById('main-book-img').src = images[currentIndex];
        
        // Cập nhật viền các thumbnail
        const thumbs = document.querySelectorAll('.thumb-item');
        thumbs.forEach((thumb, idx) => {
            if (idx === currentIndex) {
                thumb.style.borderColor = "#ff7200"; // Màu cam active
            } else {
                thumb.style.borderColor = "#eee";    // Màu mặc định
            }
        });
    }

    // Đảm bảo số lượng hoạt động bình thường
    function changeQty(bookId, delta) {
        const input = document.getElementById('qty' + bookId);
        let val = parseInt(input.value) + delta;
        if (val < 1) val = 1;
        input.value = val;
    }
</script>

<%-- style lọc review --%>
<style>
.active-filter {
	background-color: #e9a44a !important;
	color: #fff !important;
	border-color: #e9a44a !important;
}

#review-pagination .page-btn {
	padding: 5px 12px;
	border: 1px solid #ddd;
	border-radius: 4px;
	background: #fff;
	cursor: pointer;
	font-size: 14px;
}

#review-pagination .page-btn.active {
	background: #e9a44a;
	color: #fff;
	border-color: #e9a44a;
}

#review-pagination .page-btn:hover:not(.active) {
	background: #f5f5f5;
}
</style>

<script>
(function() {
    const CTX       = '${ctx}';
    const BOOK_ID   = ${book.id};
    const DEFAULT_AVATAR = CTX + '/assets/images/users/default.png';

    let currentStar    = 0;
    let currentHasImg  = false;
    let currentPage    = 1;

    // ===== GỌI API =====
    function fetchReviews() {
        document.getElementById('review-loading').style.display = 'block';
        document.getElementById('review-ol').innerHTML = '';
        document.getElementById('review-empty').style.display = 'none';
        document.getElementById('review-pagination').innerHTML = '';

        const url = CTX + '/reviews/filter?bookId=' + BOOK_ID
            + '&star=' + currentStar
            + '&hasImage=' + (currentHasImg ? '1' : '0')
            + '&page=' + currentPage;

        fetch(url)
            .then(res => res.json())
            .then(data => {
                document.getElementById('review-loading').style.display = 'none';
                renderReviews(data.reviews);
                renderPagination(data.currentPage, data.totalPages);
            })
            .catch(() => {
                document.getElementById('review-loading').style.display = 'none';
            });
    }

    // ===== RENDER REVIEW =====
    function renderReviews(reviews) {
        const ol = document.getElementById('review-ol');
        const empty = document.getElementById('review-empty');

        if (!reviews || reviews.length === 0) {
            empty.style.display = 'block';
            return;
        }

        reviews.forEach(r => {
            const avatar = r.userAvatar && r.userAvatar.trim() !== ''
                ? r.userAvatar : DEFAULT_AVATAR;

            // Render sao
            let stars = '';
            for (let i = 1; i <= 5; i++) {
                stars += '<i class="fa fa-star ' + (i <= r.rating ? 'text-yellow' : 'text-muted') + '"></i>';
            }

            // Render ảnh
            let imgsHtml = '';
            if (r.images && r.images.length > 0) {
                imgsHtml = '<div style="display:flex; gap:10px; margin-top:10px; flex-wrap:wrap;">';
                r.images.forEach(img => {
                    imgsHtml += '<a href="' + img + '" target="_blank">'
                        + '<img src="' + img + '" style="width:100px;height:100px;object-fit:cover;border-radius:4px;border:1px solid #ddd;">'
                        + '</a>';
                });
                imgsHtml += '</div>';
            }

            const li = document.createElement('li');
            li.className = 'comment even thread-even depth-1';

            const body = document.createElement('div');
            body.className = 'comment-body';

            body.innerHTML = 
                '<div class="comment-author vcard">'
                + '<img src="' + avatar + '" alt="" class="avatar">'
                + '<cite class="fn">' + escapeHtml(r.userName) + '</cite>'
                + '<span class="says">đánh giá:</span>'
                + '<div class="dz-rating">' + stars + '</div>'
                + '</div>'
                + '<div class="comment-meta"><a href="javascript:void(0);">' + r.createdAt + '</a></div>'
                + '<p>' + escapeHtml(r.comment) + '</p>'
                + imgsHtml;

            li.appendChild(body);
            ol.appendChild(li);
        });
    }

    // ===== RENDER PHÂN TRANG =====
    function renderPagination(current, total) {
        const container = document.getElementById('review-pagination');
        if (total <= 1) return;

        // Nút Trước
        const prevBtn = document.createElement('button');
        prevBtn.className = 'page-btn';
        prevBtn.textContent = '«';
        prevBtn.disabled = current <= 1;
        prevBtn.onclick = () => { if (current > 1) goToPage(current - 1); };
        container.appendChild(prevBtn);

        // Các nút số trang
        for (let i = 1; i <= total; i++) {
            const btn = document.createElement('button');
            btn.className = 'page-btn' + (i === current ? ' active' : '');
            btn.textContent = i;
            btn.onclick = (function(p) {
                return function() { goToPage(p); };
            })(i);
            container.appendChild(btn);
        }

        // Nút Sau
        const nextBtn = document.createElement('button');
        nextBtn.className = 'page-btn';
        nextBtn.textContent = '»';
        nextBtn.disabled = current >= total;
        nextBtn.onclick = () => { if (current < total) goToPage(current + 1); };
        container.appendChild(nextBtn);

        // Ô "Đi đến trang..."
        const gotoWrap = document.createElement('span');
        gotoWrap.style = 'display:flex; align-items:center; gap:4px; margin-left:8px;';
        gotoWrap.innerHTML =
            '<span style="font-size:13px; color:#555;">Đi đến trang</span>'
            + '<input id="goto-page-input" type="number" min="1" max="' + total + '" '
            + 'style="width:55px; padding:4px 6px; border:1px solid #ddd; border-radius:4px; font-size:13px;" '
            + 'placeholder="...">'
            + '<button class="page-btn" id="goto-page-btn" style="padding:4px 10px;">→</button>';
        container.appendChild(gotoWrap);

        document.getElementById('goto-page-btn').onclick = function() {
            const val = parseInt(document.getElementById('goto-page-input').value);
            if (!isNaN(val) && val >= 1 && val <= total) goToPage(val);
        };
        document.getElementById('goto-page-input').addEventListener('keydown', function(e) {
            if (e.key === 'Enter') document.getElementById('goto-page-btn').click();
        });
    }

    function goToPage(p) {
        currentPage = p;
        fetchReviews();
        // Scroll lên đầu phần review
        document.getElementById('developement-1').scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    // ===== SỰ KIỆN LỌC SAO =====
    document.querySelectorAll('.filter-star-btn').forEach(btn => {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.filter-star-btn').forEach(b => b.classList.remove('active-filter'));
            this.classList.add('active-filter');
            currentStar = parseInt(this.dataset.star);
            currentPage = 1;
            fetchReviews();
        });
    });

    // ===== SỰ KIỆN LỌC CÓ ẢNH =====
    document.getElementById('btn-has-image').addEventListener('click', function() {
        currentHasImg = !currentHasImg;
        this.classList.toggle('active-filter', currentHasImg);
        currentPage = 1;
        fetchReviews();
    });

    // ===== ESCAPE HTML =====
    function escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;')
                  .replace(/</g, '&lt;')
                  .replace(/>/g, '&gt;')
                  .replace(/"/g, '&quot;');
    }

    // ===== LOAD LẦN ĐẦU =====
    fetchReviews();

})();
</script>

<script>
//validate file upload
// Magic bytes của các định dạng ảnh hợp lệ
const MAGIC = {
    jpeg: [0xFF, 0xD8, 0xFF],
    png:  [0x89, 0x50, 0x4E, 0x47],
    gif:  [0x47, 0x49, 0x46, 0x38],
    webp: [0x52, 0x49, 0x46, 0x46]
};

function startsWith(bytes, prefix) {
    for (let i = 0; i < prefix.length; i++) {
        if (bytes[i] !== prefix[i]) return false;
    }
    return true;
}

function isValidImageBytes(bytes) {
    return startsWith(bytes, MAGIC.jpeg)
        || startsWith(bytes, MAGIC.png)
        || startsWith(bytes, MAGIC.gif)
        || startsWith(bytes, MAGIC.webp);
}

function showFileError(msg) {
    document.getElementById('file-error-msg').textContent = msg;
    document.getElementById('file-error').style.display = 'block';
}

function hideFileError() {
    document.getElementById('file-error').style.display = 'none';
}

function submitReview(event) {
    hideFileError();
    const input = document.getElementById('reviewPhotos');
    const files = input.files;

    if (files.length === 0) {
        // Không chọn ảnh thì cho gửi bình thường
        input.closest('form').submit();
        return;
    }

    // Đọc từng file, kiểm tra magic bytes
    let checked = 0;
    let hasError = false;

    Array.from(files).forEach(file => {
        const reader = new FileReader();
        reader.onload = function(e) {
            if (hasError) return;
            const bytes = new Uint8Array(e.target.result);
            if (!isValidImageBytes(bytes)) {
                hasError = true;
                showFileError(
                    '"' + file.name + '" không phải ảnh thật. '
                    + 'Chỉ chấp nhận JPG, PNG, GIF, WEBP. '
                    + 'File có thể đã bị đổi tên để qua mặt hệ thống.'
                );
            }
            checked++;
            // Tất cả file đã được kiểm tra và không có lỗi thì submit
            if (checked === files.length && !hasError) {
                input.closest('form').submit();
            }
        };
        // Chỉ đọc 8 byte đầu tiên — đủ để kiểm tra magic bytes
        reader.readAsArrayBuffer(file.slice(0, 8));
    });
}
</script>
<%@ include file="/WEB-INF/views/base/footer.jsp"%>