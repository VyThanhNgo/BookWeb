<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="Đặt lại mật khẩu - BookShop" scope="request" />
<jsp:include page="../base/header.jsp" />

<div class="page-content">
    <!-- Inner Page Banner -->
    <div class="dz-bnr-inr overlay-secondary-dark dz-bnr-inr-sm" style="background-image:url(${pageContext.request.contextPath}/assets/images/background/bg3.jpg);">
        <div class="container">
            <div class="dz-bnr-inr-entry">
                <h1>Đặt Lại Mật Khẩu</h1>
                <nav aria-label="breadcrumb" class="breadcrumb-row">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Đặt lại mật khẩu</li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
    <!-- Inner Page Banner End -->

    <!-- Reset Password Section -->
    <section class="content-inner shop-account">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8 m-b30">
                    <div class="login-form shop-form">
                        <div class="logo-header text-center mb-4">
                            <h3 class="title">Đặt Lại Mật Khẩu</h3>
                            <p class="text-muted">Email: <strong>${sessionScope.resetEmail}</strong></p>
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

                        <form method="POST" action="${pageContext.request.contextPath}/forgot-password" class="dz-form" id="resetPasswordForm">
                            <input type="hidden" name="action" value="reset-password">
                            
                            <div class="form-group mb-4">
                                <label class="font-weight-700 mb-2">Mật khẩu mới <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input name="newPassword" id="newPassword" required type="password" 
                                           class="form-control" placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)">
                                    <button class="btn btn-outline-secondary" type="button" id="toggleNewPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <small class="text-muted">Mật khẩu phải có ít nhất 6 ký tự</small>
                            </div>

                            <div class="form-group mb-4">
                                <label class="font-weight-700 mb-2">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input name="confirmPassword" id="confirmPassword" required type="password" 
                                           class="form-control" placeholder="Nhập lại mật khẩu mới">
                                    <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="form-group">
                                <button type="submit" class="btn btn-primary btnhover w-100">
                                    <i class="fas fa-key me-2"></i> Đặt Lại Mật Khẩu
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <p class="m-0">
                                <a href="${pageContext.request.contextPath}/login" class="text-primary">
                                    <i class="fas fa-arrow-left me-2"></i>Quay lại đăng nhập
                                </a>
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
    border-radius: 5px 0 0 5px;
    border: 1px solid #ddd;
    padding: 0 20px;
    font-size: 15px;
}

.login-form .input-group .btn {
    border-radius: 0 5px 5px 0;
    border: 1px solid #ddd;
    border-left: none;
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

<script>
// Toggle password visibility
document.getElementById('toggleNewPassword').addEventListener('click', function() {
    const passwordInput = document.getElementById('newPassword');
    const icon = this.querySelector('i');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
});

document.getElementById('toggleConfirmPassword').addEventListener('click', function() {
    const passwordInput = document.getElementById('confirmPassword');
    const icon = this.querySelector('i');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
});

// Form validation
document.getElementById('resetPasswordForm').addEventListener('submit', function(e) {
    const newPassword = document.getElementById('newPassword').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    if (newPassword.length < 6) {
        e.preventDefault();
        alert('Mật khẩu phải có ít nhất 6 ký tự');
        return false;
    }
    
    if (newPassword !== confirmPassword) {
        e.preventDefault();
        alert('Mật khẩu xác nhận không khớp');
        return false;
    }
});
</script>

<jsp:include page="../base/footer.jsp" />
