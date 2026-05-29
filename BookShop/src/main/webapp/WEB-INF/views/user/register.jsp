<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- Include header -->
<jsp:include page="../base/header.jsp" />

<div class="page-content">
	<section class="content-inner shop-account">
		<div class="container">
			<div class="row justify-content-center">
				<div class="col-lg-6 col-md-8">
					<div class="login-form card">
						<div class="card-body">
							<h2 class="text-center mb-4">Đăng Ký Tài Khoản</h2>

							<!-- Error message -->
							<c:if test="${not empty error}">
								<div class="alert alert-danger" role="alert">${error}</div>
							</c:if>

							<!-- Registration form -->
							<form method="post"
								action="${pageContext.request.contextPath}/register">
								<div class="mb-3">
									<label class="form-label">Tên đăng nhập <span
										class="text-danger">*</span></label> <input type="text"
										class="form-control" name="username" value="${username}"
										pattern="[a-zA-Z0-9_]{3,}"
										title="Tên đăng nhập phải có ít nhất 3 ký tự và chỉ chứa chữ cái, số, dấu gạch dưới"
										required>
									<small class="text-muted">Tối thiểu 3 ký tự (chữ cái, số, dấu gạch dưới)</small>
								</div>

								<div class="mb-3">
									<label class="form-label">Họ và tên <span
										class="text-danger">*</span></label> <input type="text"
										class="form-control" name="fullName" value="${fullName}"
										required>
								</div>

								<div class="mb-3">
									<label class="form-label">Email <span
										class="text-danger">*</span></label> <input type="email"
										class="form-control" name="email" value="${email}" required>
								</div>

								<div class="mb-3">
									<label class="form-label">Mật khẩu <span
										class="text-danger">*</span></label> <input type="password"
										class="form-control" name="password" minlength="6" required>
									<small class="text-muted">Tối thiểu 6 ký tự</small>
								</div>

								<div class="mb-3">
									<label class="form-label">Xác nhận mật khẩu <span
										class="text-danger">*</span></label> <input type="password"
										class="form-control" name="confirmPassword" minlength="6"
										required>
								</div>

								<div class="mb-3">
									<label class="form-label">Số điện thoại</label> <input
										type="tel" class="form-control" name="phone" value="${phone}">
								</div>

								<div class="mb-3">
									<label class="form-label">Địa chỉ</label>
									<textarea class="form-control" name="address" rows="2">${address}</textarea>
								</div>

								<div class="d-grid">
									<button type="submit" class="btn btn-primary btnhover">
										Đăng Ký</button>
								</div>

								<div class="text-center mt-3">
									<p>
										Đã có tài khoản? <a
											href="${pageContext.request.contextPath}/login">Đăng nhập
											ngay</a>
									</p>
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
