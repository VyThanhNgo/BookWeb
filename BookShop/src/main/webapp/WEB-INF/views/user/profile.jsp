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
									class="list-group-item list-group-item-action active">
									<i class="fas fa-user me-2"></i> Thông tin cá nhân
								</a>
								<a href="${pageContext.request.contextPath}/change-password"
									class="list-group-item list-group-item-action">
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
							<h2 class="mb-4">Thông Tin Cá Nhân</h2>

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

							<!-- Profile Form -->
							<form method="post" action="${pageContext.request.contextPath}/profile">
								<div class="row mb-3">
									<label class="col-sm-3 col-form-label">Tên đăng nhập</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" value="${user.username}" readonly disabled>
										<small class="form-text text-muted">Tên đăng nhập không thể thay đổi</small>
									</div>
								</div>

								<div class="row mb-3">
									<label class="col-sm-3 col-form-label">Họ và tên <span class="text-danger">*</span></label>
									<div class="col-sm-9">
										<input type="text" class="form-control" name="fullName" 
											value="${not empty fullName ? fullName : user.fullName}" 
											required placeholder="Nhập họ và tên đầy đủ">
									</div>
								</div>

								<div class="row mb-3">
									<label class="col-sm-3 col-form-label">Email <span class="text-danger">*</span></label>
									<div class="col-sm-9">
										<input type="email" class="form-control" name="email" 
											value="${not empty email ? email : user.email}" 
											required placeholder="email@example.com">
									</div>
								</div>

								<div class="row mb-3">
									<label class="col-sm-3 col-form-label">Số điện thoại</label>
									<div class="col-sm-9">
										<input type="tel" class="form-control" name="phone" 
											value="${not empty phone ? phone : user.phone}" 
											placeholder="0123456789">
									</div>
								</div>

								<div class="row mb-3">
									<label class="col-sm-3 col-form-label">Địa chỉ</label>
									<div class="col-sm-9">
										<textarea class="form-control" name="address" rows="3" 
											placeholder="Nhập địa chỉ giao hàng">${not empty address ? address : user.address}</textarea>
									</div>
								</div>

								<div class="row mb-3">
									<label class="col-sm-3 col-form-label">Ngày tạo</label>
									<div class="col-sm-9">
										<input type="text" class="form-control" 
											value="${user.createdAt}" 
											readonly disabled>
									</div>
								</div>

								<div class="row">
									<div class="col-sm-9 offset-sm-3">
										<button type="submit" class="btn btn-primary btnhover">
											<i class="fas fa-save me-2"></i>Lưu thay đổi
										</button>
										<a href="${pageContext.request.contextPath}/change-password" 
											class="btn btn-outline-secondary ms-2">
											<i class="fas fa-key me-2"></i>Đổi mật khẩu
										</a>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</div>

<!-- Include footer -->
<jsp:include page="../base/footer.jsp" />
