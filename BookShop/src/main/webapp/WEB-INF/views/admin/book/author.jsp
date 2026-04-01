<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Quản lý tác giả</title>
</head>
<body>

    <!-- Form thêm / sửa -->
    <c:choose>
        <c:when test="${not empty editAuthor}">
            <!-- Form SỬA -->
            <h4>Sửa tác giả</h4>
            <form action="${pageContext.request.contextPath}/admin/authors"
                  method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" value="${editAuthor.id}">

                <div class="mb-3">
                    <label>Tên tác giả</label>
                    <input type="text" name="name" class="form-control"
                           value="${editAuthor.name}" required>
                </div>

                <div class="mb-3">
                    <label>Ảnh hiện tại</label><br>
                    <img src="${not empty editAuthor.image ? editAuthor.image : pageContext.request.contextPath.concat('/assets/images/books/default-book.png')}"
                         style="width:80px; height:80px; object-fit:cover; border-radius:50%; margin-bottom:8px;">
                    <input type="hidden" name="oldImage" value="${editAuthor.image}">
                </div>

                <div class="mb-3">
                    <label>Đổi ảnh (để trống nếu giữ nguyên)</label>
                    <input type="file" name="image" class="form-control"
                           accept="image/*" onchange="previewImage(this)">
                    <img id="imgPreview" src="#" alt="Preview"
                         style="max-width:150px; margin-top:10px; display:none; border-radius:50%;">
                </div>

                <button type="submit" class="btn btn-warning">Cập nhật</button>
                <a href="${pageContext.request.contextPath}/admin/authors"
                   class="btn btn-secondary ms-2">Hủy</a>
            </form>
        </c:when>
        <c:otherwise>
            <!-- Form THÊM -->
            <h4>Thêm tác giả</h4>
            <form action="${pageContext.request.contextPath}/admin/authors"
                  method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="mb-3">
                    <label>Tên tác giả</label>
                    <input type="text" name="name" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label>Ảnh tác giả</label>
                    <input type="file" name="image" class="form-control"
                           accept="image/*" onchange="previewImage(this)">
                    <img id="imgPreview" src="#" alt="Preview"
                         style="max-width:150px; margin-top:10px; display:none; border-radius:50%;">
                </div>

                <button type="submit" class="btn btn-primary">Thêm tác giả</button>
            </form>
        </c:otherwise>
    </c:choose>

    <hr class="mt-5">
    <h4>Danh sách tác giả</h4>

    <c:if test="${param.success eq 'added'}">
        <div class="alert alert-success">Thêm tác giả thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'updated'}">
        <div class="alert alert-success">Cập nhật tác giả thành công!</div>
    </c:if>
    <c:if test="${param.success eq 'deleted'}">
        <div class="alert alert-danger">Đã xóa tác giả thành công!</div>
    </c:if>

    <table class="table table-bordered mt-3">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Ảnh</th>
                <th>Tên tác giả</th>
                <th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="a" items="${authors}">
                <tr>
                    <td>${a.id}</td>
                    <td>
                        <img src="${not empty a.image ? a.image : pageContext.request.contextPath.concat('/assets/images/books/default-book.png')}"
                             style="width:50px; height:50px; object-fit:cover; border-radius:50%;">
                    </td>
                    <td>${a.name}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/authors?action=edit&id=${a.id}"
                           class="btn btn-sm btn-warning">
                            <i class="fas fa-edit"></i> Sửa
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/authors?action=delete&id=${a.id}"
                           class="btn btn-sm btn-danger ms-1"
                           onclick="return confirmDelete('${a.name}')">
                            <i class="fas fa-trash"></i> Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <script>
        function previewImage(input) {
            var preview = document.getElementById('imgPreview');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
        function confirmDelete(name) {
            return confirm('Bạn có chắc muốn xóa tác giả "' + name + '" không?');
        }
    </script>
</body>
</html>