<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Bookland | Hệ Thống Quản Trị Góc Sách</title>
<!-- Tailwind CSS CDN -->
<script src="https://cdn.tailwindcss.com"></script>
<!-- FontAwesome Icons -->
<link
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
	rel="stylesheet">
<!-- Chart.js for beautiful statistics -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        navy: {
                            50: '#f4f7fa',
                            100: '#e9eef5',
                            500: '#3b5a85',
                            800: '#1a3352', // Màu logo gốc
                            900: '#10223b'
                        },
                        emerald: {
                            500: '#22c55e'
                        }
                    }
                }
            }
        }
    </script>
<style>
@import
	url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Urbanist:wght@600;700;800&display=swap')
	;

body {
	font-family: 'Inter', sans-serif;
}

.heading-font {
	font-family: 'Urbanist', sans-serif;
}
/* Custom scrollbar */
::-webkit-scrollbar {
	width: 6px;
	height: 6px;
}

::-webkit-scrollbar-track {
	background: transparent;
}

::-webkit-scrollbar-thumb {
	background: #cbd5e1;
	border-radius: 4px;
}

.dark ::-webkit-scrollbar-thumb {
	background: #475569;
}
</style>
</head>
<body
	class="bg-slate-50 dark:bg-slate-900 text-slate-800 dark:text-slate-100 min-h-screen flex transition-colors duration-300"
	data-context-path="${pageContext.request.contextPath}">

	<!-- TOAST NOTIFICATION SYSTEM (Hệ thống thông báo thay thế alert) -->
	<div id="toast-container"
		class="fixed top-5 right-5 z-50 flex flex-col gap-3"></div>

	<!-- SIDEBAR - ĐIỀU HƯỚNG CHÍNH -->
	<aside
		class="w-64 bg-navy-800 dark:bg-slate-950 text-white flex flex-col fixed h-full z-20 shadow-xl transition-all duration-300">
		<div class="p-5 flex items-center gap-3 border-b border-navy-500/30">
			<!-- SVG Logo từ ảnh tải lên của khách hàng -->
			<div class="bg-white p-2 rounded-lg">
				<svg class="w-8 h-8 text-navy-800" viewBox="0 0 100 100"
					fill="currentColor">
                    <rect x="15" y="15" width="70" height="70" rx="15"
						fill="none" stroke="currentColor" stroke-width="10" />
                    <line x1="50" y1="20" x2="50" y2="80"
						stroke="currentColor" stroke-width="10" />
                    <path d="M25 35 C 35 25, 45 25, 50 35"
						stroke="currentColor" stroke-width="6" fill="none" />
                    <path d="M75 35 C 65 25, 55 25, 50 35"
						stroke="currentColor" stroke-width="6" fill="none" />
                </svg>
			</div>
			<div>
				<h1 class="font-extrabold text-lg tracking-wider heading-font">GÓC
					SÁCH</h1>
				<p class="text-xs text-slate-300">Hệ Thống Quản Trị</p>
			</div>
		</div>

		<nav class="flex-1 px-4 py-6 space-y-1 overflow-y-auto">
			<button onclick="switchTab('dashboard')" id="btn-dashboard"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium transition-all duration-200 bg-navy-500/20 text-white border-l-4 border-emerald-500">
				<i class="fa-solid fa-chart-pie text-lg"></i> Tổng Quan
			</button>
			<button onclick="switchTab('books')" id="btn-books"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-book-open text-lg"></i> Quản Lý Sách
			</button>
			<button onclick="switchTab('categories')" id="btn-categories"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-tags text-lg"></i> Quản Lý Danh Mục
			</button>
			<button onclick="switchTab('authors')" id="btn-authors"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-user-pen text-lg"></i> Quản Lý Tác Giả
			</button>
			<button onclick="switchTab('users')" id="btn-users"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-users-gear text-lg"></i> Quản Lý Người Dùng
			</button>
			<button onclick="switchTab('reviews')" id="btn-reviews"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-comments text-lg"></i> Phê Duyệt Đánh Giá
			</button>
			<button onclick="switchTab('inventory')" id="btn-inventory"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-boxes-stacked text-lg"></i> Quản Lý Tồn Kho
			</button>
			<button onclick="switchTab('promotions')" id="btn-promotions"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-rectangle-ad text-lg"></i> Khuyến Mãi Đồng Giá
			</button>
			<button onclick="switchTab('orders')" id="btn-orders"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-box text-lg"></i> Quản Lý Đơn Hàng
			</button>
			<button onclick="switchTab('messages')" id="btn-messages"
				class="sidebar-btn w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium text-slate-300 hover:bg-white/5 hover:text-white transition-all duration-200 border-l-4 border-transparent">
				<i class="fa-solid fa-envelope-open-text text-lg"></i> Hòm Thư Liên
				Hệ
			</button>
		</nav>

		<div class="p-4 border-t border-navy-500/30 text-xs text-slate-400">
			<p>
				Nhóm Thực Tập: <strong>Nhóm 33</strong>
			</p>
			<p>Phiên bản: 1.0.3 - Server MySQL 8.0</p>
		</div>
	</aside>

	<!-- KHU VỰC HIỂN THỊ NỘI DUNG CHÍNH -->
	<main
		class="flex-1 ml-64 p-8 transition-all duration-300 min-h-screen flex flex-col">

		<!-- HEADER TRÊN -->
		<header
			class="flex justify-between items-center mb-8 bg-white dark:bg-slate-950 p-4 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 transition-colors duration-300">
			<div>
				<h2 id="current-title"
					class="text-2xl font-bold heading-font text-navy-800 dark:text-slate-100">Tổng
					Quan Hệ Thống</h2>
				<p class="text-xs text-slate-500 dark:text-slate-400">Theo dõi
					trạng thái kinh doanh của Góc Sách</p>
			</div>
			<div class="flex items-center gap-6">
				<!-- Nút chuyển đổi giao diện Sáng/Tối -->
				<button onclick="toggleDarkMode()"
					class="p-2.5 rounded-xl bg-slate-100 dark:bg-slate-800 hover:scale-105 active:scale-95 transition-all text-slate-600 dark:text-slate-300"
					title="Đổi giao diện">
					<i class="fa-solid fa-moon dark:hidden text-lg"></i> <i
						class="fa-solid fa-sun hidden dark:block text-lg"></i>
				</button>

				<!-- Thông tin Admin -->
				<div
					class="flex items-center gap-3 pl-4 border-l border-slate-200 dark:border-slate-800">
					<div class="text-right">
						<p class="text-sm font-bold text-navy-800 dark:text-slate-200">Admin
							Nhóm 33</p>
						<p class="text-xs text-slate-400">Quản Trị Tối Cao</p>
					</div>
					<div
						class="w-10 h-10 rounded-full bg-navy-800 text-white flex items-center justify-center font-bold text-sm">
						AD</div>
				</div>
			</div>
		</header>

		<!-- ================= PANEL 1: DASHBOARD OVERVIEW ================= -->
		<section id="panel-dashboard" class="tab-panel space-y-8">
			<!-- Thẻ thống kê nhanh -->
			<div class="grid grid-cols-1 md:grid-cols-4 gap-6">
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm flex items-center justify-between">
					<div>
						<span
							class="text-xs text-slate-400 font-bold uppercase tracking-wider">Tổng
							Doanh Thu</span>
						<h3
							class="text-2xl font-black heading-font text-navy-800 dark:text-white mt-1">
							<fmt:formatNumber value="${totalRevenue}" pattern="#,###" />
							đ
						</h3>
						<span class="text-xs text-slate-400 font-bold">Tổng doanh
							thu thực tế</span>
					</div>
					<div
						class="bg-blue-50 dark:bg-blue-900/20 p-4 rounded-xl text-blue-600">
						<i class="fa-solid fa-money-bill-wave text-2xl"></i>
					</div>
				</div>
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm flex items-center justify-between">
					<div>
						<span
							class="text-xs text-slate-400 font-bold uppercase tracking-wider">Khách
							Hàng Mới</span>
						<h3 id="dash-total-users"
							class="text-2xl font-black heading-font text-navy-800 dark:text-white mt-1">${totalUsers}</h3>
						<span class="text-xs text-emerald-500 font-bold"><i
							class="fa-solid fa-circle-check"></i> +${usersToday} user hôm nay</span>
					</div>
					<div
						class="bg-emerald-50 dark:bg-emerald-900/20 p-4 rounded-xl text-emerald-600">
						<i class="fa-solid fa-users text-2xl"></i>
					</div>
				</div>
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm flex items-center justify-between">
					<div>
						<span
							class="text-xs text-slate-400 font-bold uppercase tracking-wider">Sách
							Đang Quản Lý</span>
						<h3 id="dash-total-books"
							class="text-2xl font-black heading-font text-navy-800 dark:text-white mt-1">${totalBooks}</h3>
						<span class="text-xs text-slate-500 dark:text-slate-400">Tổng
							sách đang bán</span>
					</div>
					<div
						class="bg-purple-50 dark:bg-purple-900/20 p-4 rounded-xl text-purple-600">
						<i class="fa-solid fa-book-bookmark text-2xl"></i>
					</div>
				</div>
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm flex items-center justify-between">
					<div>
						<span
							class="text-xs text-slate-400 font-bold uppercase tracking-wider font-bold text-amber-500">Cảnh
							Báo Hết Hàng</span>
						<h3 id="dash-low-stock"
							class="text-2xl font-black heading-font text-amber-500 mt-1">2</h3>
						<span class="text-xs text-rose-500 font-bold"><i
							class="fa-solid fa-triangle-exclamation"></i> Cần nhập kho ngay</span>
					</div>
					<div
						class="bg-amber-50 dark:bg-amber-900/20 p-4 rounded-xl text-amber-600">
						<i class="fa-solid fa-triangle-exclamation text-2xl"></i>
					</div>
				</div>
			</div>

			<!-- Khối Biểu đồ & Log hoạt động -->
			<div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm lg:col-span-2">
					<div class="flex justify-between items-center mb-6">
						<h4
							class="font-bold text-navy-800 dark:text-white heading-font text-lg">Phân
							Tích Doanh Thu & Đăng Ký</h4>
						<select
							class="bg-slate-100 dark:bg-slate-800 text-xs font-bold rounded-lg p-2 border-0 outline-none">
							<option>Tháng này</option>
							<option>Tháng trước</option>
						</select>
					</div>
					<div class="h-80 flex items-center justify-center">
						<canvas id="salesChart" class="w-full h-full"></canvas>
					</div>
				</div>

				<!-- Log hoạt động hệ thống  -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm flex flex-col">
					<h4
						class="font-bold text-navy-800 dark:text-white heading-font text-lg mb-4">Nhật
						Ký Quản Trị</h4>
					<div id="log-list"
						class="flex-1 overflow-y-auto space-y-4 max-h-[320px] pr-2">
						<!-- Sẽ tự động đổ Logs từ JS -->
					</div>
				</div>
			</div>
		</section>

		<!-- ================= PANEL 2: QUẢN LÝ SÁCH (Mục 62) ================= -->
		<section id="panel-books" class="tab-panel hidden space-y-6">
			<div
				class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm">
				<!-- Bộ lọc & Thêm mới -->
				<div
					class="flex flex-col md:flex-row justify-between items-center gap-4 mb-6">
					<div class="flex flex-wrap gap-3 items-center w-full md:w-auto">
						<div
							class="bg-slate-100 dark:bg-slate-800 px-3 py-2 rounded-xl flex items-center gap-2">
							<i class="fa-solid fa-magnifying-glass text-slate-400"></i> <input
								type="text" id="search-book" oninput="filterBooks()"
								placeholder="Tìm tên sách, tác giả, ISBN..."
								class="bg-transparent border-none outline-none text-sm w-48 text-slate-800 dark:text-slate-100">
						</div>
						<select id="filter-category" onchange="filterBooks()"
							class="bg-slate-100 dark:bg-slate-800 text-sm rounded-xl px-3 py-2 border-none outline-none">
							<option value="">Tất cả danh mục</option>
						</select> <select id="filter-author" onchange="filterBooks()"
							class="bg-slate-100 dark:bg-slate-800 text-sm rounded-xl px-3 py-2 border-none outline-none">
							<option value="">Tất cả tác giả</option>
						</select> <select id="filter-status" onchange="filterBooks()"
							class="bg-slate-100 dark:bg-slate-800 text-sm rounded-xl px-3 py-2 border-none outline-none">
							<option value="active">Đang kinh doanh</option>
							<option value="deleted">Đã ẩn (Thùng rác)</option>
						</select>
					</div>
					<button onclick="openBookModal()"
						class="w-full md:w-auto bg-navy-800 dark:bg-blue-600 hover:opacity-90 active:scale-95 text-white px-5 py-2.5 rounded-xl font-bold text-sm transition-all flex items-center justify-center gap-2">
						<i class="fa-solid fa-circle-plus"></i> Thêm Sách Mới
					</button>
				</div>

				<!-- Bảng hiển thị danh sách Sách -->
				<div class="overflow-x-auto">
					<table class="w-full text-left border-collapse">
						<thead>
							<tr
								class="border-b border-slate-100 dark:border-slate-800 text-slate-400 text-xs font-bold uppercase">
								<th class="py-4 px-4">Hình ảnh</th>
								<th class="py-4 px-4">Thông tin Sách</th>
								<th class="py-4 px-4">Tác Giả</th>
								<th class="py-4 px-4">Danh Mục</th>
								<th class="py-4 px-4">Giá Bán</th>
								<th class="py-4 px-4">Kho</th>
								<th class="py-4 px-4">Đã bán</th>
								<th class="py-4 px-4 text-center">Thao tác</th>
							</tr>
						</thead>
						<tbody id="book-table-body"
							class="divide-y divide-slate-100 dark:divide-slate-800">
							<!-- Đổ bằng JS -->
						</tbody>
					</table>
				</div>
			</div>
		</section>

		<!-- ================= PANEL 3: QUẢN LÝ DANH MỤC (Mục 60) ================= -->
		<section id="panel-categories" class="tab-panel hidden space-y-6">
			<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
				<!-- Form thêm danh mục -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm h-fit">
					<h3 id="category-form-title"
						class="font-bold text-lg heading-font text-navy-800 dark:text-white mb-4">Thêm
						Danh Mục Mới</h3>
					<form id="category-form" onsubmit="handleCategorySubmit(event)"
						class="space-y-4">
						<input type="hidden" id="category-edit-id">
						<div>
							<label
								class="block text-xs font-bold text-slate-400 uppercase mb-2">Tên
								danh mục</label> <input type="text" id="category-name" required
								placeholder="Ví dụ: Khoa học viễn tưởng"
								class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2.5 text-sm outline-none focus:border-navy-500">
						</div>
						<button type="submit"
							class="w-full bg-navy-800 dark:bg-blue-600 hover:opacity-90 text-white font-bold text-sm py-2.5 rounded-xl transition-all">
							Xác Nhận Lưu</button>
						<button type="button" onclick="resetCategoryForm()"
							class="w-full border border-slate-200 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-900 text-slate-500 text-xs py-2 rounded-xl transition-all">
							Hủy chỉnh sửa</button>
					</form>
				</div>

				<!-- Bảng danh mục -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm md:col-span-2">
					<div class="flex justify-between items-center mb-4">
						<h3
							class="font-bold text-lg heading-font text-navy-800 dark:text-white">Danh
							Sách Danh Mục</h3>
						<select id="filter-category-status" onchange="renderCategories()"
							class="bg-slate-100 dark:bg-slate-800 text-xs font-semibold rounded-xl px-3 py-2 border border-slate-200 dark:border-slate-700 outline-none cursor-pointer">
							<option value="active">📁 Danh mục đang dùng</option>
							<option value="deleted">🗑️ Danh mục đã ẩn</option>
						</select>
					</div>
					<div class="overflow-x-auto">
						<table class="w-full text-left">
							<thead>
								<tr
									class="border-b border-slate-100 dark:border-slate-800 text-slate-400 text-xs font-bold uppercase">
									<th class="py-3 px-4">ID</th>
									<th class="py-3 px-4">Tên danh mục</th>
									<th class="py-3 px-4 text-center">Thao tác</th>
								</tr>
							</thead>
							<tbody id="category-table-body"
								class="divide-y divide-slate-100 dark:divide-slate-800">
								<!-- Đổ bằng JS -->
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</section>

		<!-- ================= PANEL 4: QUẢN LÝ TÁC GIẢ (Mục 61) ================= -->
		<section id="panel-authors" class="tab-panel hidden space-y-6">
			<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
				<!-- Form Tác giả -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm h-fit">
					<h3 id="author-form-title"
						class="font-bold text-lg heading-font text-navy-800 dark:text-white mb-4">Thêm
						Tác Giả</h3>
					<form id="author-form" method="POST"
						action="${pageContext.request.contextPath}/admin/authors"
						enctype="multipart/form-data" onsubmit="handleAuthorSubmit(event)"
						class="space-y-4">
						<input type="hidden" name="id" id="author-edit-id"> <input
							type="hidden" name="action" id="author-action-input" value="add">
						<input type="hidden" name="oldImage" id="author-image">
						<div>
							<label
								class="block text-xs font-bold text-slate-400 uppercase mb-2">Họ
								& Tên Tác Giả</label> <input type="text" id="author-name" name="name"
								required placeholder="Ví dụ: Nguyễn Nhật Ánh"
								class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2.5 text-sm outline-none focus:border-navy-500">
						</div>
						<div>
							<label
								class="block text-xs font-bold text-slate-400 uppercase mb-2">Ảnh
								Chân Dung Tác Giả (Chọn 1 ảnh)</label>
							<div class="flex items-center gap-3">
								<label
									class="flex flex-col items-center justify-center border-2 border-dashed border-slate-300 dark:border-slate-800 hover:border-navy-500 rounded-xl p-4 cursor-pointer hover:bg-slate-100 dark:hover:bg-slate-800 transition-all w-full text-center">
									<i class="fa-solid fa-user-tie text-xl text-slate-400 mb-1"></i>
									<span class="text-xs text-slate-500 font-semibold"
									id="author-file-name">Tải ảnh lên</span> <input type="file"
									id="author-image-file" name="image" accept="image/*"
									class="hidden"
									onchange="previewAuthorImage(event); validateSingleImage(this, 'author-error')">
								</label>
								<div id="author-error"
									style="display: none; color: #ef4444; font-size: 12px; margin-top: 6px;">
									<i class="fa-solid fa-triangle-exclamation"></i> <span></span>
								</div>
								<div id="author-preview-container" class="hidden shrink-0">
									<img id="author-preview-img"
										class="w-12 h-12 rounded-full object-cover border border-slate-200 shadow-sm">
								</div>
							</div>
							<!-- Hidden input lưu trữ URL hiện tại hoặc Base64 của ảnh -->
							<input type="hidden" id="author-image">
						</div>
						<button type="button" onclick="submitAuthorForm()"
							class="w-full bg-navy-800 dark:bg-blue-600 hover:opacity-90 text-white font-bold text-sm py-2.5 rounded-xl transition-all">
							Lưu Thông Tin</button>
						<button type="button" onclick="resetAuthorForm()"
							class="w-full border border-slate-200 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-900 text-slate-500 text-xs py-2 rounded-xl transition-all">
							Hủy chỉnh sửa</button>
					</form>
				</div>

				<!-- Bảng tác giả -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm md:col-span-2">
					<div class="flex justify-between items-center mb-4">
						<h3
							class="font-bold text-lg heading-font text-navy-800 dark:text-white">Danh
							Sách Tác Giả</h3>
						<select id="filter-author-status" onchange="renderAuthors()"
							class="bg-slate-100 dark:bg-slate-800 text-xs font-semibold rounded-xl px-3 py-2 border border-slate-200 dark:border-slate-700 outline-none cursor-pointer">
							<option value="active">✍️ Tác giả hiển thị</option>
							<option value="deleted">🗑️ Tác giả đã ẩn</option>
						</select>
					</div>
					<div class="overflow-x-auto">
						<table class="w-full text-left">
							<thead>
								<tr
									class="border-b border-slate-100 dark:border-slate-800 text-slate-400 text-xs font-bold uppercase">
									<th class="py-3 px-4">Ảnh</th>
									<th class="py-3 px-4">Tên tác giả</th>
									<th class="py-3 px-4 text-center">Thao tác</th>
								</tr>
							</thead>
							<tbody id="author-table-body"
								class="divide-y divide-slate-100 dark:divide-slate-800">
								<!-- Đổ bằng JS -->
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</section>

		<!-- ================= PANEL 5: QUẢN LÝ NGƯỜI DÙNG (Mục 17, 18) ================= -->
		<section id="panel-users" class="tab-panel hidden space-y-6">
			<div
				class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm">
				<!-- Tìm kiếm và nút chức năng -->
				<div class="flex justify-between items-center mb-6">
					<div
						class="bg-slate-100 dark:bg-slate-800 px-3 py-2 rounded-xl flex items-center gap-2">
						<i class="fa-solid fa-magnifying-glass text-slate-400"></i> <input
							type="text" id="search-user" oninput="filterUsers()"
							placeholder="Tìm tên, email..."
							class="bg-transparent border-none outline-none text-sm w-48 text-slate-800 dark:text-slate-100">
					</div>
					<button onclick="exportUsersToCSV()"
						class="bg-emerald-600 hover:opacity-90 active:scale-95 text-white px-4 py-2 rounded-xl font-bold text-sm transition-all flex items-center gap-2">
						<i class="fa-solid fa-file-excel"></i> Xuất Báo Cáo
					</button>
				</div>

				<div class="overflow-x-auto">
					<table class="w-full text-left">
						<thead>
							<tr
								class="border-b border-slate-100 dark:border-slate-800 text-slate-400 text-xs font-bold uppercase">
								<th class="py-4 px-4">Username</th>
								<th class="py-4 px-4">Họ & Tên</th>
								<th class="py-4 px-4">Email</th>
								<th class="py-4 px-4">SĐT</th>
								<th class="py-4 px-4">Quyền</th>
								<th class="py-4 px-4">Trạng thái</th>
								<th class="py-4 px-4 text-center">Thao tác</th>
							</tr>
						</thead>
						<tbody id="user-table-body"
							class="divide-y divide-slate-100 dark:divide-slate-800">
							<!-- Đổ bằng JS -->
						</tbody>
					</table>
				</div>
			</div>
		</section>

		<!-- ================= PANEL 6: QUẢN LÝ ĐÁNH GIÁ (Mục 63) ================= -->
		<section id="panel-reviews" class="tab-panel hidden space-y-6">
			<div
				class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm">
				<h3
					class="font-bold text-lg heading-font text-navy-800 dark:text-white mb-6">Phê
					Duyệt Đánh Giá Khách Hàng (Review & Review Images)</h3>

				<div id="review-cards-container"
					class="grid grid-cols-1 md:grid-cols-2 gap-6">
					<!-- Đổ bằng JS -->
				</div>
			</div>
		</section>

		<!-- ================= PANEL 7: QUẢN LÝ TỒN KHO (Mục 65) ================= -->
		<section id="panel-inventory" class="tab-panel hidden space-y-6">
			<!-- Thống kê khẩn cấp và đề xuất nhập kho -->
			<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
				<!-- Cảnh báo & Đề xuất -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm">
					<h3 class="font-bold text-lg heading-font text-amber-500 mb-4">
						<i class="fa-solid fa-triangle-exclamation"></i> Báo Động Hết Hàng
						& Đề Xuất Nhập Kho
					</h3>
					<div id="low-stock-alert-container" class="space-y-4">
						<!-- Đổ bằng JS -->
					</div>
				</div>

				<!-- Nhật ký thay đổi số lượng kho -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm flex flex-col">
					<h3
						class="font-bold text-lg heading-font text-navy-800 dark:text-white mb-4">
						<i class="fa-solid fa-clock-rotate-left"></i> Nhật Ký Biến Động
						Kho Hàng
					</h3>
					<div id="inventory-logs-list"
						class="flex-1 space-y-4 overflow-y-auto max-h-[350px] pr-2">
						<!-- Đổ bằng JS -->
					</div>
				</div>
			</div>
		</section>

		<!-- ================= PANEL 8: KHUYẾN MÃI ĐỒNG GIÁ (Mục 69) ================= -->
		<section id="panel-promotions" class="tab-panel hidden space-y-6">
			<div class="grid grid-cols-1 md:grid-cols-3 gap-8">
				<!-- Thiết lập đồng giá -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm h-fit">
					<h3
						class="font-bold text-lg heading-font text-navy-800 dark:text-white mb-4">Tạo
						Sự Kiện Đồng Giá</h3>
					<form onsubmit="handlePromotionSubmit(event)" class="space-y-4">
						<div>
							<label
								class="block text-xs font-bold text-slate-400 uppercase mb-2">Tên
								Chương Trình</label> <input type="text" id="promo-name" required
								placeholder="Ví dụ: Đồng giá Tuổi Thơ"
								class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2.5 text-sm outline-none focus:border-navy-500">
						</div>
						<div>
							<label
								class="block text-xs font-bold text-slate-400 uppercase mb-2">Mức
								Giá Áp Dụng (đ)</label> <input type="number" id="promo-price" required
								min="1000" placeholder="Ví dụ: 39000"
								class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2.5 text-sm outline-none focus:border-navy-500">
						</div>
						<div>
							<label
								class="block text-xs font-bold text-slate-400 uppercase mb-2">Sản
								Phẩm Áp Dụng</label> <select id="promo-target" required
								class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-4 py-2.5 text-sm outline-none">
								<option value="all">Tất cả sản phẩm</option>
								<option value="cate_1">Chỉ nhóm danh mục Tiểu thuyết</option>
								<option value="cate_3">Chỉ nhóm danh mục Kinh tế</option>
							</select>
						</div>
						<button type="submit"
							class="w-full bg-navy-800 dark:bg-blue-600 hover:opacity-90 text-white font-bold text-sm py-2.5 rounded-xl transition-all">
							Kích Hoạt Chương Trình</button>
					</form>
				</div>

				<!-- Các chương trình đang chạy -->
				<div
					class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm md:col-span-2">
					<h3
						class="font-bold text-lg heading-font text-navy-800 dark:text-white mb-4">Các
						Đợt Đồng Giá Đang Hoạt Động</h3>
					<div class="overflow-x-auto">
						<table class="w-full text-left">
							<thead>
								<tr
									class="border-b border-slate-100 dark:border-slate-800 text-slate-400 text-xs font-bold uppercase">
									<th class="py-3 px-4">Tên chương trình</th>
									<th class="py-3 px-4">Giá áp dụng</th>
									<th class="py-3 px-4">Áp dụng cho</th>
									<th class="py-3 px-4">Hành động</th>
								</tr>
							</thead>
							<tbody id="promo-table-body"
								class="divide-y divide-slate-100 dark:divide-slate-800">
								<!-- Đổ bằng JS -->
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</section>

		<!-- ================= PANEL 9: HÒM THƯ LIÊN HỆ (Mục 22) ================= -->
		<!-- ================= PANEL: QUẢN LÝ ĐƠN HÀNG ================= -->
		<section id="panel-orders" class="tab-panel hidden space-y-6">
			<div
				class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm">
				<h3
					class="font-bold text-lg heading-font text-navy-800 dark:text-white mb-2">Quản
					Lý Đơn Hàng</h3>
				<p class="text-sm text-slate-400 mb-4">
					Tổng: <strong>${totalOrders}</strong> đơn — Chờ xử lý: <strong
						class="text-amber-500">${pendingOrders}</strong>
				</p>
				<div class="overflow-x-auto">
					<table class="w-full text-left text-sm border-collapse">
						<thead>
							<tr class="bg-slate-100 dark:bg-slate-800">
								<th class="px-4 py-3 rounded-l-lg">Mã đơn</th>
								<th class="px-4 py-3">Khách hàng</th>
								<th class="px-4 py-3">SĐT</th>
								<th class="px-4 py-3">Tổng tiền</th>
								<th class="px-4 py-3">Ngày đặt</th>
								<th class="px-4 py-3">Trạng thái</th>
								<th class="px-4 py-3 rounded-r-lg">Thao tác</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="order" items="${recentOrders}">
								<tr
									class="border-b border-slate-100 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-900">
									<td class="px-4 py-3 font-semibold">${order.orderCode}</td>
									<td class="px-4 py-3">${order.customerName}</td>
									<td class="px-4 py-3">${order.phone}</td>
									<td class="px-4 py-3 font-semibold"><fmt:formatNumber
											value="${order.totalAmount}" pattern="#,###" />đ</td>
									<td class="px-4 py-3 text-slate-400"><fmt:formatDate
											value="${order.createdAt}" pattern="dd/MM/yy HH:mm" /></td>
									<td class="px-4 py-3"><select
										onchange="updateOrderStatus(${order.orderId}, this.value)"
										class="text-xs px-2 py-1 rounded-lg border border-slate-200 bg-white dark:bg-slate-800">
											<option value="PENDING"
												${order.status=='PENDING'?'selected':''}>Chờ xử lý</option>
											<option value="PROCESSING"
												${order.status=='PROCESSING'?'selected':''}>Đang xử
												lý</option>
											<option value="SHIPPING"
												${order.status=='SHIPPING'?'selected':''}>Đang giao</option>
											<option value="COMPLETED"
												${order.status=='COMPLETED'?'selected':''}>Hoàn
												thành</option>
											<option value="CANCELLED"
												${order.status=='CANCELLED'?'selected':''}>Đã hủy</option>
									</select></td>
									<td class="px-4 py-3">
										<button onclick="viewOrderDetail(${order.orderId})"
											class="text-xs text-blue-600 hover:underline">Xem</button>
									</td>
								</tr>
							</c:forEach>
							<c:if test="${empty recentOrders}">
								<tr>
									<td colspan="7" class="px-4 py-8 text-center text-slate-400">Chưa
										có đơn hàng nào.</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</div>

			<!-- Modal chi tiết đơn hàng -->
			<div id="order-detail-modal"
				class="fixed inset-0 bg-black/50 z-50 hidden flex items-center justify-center p-4">
				<div
					class="bg-white dark:bg-slate-900 rounded-2xl shadow-xl w-full max-w-2xl max-h-[85vh] overflow-y-auto">
					<div
						class="flex justify-between items-center p-6 border-b border-slate-100 dark:border-slate-800">
						<h3 class="font-bold text-lg text-navy-800 dark:text-white"
							id="modal-order-code">Chi tiết đơn hàng</h3>
						<button
							onclick="document.getElementById('order-detail-modal').classList.add('hidden')"
							class="text-slate-400 hover:text-slate-600 text-xl">&times;</button>
					</div>
					<div id="modal-order-body" class="p-6 text-sm space-y-3">
						<p class="text-slate-400">Đang tải...</p>
					</div>
				</div>
			</div>
		</section>

		<section id="panel-messages" class="tab-panel hidden space-y-6">
			<div
				class="bg-white dark:bg-slate-950 p-6 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm">
				<h3
					class="font-bold text-lg heading-font text-navy-800 dark:text-white mb-4">Ý
					Kiến Đóng Góp & Form Liên Hệ</h3>
				<div class="overflow-x-auto">
					<table class="w-full text-left">
						<thead>
							<tr
								class="border-b border-slate-100 dark:border-slate-800 text-slate-400 text-xs font-bold uppercase">
								<th class="py-3 px-4">Khách hàng</th>
								<th class="py-3 px-4">Email/SĐT</th>
								<th class="py-3 px-4">Nội dung</th>
								<th class="py-3 px-4 text-center">Thao tác</th>
							</tr>
						</thead>
						<tbody id="message-table-body"
							class="divide-y divide-slate-100 dark:divide-slate-800">
							<!-- Đổ bằng JS -->
						</tbody>
					</table>
				</div>
			</div>
		</section>

		<!-- FOOTER DƯỚI -->
		<footer
			class="mt-auto pt-8 border-t border-slate-200 dark:border-slate-800 text-center text-xs text-slate-400 flex justify-between">
			<p>© 2026 Admin Bookland - Góc Sách. Bảo lưu mọi quyền.</p>
			<p>Thiết kế cho Môn Thực Tập Lập Trình Web - Đạt điểm A+</p>
		</footer>
		<!-- Modal xác nhận dùng chung -->
		<div id="confirmModal"
			class="fixed inset-0 z-[999] hidden bg-black/50 flex items-center justify-center p-4">
			<div
				class="bg-white dark:bg-slate-900 w-full max-w-sm rounded-2xl shadow-2xl border border-slate-100 dark:border-slate-800 p-6 space-y-4">
				<div class="flex items-center gap-3">
					<div class="bg-amber-100 dark:bg-amber-900/30 p-2.5 rounded-xl">
						<i class="fa-solid fa-circle-exclamation text-amber-500 text-xl"></i>
					</div>
					<h3 id="confirmModalTitle"
						class="font-bold text-lg text-navy-800 dark:text-white">Xác
						nhận</h3>
				</div>
				<p id="confirmModalMessage"
					class="text-sm text-slate-500 dark:text-slate-400 leading-relaxed">
					Bạn có chắc muốn thực hiện hành động này?</p>
				<div class="flex gap-3 pt-2">
					<button id="confirmModalCancel"
						class="flex-1 border border-slate-200 dark:border-slate-700 hover:bg-slate-50 dark:hover:bg-slate-800 text-slate-600 dark:text-slate-300 text-sm font-semibold py-2.5 rounded-xl transition-all">
						Hủy bỏ</button>
					<button id="confirmModalOk"
						class="flex-1 bg-navy-800 hover:opacity-90 text-white text-sm font-bold py-2.5 rounded-xl transition-all">
						Xác nhận</button>
				</div>
			</div>
		</div>
	</main>

	<!-- MODAL 1: THÊM / CHỈNH SỬA SÁCH (Mục 62, 27) -->
	<div id="book-modal"
		class="fixed inset-0 z-50 hidden bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
		<div
			class="bg-white dark:bg-slate-950 w-full max-w-2xl rounded-2xl shadow-xl border border-slate-100 dark:border-slate-800 overflow-hidden transform scale-95 transition-all duration-300">
			<div
				class="bg-navy-800 text-white p-5 flex justify-between items-center">
				<h3 id="book-modal-title" class="font-bold text-lg heading-font">Thêm
					Sách Mới</h3>
				<button onclick="closeBookModal()"
					class="text-white/80 hover:text-white text-xl">
					<i class="fa-solid fa-xmark"></i>
				</button>
			</div>

			<form id="book-form" method="POST"
				action="${pageContext.request.contextPath}/admin/books"
				enctype="multipart/form-data" onsubmit="return validateBook()"
				class="p-6 space-y-4 max-h-[80vh] overflow-y-auto">
				<input type="hidden" name="action" id="book-action" value="add">
				<input type="hidden" name="bookId" id="book-edit-id"> <input
					type="hidden" name="oldImage" id="book-image-url">

				<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Tên
							Sách</label> <input type="text" id="book-title" name="title" required
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none">
					</div>
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Tác
							Giả</label> <select id="book-author" name="authorId" required
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none"></select>
					</div>
				</div>

				<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Danh
							Mục Sách</label> <select id="book-category" name="categoryId" required
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none"></select>
					</div>
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Năm
							Xuất Bản</label> <input type="number" id="book-year" name="publishYear"
							required min="1000" max="2026"
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none">
					</div>
				</div>

				<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Giá
							Bán (đ)</label> <input type="number" id="book-price" name="price"
							required min="0"
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none">
					</div>
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Giá
							Gốc (đ) </label> <input type="number" id="book-origin-price"
							name="originPrice" required min="0"
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none">
					</div>
				</div>

				<div class="grid grid-cols-1 md:grid-cols-2 gap-4">
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Số
							Lượng Tồn Kho</label> <input type="number" id="book-stock" name="stock"
							required min="0"
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none">
					</div>
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Mã
							ISBN </label> <input type="text" id="book-isbn" name="isbn" required
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none"
							placeholder="978-604-...">
					</div>
				</div>

				<div class="grid grid-cols-1 md:grid-cols-3 gap-4">
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Nhà
							Xuất Bản</label> <input type="text" id="book-publisher" name="publisher"
							required
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none">
					</div>
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Ngôn
							Ngữ</label> <input type="text" id="book-language" name="language"
							required
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none">
					</div>
					<div>
						<label
							class="block text-xs font-bold text-slate-400 uppercase mb-1">Hình
							Thức Bìa</label> <select id="book-cover" name="coverType" required
							class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none">
							<option value="Bìa mềm">Bìa mềm</option>
							<option value="Bìa cứng">Bìa cứng</option>
						</select>
					</div>
				</div>

				<!-- BỘ CHỌN ẢNH BÌA SÁCH (CHỌN 1 ẢNH) -->
				<div class="space-y-1">
					<label
						class="block text-xs font-bold text-slate-400 uppercase mb-1">Ảnh
						bìa sách (Chọn 1 ảnh)</label>
					<div class="flex items-center gap-4">
						<label
							class="flex flex-col items-center justify-center border-2 border-dashed border-slate-300 dark:border-slate-800 hover:border-navy-500 rounded-xl p-4 cursor-pointer hover:bg-slate-100 dark:hover:bg-slate-900 transition-all w-full text-center">
							<i
							class="fa-solid fa-cloud-arrow-up text-2xl text-slate-400 mb-1"></i>
							<span class="text-xs text-slate-500 font-semibold"
							id="cover-file-name">Tải ảnh bìa lên</span> <input type="file"
							id="book-cover-image" name="image" accept="image/*"
							class="hidden"
							onchange="previewCoverImage(event); validateSingleImage(this, 'cover-error')">
						</label>
						<div id="cover-error"
							style="display: none; color: #ef4444; font-size: 12px; margin-top: 6px;">
							<i class="fa-solid fa-triangle-exclamation"></i> <span></span>
						</div>
						<div id="book-cover-preview-container" class="hidden shrink-0">
							<img id="book-cover-preview"
								class="w-16 h-20 object-cover rounded-lg border shadow-sm">
						</div>
					</div>
					<!-- Trường hidden lưu URL thực tế (Base64 để mock hoạt động) -->
					<input type="hidden" id="book-image-url">
				</div>

				<!-- BỘ CHỌN ẢNH CHI TIẾT SÁCH (CHỌN NHIỀU ẢNH) -->
				<div class="space-y-1">
					<label
						class="block text-xs font-bold text-slate-400 uppercase mb-1">Ảnh
						chi tiết (Chọn nhiều ảnh)</label> <label
						class="flex flex-col items-center justify-center border-2 border-dashed border-slate-300 dark:border-slate-800 hover:border-navy-500 rounded-xl p-4 cursor-pointer hover:bg-slate-100 dark:hover:bg-slate-900 transition-all text-center">
						<i class="fa-solid fa-images text-2xl text-slate-400 mb-1"></i> <span
						class="text-xs text-slate-500 font-semibold"
						id="detail-files-count">Tải các ảnh chi tiết lên (Có thể
							chọn nhiều)</span> <input type="file" id="book-detail-images"
						name="subImages" accept="image/*" multiple class="hidden"
						onchange="previewDetailImages(event); validateMultipleImages(this, 'detail-error')">
						<div id="detail-error"
							style="display: none; color: #ef4444; font-size: 12px; margin-top: 6px;">
							<i class="fa-solid fa-triangle-exclamation"></i> <span></span>
						</div>
					</label>
					<div id="book-details-preview-container"
						class="flex flex-wrap gap-2 mt-2"></div>
				</div>

				<div>
					<label
						class="block text-xs font-bold text-slate-400 uppercase mb-1">Mô
						tả Sách</label>
					<textarea id="book-description" name="description" rows="3"
						class="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3 py-2 text-sm outline-none"></textarea>
				</div>

				<button type="button" onclick="submitBookForm()"
					class="w-full bg-navy-800 dark:bg-blue-600 hover:opacity-90 text-white font-bold py-3 rounded-xl transition-all">
					Lưu Sách Vào Database</button>
			</form>
		</div>
	</div>

	<!-- MODAL 2: XEM CHI TIẾT USER (Mục 19) -->
	<div id="user-modal"
		class="fixed inset-0 z-50 hidden bg-black/60 backdrop-blur-sm flex items-center justify-center p-4">
		<div
			class="bg-white dark:bg-slate-950 w-full max-w-lg rounded-2xl shadow-xl border border-slate-100 dark:border-slate-800 overflow-hidden transform scale-95 transition-all duration-300">
			<div class="p-6 space-y-6">
				<div class="flex justify-between items-start">
					<h3
						class="font-bold text-xl heading-font text-navy-800 dark:text-white">Chi
						Tiết Người Dùng</h3>
					<button onclick="closeUserModal()"
						class="text-slate-400 hover:text-slate-600">
						<i class="fa-solid fa-xmark text-xl"></i>
					</button>
				</div>

				<div class="flex items-center gap-4">
					<div
						class="w-16 h-16 rounded-full bg-slate-100 dark:bg-slate-800 flex items-center justify-center font-bold text-lg text-navy-800 dark:text-slate-200 border">
						<i class="fa-regular fa-user text-2xl"></i>
					</div>
					<div>
						<h4 id="user-modal-fullname"
							class="font-bold text-lg text-slate-800 dark:text-slate-100">Hương
							Quỳnh</h4>
						<p id="user-modal-username" class="text-xs text-slate-400">@quynh</p>
					</div>
				</div>

				<div class="space-y-2 border-t pt-4 text-sm">
					<p>
						<strong>Email:</strong> <span id="user-modal-email">shodakima@gmail.com</span>
					</p>
					<p>
						<strong>Số điện thoại:</strong> <span id="user-modal-phone">Chưa
							cập nhật</span>
					</p>
					<p>
						<strong>Địa chỉ nhận hàng :</strong> <span id="user-modal-address">Chưa
							cập nhật</span>
					</p>
					<p>
						<strong>Ngày tạo tài khoản:</strong> <span id="user-modal-created">2026-04-19</span>
					</p>
				</div>

				<div class="border-t pt-4">
					<h5
						class="font-bold text-sm text-navy-800 dark:text-slate-200 mb-3">Lịch
						Sử Mua Hàng & Hoạt Động</h5>
					<div class="space-y-2 text-xs text-slate-500">
						<div class="flex justify-between border-b pb-1">
							<span>Đơn hàng #GS-9023</span> <span
								class="text-emerald-500 font-bold">Thành công</span>
						</div>
						<div class="flex justify-between border-b pb-1">
							<span>Đơn hàng #GS-8112</span> <span
								class="text-emerald-500 font-bold">Thành công</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Data thật từ server inject vào JS -->
	<script>
    const CTX = "${pageContext.request.contextPath}";

    let categories = [
        <c:forEach var="c" items="${categories}" varStatus="s">
            {id:${c.id}, name:"${fn:escapeXml(c.name)}"}
            <c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];
    
    let deletedCategories = [
        <c:forEach var="c" items="${deletedCategories}" varStatus="s">
            {id:${c.id}, name:"${fn:escapeXml(c.name)}"}
            <c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];

    let authors = [
        <c:forEach var="a" items="${authors}" varStatus="s">
            {id:${a.id}, name:"${fn:escapeXml(a.name)}", image:"${a.image}"}
            <c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];

    let deletedAuthors = [
        <c:forEach var="a" items="${deletedAuthors}" varStatus="s">
            {id:${a.id}, name:"${fn:escapeXml(a.name)}", image:"${a.image}"}
            <c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];
    
    let books = [
        <c:forEach var="b" items="${books}" varStatus="s">
            {
                id:           ${b.id},
                title:        "${fn:escapeXml(b.title)}",
                author_id:    ${b.author.id},
                category_id:  ${b.category.id},
                price:        ${b.price},
                origin_price: ${b.originPrice},
                stock:        ${b.stock},
                sold:         ${b.soldQuantity},
                isbn:         "${b.isbn}",
                publisher:    "${fn:escapeXml(b.publisher)}",
                language:     "${b.language}",
                cover:        "${b.coverType}",
                image:        "${b.image}",
                year:         ${b.publishYear},
                desc:         "${fn:escapeXml(b.description)}",
                detail_images: []
            }
            <c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];
    
 // data sách đã bị ẩn (thùng rác)
    let deletedBooks = [
        <c:forEach var="b" items="${deletedBooks}" varStatus="s">
            {
                id:          ${b.id},
                title:       "${fn:escapeXml(b.title)}",
                author_id:   ${b.author.id},
                category_id: ${b.category.id},
                price:       ${b.price},
                origin_price:${b.originPrice},
                stock:       ${b.stock},
                sold:        ${b.soldQuantity},
                isbn:        "${b.isbn}",
                publisher:   "${fn:escapeXml(b.publisher)}",
                language:    "${b.language}",
                cover:       "${b.coverType}",
                image:       "${b.image}",
                year:        ${b.publishYear},
                desc:        "${fn:escapeXml(b.description)}",
                detail_images:[]
            }
            <c:if test="${!s.last}">,</c:if>
        </c:forEach>
    ];

    <c:if test="${not empty param.success or not empty param.error}">
    window._adminNotify = {
        key: '${not empty param.success ? param.success : param.error}'
    };
    </c:if>
</script>

	<!-- Toàn bộ logic JS nằm trong file riêng -->
	<script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
</body>
</html>