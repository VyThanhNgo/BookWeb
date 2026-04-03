<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="base/header.jsp"/>

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/home.css">
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,600;0,700;1,400;1,600&family=Be+Vietnam+Pro:wght@300;400;500;600;700&display=swap"
      rel="stylesheet">

<div class="page-content">

    <section class="hero-home">
        <div class="hero-circle-secondary"></div>
        <div class="hero-bg-dots"></div>

        <div class="container hero-content">
            <div class="row align-items-center hero-row">
                <!-- LEFT: text -->
                <div class="col-lg-6 hero-text-col">
                    <div class="hero-label">
                        <span class="pulse-dot"></span>
                        Chào mừng đến BookShop
                    </div>

                    <h1 class="hero-title">
                        Khám phá <span class="text-highlight">Thế giới</span><br>
                        qua từng trang sách
                    </h1>

                    <p class="hero-desc">
                        Hàng nghìn đầu sách hay đang chờ bạn. Từ tiểu thuyết lãng mạn
                        đến sách kinh doanh — tất cả có tại BookShop với giá tốt nhất.
                    </p>

                    <div class="hero-btn-group">
                        <a href="${pageContext.request.contextPath}/books" class="btn-hero-primary">
                            <i class="fas fa-book-open"></i>
                            Khám phá ngay
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn-hero-secondary">
                            <i class="fas fa-user-plus"></i>
                            Đăng ký miễn phí
                        </a>
                    </div>

                    <div class="hero-stats">
                        <div class="hero-stat-item">
                            <span class="stat-number">5k<span class="accent">+</span></span>
                            <span class="stat-label">Đầu sách</span>
                        </div>
                        <div class="hero-stat-separator"></div>
                        <div class="hero-stat-item">
                            <span class="stat-number">20k<span class="accent">+</span></span>
                            <span class="stat-label">Khách hàng</span>
                        </div>
                        <div class="hero-stat-separator"></div>
                        <div class="hero-stat-item">
                            <span class="stat-number">4.9<span class="accent">★</span></span>
                            <span class="stat-label">Đánh giá</span>
                        </div>
                    </div>
                </div>

                <!-- RIGHT: large image, overflows upward -->
                <div class="col-lg-6 hero-img-col-wrap">
                    <div class="hero-image-scene">
                        <!-- decorative blobs -->
                        <div class="img-blob img-blob-1"></div>
                        <div class="img-blob img-blob-2"></div>

                        <!-- floating info card -->
                        <div class="hero-float-card hero-float-readers">
                            <div class="float-card-icon"><i class="fas fa-users"></i></div>
                            <div class="float-card-text">
                                <strong>12.5k</strong>
                                <span>Độc giả online</span>
                            </div>
                        </div>

                        <!-- floating rating card -->
                        <div class="hero-float-card hero-float-rating">
                            <div class="float-card-icon star"><i class="fas fa-star"></i></div>
                            <div class="float-card-text">
                                <strong>4.9 / 5</strong>
                                <span>Đánh giá trung bình</span>
                            </div>
                        </div>

                        <div class="hero-image-frame">
                            <img class="hero-book-image"
                                 src="${pageContext.request.contextPath}/assets/images/books/book-placeholder.png"
                                 alt="Sách hay tại BookShop"
                                 onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=700&q=80'">
                            <div class="hero-img-shine"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <style>
        /* ====================================================
           HERO CONTENT — IMPROVED UX/UI
           ==================================================== */

        /* Subtle dot-grid background texture */
        .hero-bg-dots {
            position: absolute;
            inset: 0;
            background-image: radial-gradient(circle, rgba(var(--color-primary-rgb, 26,22,104), 0.07) 1px, transparent 1px);
            background-size: 28px 28px;
            pointer-events: none;
            z-index: 0;
        }

        /* Keep hero-home relative for absolute children */
        .hero-home { position: relative; overflow: visible; }

        /* Row: allow right column to overflow top */
        .hero-row { position: relative; }

        /* Left text column — slide in from left */
        .hero-text-col {
            animation: heroTextIn 0.8s cubic-bezier(0.22, 1, 0.36, 1) both;
        }
        @keyframes heroTextIn {
            from { opacity: 0; transform: translateX(-36px); }
            to   { opacity: 1; transform: translateX(0); }
        }

        /* Stat separators */
        .hero-stat-separator {
            width: 1px;
            height: 36px;
            background: rgba(0,0,0,0.12);
            align-self: center;
            margin: 0 4px;
        }

        /* ── RIGHT COLUMN ── */
        .hero-img-col-wrap {
            position: relative;
            display: flex;
            justify-content: flex-end;
            /* Allow image to overflow the section upward */
            overflow: visible;
            animation: heroImgIn 0.9s 0.15s cubic-bezier(0.22, 1, 0.36, 1) both;
        }
        @keyframes heroImgIn {
            from { opacity: 0; transform: translateY(30px) scale(0.96); }
            to   { opacity: 1; transform: translateY(0) scale(1); }
        }

        .hero-image-scene {
            position: relative;
            width: 100%;
            max-width: 580px;   /* wider than before */
            /* Pull image upward so it overflows the section top */
            margin-top: -60px;
        }

        /* Decorative blobs behind the image */
        .img-blob {
            position: absolute;
            border-radius: 50%;
            filter: blur(48px);
            pointer-events: none;
            z-index: 0;
        }
        .img-blob-1 {
            width: 340px; height: 340px;
            top: 10%; right: -40px;
            background: radial-gradient(circle, rgba(234,164,81,0.25), transparent 70%);
            animation: blobFloat 7s ease-in-out infinite alternate;
        }
        .img-blob-2 {
            width: 260px; height: 260px;
            bottom: 5%; left: 0;
            background: radial-gradient(circle, rgba(26,22,104,0.18), transparent 70%);
            animation: blobFloat 9s 2s ease-in-out infinite alternate-reverse;
        }
        @keyframes blobFloat {
            from { transform: translate(0, 0) scale(1); }
            to   { transform: translate(12px, -16px) scale(1.06); }
        }

        /* Image frame */
        .hero-image-frame {
            position: relative;
            z-index: 2;
            border-radius: 28px;
            overflow: hidden;
            box-shadow:
                    0 30px 80px rgba(0,0,0,0.22),
                    0  8px 24px rgba(0,0,0,0.12),
                    inset 0 0 0 1px rgba(255,255,255,0.15);
        }

        .hero-book-image {
            width: 100%;
            height: 560px;          /* taller */
            object-fit: cover;
            object-position: center top;
            display: block;
            transition: transform 0.7s cubic-bezier(0.22, 1, 0.36, 1);
        }
        .hero-image-frame:hover .hero-book-image {
            transform: scale(1.04);
        }

        /* Subtle light-sweep shine on hover */
        .hero-img-shine {
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,255,255,0.18) 0%, transparent 50%);
            border-radius: 28px;
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.4s;
        }
        .hero-image-frame:hover .hero-img-shine { opacity: 1; }

        /* ── FLOATING CARDS ── */
        .hero-float-card {
            position: absolute;
            z-index: 4;
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255,255,255,0.92);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.6);
            border-radius: 16px;
            padding: 12px 18px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.13);
            animation: cardFloat 4s ease-in-out infinite alternate;
        }
        .hero-float-readers {
            bottom: 60px;
            left: -20px;
            animation-delay: 0s;
        }
        .hero-float-rating {
            top: 80px;
            right: -10px;
            animation-delay: 1.5s;
        }
        @keyframes cardFloat {
            from { transform: translateY(0); }
            to   { transform: translateY(-8px); }
        }

        .float-card-icon {
            width: 38px; height: 38px;
            border-radius: 10px;
            background: linear-gradient(135deg, #1a1668, #3a35aa);
            display: flex; align-items: center; justify-content: center;
            color: #fff;
            font-size: 15px;
            flex-shrink: 0;
        }
        .float-card-icon.star {
            background: linear-gradient(135deg, #EAA451, #f5c842);
        }
        .float-card-text {
            display: flex; flex-direction: column; line-height: 1.2;
        }
        .float-card-text strong {
            font-size: 15px; font-weight: 700; color: #1a1668;
        }
        .float-card-text span {
            font-size: 11px; color: #666;
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 991px) {
            .hero-image-scene { margin-top: 0; max-width: 100%; }
            .hero-book-image  { height: 380px; }
            .hero-float-readers { left: 10px; }
            .hero-float-rating  { right: 10px; }
        }
        @media (max-width: 575px) {
            .hero-book-image { height: 280px; }
            .hero-float-card { padding: 8px 12px; }
        }
    </style>

    <section class="feature-strip">
        <div class="container">
            <div class="row g-0">
                <div class="col-lg-3 col-md-6 reveal-item delay-100">
                    <div class="feature-strip-item">
                        <div class="feature-icon-box"><i class="fas fa-shipping-fast"></i></div>
                        <div class="feature-text">
                            <h6>Giao hàng nhanh</h6>
                            <small>Miễn phí ship cho đơn từ 200k</small>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 reveal-item delay-200">
                    <div class="feature-strip-item">
                        <div class="feature-icon-box"><i class="fas fa-undo-alt"></i></div>
                        <div class="feature-text">
                            <h6>Đổi trả dễ dàng</h6>
                            <small>Không lo — đổi trả trong 7 ngày</small>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 reveal-item delay-300">
                    <div class="feature-strip-item">
                        <div class="feature-icon-box"><i class="fas fa-headset"></i></div>
                        <div class="feature-text">
                            <h6>Hỗ trợ 24/7</h6>
                            <small>Tư vấn nhiệt tình, phản hồi ngay</small>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6 reveal-item delay-400">
                    <div class="feature-strip-item">
                        <div class="feature-icon-box"><i class="fas fa-medal"></i></div>
                        <div class="feature-text">
                            <h6>Sách chính hãng</h6>
                            <small>100% bản quyền, cam kết chất lượng</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="home-section">
        <div class="container">
            <div class="slider-header">
                <div class="section-title reveal-item">
                    <span class="sub-label">Mới nhất</span>
                    <h2>Sách mới về</h2>
                    <p class="sub-desc">Cập nhật những đầu sách hot nhất trên thị trường</p>
                </div>
                <div class="slider-nav-btns reveal-item delay-200">
                    <button class="btn-slider-prev" id="prevNew" title="Trước">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="btn-slider-next" id="nextNew" title="Tiếp">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>

            <div class="swiper home-swiper new-books-slider">
                <div class="swiper-wrapper">
                    <c:forEach var="book" items="${newBooks}">
                        <div class="swiper-slide">
                            <div class="book-card reveal-item">
                                <div class="card-image">
                                    <span class="badge-tag new">Mới</span>
                                    <c:choose>
										<c:when test="${not empty book.image}">
										    <img src="${pageContext.request.contextPath}/assets/images/books/${book.image}"
										         alt="${book.title}" loading="lazy">
										</c:when>
                                        <c:otherwise>
                                            <img src="https://via.placeholder.com/300x400/f0eef8/1a1668?text=${book.title}"
                                                 alt="${book.title}" loading="lazy">
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="card-overlay">
                                        <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}"
                                           class="btn-detail">
                                            <i class="fas fa-eye"></i> Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="category-label">
                                        <c:if test="${not empty book.category}">${book.category.name}</c:if>
                                    </div>
                                    <h4 class="book-title">
                                        <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}">${book.title}</a>
                                    </h4>
                                    <div class="author-name">
                                        <i class="fas fa-feather-alt"></i>
                                        <c:choose>
                                            <c:when test="${not empty book.author}">${book.author.name}</c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="price-cart-row">
                                        <span class="book-price">
                                            <fmt:formatNumber value="${book.price}" type="currency" currencySymbol=""
                                                              maxFractionDigits="0"/>đ
                                        </span>
                                        <button class="btn-add-cart" title="Thêm vào giỏ"
                                                onclick="addToCart(${book.id})">
                                            <i class="fas fa-cart-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty newBooks}">
                        <div class="swiper-slide">
                            <div class="book-card">
                                <div class="card-image">
                                    <img src="https://via.placeholder.com/300x400/f0eef8/1a1668?text=Coming+Soon"
                                         alt="Sắp có">
                                </div>
                                <div class="card-body">
                                    <div class="category-label">Sắp ra mắt</div>
                                    <h4 class="book-title">Đang cập nhật sách mới...</h4>
                                    <div class="author-name"><i class="fas fa-feather-alt"></i> BookShop</div>
                                    <div class="price-cart-row"><span class="book-price">---</span></div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <div class="swiper-pagination"></div>
            </div>
        </div>
    </section>

    <div class="container">
        <div class="promo-banner reveal-item">
            <div class="row align-items-center">
                <div class="col-lg-8">
                    <div class="banner-content">
                        <div class="promo-tag">
                            <i class="fas fa-tag"></i> Ưu đãi đặc biệt
                        </div>
                        <h3>
                            Giảm <span class="highlight">30%</span> cho<br>
                            đơn hàng đầu tiên của bạn!
                        </h3>
                        <p>Đăng ký thành viên ngay hôm nay để nhận ưu đãi hấp dẫn. Nhanh tay kẻo lỡ — chương trình có
                            giới hạn!</p>
                        <a href="${pageContext.request.contextPath}/register" class="btn-hero-primary">
                            <i class="fas fa-user-plus"></i>
                            Đăng ký ngay
                        </a>
                    </div>
                </div>
                <div class="col-lg-4 d-none d-lg-block">
                    <div class="banner-icon-side">
                        <div class="banner-icon-large">
                            <i class="fas fa-gift"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <section class="home-section bg-light">
        <div class="container">
            <div class="section-title text-center reveal-item">
                <span class="sub-label">Thể loại</span>
                <h2>Danh mục sách</h2>
                <p class="sub-desc">Duyệt qua các thể loại sách mà bạn yêu thích</p>
            </div>

            <div class="category-grid">
                <c:forEach var="cat" items="${categories}">
                    <a href="${pageContext.request.contextPath}/books?categoryId=${cat.id}"
                       class="category-card reveal-item">
                        <div class="category-icon">
                            <c:choose>
                                <c:when test="${cat.name eq 'Tiểu thuyết'}"><i class="fas fa-book"></i></c:when>
                                <c:when test="${cat.name eq 'Công nghệ'}"><i class="fas fa-laptop-code"></i></c:when>
                                <c:when test="${cat.name eq 'Kinh tế'}"><i class="fas fa-chart-line"></i></c:when>
                                <c:when test="${cat.name eq 'Tâm lý'}"><i class="fas fa-brain"></i></c:when>
                                <c:when test="${cat.name eq 'Thiếu nhi'}"><i class="fas fa-child"></i></c:when>
                                <c:otherwise><i class="fas fa-bookmark"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <h5>${cat.name}</h5>
                        <span>Xem sách</span>
                    </a>
                </c:forEach>

                <c:if test="${empty categories}">
                    <div class="category-card reveal-item delay-100">
                        <div class="category-icon"><i class="fas fa-book"></i></div>
                        <h5>Tiểu thuyết</h5><span>Đang cập nhật</span>
                    </div>
                    <div class="category-card reveal-item delay-200">
                        <div class="category-icon"><i class="fas fa-laptop-code"></i></div>
                        <h5>Công nghệ</h5><span>Đang cập nhật</span>
                    </div>
                    <div class="category-card reveal-item delay-300">
                        <div class="category-icon"><i class="fas fa-chart-line"></i></div>
                        <h5>Kinh tế</h5><span>Đang cập nhật</span>
                    </div>
                    <div class="category-card reveal-item delay-400">
                        <div class="category-icon"><i class="fas fa-brain"></i></div>
                        <h5>Tâm lý</h5><span>Đang cập nhật</span>
                    </div>
                </c:if>
            </div>
        </div>
    </section>

    <section class="home-section">
        <div class="container">
            <div class="slider-header">
                <div class="section-title reveal-item">
                    <span class="sub-label">Được yêu thích</span>
                    <h2>Sách bán chạy</h2>
                    <p class="sub-desc">Những cuốn được mua nhiều nhất tháng này</p>
                </div>
                <div class="slider-nav-btns reveal-item delay-200">
                    <button class="btn-slider-prev" id="prevHot" title="Trước">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="btn-slider-next" id="nextHot" title="Tiếp">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </div>
            </div>

            <div class="swiper home-swiper hot-books-slider">
                <div class="swiper-wrapper">
                    <c:forEach var="book" items="${bestSellers}">
                        <div class="swiper-slide">
                            <div class="book-card reveal-item">
                                <div class="card-image">
                                    <span class="badge-tag hot">Hot</span>
									<c:choose>
									    <c:when test="${not empty book.image}">
									        <%-- Đảm bảo có dấu / trước assets --%>
									        <img src="${pageContext.request.contextPath}/assets/images/books/${book.image}" 
									             alt="${book.title}" loading="lazy">
									    </c:when>
									    <c:otherwise>
									        <%-- Hiện ảnh mặc định từ internet nếu database trống --%>
									        <img src="https://via.placeholder.com/300x400/1a1668/EAA451?text=${book.title}"
									             alt="${book.title}" loading="lazy">
									    </c:otherwise>
									</c:choose>
                                    <div class="card-overlay">
                                        <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}"
                                           class="btn-detail">
                                            <i class="fas fa-eye"></i> Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div class="category-label">
                                        <c:if test="${not empty book.category}">${book.category.name}</c:if>
                                    </div>
                                    <h4 class="book-title">
                                        <a href="${pageContext.request.contextPath}/books/detail?id=${book.id}">${book.title}</a>
                                    </h4>
                                    <div class="author-name">
                                        <i class="fas fa-feather-alt"></i>
                                        <c:choose>
                                            <c:when test="${not empty book.author}">${book.author.name}</c:when>
                                            <c:otherwise>Chưa cập nhật</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="price-cart-row">
                                        <span class="book-price">
                                            <fmt:formatNumber value="${book.price}" type="currency" currencySymbol=""
                                                              maxFractionDigits="0"/>đ
                                        </span>
                                        <button class="btn-add-cart" title="Thêm vào giỏ"
                                                onclick="addToCart(${book.id})">
                                            <i class="fas fa-cart-plus"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty bestSellers}">
                        <div class="swiper-slide">
                            <div class="book-card">
                                <div class="card-image">
                                    <img src="https://via.placeholder.com/300x400/1a1668/EAA451?text=Best+Seller"
                                         alt="Bán chạy">
                                </div>
                                <div class="card-body">
                                    <div class="category-label">Best Seller</div>
                                    <h4 class="book-title">Đang cập nhật...</h4>
                                    <div class="author-name"><i class="fas fa-feather-alt"></i> BookShop</div>
                                    <div class="price-cart-row"><span class="book-price">---</span></div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <div class="swiper-pagination"></div>
            </div>
        </div>
    </section>

    <section class="cta-section">
        <div class="container">
            <div class="cta-content reveal-item">
                <div class="cta-label">
                    <i class="fas fa-star"></i> Bắt đầu ngay hôm nay
                </div>
                <h2>
                    Sẵn sàng để đọc<br>
                    những cuốn sách <em>tuyệt vời</em>?
                </h2>
                <p>
                    Khám phá hàng nghìn đầu sách hay với giá tốt nhất —
                    giao hàng tận tay, đổi trả dễ dàng.
                </p>
                <div class="cta-btn-group">
                    <a href="${pageContext.request.contextPath}/books" class="btn-cta-primary">
                        <i class="fas fa-store"></i> Xem tất cả sách
                    </a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-cta-outline">
                        <i class="fas fa-user-plus"></i> Tạo tài khoản miễn phí
                    </a>
                </div>
            </div>
        </div>
    </section>

</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var sliderConfig = {
            slidesPerView: 1,
            spaceBetween: 20,
            loop: false,
            pagination: {
                el: '.swiper-pagination',
                clickable: true
            },
            breakpoints: {
                576: {slidesPerView: 2},
                768: {slidesPerView: 3},
                1200: {slidesPerView: 4}
            }
        };

        var newBooksSwiper = null;
        if (document.querySelector('.new-books-slider')) {
            newBooksSwiper = new Swiper('.new-books-slider', sliderConfig);
            document.getElementById('prevNew')?.addEventListener('click', function () {
                newBooksSwiper.slidePrev();
            });
            document.getElementById('nextNew')?.addEventListener('click', function () {
                newBooksSwiper.slideNext();
            });
        }

        var hotBooksSwiper = null;
        if (document.querySelector('.hot-books-slider')) {
            hotBooksSwiper = new Swiper('.hot-books-slider', sliderConfig);
            document.getElementById('prevHot')?.addEventListener('click', function () {
                hotBooksSwiper.slidePrev();
            });
            document.getElementById('nextHot')?.addEventListener('click', function () {
                hotBooksSwiper.slideNext();
            });
        }

        var revealElements = document.querySelectorAll('.reveal-item');
        if ('IntersectionObserver' in window) {
            var observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('visible');
                        observer.unobserve(entry.target);
                    }
                });
            }, {
                threshold: 0.08,
                rootMargin: '0px 0px -35px 0px'
            });

            revealElements.forEach(function (el) {
                observer.observe(el);
            });
        } else {
            revealElements.forEach(function (el) {
                el.classList.add('visible');
            });
        }
    });

    function addToCart(bookId) {
        window.location.href = '${pageContext.request.contextPath}/cart?action=add&bookId=' + bookId + '&quantity=1';
    }
</script>

<jsp:include page="base/footer.jsp"/>
