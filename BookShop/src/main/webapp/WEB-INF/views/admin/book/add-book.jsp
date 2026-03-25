<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="${pageContext.request.contextPath}/admin/books"
		method="post" enctype="multipart/form-data">
		<%--enctype này phải có --%>

		<input type="hidden" name="action" value="add">

		<div class="mb-3">
			<label>Tên sách</label> <input type="text" name="title"
				class="form-control" required>
		</div>
		<div class="mb-3">
			<label>Giá</label> <input type="number" name="price"
				class="form-control" required>
		</div>
		<div class="mb-3">
			<label>Danh mục</label> <select name="categoryId"
				class="form-control">
				<c:forEach var="cat" items="${categories}">
					<option value="${cat.id}">${cat.name}</option>
				</c:forEach>
			</select>
		</div>
		<div class="mb-3">
			<label>Tác giả</label> <select name="authorId" class="form-control">
				<c:forEach var="a" items="${authors}">
					<option value="${a.id}">${a.name}</option>
				</c:forEach>
			</select>
		</div>
		<div class="mb-3">
			<label>Năm xuất bản</label> <input type="number" name="publishYear"
				class="form-control">
		</div>
		<div class="mb-3">
			<label>Tồn kho</label> <input type="number" name="stock"
				class="form-control">
		</div>
		<div class="mb-3">
			<label>Mô tả</label>
			<textarea name="description" class="form-control" rows="3"></textarea>
		</div>

		<%-- PHẦN UPLOAD ẢNH --%>
		<div class="mb-3">
			<label>Ảnh bìa sách</label> <input type="file" name="image"
				class="form-control" accept="image/*" onchange="previewImage(this)">
			<%-- Preview ảnh trước khi submit --%>
			<img id="imgPreview" src="#" alt="Preview"
				style="max-width: 150px; margin-top: 10px; display: none;">
		</div>

		<button type="submit" class="btn btn-primary">Thêm sách</button>

		<hr class="mt-5">
		<h4>Danh sách sách hiện có</h4>

		<c:if test="${param.success eq 'added'}">
			<div class="alert alert-success">Thêm sách thành công!</div>
		</c:if>
		<c:if test="${param.success eq 'updated'}">
			<div class="alert alert-success">Cập nhật sách thành công!</div>
		</c:if>
		<c:if test="${param.success eq 'deleted'}">
			<div class="alert alert-danger">Đã xóa sách thành công!</div>
		</c:if>

		<table class="table table-bordered mt-3">
			<thead class="table-dark">
				<tr>
					<th>ID</th>
					<th>Ảnh</th>
					<th>Tên sách</th>
					<th>Giá</th>
					<th>Danh mục</th>
					<th>Thao tác</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="b" items="${books}">
					<tr>
						<td>${b.id}</td>
						<td><img
							src="${not empty b.image 
                ? pageContext.request.contextPath.concat('/assets/images/books/').concat(b.image)
                : pageContext.request.contextPath.concat('/assets/images/default-book.jpg')}"
							style="width: 50px; height: 65px; object-fit: cover;"></td>
						<td>${b.title}</td>
						<td>${b.price}</td>
						<td>${b.category.name}</td>
						<td><a
							href="${pageContext.request.contextPath}/admin/books?action=edit&id=${b.id}"
							class="btn btn-sm btn-warning">Sửa</a> <a
							href="${pageContext.request.contextPath}/admin/books?action=delete&id=${b.id}"
							class="btn btn-sm btn-danger ms-1"
							onclick="return confirmDelete('${b.title}')"> <i
								class="fas fa-trash"></i> Xóa
						</a>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</form>

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
		
		function confirmDelete(title) {
		    return confirm('Bạn có chắc muốn xóa sách "' + title + '" không?\nHành động này không thể hoàn tác!');
		}
	</script>
</body>
</html>