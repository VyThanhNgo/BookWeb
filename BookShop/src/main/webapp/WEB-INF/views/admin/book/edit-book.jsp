<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	<%@ include file="/WEB-INF/views/base/header.jsp"%>

	<div class="page-content bg-grey">
		<div class="content-inner">
			<div class="container">
				<div class="row justify-content-center">
					<div class="col-lg-8">

						<h3 class="mb-4">Sửa Sách</h3>

						<c:if test="${param.success eq 'updated'}">
							<div class="alert alert-success">Cập nhật sách thành công!</div>
						</c:if>

						<form action="${pageContext.request.contextPath}/admin/books"
							method="post" enctype="multipart/form-data">

							<input type="hidden" name="action" value="edit"> <input
								type="hidden" name="bookId" value="${book.id}"> <input
								type="hidden" name="oldImage" value="${book.image}">

							<div class="mb-3">
								<label class="form-label">Tên sách</label> <input type="text"
									name="title" class="form-control" value="${book.title}"
									required>
							</div>

							<div class="row">
								<div class="col-md-6 mb-3">
									<label class="form-label">Giá (VNĐ)</label> <input
										type="number" name="price" class="form-control"
										value="${book.price}" required>
								</div>
								<div class="col-md-6 mb-3">
									<label class="form-label">Tồn kho</label> <input type="number"
										name="stock" class="form-control" value="${book.stock}">
								</div>
							</div>

							<div class="row">
								<div class="col-md-6 mb-3">
									<label class="form-label">Danh mục</label> <select
										name="categoryId" class="form-control">
										<c:forEach var="cat" items="${categories}">
											<option value="${cat.id}"
												${cat.id == book.category.id ? 'selected' : ''}>
												${cat.name}</option>
										</c:forEach>
									</select>
								</div>
								<div class="col-md-6 mb-3">
									<label class="form-label">Tác giả</label> <select
										name="authorId" class="form-control">
										<c:forEach var="a" items="${authors}">
											<option value="${a.id}"
												${a.id == book.author.id ? 'selected' : ''}>
												${a.name}</option>
										</c:forEach>
									</select>
								</div>
							</div>

							<div class="mb-3">
								<label class="form-label">Năm xuất bản</label> <input
									type="number" name="publishYear" class="form-control"
									value="${book.publishYear}">
							</div>

							<div class="mb-3">
								<label class="form-label">Mô tả</label>
								<textarea name="description" class="form-control" rows="4">${book.description}</textarea>
							</div>

							<%-- ẢNH --%>
							<div class="mb-3">
								<label class="form-label">Ảnh bìa</label><br>

								<%-- Hiển thị ảnh hiện tại --%>
								<c:choose>
									<c:when test="${not empty book.image}">
										<img id="imgPreview" src="${book.image}"
											style="max-width: 150px; border: 1px solid #ddd; padding: 4px; margin-bottom: 8px; display: block;">
									</c:when>
									<c:otherwise>
										<img id="imgPreview"
											src="${pageContext.request.contextPath}/assets/images/books/default-book.png"
											style="max-width: 150px; border: 1px solid #ddd; padding: 4px; margin-bottom: 8px; display: block;">
									</c:otherwise>
								</c:choose>

								<input type="file" name="image" class="form-control"
									accept="image/*" onchange="previewImage(this)"> <small
									class="text-muted">Để trống nếu không muốn đổi ảnh</small>
							</div>

							<div class="d-flex gap-2">
								<button type="submit" class="btn btn-primary">Lưu thay
									đổi</button>
								<a href="${pageContext.request.contextPath}/admin/books"
									class="btn btn-secondary">Quay lại</a>
							</div>

						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script>
		function previewImage(input) {
			if (input.files && input.files[0]) {
				var reader = new FileReader();
				reader.onload = function(e) {
					document.getElementById('imgPreview').src = e.target.result;
				};
				reader.readAsDataURL(input.files[0]);
			}
		}
	</script>

	<%@ include file="/WEB-INF/views/base/footer.jsp"%>
</body>
</html>