<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- Sửa đường dẫn để Servlet có thể tìm thấy Header đúng vị trí --%>
<jsp:include page="/WEB-INF/views/base/header.jsp" />

<div class="page-content">
    <section class="content-inner shop-account">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-5 col-md-7">
                    <div class="login-form card">
                        <div class="card-body">
                            <h2 class="text-center mb-4">Đăng Nhập</h2>
                            
                            <c:if test="${not empty success}">
                                <div class="alert alert-success" role="alert">${success}</div>
                            </c:if>

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger" role="alert">${error}</div>
                            </c:if>

                            <form method="post" action="${pageContext.request.contextPath}/login">
                                <div class="mb-3">
                                    <label class="form-label">Tên đăng nhập hoặc Email</label>
                                    <input type="text" class="form-control" name="usernameOrEmail"
                                        value="${usernameOrEmail}" required autofocus
                                        placeholder="username hoặc email@example.com">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu</label> 
                                    <input type="password" class="form-control" name="password" required>
                                </div>

                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="rememberMe">
                                    <label class="form-check-label" for="rememberMe">
                                        Ghi nhớ đăng nhập </label>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary btnhover">
                                        Đăng Nhập</button>
                                </div>

                                <div class="text-center mt-3">
                                    <p>
                                        Chưa có tài khoản? <a
                                            href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                                    </p>
                                    <a href="${pageContext.request.contextPath}/forgot-password" class="text-muted">Quên mật khẩu?</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<%-- Sửa đường dẫn để Servlet có thể tìm thấy Footer --%>
<jsp:include page="/WEB-INF/views/base/footer.jsp" />