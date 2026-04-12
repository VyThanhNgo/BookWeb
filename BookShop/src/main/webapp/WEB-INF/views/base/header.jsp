<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="keywords" content="">
<meta name="author" content="">
<meta name="robots" content="">
<meta name="description" content="Bookland-Book Store Ecommerce Website">
<meta property="og:title"
	content="Bookland-Book Store Ecommerce Website">
<meta property="og:description"
	content="Bookland-Book Store Ecommerce Website">
<meta property="og:image"
	content="https://bookland.dexignzone.com/xhtml/social-image.png">
<meta name="format-detection" content="telephone=no">

<!-- FAVICONS ICON -->
<link rel="shortcut icon" type="image/x-icon" href="images/favicon.png">

<!-- PAGE TITLE HERE -->
<title>${pageTitle != null ? pageTitle : 'Góc Sách'}</title>

<!-- MOBILE SPECIFIC -->
<meta name="viewport" content="width=device-width, initial-scale=1">


<!-- STYLESHEETS -->
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/assets/css/style.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/assets/icons/fontawesome/css/all.min.css">
<!-- FLATICON -->
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/assets/icons/flaticon/font/flaticon.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/assets/vendor/bootstrap-select/dist/css/bootstrap-select.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/assets/vendor/swiper/swiper-bundle.min.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/assets/vendor/nouislider/nouislider.min.css">


<!-- GOOGLE FONTS-->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="">
<link
	href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700;800&amp;family=Poppins:wght@100;200;300;400;500;600;700;800;900&amp;display=swap"
	rel="stylesheet">

</head>
<body>
	<div class="page-wraper">

		<!-- Header -->
		<header class="site-header mo-left header style-1">
			<!-- Main Header -->
			<div class="header-info-bar">
				<div class="container clearfix">
					<!-- Website Logo -->
					<div class="logo-header logo-dark">
						<a href="index.html"><img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="logo"></a>
					</div>

					<!-- EXTRA NAV -->
					<div class="extra-nav">
						<div class="extra-cell">
							<ul class="navbar-nav header-right">
								<li class="nav-item"><a class="nav-link"
									href="wishlist.html"> <svg
											xmlns="http://www.w3.org/2000/svg" height="24px"
											viewBox="0 0 24 24" width="24px" fill="#000000">
											<path d="M0 0h24v24H0V0z" fill="none"></path>
											<path
												d="M16.5 3c-1.74 0-3.41.81-4.5 2.09C10.91 3.81 9.24 3 7.5 3 4.42 3 2 5.42 2 8.5c0 3.78 3.4 6.86 8.55 11.54L12 21.35l1.45-1.32C18.6 15.36 22 12.28 22 8.5 22 5.42 19.58 3 16.5 3zm-4.4 15.55l-.1.1-.1-.1C7.14 14.24 4 11.39 4 8.5 4 6.5 5.5 5 7.5 5c1.54 0 3.04.99 3.57 2.36h1.87C13.46 5.99 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5 0 2.89-3.14 5.74-7.9 10.05z"></path></svg>
										<span class="badge">21</span>
								</a></li>
								<li class="nav-item dropdown">
									<button type="button"
											class="nav-link box cart-btn"
											data-bs-toggle="dropdown"
											aria-expanded="false">
										<svg xmlns="http://www.w3.org/2000/svg" height="24px"
											 viewBox="0 0 24 24" width="24px" fill="#000000">
											<path d="M0 0h24v24H0V0z" fill="none"></path>
											<path
													d="M15.55 13c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.37-.66-.11-1.48-.87-1.48H5.21l-.94-2H1v2h2l3.6 7.59-1.35 2.44C4.52 15.37 5.48 17 7 17h12v-2H7l1.1-2h7.45zM6.16 6h12.15l-2.76 5H8.53L6.16 6zM7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zm10 0c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"></path>
										</svg>

										<span class="badge" id="cart-badge">
    <c:choose>
		<c:when test="${sessionScope.cart != null}">
			${sessionScope.cart.totalItems}
		</c:when>
		<c:otherwise>0</c:otherwise>
	</c:choose>
</span>									</button>

									<ul class="dropdown-menu cart-list dropdown-menu-end" id="mini-cart-list">
										<c:choose>
											<c:when test="${sessionScope.cart != null && not empty sessionScope.cart.items}">
												<c:forEach var="ci" items="${sessionScope.cart.items}">
													<li class="cart-item" data-id="${ci.bookId}">
														<div class="media">
															<div class="media-left">
																<div class="mini-cart-thumb">
																	<img src="${not empty ci.image ? ci.image : pageContext.request.contextPath.concat('/assets/images/books/default-book.png')}"
																		 alt="${ci.title}"
																		 style="width:60px;height:80px;object-fit:cover;border-radius:4px;">
																</div>
															</div>
															<div class="media-body">
																<h6 class="dz-title">
																	<a href="${pageContext.request.contextPath}/books/detail?id=${ci.bookId}"
																	   class="media-heading">
																			${ci.title}
																	</a>
																</h6>
																<span class="dz-price">
                                <fmt:formatNumber value="${ci.price}" pattern="#,###"/> đ x ${ci.quantity}
                            </span>
																<a href="javascript:void(0);"
																   class="item-close js-mini-cart-remove"
																   data-id="${ci.bookId}">×</a>															</div>
														</div>
													</li>
												</c:forEach>

												<li class="cart-item text-center mini-cart-total">
													<h6 class="text-secondary mb-0">
														Total = <fmt:formatNumber value="${sessionScope.cart.totalPrice}" pattern="#,###"/> đ
													</h6>
												</li>

												<li class="text-center d-flex cart-actions-mini">
													<a href="${pageContext.request.contextPath}/cart"
													   class="btn btn-sm btn-primary me-2 btnhover w-100">
														View Cart
													</a>
													<a href="${pageContext.request.contextPath}/order"
													   class="btn btn-sm btn-outline-primary btnhover w-100">
														Checkout
													</a>
												</li>
											</c:when>

											<c:otherwise>
												<li class="cart-item text-center">
													<p class="mb-0">Giỏ hàng đang trống.</p>
												</li>
												<li class="text-center d-flex cart-actions-mini">
													<a href="${pageContext.request.contextPath}/cart"
													   class="btn btn-sm btn-primary me-2 btnhover w-100">
														View Cart
													</a>
													<a href="${pageContext.request.contextPath}/order"
													   class="btn btn-sm btn-outline-primary btnhover w-100">
														Checkout
													</a>
												</li>
											</c:otherwise>
										</c:choose>
									</ul>
								</li>
								<li class="nav-item dropdown profile-dropdown ms-4">
									<a class="nav-link account-toggle" href="javascript:void(0);" role="button"
									   data-bs-toggle="dropdown" aria-expanded="false">
										<img class="account-avatar"
											 src="${pageContext.request.contextPath}/assets/images/profile1.jpg"
											 alt=""
											 onerror="this.src='${pageContext.request.contextPath}/assets/images/default-avatar.png'; this.onerror=null;">

										<div class="profile-info">
											<c:choose>
												<c:when test="${sessionScope.loggedInUser != null}">
													<h6 class="title">${sessionScope.loggedInUser.fullName}</h6>
													<span>${sessionScope.loggedInUser.email}</span>
												</c:when>
												<c:otherwise>
													<h6 class="title">Tài khoản</h6>
													<span>Vui lòng đăng nhập</span>
												</c:otherwise>
											</c:choose>
										</div>
									</a>

									<div class="dropdown-menu py-0 dropdown-menu-end account-dropdown">
										<c:choose>
											<c:when test="${sessionScope.loggedInUser != null}">
												<div class="dropdown-header">
													<h6 class="m-0">${sessionScope.loggedInUser.fullName}</h6>
													<span>${sessionScope.loggedInUser.email}</span>
												</div>

												<div class="dropdown-body">
													<a href="${pageContext.request.contextPath}/profile"
													   class="dropdown-item d-flex align-items-center ai-icon">
														<i class="fa fa-user me-2"></i>
														<span>Thông tin cá nhân</span>
													</a>

													<a href="${pageContext.request.contextPath}/change-password"
													   class="dropdown-item d-flex align-items-center ai-icon">
														<i class="fa fa-key me-2"></i>
														<span>Đổi mật khẩu</span>
													</a>

													<a href="${pageContext.request.contextPath}/order"
													   class="dropdown-item d-flex align-items-center ai-icon">
														<i class="fa fa-shopping-bag me-2"></i>
														<span>Đơn hàng của tôi</span>
													</a>

													<a href="javascript:void(0)"
													   class="dropdown-item d-flex align-items-center ai-icon">
														<i class="fa fa-heart me-2"></i>
														<span>Danh sách yêu thích</span>
													</a>
												</div>

												<div class="dropdown-footer">
													<a class="btn btn-primary w-100 btnhover btn-sm"
													   href="${pageContext.request.contextPath}/logout">
														Đăng xuất
													</a>
												</div>
											</c:when>

											<c:otherwise>
												<div class="dropdown-header">
													<h6 class="m-0">Khách</h6>
													<span>Chào mừng bạn đến với Góc Sách</span>
												</div>

												<div class="dropdown-body">
													<a href="${pageContext.request.contextPath}/login"
													   class="dropdown-item d-flex align-items-center ai-icon">
														<i class="fa fa-sign-in me-2"></i>
														<span>Đăng nhập</span>
													</a>

													<a href="${pageContext.request.contextPath}/register"
													   class="dropdown-item d-flex align-items-center ai-icon">
														<i class="fa fa-user-plus me-2"></i>
														<span>Đăng ký</span>
													</a>
												</div>
											</c:otherwise>
										</c:choose>
									</div>
								</li>									<div class="dropdown-menu py-0 dropdown-menu-end">
										<div class="dropdown-header">
											<h6 class="m-0">Brian</h6>
											<span>info@gmail.com</span>
										</div>
										<div class="dropdown-body">
											<a href="my-profile.html"
												class="dropdown-item d-flex justify-content-between align-items-center ai-icon">
												<div>
													<svg xmlns="http://www.w3.org/2000/svg" height="20px"
														viewBox="0 0 24 24" width="20px" fill="#000000">
														<path d="M0 0h24v24H0V0z" fill="none"></path>
														<path
															d="M12 6c1.1 0 2 .9 2 2s-.9 2-2 2-2-.9-2-2 .9-2 2-2m0 10c2.7 0 5.8 1.29 6 2H6c.23-.72 3.31-2 6-2m0-12C9.79 4 8 5.79 8 8s1.79 4 4 4 4-1.79 4-4-1.79-4-4-4zm0 10c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"></path></svg>
													<span class="ms-2">Profile</span>
												</div>
											</a>
											<a href="shop-cart.html"
												class="dropdown-item d-flex justify-content-between align-items-center ai-icon">
												<div>
													<svg xmlns="http://www.w3.org/2000/svg" height="20px"
														viewBox="0 0 24 24" width="20px" fill="#000000">
														<path d="M0 0h24v24H0V0z" fill="none"></path>
														<path
															d="M15.55 13c.75 0 1.41-.41 1.75-1.03l3.58-6.49c.37-.66-.11-1.48-.87-1.48H5.21l-.94-2H1v2h2l3.6 7.59-1.35 2.44C4.52 15.37 5.48 17 7 17h12v-2H7l1.1-2h7.45zM6.16 6h12.15l-2.76 5H8.53L6.16 6zM7 18c-1.1 0-1.99.9-1.99 2S5.9 22 7 22s2-.9 2-2-.9-2-2-2zm10 0c-1.1 0-1.99.9-1.99 2s.89 2 1.99 2 2-.9 2-2-.9-2-2-2z"></path></svg>
													<span class="ms-2">My Order</span>
												</div>
											</a> <a href="wishlist.html"
												class="dropdown-item d-flex justify-content-between align-items-center ai-icon">
												<div>
													<svg xmlns="http://www.w3.org/2000/svg" height="20px"
														viewBox="0 0 24 24" width="20px" fill="#000000">
														<path d="M0 0h24v24H0V0z" fill="none"></path>
														<path
															d="M16.5 3c-1.74 0-3.41.81-4.5 2.09C10.91 3.81 9.24 3 7.5 3 4.42 3 2 5.42 2 8.5c0 3.78 3.4 6.86 8.55 11.54L12 21.35l1.45-1.32C18.6 15.36 22 12.28 22 8.5 22 5.42 19.58 3 16.5 3zm-4.4 15.55l-.1.1-.1-.1C7.14 14.24 4 11.39 4 8.5 4 6.5 5.5 5 7.5 5c1.54 0 3.04.99 3.57 2.36h1.87C13.46 5.99 14.96 5 16.5 5c2 0 3.5 1.5 3.5 3.5 0 2.89-3.14 5.74-7.9 10.05z"></path></svg>
													<span class="ms-2">Wishlist</span>
												</div>
											</a>
										</div>
										<div class="dropdown-footer">
											<a class="btn btn-primary w-100 btnhover btn-sm"
												href="shop-login.html">Log Out</a>
										</div>
									</div>
								</li>
							</ul>
						</div>
					</div>

					<!-- header search nav -->
					<div class="header-search-nav">
						<form class="header-item-search"
							action="${pageContext.request.contextPath}/books" method="get">
							<div class="input-group search-input">
								<div class="dropdown bootstrap-select default-select">
									<select class="default-select" name="categoryId">
										<option value="">Danh mục</option>
										<c:forEach var="cat" items="${categories}">
											<option value="${cat.id}">${cat.name}</option>
										</c:forEach>
									</select>
									<button type="button" tabindex="-1"
										class="btn dropdown-toggle btn-light"
										data-bs-toggle="dropdown" role="combobox"
										aria-owns="bs-select-1" aria-haspopup="listbox"
										aria-expanded="false" title="Category">
										<div class="filter-option">
											<div class="filter-option-inner">
												<div class="filter-option-inner-inner">Danh mục</div>
											</div>
										</div>
									</button>
									<div class="dropdown-menu ">
										<div class="inner show" role="listbox" id="bs-select-1"
											tabindex="-1">
											<ul class="dropdown-menu inner show" role="presentation"></ul>
										</div>
									</div>
								</div>
								<input type="text" name="keyword" class="form-control"
									aria-label="Text input with dropdown button"
									placeholder="Nhập tên sách để tìm..." value="${keyword}"
									fdprocessedid="4p8wu9">
								<button class="btn" type="submit" fdprocessedid="1sapa">
									<i class="flaticon-loupe"></i>
								</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<!-- Main Header End -->

			<!-- Main Header -->
			<div class="sticky-header main-bar-wraper navbar-expand-lg">
				<div class="main-bar clearfix">
					<div class="container clearfix">
						<!-- Website Logo -->
						<div class="logo-header logo-dark">
							<a href="index.html"><img src="images/logo.png" alt="logo"></a>
						</div>

						<!-- Nav Toggle Button -->
						<button
							class="navbar-toggler collapsed navicon justify-content-end"
							type="button" data-bs-toggle="collapse"
							data-bs-target="#navbarNavDropdown"
							aria-controls="navbarNavDropdown" aria-expanded="false"
							aria-label="Toggle navigation">
							<span></span> <span></span> <span></span>
						</button>

						<!-- EXTRA NAV -->
						<div class="extra-nav">
							<div class="extra-cell">
								<a href="contact-us.html" class="btn btn-primary btnhover">Liên Hệ Ngay</a>
							</div>
						</div>

						<!-- Main Nav -->
						<div
							class="header-nav navbar-collapse collapse justify-content-start"
							id="navbarNavDropdown">
							<div class="logo-header logo-dark">
								<a href="index.html"><img src="images/logo.png" alt=""></a>
							</div>
							<form class="search-input">
								<div class="input-group">
									<input type="text" class="form-control"
										aria-label="Text input with dropdown button"
										placeholder="Search Books Here">
									<button class="btn" type="button">
										<i class="flaticon-loupe"></i>
									</button>
								</div>
							</form>
							<ul class="nav navbar-nav">
								<li ><a href="javascript:void(0);"><span>Trang chủ</span></a>
									</li>
								<li class="sub-menu-down"><a href="javascript:void(0);"><span>Các trang khác</span></a>
									<ul class="sub-menu">
										<li><a href="about-us.html"><span>About Us</span></a></li>
										<li><a href="my-profile.html">My Profile</a></li>
										<li><a href="services.html">Services</a></li>
										<li><a href="faq.html">FAQ's</a></li>
										<li><a href="help-desk.html">Help Desk</a></li>
										<li><a href="coming-soon.html">Coming Soon</a></li>
										<li><a href="pricing.html">Pricing</a></li>
										<li><a href="privacy-policy.html">Privacy Policy</a></li>
										<li><a href="under-construction.html">Under
												Construction</a></li>
										<li><a href="error-404.html">Error 404</a></li>
									</ul></li>
								<li ><a href="${pageContext.request.contextPath}/books"><span>Sản phẩm</span></a>
									</li>
								<li class="sub-menu-down"><a href="javascript:void(0);"><span>Bài viết</span></a>
									<ul class="sub-menu">
										<li><a href="javascript:void(0);">Page Layout <i
												class="fa fa-angle-right"></i></a>
											<ul class="sub-menu">
												<li><a href="javascript:void(0);">No Sidebar <i
														class="fa fa-angle-right"></i></a>
													<ul class="sub-menu">
														<li><a href="blog-list-no-sidebar.html">Blog List</a></li>
														<li><a href="blog-grid-no-sidebar.html">Blog Grid</a></li>
														<li><a href="blog-grid-wide.html">Blog Grid Wide</a></li>
													</ul></li>
												<li><a href="javascript:void(0);">2 Columns <i
														class="fa fa-angle-right"></i></a>
													<ul class="sub-menu">
														<li><a href="blog-list-right-sidebar.html">Blog
																List</a></li>
														<li><a href="blog-grid-right-sidebar.html">Blog
																Grid</a></li>
													</ul></li>
												<li><a href="javascript:void(0);">3 Columns <i
														class="fa fa-angle-right"></i></a>
													<ul class="sub-menu">
														<li><a href="blog-list-both-sidebar.html">Blog
																List</a></li>
														<li><a href="blog-grid-both-sidebar.html">Blog
																Grid</a></li>
													</ul></li>
											</ul></li>
										<li><a href="javascript:void(0);">Blog Sidebar <i
												class="fa fa-angle-right"></i></a>
											<ul class="sub-menu">
												<li><a href="javascript:void(0);">No Sidebar <i
														class="fa fa-angle-right"></i></a>
													<ul class="sub-menu">
														<li><a href="blog-list-no-sidebar.html">Blog List</a></li>
														<li><a href="blog-grid-no-sidebar.html">Blog Grid</a></li>
													</ul></li>
												<li><a href="javascript:void(0);">Left Sidebar <i
														class="fa fa-angle-right"></i></a>
													<ul class="sub-menu">
														<li><a href="blog-list-left-sidebar.html">Blog
																List</a></li>
														<li><a href="blog-grid-left-sidebar.html">Blog
																Grid</a></li>
													</ul></li>
												<li><a href="javascript:void(0);">Right Sidebar <i
														class="fa fa-angle-right"></i></a>
													<ul class="sub-menu">
														<li><a href="blog-list-right-sidebar.html">Blog
																List</a></li>
														<li><a href="blog-grid-right-sidebar.html">Blog
																Grid</a></li>
													</ul></li>
												<li><a href="javascript:void(0);">2 Sidebar <i
														class="fa fa-angle-right"></i></a>
													<ul class="sub-menu">
														<li><a href="blog-list-both-sidebar.html">Blog
																List</a></li>
														<li><a href="blog-grid-both-sidebar.html">Blog
																Grid</a></li>
													</ul></li>
											</ul></li>
									</ul></li>

								<li><a href="contact-us.html">Liên hệ</a></li>
							</ul>

							<div class="dz-social-icon">
								<ul>
									<li><a class="fab fa-facebook-f" target="_blank"
										href="https://www.facebook.com/dexignzone"></a></li>
									<li><a class="fab fa-twitter" target="_blank"
										href="https://twitter.com/dexignzones"></a></li>
									<li><a class="fab fa-linkedin-in" target="_blank"
										href="https://www.linkedin.com/showcase/3686700/admin/"></a></li>
									<li><a class="fab fa-instagram" target="_blank"
										href="https://www.instagram.com/website_templates__/"></a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- Main Header End -->
			<script>
				function formatMoney(value) {
					return Number(value || 0).toLocaleString('vi-VN');
				}

				function updateMiniCartUI(data) {
					const list = document.getElementById('mini-cart-list');
					const ctx = '${pageContext.request.contextPath}';

					if (!list || !data || !data.item) return;

					const item = data.item;

					const emptyText = list.querySelector('.cart-item p');
					if (emptyText) {
						list.innerHTML = '';
					}

					const existingItem = list.querySelector('.cart-item[data-id="' + item.id + '"]');
					if (existingItem) {
						const priceEl = existingItem.querySelector('.dz-price');
						if (priceEl) {
							priceEl.textContent = formatMoney(item.price) + ' đ x ' + item.quantity;
						}
					} else {
						const itemHtml =
								'<li class="cart-item" data-id="' + item.id + '">' +
								'<div class="media">' +
								'<div class="media-left">' +
								'<div class="mini-cart-thumb">' +
								'<img src="' + (item.image && item.image.trim() !== '' ? item.image : ctx + '/assets/images/books/default-book.png') + '"' +
								' style="width:60px;height:80px;object-fit:cover;border-radius:4px;">' +
								'</div>' +
								'</div>' +
								'<div class="media-body">' +
								'<h6 class="dz-title">' +
								'<a href="' + ctx + '/books/detail?id=' + item.id + '" class="media-heading">' +
								item.title +
								'</a>' +
								'</h6>' +
								'<span class="dz-price">' + formatMoney(item.price) + ' đ x ' + item.quantity + '</span>' +
								'<a href="javascript:void(0);" class="item-close js-mini-cart-remove" data-id="' + item.id + '">×</a>' +
								'</div>' +
								'</div>' +
								'</li>';
						list.insertAdjacentHTML('afterbegin', itemHtml);
					}

					let totalRow = list.querySelector('.mini-cart-total');
					if (!totalRow) {
						totalRow = document.createElement('li');
						totalRow.className = 'cart-item text-center mini-cart-total';
						list.insertAdjacentElement('beforeend', totalRow);
					}
					totalRow.innerHTML =
							'<h6 class="text-secondary mb-0">Total = ' + formatMoney(data.totalPrice) + ' đ</h6>';
					let actionsRow = list.querySelector('.cart-actions-mini');
					if (!actionsRow) {
						const li = document.createElement('li');
						li.className = 'text-center d-flex cart-actions-mini';
						li.innerHTML =
								'<a href="' + ctx + '/cart" class="btn btn-sm btn-primary me-2 btnhover w-100">View Cart</a>' +
								'<a href="' + ctx + '/order" class="btn btn-sm btn-outline-primary btnhover w-100">Checkout</a>';						list.appendChild(li);
					}
				}
			</script>
			<script>
				document.addEventListener('click', function(e) {
					const btn = e.target.closest('.js-mini-cart-remove');
					if (!btn) return;

					e.preventDefault();
					e.stopPropagation();

					const bookId = btn.getAttribute('data-id');
					const ctx = '${pageContext.request.contextPath}';
					const list = document.getElementById('mini-cart-list');

					fetch(ctx + '/cart?action=remove&id=' + encodeURIComponent(bookId), {
						method: 'GET',
						headers: {
							'X-Requested-With': 'XMLHttpRequest'
						}
					})
							.then(res => res.json())
							.then(data => {
								if (data.success) {
									const item = list.querySelector('.cart-item[data-id="' + bookId + '"]');
									if (item) item.remove();

									const badge = document.getElementById('cart-badge');
									if (badge) badge.textContent = data.totalItems;

									const totalRow = list.querySelector('.mini-cart-total');
									if (totalRow) {
										totalRow.innerHTML =
												'<h6 class="text-secondary mb-0">Total = ' +
												Number(data.totalPrice).toLocaleString('vi-VN') +
												' đ</h6>';
									}

									const remain = list.querySelectorAll('.cart-item[data-id]');
									if (remain.length === 0) {
										list.innerHTML =
												'<li class="cart-item text-center">' +
												'<p class="mb-0">Giỏ hàng đang trống.</p>' +
												'</li>' +
												'<li class="text-center d-flex cart-actions-mini">' +
												'<a href="' + ctx + '/cart" class="btn btn-sm btn-primary me-2 w-100">View Cart</a>' +
												'<a href="' + ctx + '/order" class="btn btn-sm btn-outline-primary w-100">Checkout</a>' +
												'</li>';
									}
								}
							})
							.catch(err => console.error('Mini cart remove error:', err));
				});
			</script>
		</header>
		<!-- Header End -->