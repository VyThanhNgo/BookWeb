/**
 * 
 */
// Thay thế confirm()của trình duyệt(hộp thoại localhost:8080 says) bằng modal đẹp
function showConfirm(message, title, btnLabel, onConfirm) {
    document.getElementById('confirmModalMessage').textContent = message;
    document.getElementById('confirmModalTitle').textContent = title || 'Xác nhận';
    const okBtn = document.getElementById('confirmModalOk');
    okBtn.textContent = btnLabel || 'Xác nhận';
    okBtn.className = 'confirmModalOkBtn ' + (btnLabel === 'Xóa vĩnh viễn' 
        ? 'bg-red-700 hover:bg-red-800' : 'bg-navy-800 hover:opacity-90') 
        + ' text-white text-sm font-bold px-5 py-2 rounded-xl transition-all';
    const modal = document.getElementById('confirmModal');
    modal.classList.remove('hidden');
    const fresh = okBtn.cloneNode(true);
    fresh.className = okBtn.className;
    okBtn.parentNode.replaceChild(fresh, okBtn);
    fresh.addEventListener('click', function () {
        modal.classList.add('hidden');
        onConfirm();
    });
    document.getElementById('confirmModalCancel').onclick = function () {
        modal.classList.add('hidden');
    };
}

// Các biến mock không liên quan đến server
let users = [
	{ id: 1, username: "quynh", fullname: "Hương Quỳnh", email: "shodakima@gmail.com", phone: "0982736152", role: "user", is_active: true, created_at: "2026-04-19" },
	{ id: 2, username: "admin_test", fullname: "Admin Hệ Thống", email: "admin@gocsach.vn", phone: "0900000001", role: "admin", is_active: true, created_at: "2026-01-01" },
	{ id: 3, username: "spam_account", fullname: "Lê Văn Spam", email: "spam@gmail.com", phone: "0349881726", role: "user", is_active: false, created_at: "2026-05-20" }
];

let reviews = [
	{ id: 1, book_title: "Rich Dad Poor Dad", user_fullname: "Hương Quỳnh", rating: 4, comment: "Nhận được hàng cũng nhanh, sách ok đóng gói cẩn thận.", images: ["http://res.cloudinary.com/dqiefayjh/image/upload/v1776606948/reviews/vwhpvvjhuwwva0f2sumy.jpg"] }
];

let messages = [
	{ id: 1, name: "Trần Anh Tuấn", contact: "tuan@gmail.com", content: "Sách có áp dụng mã giảm giá khi mua sỉ số lượng lớn không shop?" }
];

let promotions = [
	{ id: 1, name: "Khởi đầu mùa hè", price: 39000, target: "cate_1" }
];

let inventoryLogs = [
	{ time: "15:30:20", message: "Nhập thêm 10 cuốn 'Rich Dad Poor Dad'" },
	{ time: "10:15:00", message: "Hủy đơn hàng #GS-9238 - hoàn lại 1 cuốn" }
];

let adminLogs = [
	{ id: 1, time: "Hôm nay, 15:30", action: "Đã khóa tài khoản Lê Văn Spam" },
	{ id: 2, time: "Hôm nay, 14:22", action: "Cập nhật giá bán sách Vũ Trụ Trong Vỏ Hạt Dẻ" }
];

let tempDetailImages = [];

// ===================== PREVIEW ẢNH =====================
function previewCoverImage(event) {
	const file = event.target.files[0];
	if (file) {
		document.getElementById('cover-file-name').innerText = file.name;
		const reader = new FileReader();
		reader.onload = function(e) {
			document.getElementById('book-cover-preview').src = e.target.result;
			document.getElementById('book-cover-preview-container').classList.remove('hidden');
			document.getElementById('book-image-url').value = e.target.result;
		};
		reader.readAsDataURL(file);
	}
}

function previewDetailImages(event) {
	const files = event.target.files;
	const container = document.getElementById('book-details-preview-container');
	container.innerHTML = '';
	tempDetailImages = [];
	document.getElementById('detail-files-count').innerText = 'Đã chọn ' + files.length + ' ảnh chi tiết';
	for (let i = 0; i < files.length; i++) {
		const reader = new FileReader();
		reader.onload = function(e) {
			tempDetailImages.push(e.target.result);
			const img = document.createElement('img');
			img.className = "w-16 h-16 object-cover rounded-lg border shadow-sm";
			img.src = e.target.result;
			container.appendChild(img);
		};
		reader.readAsDataURL(files[i]);
	}
}

function previewAuthorImage(event) {
	const file = event.target.files[0];
	if (file) {
		document.getElementById('author-file-name').innerText = file.name;
		const reader = new FileReader();
		reader.onload = function(e) {
			document.getElementById('author-preview-img').src = e.target.result;
			document.getElementById('author-preview-container').classList.remove('hidden');
			document.getElementById('author-image').value = e.target.result;
		};
		reader.readAsDataURL(file);
	}
}

// ===================== SWITCH TAB =====================
function switchTab(tabId) {
	document.querySelectorAll('.tab-panel').forEach(p => p.classList.add('hidden'));
	document.getElementById('panel-' + tabId).classList.remove('hidden');

	document.querySelectorAll('.sidebar-btn').forEach(btn => {
		btn.classList.remove('bg-navy-500/20', 'text-white', 'border-emerald-500');
		btn.classList.add('text-slate-300', 'border-transparent');
	});
	const activeBtn = document.getElementById('btn-' + tabId);
	activeBtn.classList.add('bg-navy-500/20', 'text-white', 'border-emerald-500');
	activeBtn.classList.remove('text-slate-300', 'border-transparent');

	const titles = {
		dashboard: "Tổng Quan Hệ Thống",
		books: "Quản Lý Kho Sách",
		categories: "Quản Lý Danh Mục",
		authors: "Quản Lý Tác Giả",
		users: "Quản Lý Thành Viên",
		reviews: "Kiểm Duyệt Bình Luận",
		inventory: "Quản Trị Tồn Kho",
		promotions: "Cấu Hình Đồng Giá",
		coupons: "Quản Lý Mã Giảm Giá",
		orders: "Theo Dõi Trạng Thái Đơn Hàng",
		messages: "Ý Kiến & Liên Hệ"
	};
	document.getElementById('current-title').innerText = titles[tabId];
	if (tabId === 'coupons') loadCoupons();

	const renders = {
		dashboard: renderDashboard, books: renderBooks,
		categories: renderCategories, authors: renderAuthors,
		users: renderUsers, reviews: renderReviews,
		inventory: renderInventory, promotions: renderPromotions,
		messages: renderMessages
	};
	if (renders[tabId]) renders[tabId]();
}

// ===================== TOAST =====================
function showToast(message, type) {
	type = type || 'success';
	const toast = document.createElement('div');
	const bgClass = type === 'success' ? 'bg-emerald-500' : 'bg-rose-500';
	toast.className = bgClass + ' text-white px-5 py-3 rounded-xl shadow-lg flex items-center gap-3 animate-bounce transition-all duration-300';
	const icon = type === 'success' ? 'fa-circle-check' : 'fa-circle-exclamation';
	toast.innerHTML = '<i class="fa-solid ' + icon + ' text-lg"></i>'
		+ '<span class="text-sm font-semibold">' + message + '</span>';
	document.getElementById('toast-container').appendChild(toast);
	setTimeout(function() {
		toast.classList.add('opacity-0');
		setTimeout(function() { toast.remove(); }, 300);
	}, 3000);
}

// ===================== DARK MODE =====================
function toggleDarkMode() {
	document.documentElement.classList.toggle('dark');
	showToast("Đã thay đổi chế độ hiển thị!", "success");
}

// ===================== DASHBOARD =====================
function renderDashboard() {
	document.getElementById('dash-low-stock').innerText = books.filter(function(b) { return b.stock <= 5; }).length;

	document.getElementById('log-list').innerHTML = adminLogs.map(function(log) {
		return '<div class="flex gap-3 border-b border-slate-100 dark:border-slate-800 pb-3">'
			+ '<div class="bg-navy-50 dark:bg-slate-900 text-navy-800 dark:text-slate-300 w-8 h-8 rounded-lg flex items-center justify-center shrink-0"><i class="fa-solid fa-clock-rotate-left"></i></div>'
			+ '<div><p class="text-sm font-semibold text-slate-700 dark:text-slate-300">' + log.action + '</p>'
			+ '<span class="text-xs text-slate-400">' + log.time + '</span></div></div>';
	}).join('');
}

function addAdminLog(action) {
	const time = new Date().toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
	adminLogs.unshift({ id: adminLogs.length + 1, time: "Hôm nay, " + time, action: action });
	renderDashboard();
}

// ===================== SÁCH =====================
function renderBooks() {
	const statusEl = document.getElementById('filter-status');
	const status = (statusEl && statusEl.value) ? statusEl.value : 'active';
	const source = (status === 'deleted') ? deletedBooks : books;

	const tbody = document.getElementById('book-table-body');
	tbody.innerHTML = source.map(function(book) {
		const authorName = (authors.find(function(a) { return a.id == book.author_id; }) || { name: "Chưa rõ" }).name;
		const categoryName = (categories.find(function(c) { return c.id == book.category_id; }) || { name: "Chưa rõ" }).name;
		const stockClass = book.stock <= 5 ? 'text-rose-500' : 'text-slate-600 dark:text-slate-300';
		return '<tr class="hover:bg-slate-50 dark:hover:bg-slate-900 transition-all text-sm">'
			+ '<td class="py-4 px-4"><img src="' + book.image + '" class="w-12 h-16 rounded-lg object-cover shadow-sm" alt=""></td>'
			+ '<td class="py-4 px-4 max-w-xs"><p class="font-extrabold text-navy-800 dark:text-slate-200">' + book.title + '</p><p class="text-xs text-slate-400 mt-1">ISBN: ' + book.isbn + '</p></td>'
			+ '<td class="py-4 px-4 font-semibold">' + authorName + '</td>'
			+ '<td class="py-4 px-4"><span class="bg-slate-100 dark:bg-slate-800 text-slate-600 dark:text-slate-300 text-xs font-bold px-2.5 py-1 rounded-lg">' + categoryName + '</span></td>'
			+ '<td class="py-4 px-4 font-bold text-navy-800 dark:text-white">' + book.price.toLocaleString() + 'đ</td>'
			+ '<td class="py-4 px-4"><span class="font-bold ' + stockClass + '">' + book.stock + ' cuốn</span></td>'
			+ '<td class="py-4 px-4 font-semibold text-slate-500">' + book.sold + '</td>'
			+ '<td class="py-4 px-4"><div class="flex justify-center gap-2">'
			+ (function() {
				// Kiểm tra xem dropdown filter-status hiện tại đang chọn mục nào
				const statusEl = document.getElementById('filter-status');
				const isDeletedMode = statusEl && statusEl.value === 'deleted';

				if (isDeletedMode) {
					// Giao diện khi xem Thùng rác: Hiện nút Khôi phục và Xóa hẳn
					return '<button onclick="restoreBook(' + book.id + ')" class="p-2 text-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 rounded-lg" title="Khôi phục sách"><i class="fa-solid fa-trash-arrow-up"></i></button>'
						+ '<button onclick="hardDeleteBook(' + book.id + ')" class="p-2 text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-900/20 rounded-lg" title="Xóa vĩnh viễn"><i class="fa-solid fa-circle-xmark"></i></button>';
				} else {
					// Giao diện bình thường: Hiện nút Sửa và Xóa tạm thời
					return '<button onclick="openBookModal(' + book.id + ')" class="p-2 text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-900/20 rounded-lg" title="Chỉnh sửa"><i class="fa-solid fa-pen"></i></button>'
						+ '<button onclick="deleteBook(' + book.id + ')" class="p-2 text-rose-600 hover:bg-rose-50 dark:hover:bg-rose-900/20 rounded-lg" title="Xóa tạm thời"><i class="fa-solid fa-trash"></i></button>';
				}
			})()
			+ '</div></td></tr>';
	}).join('');

	document.getElementById('book-author').innerHTML = authors.map(function(a) { return '<option value="' + a.id + '">' + a.name + '</option>'; }).join('');
	document.getElementById('book-category').innerHTML = categories.map(function(c) { return '<option value="' + c.id + '">' + c.name + '</option>'; }).join('');
	document.getElementById('filter-category').innerHTML = '<option value="">Tất cả danh mục</option>' + categories.map(function(c) { return '<option value="' + c.id + '">' + c.name + '</option>'; }).join('');
	document.getElementById('filter-author').innerHTML = '<option value="">Tất cả tác giả</option>' + authors.map(function(a) { return '<option value="' + a.id + '">' + a.name + '</option>'; }).join('');
}

function filterBooks() {
	const query = document.getElementById('search-book').value.toLowerCase();
	const cateId = document.getElementById('filter-category').value;
	const authId = document.getElementById('filter-author').value;

	// THÊM: Lấy giá trị trạng thái lọc (active hoặc deleted) từ ô select mới thêm
	const statusFilter = document.getElementById('filter-status') ? document.getElementById('filter-status').value : 'active';

	const source = (statusFilter === 'deleted') ? deletedBooks : books;

	const filtered = source.filter(function(b) {
		return (b.title.toLowerCase().includes(query) || b.isbn.includes(query))
			&& (cateId ? b.category_id == cateId : true)
			&& (authId ? b.author_id == authId : true);
	});

	document.getElementById('book-table-body').innerHTML = filtered.map(function(book) {
		const authorName = (authors.find(function(a) { return a.id == book.author_id; }) || { name: "Chưa rõ" }).name;
		const categoryName = (categories.find(function(c) { return c.id == book.category_id; }) || { name: "Chưa rõ" }).name;

		// THÊM LOGIC ĐỔI ICON THAO TÁC KHI TÌM KIẾM Y HỆT TRÊN RENDERBOOKS
		let actionButtons = "";
		if (statusFilter === 'deleted') {
			actionButtons = '<button onclick="restoreBook(' + book.id + ')" class="p-1.5 text-emerald-500 hover:bg-emerald-50 rounded" title="Khôi phục"><i class="fa-solid fa-trash-arrow-up"></i></button>'
				+ '<button onclick="hardDeleteBook(' + book.id + ')" class="p-1.5 text-rose-500 hover:bg-rose-50 rounded ml-1" title="Xóa vĩnh viễn"><i class="fa-solid fa-circle-xmark"></i></button>';
		} else {
			actionButtons = '<button onclick="openBookModal(' + book.id + ')" class="p-1.5 text-blue-500 hover:bg-blue-50 rounded"><i class="fa-solid fa-pen"></i></button>'
				+ '<button onclick="deleteBook(' + book.id + ')" class="p-1.5 text-rose-500 hover:bg-rose-50 rounded ml-1"><i class="fa-solid fa-trash"></i></button>';
		}

		return '<tr class="hover:bg-slate-50 dark:hover:bg-slate-900 transition-all text-sm">'
			+ '<td class="py-4 px-4"><img src="' + book.image + '" class="w-12 h-16 rounded-lg object-cover" alt=""></td>'
			+ '<td class="py-4 px-4 max-w-xs"><p class="font-bold">' + book.title + '</p><p class="text-xs text-slate-400">ISBN: ' + book.isbn + '</p></td>'
			+ '<td class="py-4 px-4">' + authorName + '</td>'
			+ '<td class="py-4 px-4"><span class="bg-slate-100 dark:bg-slate-800 text-xs px-2 py-1 rounded-lg">' + categoryName + '</span></td>'
			+ '<td class="py-4 px-4 font-bold">' + book.price.toLocaleString() + 'đ</td>'
			+ '<td class="py-4 px-4">' + book.stock + '</td>'
			+ '<td class="py-4 px-4">' + book.sold + '</td>'
			+ '<td class="py-4 px-4 text-center">' + actionButtons + '</td></tr>';
	}).join('');
}

function openBookModal(id) {
	const modal = document.getElementById('book-modal');
	modal.classList.remove('hidden');
	setTimeout(function() { modal.firstElementChild.classList.remove('scale-95'); }, 50);

	document.getElementById('book-cover-image').value = "";
	document.getElementById('book-detail-images').value = "";
	document.getElementById('cover-file-name').innerText = "Tải ảnh bìa lên";
	document.getElementById('detail-files-count').innerText = "Tải các ảnh chi tiết lên (Có thể chọn nhiều)";
	document.getElementById('book-cover-preview-container').classList.add('hidden');
	document.getElementById('book-details-preview-container').innerHTML = "";
	tempDetailImages = [];

	if (id) {
		document.getElementById('book-action').value = 'edit';
		document.getElementById('book-modal-title').innerText = "Chỉnh sửa Thông Tin Sách";
		const book = books.find(function(b) { return b.id == id; });
		document.getElementById('book-edit-id').value = book.id;
		document.getElementById('book-title').value = book.title;
		document.getElementById('book-author').value = book.author_id;
		document.getElementById('book-category').value = book.category_id;
		document.getElementById('book-year').value = book.year;
		document.getElementById('book-price').value = book.price;
		document.getElementById('book-origin-price').value = book.origin_price;
		document.getElementById('book-stock').value = book.stock;
		document.getElementById('book-isbn').value = book.isbn;
		document.getElementById('book-publisher').value = book.publisher;
		document.getElementById('book-language').value = book.language;
		document.getElementById('book-cover').value = book.cover;
		document.getElementById('book-image-url').value = book.image;
		document.getElementById('book-description').value = book.desc;
		if (book.image) {
			document.getElementById('book-cover-preview').src = book.image;
			document.getElementById('book-cover-preview-container').classList.remove('hidden');
			document.getElementById('cover-file-name').innerText = "Đã có ảnh bìa hiện tại";
		}
	} else {
		document.getElementById('book-action').value = 'add';
		document.getElementById('book-modal-title').innerText = "Thêm Sách Mới";
		document.getElementById('book-edit-id').value = "";
		document.getElementById('book-title').value = "";
		document.getElementById('book-year').value = "2026";
		document.getElementById('book-price').value = "0";
		document.getElementById('book-origin-price').value = "0";
		document.getElementById('book-stock').value = "10";
		document.getElementById('book-isbn').value = "";
		document.getElementById('book-publisher').value = "";
		document.getElementById('book-language').value = "Tiếng Việt";
		document.getElementById('book-image-url').value = "";
		document.getElementById('book-description').value = "";
	}
}

function closeBookModal() {
	const modal = document.getElementById('book-modal');
	modal.firstElementChild.classList.add('scale-95');
	setTimeout(function() { modal.classList.add('hidden'); }, 200);
}

function validateBook() {
	const price = parseFloat(document.getElementById('book-price').value);
	const stock = parseInt(document.getElementById('book-stock').value);
	if (price < 0 || stock < 0) {
		showToast("Giá và tồn kho không được âm!", "danger");
		return false;
	}
	return true;
}

function deleteBook(id) {
	const book = books.find(function(b) { return b.id == id; });
	showConfirm('Bạn muốn ẩn sách "' + book.title + '"? Sách sẽ không hiển thị với khách hàng.', 'Ẩn sách', 'Xác nhận ẩn', function() {
	    fetch(CTX + '/admin/books?action=delete&id=' + id)
	        .then(r => r.json())
	        .then(data => {
	            if (data.success) {
	                books = books.filter(b => b.id != id);
	                deletedBooks.push(book);
	                showToast('Đã ẩn sách thành công!', 'success');
	                renderBooks();
	            } else {
	                showToast('Không thể ẩn! Sách đang có đơn hàng đang xử lý.', 'danger');
	            }
	        });
	});
	return; // thoát sớm, fetch nằm trong callback
	
}

// Thêm hàm xử lý Khôi phục sản phẩm (Soft delete -> Active)
function restoreBook(id) {
	showConfirm('Khôi phục sách này về danh sách đang kinh doanh?', 'Khôi phục sách', 'Khôi phục', function() {
	    fetch(CTX + '/admin/books?action=restore&id=' + id)
	        .then(r => r.json())
	        .then(data => {
	            if (data.success) {
	                const book = deletedBooks.find(b => b.id == id);
	                deletedBooks = deletedBooks.filter(b => b.id != id);
	                books.push(book);
	                showToast('Đã khôi phục sách!', 'success');
	                renderBooks();
	            }
	        });
	});
	return;

}

// Thêm hàm xử lý Xóa vĩnh viễn (Hard delete khỏi cơ sở dữ liệu)
function hardDeleteBook(id) {
	showConfirm('⚠️ Hành động này không thể hoàn tác! Sách sẽ bị xóa khỏi hệ thống vĩnh viễn.', 'Xóa vĩnh viễn', 'Xóa vĩnh viễn', function() {
	    fetch(CTX + '/admin/books?action=hardDelete&id=' + id)
	        .then(r => r.json())
	        .then(data => {
	            if (data.success) {
	                deletedBooks = deletedBooks.filter(b => b.id != id);
	                showToast('Đã xóa vĩnh viễn!', 'success');
	                renderBooks();
	            } else {
	                showToast('Không thể xóa! Sách đã từng có trong đơn hàng.', 'danger');
	            }
	        });
	});
	return;
	
}

// ===================== DANH MỤC =====================
function renderCategories() {
	const statusEl = document.getElementById('filter-category-status');
	const status = (statusEl && statusEl.value) ? statusEl.value : 'active';
	const source = (status === 'deleted') ? deletedCategories : categories;

	document.getElementById('category-table-body').innerHTML = source.map(function(cate) {
		return '<tr class="hover:bg-slate-50 dark:hover:bg-slate-900 transition-all text-sm">'
			+ '<td class="py-3 px-4 font-bold text-slate-400">#0' + cate.id + '</td>'
			+ '<td class="py-3 px-4 font-bold text-navy-800 dark:text-slate-200">' + cate.name + '</td>'
			+ '<td class="py-3 px-4 text-center">'
			+ (function() {
				// Giả định ô select bộ lọc trạng thái danh mục có id là 'filter-category-status'
				const statusEl = document.getElementById('filter-category-status');
				if (statusEl && statusEl.value === 'deleted') {
					return '<button onclick="restoreCategory(' + cate.id + ')" class="p-1.5 text-emerald-500 hover:bg-emerald-50 dark:hover:bg-slate-800 rounded" title="Khôi phục"><i class="fa-solid fa-trash-arrow-up"></i></button>'
						+ '<button onclick="hardDeleteCategory(' + cate.id + ')" class="p-1.5 text-rose-700 hover:bg-rose-50 dark:hover:bg-slate-800 rounded ml-1" title="Xóa vĩnh viễn"><i class="fa-solid fa-circle-xmark"></i></button>';
				} else {
					return '<button onclick="editCategory(' + cate.id + ')" class="p-1.5 text-blue-500 hover:bg-blue-50 dark:hover:bg-slate-800 rounded"><i class="fa-solid fa-pen"></i></button>'
						+ '<button onclick="deleteCategory(' + cate.id + ')" class="p-1.5 text-rose-500 hover:bg-rose-50 dark:hover:bg-slate-800 rounded ml-1"><i class="fa-solid fa-trash"></i></button>';
				}
			})()
			+ '</td></tr>';
	}).join('');
}

function handleCategorySubmit(event) {
    event.preventDefault();
    const id = document.getElementById('category-edit-id').value;
    const name = document.getElementById('category-name').value.trim();

    const params = new URLSearchParams();
    params.append('action', id ? 'edit' : 'add');
    params.append('name', name);
    if (id) params.append('id', id);

    fetch(CTX + '/admin/categories', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params
    })
    .then(r => r.json())
    .then(data => {
        const msgs = {
            added:     ['Thêm danh mục thành công!', 'success'],
			empty_name: ['Tên danh mục không được để trống!', 'danger'],
            updated:   ['Cập nhật thành công!', 'success'],
            duplicate: ['Tên danh mục đã tồn tại!', 'danger']
        };
        const [msg, type] = msgs[data.message] || ['Thao tác hoàn tất', 'success'];
        showToast(msg, type);
        if (data.success) {
            if (id) {
                const cat = categories.find(c => c.id == id);
                if (cat) cat.name = name;
            } else {
                categories.push({ id: data.id, name: data.name });
            }
            resetCategoryForm();
            renderCategories();
        }
    })
    .catch(err => console.error('Fetch error:', err));
}

function editCategory(id) {
	const cate = categories.find(function(c) { return c.id == id; });
	document.getElementById('category-form-title').innerText = "Chỉnh Sửa Danh Mục";
	document.getElementById('category-edit-id').value = cate.id;
	document.getElementById('category-name').value = cate.name;
}

function resetCategoryForm() {
	document.getElementById('category-form-title').innerText = "Thêm Danh Mục Mới";
	document.getElementById('category-edit-id').value = "";
	document.getElementById('category-name').value = "";
}

function deleteCategory(id) {
	showConfirm('Ẩn danh mục này? Danh mục sẽ không hiển thị khi thêm sách mới.', 'Ẩn danh mục', 'Xác nhận ẩn', function() {
	    fetch(CTX + '/admin/categories?action=delete&id=' + id)
	        .then(r => r.json())
	        .then(data => {
	            if (data.success) {
	                const cat = categories.find(c => c.id == id);
	                categories = categories.filter(c => c.id != id);
	                deletedCategories.push(cat);
	                showToast('Đã ẩn danh mục!', 'success');
	                renderCategories();
	            } else {
	                showToast('Không thể xóa! Danh mục còn sách liên kết.', 'danger');
	            }
	        });
	});
	return;
}

function restoreCategory(id) {
	showConfirm('Khôi phục danh mục này về danh sách đang sử dụng?', 'Khôi phục danh mục', 'Khôi phục', function() {
		fetch(CTX + '/admin/categories?action=restore&id=' + id)
			.then(r => r.json())
			.then(data => {
				if (data.success) {
					const cat = deletedCategories.find(c => c.id == id);
					deletedCategories = deletedCategories.filter(c => c.id != id);
					categories.push(cat);
					showToast('Đã khôi phục danh mục!', 'success');
					renderCategories();
				}
			});
	});
}

function hardDeleteCategory(id) {
	showConfirm('⚠️ Xóa vĩnh viễn danh mục này? Hành động không thể hoàn tác!', 'Xóa vĩnh viễn', 'Xóa vĩnh viễn', function() {
		fetch(CTX + '/admin/categories?action=hardDelete&id=' + id)
			.then(r => r.json())
			.then(data => {
				if (data.success) {
					deletedCategories = deletedCategories.filter(c => c.id != id);
					showToast('Đã xóa vĩnh viễn!', 'success');
					renderCategories();
				} else {
					showToast('Không thể xóa! Còn sách liên kết.', 'danger');
				}
			});
	});
}

// ===================== TÁC GIẢ =====================
function renderAuthors() {
	const statusEl = document.getElementById('filter-author-status');
	// THÊM: ép mặc định về 'active' nếu chưa có giá trị
	const status = (statusEl && statusEl.value) ? statusEl.value : 'active';

	const source = (status === 'deleted') ? deletedAuthors : authors;  // ĐỔI: dùng đúng source

	document.getElementById('author-table-body').innerHTML = source.map(function(auth) {
		return '<tr class="hover:bg-slate-50 dark:hover:bg-slate-900 transition-all text-sm">'
			+ '<td class="py-3 px-4"><img src="' + auth.image + '" class="w-10 h-10 rounded-full object-cover" alt=""></td>'
			+ '<td class="py-3 px-4 font-bold text-navy-800 dark:text-slate-200">' + auth.name + '</td>'
			+ '<td class="py-3 px-4 text-center">'
			+ (status === 'deleted'
				? '<button onclick="restoreAuthor(' + auth.id + ')" class="p-1.5 text-emerald-500 hover:bg-emerald-50 dark:hover:bg-slate-800 rounded" title="Khôi phục"><i class="fa-solid fa-trash-arrow-up"></i></button>'
				+ '<button onclick="hardDeleteAuthor(' + auth.id + ')" class="p-1.5 text-rose-700 hover:bg-rose-50 dark:hover:bg-slate-800 rounded ml-1" title="Xóa vĩnh viễn"><i class="fa-solid fa-circle-xmark"></i></button>'
				: '<button onclick="editAuthor(' + auth.id + ')" class="p-1.5 text-blue-500 hover:bg-blue-50 dark:hover:bg-slate-800 rounded"><i class="fa-solid fa-pen"></i></button>'
				+ '<button onclick="deleteAuthor(' + auth.id + ')" class="p-1.5 text-rose-500 hover:bg-rose-50 dark:hover:bg-slate-800 rounded ml-1"><i class="fa-solid fa-trash"></i></button>')
			+ '</td></tr>';
	}).join('');
}

function handleAuthorSubmit(event) {
    event.preventDefault();
    const id = document.getElementById('author-edit-id').value;
    document.getElementById('author-action-input').value = id ? 'edit' : 'add';
    submitAuthorForm(); 
}

function editAuthor(id) {
	const auth = authors.find(function(a) { return a.id == id; });
	document.getElementById('author-form-title').innerText = "Chỉnh Sửa Tác Giả";
	document.getElementById('author-edit-id').value = auth.id;
	document.getElementById('author-name').value = auth.name;
	document.getElementById('author-image').value = auth.image;
	document.getElementById('author-image-file').value = "";
	if (auth.image) {
		document.getElementById('author-preview-img').src = auth.image;
		document.getElementById('author-preview-container').classList.remove('hidden');
		document.getElementById('author-file-name').innerText = "Đã có ảnh hiện tại";
	} else {
		document.getElementById('author-preview-container').classList.add('hidden');
	}
}

function resetAuthorForm() {
	document.getElementById('author-form-title').innerText = "Thêm Tác Giả";
	document.getElementById('author-edit-id').value = "";
	document.getElementById('author-name').value = "";
	document.getElementById('author-image').value = "";
	document.getElementById('author-image-file').value = "";
	document.getElementById('author-file-name').innerText = "Tải ảnh lên";
	document.getElementById('author-preview-container').classList.add('hidden');
}

function deleteAuthor(id) {
	showConfirm('Ẩn tác giả này? Tác giả sẽ không hiển thị khi thêm sách mới.', 'Ẩn tác giả', 'Xác nhận ẩn', function() {
		fetch(CTX + '/admin/authors?action=delete&id=' + id)
			.then(r => r.json())
			.then(data => {
				if (data.success) {
					const auth = authors.find(a => a.id == id);
					authors = authors.filter(a => a.id != id);
					deletedAuthors.push(auth);
					showToast('Đã ẩn tác giả!', 'success');
					renderAuthors();
				} else {
					showToast('Không thể xóa! Tác giả còn sách liên kết.', 'danger');
				}
			});
	});
}

function restoreAuthor(id) {
	showConfirm('Khôi phục tác giả này về danh sách hiển thị?', 'Khôi phục tác giả', 'Khôi phục', function() {
		fetch(CTX + '/admin/authors?action=restore&id=' + id)
			.then(r => r.json())
			.then(data => {
				if (data.success) {
					const auth = deletedAuthors.find(a => a.id == id);
					deletedAuthors = deletedAuthors.filter(a => a.id != id);
					authors.push(auth);
					showToast('Đã khôi phục tác giả!', 'success');
					renderAuthors();
				}
			});
	});
}

function hardDeleteAuthor(id) {
	showConfirm('⚠️ Xóa vĩnh viễn tác giả này? Hành động không thể hoàn tác!', 'Xóa vĩnh viễn', 'Xóa vĩnh viễn', function() {
		fetch(CTX + '/admin/authors?action=hardDelete&id=' + id)
			.then(r => r.json())
			.then(data => {
				if (data.success) {
					deletedAuthors = deletedAuthors.filter(a => a.id != id);
					showToast('Đã xóa vĩnh viễn!', 'success');
					renderAuthors();
				} else {
					showToast('Không thể xóa! Còn sách liên kết.', 'danger');
				}
			});
	});
}

// ===================== USERS =====================
function renderUsers() {
	document.getElementById('user-table-body').innerHTML = users.map(function(user) {
		const roleClass = user.role === 'admin' ? 'bg-indigo-100 text-indigo-700' : 'bg-slate-100 text-slate-600';
		const statusClass = user.is_active ? 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200' : 'bg-rose-100 text-rose-700 hover:bg-rose-200';
		const statusText = user.is_active ? 'Đang Hoạt Động' : 'Đã Khóa';
		return '<tr class="hover:bg-slate-50 dark:hover:bg-slate-900 transition-all text-sm">'
			+ '<td class="py-4 px-4 font-bold text-navy-800 dark:text-slate-300">@' + user.username + '</td>'
			+ '<td class="py-4 px-4 font-bold text-slate-700 dark:text-slate-200">' + user.fullname + '</td>'
			+ '<td class="py-4 px-4 text-slate-500">' + user.email + '</td>'
			+ '<td class="py-4 px-4 text-slate-500">' + (user.phone || 'Chưa có') + '</td>'
			+ '<td class="py-4 px-4"><span class="text-xs px-2.5 py-1 rounded-lg font-extrabold ' + roleClass + '">' + user.role.toUpperCase() + '</span></td>'
			+ '<td class="py-4 px-4"><button onclick="toggleUserStatus(' + user.id + ')" class="text-xs font-bold px-3 py-1.5 rounded-full transition-all duration-300 ' + statusClass + '">' + statusText + '</button></td>'
			+ '<td class="py-4 px-4 text-center"><button onclick="openUserModal(' + user.id + ')" class="p-1.5 text-navy-800 hover:bg-slate-100 dark:hover:bg-slate-800 rounded"><i class="fa-solid fa-circle-info text-lg"></i></button></td>'
			+ '</tr>';
	}).join('');
}

function filterUsers() {
	const query = document.getElementById('search-user').value.toLowerCase();
	const filtered = users.filter(function(u) {
		return u.fullname.toLowerCase().includes(query) || u.email.toLowerCase().includes(query);
	});
	// Tái sử dụng renderUsers với filtered — đơn giản nhất là gán tạm rồi render
	const temp = users;
	users = filtered;
	renderUsers();
	users = temp;
}

function toggleUserStatus(id) {
	const user = users.find(function(u) { return u.id == id; });
	user.is_active = !user.is_active;
	const actionText = user.is_active ? "Mở khóa" : "Khóa";
	showToast('Đã ' + actionText.toLowerCase() + ' tài khoản @' + user.username + ' thành công!', 'success');
	addAdminLog('Đã ' + actionText.toLowerCase() + ' tài khoản của @' + user.username);
	renderUsers();
}

function openUserModal(id) {
	const user = users.find(function(u) { return u.id == id; });
	document.getElementById('user-modal-fullname').innerText = user.fullname;
	document.getElementById('user-modal-username').innerText = "@" + user.username;
	document.getElementById('user-modal-email').innerText = user.email;
	document.getElementById('user-modal-phone').innerText = user.phone || "Chưa thiết lập";
	document.getElementById('user-modal-created').innerText = user.created_at;
	const modal = document.getElementById('user-modal');
	modal.classList.remove('hidden');
	setTimeout(function() { modal.firstElementChild.classList.remove('scale-95'); }, 50);
}

function closeUserModal() {
	const modal = document.getElementById('user-modal');
	modal.firstElementChild.classList.add('scale-95');
	setTimeout(function() { modal.classList.add('hidden'); }, 200);
}

function exportUsersToCSV() {
	let csv = "data:text/csv;charset=utf-8,ID,Username,Fullname,Email,Role,Active,JoinedAt\n";
	users.forEach(function(u) {
		csv += u.id + ',' + u.username + ',' + u.fullname + ',' + u.email + ',' + u.role + ',' + (u.is_active ? 'ACTIVE' : 'BANNED') + ',' + u.created_at + '\n';
	});
	const link = document.createElement("a");
	link.setAttribute("href", encodeURI(csv));
	link.setAttribute("download", "GocSach_Users_Report.csv");
	document.body.appendChild(link);
	link.click();
	document.body.removeChild(link);
	showToast("Đang tải xuống báo cáo CSV!", "success");
}

// ===================== REVIEWS =====================
function renderReviews() {
	document.getElementById('review-cards-container').innerHTML = reviews.map(function(rev) {
		let stars = '';
		for (let i = 0; i < rev.rating; i++) stars += '<i class="fa-solid fa-star"></i>';
		for (let i = rev.rating; i < 5; i++) stars += '<i class="fa-regular fa-star"></i>';

		let imgHtml = '';
		if (rev.images.length > 0) {
			imgHtml = '<div class="flex gap-2">' + rev.images.map(function(img) {
				return '<img src="' + img + '" class="w-20 h-20 rounded-lg object-cover border" alt="">';
			}).join('') + '</div>';
		}

		return '<div class="bg-slate-50 dark:bg-slate-900 p-5 rounded-2xl border border-slate-100 dark:border-slate-800 space-y-4">'
			+ '<div class="flex justify-between items-start">'
			+ '<div><h4 class="font-extrabold text-navy-800 dark:text-slate-200">' + rev.user_fullname + '</h4>'
			+ '<p class="text-xs text-slate-400">Đánh giá: <strong>' + rev.book_title + '</strong></p></div>'
			+ '<div class="text-amber-400 flex gap-0.5">' + stars + '</div></div>'
			+ '<p class="text-sm italic text-slate-600 dark:text-slate-300">"' + rev.comment + '"</p>'
			+ imgHtml
			+ '<div class="flex gap-2 border-t pt-4">'
			+ '<input type="text" placeholder="Phản hồi đánh giá..." class="flex-1 bg-white dark:bg-slate-950 border rounded-xl px-3 py-1.5 text-xs outline-none">'
			+ '<button onclick="replyReview(' + rev.id + ')" class="bg-navy-800 dark:bg-blue-600 text-white font-semibold text-xs px-4 py-2 rounded-xl">Trả lời</button>'
			+ '</div></div>';
	}).join('');
}

function replyReview(id) {
	showToast("Đã phản hồi đánh giá thành công!", "success");
}

// ===================== TỒN KHO =====================
function renderInventory() {
	const lowStockBooks = books.filter(function(b) { return b.stock <= 5; });
	const alertContainer = document.getElementById('low-stock-alert-container');

	if (lowStockBooks.length === 0) {
		alertContainer.innerHTML = '<p class="text-sm text-emerald-500 font-bold"><i class="fa-solid fa-circle-check"></i> Toàn bộ sách trong kho đều đạt ngưỡng an toàn!</p>';
	} else {
		alertContainer.innerHTML = lowStockBooks.map(function(book) {
			return '<div class="p-4 bg-amber-50 dark:bg-amber-900/10 rounded-xl border border-amber-200 flex justify-between items-center">'
				+ '<div><p class="font-bold text-slate-800 dark:text-slate-200 text-sm">' + book.title + '</p>'
				+ '<p class="text-xs text-amber-600">Còn lại: <strong>' + book.stock + ' cuốn</strong> (Đã bán: ' + book.sold + ')</p>'
				+ '<span class="text-[10px] bg-amber-500 text-white font-bold px-2 py-0.5 rounded-full uppercase mt-1 inline-block">Đề xuất nhập: 30 cuốn</span></div>'
				+ '<button onclick="restockBook(' + book.id + ')" class="bg-amber-500 hover:bg-amber-600 text-white font-bold text-xs px-4 py-2 rounded-xl">Nhập Kho</button>'
				+ '</div>';
		}).join('');
	}

	document.getElementById('inventory-logs-list').innerHTML = inventoryLogs.map(function(log) {
		return '<div class="flex justify-between items-center text-xs border-b border-slate-100 dark:border-slate-800 pb-2">'
			+ '<span class="text-slate-500 font-semibold">' + log.message + '</span>'
			+ '<span class="bg-slate-100 dark:bg-slate-800 text-slate-400 px-2 py-0.5 rounded-md font-mono">' + log.time + '</span>'
			+ '</div>';
	}).join('');
}

function restockBook(id) {
	const book = books.find(function(b) { return b.id == id; });
	book.stock += 30;
	const time = new Date().toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
	inventoryLogs.unshift({ time: time, message: 'Nhập kho +30 cuốn "' + book.title + '"' });
	showToast('Đã tăng tồn kho "' + book.title + '" thêm 30 sản phẩm!', 'success');
	addAdminLog('Yêu cầu nhập kho tự động cho cuốn "' + book.title + '"');
	renderInventory();
	renderDashboard();
}

// ===================== KHUYẾN MÃI =====================
function renderPromotions() {
	document.getElementById('promo-table-body').innerHTML = promotions.map(function(p) {
		const targetText = p.target === 'all' ? 'Tất cả sản phẩm' : (p.target === 'cate_1' ? 'Tiểu thuyết' : 'Kinh tế');
		return '<tr class="hover:bg-slate-50 dark:hover:bg-slate-900 transition-all text-sm">'
			+ '<td class="py-3 px-4 font-bold text-navy-800 dark:text-slate-200">' + p.name + '</td>'
			+ '<td class="py-3 px-4 font-bold text-emerald-500">' + p.price.toLocaleString() + 'đ</td>'
			+ '<td class="py-3 px-4"><span class="bg-slate-100 dark:bg-slate-800 text-xs px-2.5 py-1 rounded-lg font-semibold">' + targetText + '</span></td>'
			+ '<td class="py-3 px-4"><button onclick="deletePromo(' + p.id + ')" class="text-rose-500 hover:text-rose-700 font-bold text-xs"><i class="fa-solid fa-trash-can"></i> Hủy</button></td>'
			+ '</tr>';
	}).join('');
}

function handlePromotionSubmit(event) {
	event.preventDefault();
	const name = document.getElementById('promo-name').value;
	const price = parseFloat(document.getElementById('promo-price').value);
	const target = document.getElementById('promo-target').value;
	promotions.push({ id: promotions.length + 1, name: name, price: price, target: target });
	showToast("Khởi tạo chương trình đồng giá thành công!", "success");
	addAdminLog('Khởi chạy sự kiện đồng giá "' + name + '" ở mức ' + price.toLocaleString() + 'đ');
	renderPromotions();
	document.getElementById('promo-name').value = "";
	document.getElementById('promo-price').value = "";
}

function deletePromo(id) {
	showConfirm('Bạn muốn dừng chương trình đồng giá này? Giá sách sẽ trở về bình thường.', 'Hủy chương trình', 'Xác nhận hủy', function() {
		promotions = promotions.filter(function(p) { return p.id != id; });
		showToast("Đã dừng chương trình!", "success");
		renderPromotions();
	});
}

// ===================== MESSAGES =====================
function renderMessages() {
	document.getElementById('message-table-body').innerHTML = messages.map(function(m) {
		return '<tr class="hover:bg-slate-50 dark:hover:bg-slate-900 transition-all text-sm">'
			+ '<td class="py-3 px-4 font-bold text-navy-800 dark:text-slate-300">' + m.name + '</td>'
			+ '<td class="py-3 px-4 text-slate-500">' + m.contact + '</td>'
			+ '<td class="py-3 px-4 text-xs italic">"' + m.content + '"</td>'
			+ '<td class="py-3 px-4 text-center"><a href="mailto:' + m.contact + '" class="bg-slate-100 dark:bg-slate-800 hover:bg-navy-800 hover:text-white px-3 py-1.5 rounded-lg text-xs font-bold transition-all"><i class="fa-regular fa-envelope"></i> Phản hồi</a></td>'
			+ '</tr>';
	}).join('');
}

// ===================== KHỞI TẠO =====================
window.addEventListener('load', function() {

	

	switchTab('dashboard');

	const salesCtx = document.getElementById('salesChart').getContext('2d');
	const now = new Date();
	const monthLabels = [];
	for (let i = 5; i >= 0; i--) {
		const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
		monthLabels.push('T' + (d.getMonth() + 1) + '/' + d.getFullYear().toString().slice(2));
	}
	new Chart(salesCtx, {
		type: 'line',
		data: {
			labels: monthLabels,
			datasets: [
				{
					label: 'Doanh Thu (nghìn đồng)',
					data: typeof monthlyRevenueData !== 'undefined' ? monthlyRevenueData : [0,0,0,0,0,0],
					borderColor: '#1a3352',
					backgroundColor: 'rgba(26, 51, 82, 0.1)',
					fill: true,
					tension: 0.4
				}
			]
		},
		options: {
			responsive: true,
			maintainAspectRatio: false,
			plugins: { legend: { position: 'bottom' } }
		}
	});
});

// ===================== COUPON =====================
function loadCoupons() {
	fetch(CTX + '/admin/coupons', { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
		.then(function(r) { return r.json(); })
		.then(function(list) { renderCoupons(list); })
		.catch(function() { document.getElementById('coupon-table-body').innerHTML = '<tr><td colspan="9" class="px-4 py-4 text-center text-red-400">Lỗi tải dữ liệu</td></tr>'; });
}

function renderCoupons(list) {
	const fmt = function(v) { return Number(v || 0).toLocaleString('vi-VN'); };
	if (!list.length) {
		document.getElementById('coupon-table-body').innerHTML = '<tr><td colspan="9" class="px-4 py-6 text-center text-slate-400">Chưa có mã giảm giá nào.</td></tr>';
		return;
	}
	document.getElementById('coupon-table-body').innerHTML = list.map(function(c) {
		const typeLabel = c.type === 'PERCENT' ? c.value + '%' : fmt(c.value) + 'đ';
		const maxLabel  = c.maxDiscount ? ' (tối đa ' + fmt(c.maxDiscount) + 'đ)' : '';
		const limitLabel = c.usageLimit ? c.usedCount + '/' + c.usageLimit : c.usedCount + '/∞';
		const expLabel  = c.expiresAt ? c.expiresAt.replace('T', ' ') : '—';
		const badge = c.active
			? '<span class="bg-emerald-100 text-emerald-700 text-xs font-bold px-2 py-0.5 rounded-full">Đang bật</span>'
			: '<span class="bg-red-100 text-red-600 text-xs font-bold px-2 py-0.5 rounded-full">Đã tắt</span>';
		return '<tr class="hover:bg-slate-50 dark:hover:bg-slate-900 text-sm">'
			+ '<td class="px-4 py-3 font-bold font-mono text-navy-800 dark:text-white">' + c.code + '</td>'
			+ '<td class="px-4 py-3">' + typeLabel + maxLabel + '</td>'
			+ '<td class="px-4 py-3">' + (c.type === 'PERCENT' ? c.value + '%' : fmt(c.value) + 'đ') + '</td>'
			+ '<td class="px-4 py-3">' + fmt(c.minOrder) + 'đ</td>'
			+ '<td class="px-4 py-3 text-center">' + limitLabel + '</td>'
			+ '<td class="px-4 py-3 text-center">' + c.usedCount + '</td>'
			+ '<td class="px-4 py-3 text-xs text-slate-400">' + expLabel + '</td>'
			+ '<td class="px-4 py-3">' + badge + '</td>'
			+ '<td class="px-4 py-3 flex gap-2">'
			+   '<button onclick="toggleCoupon(' + c.id + ')" class="text-xs px-3 py-1 rounded-lg border border-slate-200 hover:bg-slate-100 dark:hover:bg-slate-800">' + (c.active ? 'Tắt' : 'Bật') + '</button>'
			+   '<button onclick="openCouponModal(' + JSON.stringify(c) + ')" class="text-xs px-3 py-1 rounded-lg border border-blue-200 text-blue-600 hover:bg-blue-50">Sửa</button>'
			+   '<button onclick="deleteCoupon(' + c.id + ',\'' + c.code + '\')" class="text-xs px-3 py-1 rounded-lg border border-red-200 text-red-500 hover:bg-red-50">Xóa</button>'
			+ '</td>'
			+ '</tr>';
	}).join('');
}

function openCouponModal(c) {
	document.getElementById('coupon-modal-err').classList.add('hidden');
	document.getElementById('coupon-id').value     = c ? c.id : '';
	document.getElementById('coupon-code').value   = c ? c.code : '';
	document.getElementById('coupon-type').value   = c ? c.type : 'PERCENT';
	document.getElementById('coupon-value').value  = c ? c.value : '';
	document.getElementById('coupon-min').value    = c ? c.minOrder : '';
	document.getElementById('coupon-max').value    = c ? (c.maxDiscount || '') : '';
	document.getElementById('coupon-limit').value  = c ? (c.usageLimit || '') : '';
	document.getElementById('coupon-expires').value = c ? (c.expiresAt ? c.expiresAt.slice(0,16) : '') : '';
	document.getElementById('coupon-modal-title').textContent = c ? 'Sửa mã giảm giá' : 'Thêm mã giảm giá';
	document.getElementById('coupon-modal').classList.remove('hidden');
}

function closeCouponModal() {
	document.getElementById('coupon-modal').classList.add('hidden');
}

function saveCoupon() {
	const id    = document.getElementById('coupon-id').value;
	const code  = document.getElementById('coupon-code').value.trim().toUpperCase();
	const value = document.getElementById('coupon-value').value;
	const err   = document.getElementById('coupon-modal-err');

	if (!code || !value) {
		err.textContent = 'Vui lòng nhập mã và giá trị giảm.';
		err.classList.remove('hidden');
		return;
	}

	const body = new URLSearchParams({
		action:         id ? 'update' : 'create',
		id:             id || '',
		code:           code,
		discountType:   document.getElementById('coupon-type').value,
		discountValue:  value,
		minOrderAmount: document.getElementById('coupon-min').value || 0,
		maxDiscount:    document.getElementById('coupon-max').value,
		usageLimit:     document.getElementById('coupon-limit').value,
		expiresAt:      document.getElementById('coupon-expires').value
	});

	fetch(CTX + '/admin/coupons', { method: 'POST', body: body })
		.then(function(r) { return r.json(); })
		.then(function(data) {
			if (data.success) {
				closeCouponModal();
				loadCoupons();
				showToast(id ? 'Cập nhật thành công!' : 'Thêm mã thành công!', 'success');
			} else {
				err.textContent = data.message || 'Lỗi, thử lại.';
				err.classList.remove('hidden');
			}
		});
}

function toggleCoupon(id) {
	fetch(CTX + '/admin/coupons', { method: 'POST', body: new URLSearchParams({ action: 'toggle', id: id }) })
		.then(function(r) { return r.json(); })
		.then(function(data) {
			if (data.success) { loadCoupons(); showToast('Đã cập nhật trạng thái!', 'success'); }
		});
}

function deleteCoupon(id, code) {
	showConfirm('Xóa mã "' + code + '"? Hành động không thể hoàn tác.', 'Xóa mã giảm giá', 'Xóa vĩnh viễn', function() {
		fetch(CTX + '/admin/coupons', { method: 'POST', body: new URLSearchParams({ action: 'delete', id: id }) })
			.then(function(r) { return r.json(); })
			.then(function(data) {
				if (data.success) { loadCoupons(); showToast('Đã xóa mã!', 'success'); }
			});
	});
}

function filterOrders() {
	const q = (document.getElementById('order-search').value || '').toLowerCase().trim();
	const s = (document.getElementById('order-filter-status').value || '');
	document.querySelectorAll('tr.order-row').forEach(function(row) {
		const matchQ = !q || row.dataset.code.includes(q) || row.dataset.name.includes(q) || row.dataset.phone.includes(q);
		const matchS = !s || row.dataset.status === s;
		row.style.display = (matchQ && matchS) ? '' : 'none';
	});
}

function updateOrderStatus(orderId, status, selectEl) {
	const ORDER = ['PENDING', 'CONFIRMED', 'SHIPPING', 'COMPLETED'];
	const currentStatus = selectEl ? selectEl.getAttribute('data-current') : null;
	if (currentStatus && currentStatus !== 'CANCELLED') {
		const curIdx = ORDER.indexOf(currentStatus);
		const newIdx = ORDER.indexOf(status);
		if (newIdx !== -1 && curIdx !== -1 && newIdx < curIdx && status !== 'CANCELLED') {
			showToast('Không thể chuyển ngược trạng thái đơn hàng!', 'danger');
			if (selectEl) selectEl.value = currentStatus;
			return;
		}
		if (currentStatus === 'COMPLETED' && status !== 'COMPLETED') {
			showToast('Đơn đã hoàn thành, không thể thay đổi!', 'danger');
			if (selectEl) selectEl.value = currentStatus;
			return;
		}
	}
	const url = (document.body.getAttribute('data-context-path') || '') + '/admin/orders';
	fetch(url, {
		method: 'POST',
		headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
		body: 'orderId=' + encodeURIComponent(orderId) + '&status=' + encodeURIComponent(status)
	})
		.then(r => r.json())
		.then(data => {
			if (data.success) {
				if (selectEl) selectEl.setAttribute('data-current', status);
				showToast('Cập nhật trạng thái thành công!', 'success');
			} else {
				showToast('Cập nhật thất bại!', 'danger');
				if (selectEl) selectEl.value = currentStatus;
			}
		})
		.catch(() => showToast('Lỗi kết nối!', 'danger'));
}

function viewOrderDetail(orderId) {
	const modal = document.getElementById('order-detail-modal');
	const body = document.getElementById('modal-order-body');
	const title = document.getElementById('modal-order-code');
	body.innerHTML = '<p class="text-slate-400">Đang tải...</p>';
	modal.classList.remove('hidden');

	const ctx = document.body.getAttribute('data-context-path') || '';
	fetch(ctx + '/admin/orders?orderId=' + orderId, {
		headers: { 'X-Requested-With': 'XMLHttpRequest' }
	})
		.then(r => r.json())
		.then(data => {
			if (!data.success) { body.innerHTML = '<p class="text-red-500">' + (data.message || 'Lỗi') + '</p>'; return; }
			const o = data.order;
			if (title) title.textContent = 'Đơn hàng #' + o.orderCode;

			const fmt = v => Number(v || 0).toLocaleString('vi-VN');
			const statusColor = { PENDING: '#92400e', CONFIRMED: '#1e40af', SHIPPING: '#0369a1', COMPLETED: '#065f46', PAYMENT_FAILED: '#991b1b', CANCELLED: '#991b1b' };
			const statusBg = { PENDING: '#fff3cd', CONFIRMED: '#dbeafe', SHIPPING: '#e0f2fe', COMPLETED: '#d1fae5', PAYMENT_FAILED: '#fee2e2', CANCELLED: '#fee2e2' };

			let itemsHtml = data.items.map(it =>
				`<tr style="border-bottom:1px solid #eee;">
                <td style="padding:8px 12px;">${it.title}</td>
                <td style="padding:8px 12px;text-align:center;">${it.quantity}</td>
                <td style="padding:8px 12px;text-align:right;">${fmt(it.price)}đ</td>
                <td style="padding:8px 12px;text-align:right;">${fmt(it.price * it.quantity)}đ</td>
            </tr>`
			).join('');

			body.innerHTML = `
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px;">
                <div style="background:#f8fafc;padding:14px;border-radius:8px;font-size:.9em;">
                    <p style="font-weight:600;margin-bottom:6px;color:#1e3a5f;">Thông tin giao hàng</p>
                    <p>${o.customerName}</p><p>${o.phone}</p>
                    <p>${o.email || ''}</p><p>${o.address}</p>
                </div>
                <div style="background:#f8fafc;padding:14px;border-radius:8px;font-size:.9em;">
                    <p style="font-weight:600;margin-bottom:6px;color:#1e3a5f;">Thanh toán</p>
                    <p>Phương thức: <strong>${o.paymentMethod}</strong></p>
                    <p>Tiền hàng: ${fmt(o.subtotal)}đ</p>
                    <p>Phí ship: ${fmt(o.shippingFee)}đ</p>
                    <p style="font-size:1.05em;">Tổng: <strong>${fmt(o.totalAmount)}đ</strong></p>
                    <p>Trạng thái: <span style="padding:2px 10px;border-radius:10px;font-size:.85em;font-weight:600;background:${statusBg[o.status] || '#eee'};color:${statusColor[o.status] || '#333'}">${o.status}</span></p>
                    <p style="color:#999;font-size:.85em;">${o.createdAt}</p>
                </div>
            </div>
            <p style="font-weight:600;color:#1e3a5f;margin-bottom:8px;">Sản phẩm</p>
            <table style="width:100%;border-collapse:collapse;font-size:.9em;">
                <thead><tr style="background:#1e3a5f;color:#fff;">
                    <th style="padding:8px 12px;text-align:left;">Sách</th>
                    <th style="padding:8px 12px;text-align:center;">SL</th>
                    <th style="padding:8px 12px;text-align:right;">Đơn giá</th>
                    <th style="padding:8px 12px;text-align:right;">Thành tiền</th>
                </tr></thead>
                <tbody>${itemsHtml}</tbody>
            </table>`;
		})
		.catch(() => { body.innerHTML = '<p class="text-red-500">Lỗi kết nối server.</p>'; });
}

// ===== MAGIC BYTES VALIDATE (dùng chung) =====
const MAGIC_BYTES = {
	jpeg: [0xFF, 0xD8, 0xFF],
	png: [0x89, 0x50, 0x4E, 0x47],
	gif: [0x47, 0x49, 0x46, 0x38],
	webp: [0x52, 0x49, 0x46, 0x46]
};

function isValidImageBytes(bytes) {
	return Object.values(MAGIC_BYTES).some(magic =>
		magic.every((b, i) => bytes[i] === b)
	);
}

function showAdminError(divId, msg) {
	const div = document.getElementById(divId);
	div.querySelector('span').textContent = msg;
	div.style.display = 'block';
}

function hideAdminError(divId) {
	document.getElementById(divId).style.display = 'none';
}




// Validate 1 file, trả về Promise<boolean>
function checkSingleFile(file) {
	return new Promise(function(resolve) {
		if (!file) { resolve(true); return; }
		const reader = new FileReader();
		reader.onload = function(e) {
			resolve(isValidImageBytes(new Uint8Array(e.target.result)));
		};
		reader.readAsArrayBuffer(file.slice(0, 8));
	});
}

// Validate nhiều file, trả về Promise<string|null>
function checkMultipleFiles(files) {
	const promises = Array.from(files).map(function(file) {
		return checkSingleFile(file).then(function(ok) { return ok ? null : file.name; });
	});
	return Promise.all(promises).then(function(results) {
		return results.find(function(r) { return r !== null; }) || null;
	});
}

// Submit form tác giả
function submitAuthorForm() {
	hideAdminError('author-error');
	const input = document.getElementById('author-image-file');
	const file = input.files[0];

	if (!file) {
	    const form = document.getElementById('author-form');
	    const formData = new FormData(form);
	    fetch(CTX + '/admin/authors', { method: 'POST', body: formData })
	        .then(r => r.json())
	        .then(data => {
	            const msgs = {
	                added:   ['Thêm tác giả thành công!', 'success'],
					empty_name: ['Tên tác giả không được để trống!', 'danger'],
	                updated: ['Cập nhật tác giả thành công!', 'success']
	            };
	            const [msg, type] = msgs[data.message] || ['Thao tác hoàn tất', 'success'];
	            showToast(msg, type);
	            if (data.success) {
	                const editId = document.getElementById('author-edit-id').value;
	                if (editId) {
	                    const auth = authors.find(a => a.id == editId);
	                    if (auth) {
	                        auth.name = document.getElementById('author-name').value;
	                    }
	                } else {
	                    authors.push({ id: data.id, name: data.name, image: data.image || '' });
	                }
	                resetAuthorForm();
	                renderAuthors();
	            }
	        });
	    return;
	}

	checkSingleFile(file).then(function(ok) {
		if (!ok) {
			showAdminError('author-error',
				'"' + file.name + '" không phải ảnh thật. Chỉ chấp nhận JPG, PNG, GIF, WEBP.');
			input.value = '';
			const preview = document.getElementById('author-preview-container');
			if (preview) preview.classList.add('hidden');
			document.getElementById('author-file-name').innerText = 'Tải ảnh lên';
			return;
		}
		// Resize trước khi submit
		resizeImageFile(file, MAX_WIDTH, MAX_HEIGHT, QUALITY).then(function(resized) {
		    replaceFileInInput(input, resized);
		    const form = document.getElementById('author-form');
		    const formData = new FormData(form);
			fetch(CTX + '/admin/authors', { method: 'POST', body: formData })
			    .then(r => r.json())
			    .then(data => {
					const msgs = {
					    added:        ['Thêm tác giả thành công!', 'success'],
					    updated:      ['Cập nhật tác giả thành công!', 'success'],
					    invalid_file: ['File không hợp lệ!', 'danger'],
					    empty_name:   ['Tên tác giả không được để trống!', 'danger']
					};
			        const [msg, type] = msgs[data.message] || ['Thao tác hoàn tất', 'success'];
			        showToast(msg, type);
			        if (data.success) {
			            const editId = document.getElementById('author-edit-id').value;
			            if (editId) {
			                const auth = authors.find(a => a.id == editId);
			                if (auth) {
			                    auth.name = document.getElementById('author-name').value;
			                    auth.image = data.image || auth.image;
			                }
			            } else {
			                authors.push({ id: data.id, name: data.name, image: data.image || '' });
			            }
			            resetAuthorForm();
			            renderAuthors();
			        }
			    });
		});
	});
}

// Submit form sách
function submitBookForm() {
	hideAdminError('cover-error');
	hideAdminError('detail-error');

	const coverInput = document.getElementById('book-cover-image');
	const detailInput = document.getElementById('book-detail-images');
	const coverFile = coverInput.files[0];

	checkSingleFile(coverFile).then(function(coverOk) {
		if (!coverOk) {
			showAdminError('cover-error',
				'"' + coverFile.name + '" không phải ảnh thật. Chỉ chấp nhận JPG, PNG, GIF, WEBP.');
			coverInput.value = '';
			const p = document.getElementById('book-cover-preview-container');
			if (p) p.classList.add('hidden');
			document.getElementById('cover-file-name').innerText = 'Tải ảnh bìa lên';
			return;
		}

		checkMultipleFiles(detailInput.files).then(function(badFile) {
			if (badFile) {
				showAdminError('detail-error',
					'"' + badFile + '" không phải ảnh thật. Chỉ chấp nhận JPG, PNG, GIF, WEBP.');
				detailInput.value = '';
				document.getElementById('book-details-preview-container').innerHTML = '';
				document.getElementById('detail-files-count').innerText = 'Tải các ảnh chi tiết lên (Có thể chọn nhiều)';
				return;
			}

			// Resize ảnh bìa
			const resizeCover = coverFile
				? resizeImageFile(coverFile, MAX_WIDTH, MAX_HEIGHT, QUALITY).then(function(r) { replaceFileInInput(coverInput, r); })
				: Promise.resolve();

			// Resize tất cả ảnh chi tiết
			const detailFiles = Array.from(detailInput.files);
			const resizeDetails = detailFiles.length
				? Promise.all(detailFiles.map(function(f) { return resizeImageFile(f, 1200, 1200, QUALITY); }))
					.then(function(resizedList) { replaceMultipleFilesInInput(detailInput, resizedList); })
				: Promise.resolve();

			Promise.all([resizeCover, resizeDetails]).then(function() {
				const form = document.getElementById('book-form');
				const formData = new FormData(form);
				fetch(CTX + '/admin/books', { method: 'POST', body: formData })
				    .then(r => r.json())
				    .then(data => {
				        const msgs = {
				            added:         ['Thêm sách thành công!', 'success'],
				            updated:       ['Cập nhật sách thành công!', 'success'],
				            invalid_file:  ['File không hợp lệ!', 'danger'],
							empty_title:          ['Tên sách không được để trống!', 'danger'],
							invalid_origin_price: ['Giá gốc không được thấp hơn giá bán!', 'danger'],
							invalid_year:         ['Năm xuất bản không hợp lệ!', 'danger'],
				            invalid_value: ['Giá hoặc tồn kho không hợp lệ!', 'danger']
				        };
				        const [msg, type] = msgs[data.message] || ['Thao tác hoàn tất', 'success'];
				        showToast(msg, type);
				        if (data.success) {
				            const bookId = document.getElementById('book-edit-id').value;
				            if (bookId) {
				                const book = books.find(b => b.id == bookId);
				                if (book) {
				                    book.title       = document.getElementById('book-title').value;
				                    book.author_id   = parseInt(document.getElementById('book-author').value);
				                    book.category_id = parseInt(document.getElementById('book-category').value);
				                    book.price       = parseFloat(document.getElementById('book-price').value);
				                    book.origin_price= parseFloat(document.getElementById('book-origin-price').value);
				                    book.stock       = parseInt(document.getElementById('book-stock').value);
				                    book.isbn        = document.getElementById('book-isbn').value;
				                    book.publisher   = document.getElementById('book-publisher').value;
				                    book.language    = document.getElementById('book-language').value;
				                    book.cover       = document.getElementById('book-cover').value;
				                    book.year        = parseInt(document.getElementById('book-year').value);
				                    book.image       = document.getElementById('book-image-url').value || book.image;
				                }
				            } else {
				                books.push({
				                    id:           data.id,
				                    title:        document.getElementById('book-title').value,
				                    author_id:    parseInt(document.getElementById('book-author').value),
				                    category_id:  parseInt(document.getElementById('book-category').value),
				                    price:        parseFloat(document.getElementById('book-price').value),
				                    origin_price: parseFloat(document.getElementById('book-origin-price').value),
				                    stock:        parseInt(document.getElementById('book-stock').value),
				                    sold:         0,
				                    isbn:         document.getElementById('book-isbn').value,
				                    publisher:    document.getElementById('book-publisher').value,
				                    language:     document.getElementById('book-language').value,
				                    cover:        document.getElementById('book-cover').value,
				                    year:         parseInt(document.getElementById('book-year').value),
				                    image:        document.getElementById('book-image-url').value || '',
				                    desc:         document.getElementById('book-description').value,
				                    detail_images:[]
				                });
				            }
				            closeBookModal();
				            renderBooks();
				        }
				    });
			});
		});
	});
}

// Thay 1 file trong input bằng file đã resize
function replaceFileInInput(input, newFile) {
	const dt = new DataTransfer();
	dt.items.add(newFile);
	input.files = dt.files;
}

// Thay nhiều file trong input bằng danh sách đã resize
function replaceMultipleFilesInInput(input, newFiles) {
	const dt = new DataTransfer();
	newFiles.forEach(function(f) { dt.items.add(f); });
	input.files = dt.files;
}

// ===================== RESIZE ẢNH TRƯỚC KHI UPLOAD =====================
// Giới hạn kích thước tối đa
const MAX_WIDTH = 800;  // ảnh bìa sách / tác giả
const MAX_HEIGHT = 800;
const QUALITY = 0.85; // chất lượng JPEG (0.0 - 1.0)

function resizeImageFile(file, maxW, maxH, quality) {
	return new Promise(function(resolve) {
		const img = new Image();
		const url = URL.createObjectURL(file);
		img.onload = function() {
			URL.revokeObjectURL(url);

			let w = img.width;
			let h = img.height;

			// Tính tỉ lệ thu nhỏ
			if (w > maxW || h > maxH) {
				const ratio = Math.min(maxW / w, maxH / h);
				w = Math.round(w * ratio);
				h = Math.round(h * ratio);
			}

			const canvas = document.createElement('canvas');
			canvas.width = w;
			canvas.height = h;
			canvas.getContext('2d').drawImage(img, 0, 0, w, h);

			canvas.toBlob(function(blob) {
				// Tạo File mới từ blob, giữ tên file gốc
				const resized = new File([blob], file.name, { type: 'image/jpeg' });
				resolve(resized);
			}, 'image/jpeg', quality);
		};
		img.src = url;
	});
}