<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Include header -->
<jsp:include page="../base/header.jsp"/>

<div class="page-content">
    <section class="content-inner">
        <div class="container">

            <!-- Back button -->
            <div class="mb-3">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                </a>
            </div>

            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>
                            <i class="fas fa-user-circle me-2"></i>Chi tiết Người dùng
                        </h2>
                    </div>

                    <!-- Success/Error messages -->
                    <c:if test="${not empty param.success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${param.success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- User Information -->
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">ID</label>
                            <p class="form-control-plaintext">${user.id}</p>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Tên đăng nhập</label>
                            <p class="form-control-plaintext">
                                <strong>${user.username}</strong>
                                <c:if test="${isCurrentUser}">
                                    <span class="badge bg-info ms-2">You</span>
                                </c:if>
                            </p>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Email</label>
                            <p class="form-control-plaintext">
                                <i class="fas fa-envelope me-2 text-muted"></i>${user.email}
                            </p>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Họ và tên</label>
                            <p class="form-control-plaintext">${user.fullName}</p>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Số điện thoại</label>
                            <p class="form-control-plaintext">
                                <c:choose>
                                    <c:when test="${not empty user.phone}">
                                        <i class="fas fa-phone me-2 text-muted"></i>${user.phone}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa cập nhật</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Vai trò</label>
                            <p class="form-control-plaintext">
                                <c:choose>
                                    <c:when test="${user.role == 'admin'}">
												<span class="badge bg-danger">
													Quản trị viên
												</span>
                                    </c:when>
                                    <c:otherwise>
												<span class="badge bg-primary">
													Người dùng
												</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Trạng thái tài khoản</label>
                            <p class="form-control-plaintext">
                                <c:choose>
                                    <c:when test="${user.active}">
												<span class="badge bg-success">
													<i class="fas fa-check-circle me-1"></i>Đã kích hoạt
												</span>
                                    </c:when>
                                    <c:otherwise>
												<span class="badge bg-secondary">
													<i class="fas fa-lock me-1"></i>Đã khóa
												</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Ngày tạo tài khoản</label>
                            <p class="form-control-plaintext">
                                <i class="fas fa-calendar me-2 text-muted"></i>${user.createdAt}
                            </p>
                        </div>

                        <div class="col-12 mb-3">
                            <label class="form-label fw-bold">Địa chỉ</label>
                            <p class="form-control-plaintext">
                                <c:choose>
                                    <c:when test="${not empty user.address}">
                                        <i class="fas fa-map-marker-alt me-2 text-muted"></i>${user.address}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">Chưa cập nhật</span>
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="border-top pt-4 mt-4">
                        <h5 class="mb-3">Thao tác quản lý</h5>
                        <div class="d-flex gap-2">
                            <!-- Lock/Unlock button -->
                            <c:if test="${!isCurrentUser}">
                                <c:choose>
                                    <c:when test="${user.active}">
                                        <button type="button" class="btn btn-warning"
                                                onclick="confirmAction('lock', ${user.id}, '${user.username}')">
                                            <i class="fas fa-lock me-2"></i>Khóa tài khoản
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-success"
                                                onclick="confirmAction('unlock', ${user.id}, '${user.username}')">
                                            <i class="fas fa-unlock me-2"></i>Mở khóa tài khoản
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>

                            <c:if test="${isCurrentUser}">
                                <div class="alert alert-info mb-0 w-100">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Bạn không thể khóa tài khoản của chính mình.
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Statistics (placeholder for future) -->
                    <div class="border-top pt-4 mt-4">
                        <h5 class="mb-3">Thống kê hoạt động</h5>
                        <div class="row text-center">
                            <div class="col-md-4">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h3 class="text-primary">0</h3>
                                        <p class="mb-0 text-muted">Đơn hàng</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h3 class="text-success">0 VNĐ</h3>
                                        <p class="mb-0 text-muted">Tổng chi tiêu</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <h3 class="text-info">0</h3>
                                        <p class="mb-0 text-muted">Đánh giá</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- Hidden form for actions -->
<form id="actionForm" method="post" action="${pageContext.request.contextPath}/admin/user-detail">
    <input type="hidden" name="action" id="actionType">
    <input type="hidden" name="userId" id="actionUserId">
</form>

<script>
    function confirmAction(action, userId, username) {
        var message;
        if (action === 'lock') {
            message = 'Bạn có chắc muốn KHÓA tài khoản "' + username + '"?\n\nUser sẽ không thể đăng nhập sau khi bị khóa.';
        } else if (action === 'unlock') {
            message = 'Bạn có chắc muốn MỞ KHÓA tài khoản "' + username + '"?\n\nUser sẽ có thể đăng nhập lại.';
        }

        if (confirm(message)) {
            document.getElementById('actionType').value = action;
            document.getElementById('actionUserId').value = userId;
            document.getElementById('actionForm').submit();
        }
    }
</script>

<!-- Include footer -->
<jsp:include page="../base/footer.jsp"/>
