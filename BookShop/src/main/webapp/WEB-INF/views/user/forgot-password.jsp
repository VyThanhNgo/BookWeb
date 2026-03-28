<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Quên mật khẩu - BookShop" scope="request" />
<jsp:include page="../base/header.jsp" />

<div class="page-content">
    <!-- Inner Page Banner -->
    <div class="dz-bnr-inr overlay-secondary-dark dz-bnr-inr-sm" style="background-image:url(${pageContext.request.contextPath}/assets/images/background/bg3.jpg);">
        <div class="container">
            <div class="dz-bnr-inr-entry">
                <h1>Quên Mật Khẩu</h1>
                <nav aria-label="breadcrumb" class="breadcrumb-row">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Quên mật khẩu</li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
    <!-- Inner Page Banner End -->

    <!-- Forgot Password Section -->
    <section class="content-inner shop-account">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8 m-b30">
                    <div class="login-form shop-form">
                        <div class="logo-header text-center mb-4 w-100">
                            <h3 class="title">Quên Mật Khẩu?</h3>
                            <p class="text-muted">Nhập email của bạn để đặt lại mật khẩu</p>
                        </div>

                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <svg viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" class="me-2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form method="POST" action="${pageContext.request.contextPath}/forgot-password" class="dz-form">
                            <input type="hidden" name="action" value="verify-email">
                            
                            <div class="form-group mb-4">
                                <label class="font-weight-700 mb-2">Email <span class="text-danger">*</span></label>
                                <input name="email" required type="email" class="form-control" 
                                       placeholder="Nhập email của bạn" value="${param.email}">
                            </div>
                            
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary btnhover w-100">
                                    <i class="fas fa-envelope me-2"></i> Xác nhận Email
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <p class="m-0">Đã nhớ mật khẩu? 
                                <a href="${pageContext.request.contextPath}/login" class="text-primary">Đăng nhập ngay</a>
                            </p>
                        </div>

                        <div class="text-center mt-3">
                            <p class="m-0">Chưa có tài khoản? 
                                <a href="${pageContext.request.contextPath}/register" class="text-primary">Đăng ký ngay</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<style>
.shop-account {
    padding: 80px 0;
}

.login-form {
    background: #fff;
    padding: 40px;
    border-radius: 10px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.1);
}

.login-form .title {
    font-size: 28px;
    font-weight: 700;
    color: #1a1668;
    margin-bottom: 10px;
}

.login-form .form-control {
    height: 50px;
    border-radius: 5px;
    border: 1px solid #ddd;
    padding: 0 20px;
    font-size: 15px;
}

.login-form .form-control:focus {
    border-color: #EAA451;
    box-shadow: 0 0 0 0.2rem rgba(234, 164, 81, 0.25);
}

.login-form .btn-primary {
    height: 50px;
    border-radius: 5px;
    font-size: 16px;
    font-weight: 600;
    background: linear-gradient(135deg, #EAA451 0%, #f7b731 100%);
    border: none;
}

.login-form .btn-primary:hover {
    box-shadow: 0 8px 25px rgba(234, 164, 81, 0.5);
    transform: translateY(-2px);
}

.alert {
    border-radius: 5px;
}
</style>

<jsp:include page="../base/footer.jsp" />
