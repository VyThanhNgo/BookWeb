<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- Include header -->
<jsp:include page="../base/header.jsp" />

<div class="page-content">
	<section class="content-inner shop-account">
		<div class="container">
			<div class="row">
				<!-- Sidebar Menu -->
				<div class="col-lg-3 col-md-4 mb-4">
					<div class="card">
						<div class="card-body">
							<h5 class="card-title mb-3">Tài Khoản</h5>
							<div class="list-group list-group-flush">
								<a href="${pageContext.request.contextPath}/profile"
									class="list-group-item list-group-item-action">
									<i class="fas fa-user me-2"></i> Thông tin cá nhân
								</a>
								<a href="${pageContext.request.contextPath}/change-password"
									class="list-group-item list-group-item-action active">
									<i class="fas fa-key me-2"></i> Đổi mật khẩu
								</a>
								<a href="${pageContext.request.contextPath}/orders"
									class="list-group-item list-group-item-action">
									<i class="fas fa-shopping-bag me-2"></i> Đơn hàng của tôi
								</a>
								<a href="${pageContext.request.contextPath}/logout"
									class="list-group-item list-group-item-action text-danger">
									<i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
								</a>
							</div>
						</div>
					</div>
				</div>

				<!-- Main Content -->
				<div class="col-lg-9 col-md-8">
					<div class="card">
						<div class="card-body">
							<h2 class="mb-4">Đổi Mật Khẩu</h2>

							<!-- Success message -->
							<c:if test="${not empty success}">
								<div class="alert alert-success alert-dismissible fade show" role="alert">
									<i class="fas fa-check-circle me-2"></i>${success}
									<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
								</div>
							</c:if>

							<!-- Error message -->
							<c:if test="${not empty error}">
								<div class="alert alert-danger alert-dismissible fade show" role="alert">
									<i class="fas fa-exclamation-circle me-2"></i>${error}
									<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
								</div>
							</c:if>

							<div class="row justify-content-center">
								<div class="col-md-8">
									<!-- Change Password Form -->
									<form method="post" action="${pageContext.request.contextPath}/change-password" 
										onsubmit="return validatePassword()">
										
										<div class="mb-3">
											<label class="form-label">Mật khẩu hiện tại <span class="text-danger">*</span></label>
											<input type="password" class="form-control" id="currentPassword" 
												name="currentPassword" required 
												placeholder="Nhập mật khẩu hiện tại">
										</div>

										<div class="mb-3">
											<label class="form-label">Mật khẩu mới <span class="text-danger">*</span></label>
											<input type="password" class="form-control" id="newPassword" 
												name="newPassword" required minlength="6"
												placeholder="Nhập mật khẩu mới (tối thiểu 6 ký tự)">
											<small class="form-text text-muted">
												Mật khẩu phải có ít nhất 6 ký tự
											</small>
										</div>

										<div class="mb-3">
											<label class="form-label">Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
											<input type="password" class="form-control" id="confirmPassword" 
												name="confirmPassword" required 
												placeholder="Nhập lại mật khẩu mới">
											<small id="passwordMismatch" class="form-text text-danger d-none">
												Mật khẩu xác nhận không khớp
											</small>
										</div>

										<div class="alert alert-info">
											<i class="fas fa-info-circle me-2"></i>
											<strong>Lưu ý:</strong> Sau khi đổi mật khẩu, bạn vẫn đăng nhập bình thường. 
											Vui lòng ghi nhớ mật khẩu mới.
										</div>

										<div class="d-grid gap-2">
											<button type="submit" class="btn btn-primary btnhover">
												<i class="fas fa-save me-2"></i>Đổi mật khẩu
											</button>
											<a href="${pageContext.request.contextPath}/profile" 
												class="btn btn-outline-secondary">
												<i class="fas fa-arrow-left me-2"></i>Quay lại
											</a>
										</div>
									</form>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>

<!-- Password validation script -->
<script>
	function validatePassword() {
		var newPassword = document.getElementById('newPassword').value;
		var confirmPassword = document.getElementById('confirmPassword').value;
		var mismatchMsg = document.getElementById('passwordMismatch');

		if (newPassword !== confirmPassword) {
			mismatchMsg.classList.remove('d-none');
			document.getElementById('confirmPassword').classList.add('is-invalid');
			return false;
		} else {
			mismatchMsg.classList.add('d-none');
			document.getElementById('confirmPassword').classList.remove('is-invalid');
			return true;
		}
	}

	// Real-time validation
	document.getElementById('confirmPassword').addEventListener('keyup', function() {
		var newPassword = document.getElementById('newPassword').value;
		var confirmPassword = this.value;
		var mismatchMsg = document.getElementById('passwordMismatch');

		if (confirmPassword.length > 0) {
			if (newPassword !== confirmPassword) {
				mismatchMsg.classList.remove('d-none');
				this.classList.add('is-invalid');
			} else {
				mismatchMsg.classList.add('d-none');
				this.classList.remove('is-invalid');
				this.classList.add('is-valid');
			}
		} else {
			mismatchMsg.classList.add('d-none');
			this.classList.remove('is-invalid', 'is-valid');
		}
	});
</script>

<!-- Include footer -->
<jsp:include page="../base/footer.jsp" />
