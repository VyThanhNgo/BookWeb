<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- Include header -->
<jsp:include page="../base/header.jsp"/>

<div class="page-content">
    <section class="content-inner">
        <div class="container">

            <div class="card">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2>
                            <i class="fas fa-users me-2"></i>Quản lý Người dùng
                        </h2>
                        <span class="badge bg-secondary">Số lượng: ${totalUsers} người dùng</span>
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

                    <!-- Search and Filter Bar -->
                    <div class="card mb-3">
                        <div class="card-body">
                            <form method="get" action="${pageContext.request.contextPath}/admin/users"
                                  class="row g-3">
                                <!-- Search -->
                                <div class="col-md-5">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" name="search"
                                           placeholder="Tên đăng nhập, Email, Họ tên..."
                                           value="${searchKeyword}">
                                </div>

                                <!-- Role Filter -->
                                <div class="col-md-3">
                                    <label class="form-label">Vai trò</label>
                                    <select class="form-select" name="role">
                                        <option value="all" ${roleFilter == null || roleFilter == 'all' ? 'selected' : ''}>
                                            Tất cả
                                        </option>
                                        <option value="user" ${roleFilter == 'user' ? 'selected' : ''}>Người dùng</option>
                                        <option value="admin" ${roleFilter == 'admin' ? 'selected' : ''}>Quản trị viên
                                        </option>
                                    </select>
                                </div>

                                <!-- Status Filter -->
                                <div class="col-md-2">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status">
                                        <option value="all" ${statusFilter == null || statusFilter == 'all' ? 'selected' : ''}>
                                            Tất cả
                                        </option>
                                        <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>
                                            Đã kích hoạt
                                        </option>
                                        <option value="locked" ${statusFilter == 'locked' ? 'selected' : ''}>
                                            Đã khóa
                                        </option>
                                    </select>
                                </div>

                                <!-- Buttons -->
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-search me-1"></i>Lọc
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Users Table -->
                    <div class="table-responsive">
                        <table class="table table-hover table-bordered">
                            <thead class="table-light">
                            <tr>
                                <th width="5%">ID</th>
                                <th width="15%">Tên đăng nhập</th>
                                <th width="20%">Email</th>
                                <th width="20%">Họ tên</th>
                                <th width="10%">Vai trò</th>
                                <th width="10%">Trạng thái</th>
                                <th width="15%">Ngày tạo</th>
                                <th width="15%">Thao tác</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="8" class="text-center text-muted py-4">
                                            <i class="fas fa-inbox fa-3x mb-3 d-block"></i>
                                            Không tìm thấy người dùng
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>${user.id}</td>
                                            <td>
                                                <strong>${user.username}</strong>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>${user.fullName}</td>
                                            <td>
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
                                            </td>
                                            <td>
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
                                            </td>
                                            <td>
                                                <small>${user.createdAt}</small>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <!-- View Detail -->
                                                    <a href="${pageContext.request.contextPath}/admin/user-detail?id=${user.id}"
                                                       class="btn btn-info btn-sm" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>

                                                    <!-- Toggle Lock/Unlock -->
                                                    <c:choose>
                                                        <c:when test="${user.active}">
                                                            <button type="button" class="btn btn-warning btn-sm"
                                                                    onclick="confirmToggle(${user.id}, '${user.username}', 'lock')"
                                                                    title="Khóa tài khoản">
                                                                <i class="fas fa-lock"></i>
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button type="button" class="btn btn-success btn-sm"
                                                                    onclick="confirmToggle(${user.id}, '${user.username}', 'unlock')"
                                                                    title="Mở khóa tài khoản">
                                                                <i class="fas fa-unlock"></i>
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="User pagination">
                            <ul class="pagination justify-content-center">
                                <!-- Previous -->
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i> Previous
                                    </a>
                                </li>

                                <!-- Page numbers -->
                                <c:forEach begin="1" end="${totalPages}" var="page">
                                    <li class="page-item ${currentPage == page ? 'active' : ''}">
                                        <a class="page-link" href="?page=${page}">${page}</a>
                                    </li>
                                </c:forEach>

                                <!-- Next -->
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}">
                                        Next <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </section>
</div>

<!-- Hidden form for toggle action -->
<form id="toggleForm" method="post" action="${pageContext.request.contextPath}/admin/users">
    <input type="hidden" name="action" value="toggle">
    <input type="hidden" name="userId" id="toggleUserId">
</form>

<script>
    function confirmToggle(userId, username, action) {
        var message = action === 'lock'
            ? 'Bạn có chắc muốn KHÓA tài khoản "' + username + '"?'
            : 'Bạn có chắc muốn MỞ KHÓA tài khoản "' + username + '"?';

        if (confirm(message)) {
            document.getElementById('toggleUserId').value = userId;
            document.getElementById('toggleForm').submit();
        }
    }
</script>

<!-- Include footer -->
<jsp:include page="../base/footer.jsp"/>
