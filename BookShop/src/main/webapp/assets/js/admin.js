/**
 * 
 */
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
        dashboard:  "Tổng Quan Hệ Thống",
        books:      "Quản Lý Kho Sách",
        categories: "Quản Lý Danh Mục",
        authors:    "Quản Lý Tác Giả",
        users:      "Quản Lý Thành Viên",
        reviews:    "Kiểm Duyệt Bình Luận",
        inventory:  "Quản Trị Tồn Kho",
        promotions: "Cấu Hình Đồng Giá",
        messages:   "Ý Kiến & Liên Hệ"
    };
    document.getElementById('current-title').innerText = titles[tabId];

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
    document.getElementById('dash-total-users').innerText = users.length;
    document.getElementById('dash-total-books').innerText = books.length;
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
        const authorName = (authors.find(function(a) { return a.id == book.author_id; }) || {name:"Chưa rõ"}).name;
        const categoryName = (categories.find(function(c) { return c.id == book.category_id; }) || {name:"Chưa rõ"}).name;
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
        const authorName = (authors.find(function(a) { return a.id == book.author_id; }) || {name:"Chưa rõ"}).name;
        const categoryName = (categories.find(function(c) { return c.id == book.category_id; }) || {name:"Chưa rõ"}).name;
        
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
    if (confirm('Xác nhận xóa "' + book.title + '"?')) {
        window.location.href = CTX + '/admin/books?action=delete&id=' + id;
    }
}

// Thêm hàm xử lý Khôi phục sản phẩm (Soft delete -> Active)
function restoreBook(id) {
    if (confirm("Bạn có chắc chắn muốn khôi phục cuốn sách này về kho hiển thị công khai không?")) {
        // Điều hướng gửi request về Controller xử lý cập nhật is_deleted = 0
        window.location.href = CTX + '/admin/books?action=restore&id=' + id;
    }
}

// Thêm hàm xử lý Xóa vĩnh viễn (Hard delete khỏi cơ sở dữ liệu)
function hardDeleteBook(id) {
    if (confirm("CẢNH BÁO: Hành động này sẽ xóa vĩnh viễn dữ liệu sách và không thể hoàn tác! Bạn vẫn muốn xóa chứ?")) {
        // Điều hướng gửi request về Controller chạy lệnh DELETE FROM
        window.location.href = CTX + '/admin/books?action=hardDelete&id=' + id;
    }
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
    const id   = document.getElementById('category-edit-id').value;
    const name = document.getElementById('category-name').value.trim();
    const isDuplicate = categories.some(function(c) {
        return c.name.toLowerCase() === name.toLowerCase() && c.id != id;
    });
    if (isDuplicate) { showToast("Tên danh mục đã tồn tại!", "danger"); return; }

    const form = document.createElement('form');
    form.method = 'POST';
    form.action = CTX + '/admin/categories';
    [['action', id ? 'edit' : 'add'], ['name', name], ['id', id]].forEach(function(pair) {
        if (pair[1]) {
            const i = document.createElement('input');
            i.type = 'hidden'; i.name = pair[0]; i.value = pair[1];
            form.appendChild(i);
        }
    });
    document.body.appendChild(form);
    form.submit();
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
    if (books.some(function(b) { return b.category_id == id; })) {
        showToast("Không thể xóa! Danh mục còn sách liên kết.", "danger"); return;
    }
    if (confirm("Xác nhận xóa danh mục này?")) {
        window.location.href = CTX + '/admin/categories?action=delete&id=' + id;
    }
}

function restoreCategory(id) {
    if (confirm("Xác nhận khôi phục danh mục này hiển thị trở lại?")) {
        window.location.href = CTX + '/admin/categories?action=restore&id=' + id;
    }
}

function hardDeleteCategory(id) {
    if (confirm("CẢNH BÁO: Xóa VĨNH VIỄN danh mục này và tất cả dữ liệu liên quan sẽ bị ảnh hưởng. Bạn có chắc chắn?")) {
        window.location.href = CTX + '/admin/categories?action=hardDelete&id=' + id;
    }
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
    document.getElementById('author-form').submit();
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
    if (books.some(function(b) { return b.author_id == id; })) {
        showToast("Không thể xóa! Tác giả còn sách liên kết.", "danger"); return;
    }
    if (confirm("Xác nhận xóa tác giả này?")) {
        window.location.href = CTX + '/admin/authors?action=delete&id=' + id;
    }
}

function restoreAuthor(id) {
    if (confirm("Xác nhận khôi phục tác giả này hoạt động trở lại?")) {
        window.location.href = CTX + '/admin/authors?action=restore&id=' + id;
    }
}

function hardDeleteAuthor(id) {
    if (confirm("CẢNH BÁO: Hành động này sẽ xóa VĨNH VIỄN tác giả này khỏi hệ thống. Bạn có chắc chắn muốn tiếp tục?")) {
        window.location.href = CTX + '/admin/authors?action=hardDelete&id=' + id;
    }
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
    if (confirm("Bạn có chắc muốn hủy chương trình đồng giá này?")) {
        promotions = promotions.filter(function(p) { return p.id != id; });
        showToast("Đã dừng chương trình!", "success");
        renderPromotions();
    }
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
    // Hiện toast từ redirect server nếu có
    if (window._adminNotify) {
        const map = {
            'added':           ['Thêm mới thành công!',                   'success'],
            'updated':         ['Cập nhật thành công!',                   'success'],
            'deleted':         ['Đã xóa thành công!',                     'success'],
            'book_has_orders': ['Không thể xóa sách đang có đơn hàng!',  'danger'],
            'has_books':       ['Không thể xóa! Vẫn còn sách liên kết.', 'danger'],
            'invalid_value':   ['Giá hoặc tồn kho không hợp lệ!',        'danger'],
            'duplicate':       ['Tên đã tồn tại trong hệ thống!',        'danger']
        };
        const entry = map[window._adminNotify.key];
        if (entry) showToast(entry[0], entry[1]);
    }

    switchTab('dashboard');

    const ctx = document.getElementById('salesChart').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4'],
            datasets: [
                {
                    label: 'Doanh Thu (triệu đồng)',
                    data: [12, 19, 3, 11],
                    borderColor: '#1a3352',
                    backgroundColor: 'rgba(26, 51, 82, 0.1)',
                    fill: true,
                    tension: 0.4
                },
                {
                    label: 'Lượt đăng ký mới x10',
                    data: [5, 8, 12, 10],
                    borderColor: '#22c55e',
                    backgroundColor: 'transparent',
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

function updateOrderStatus(orderId, status) {
    const fd = new FormData();
    fd.append('orderId', orderId);
    fd.append('status', status);
    fetch(document.querySelector('meta[name="ctx"]') ? document.querySelector('meta[name="ctx"]').content + '/admin/orders' : '/BookShop_war/admin/orders', {
        method: 'POST', body: fd
    })
    .then(r => r.json())
    .then(data => {
        if (data.success) showToast('Cập nhật trạng thái thành công!', 'success');
        else showToast('Cập nhật thất bại!', 'danger');
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
        const statusColor = { PENDING:'#92400e', PROCESSING:'#1e40af', SHIPPING:'#0369a1', COMPLETED:'#065f46', CANCELLED:'#991b1b' };
        const statusBg   = { PENDING:'#fff3cd', PROCESSING:'#dbeafe', SHIPPING:'#e0f2fe', COMPLETED:'#d1fae5', CANCELLED:'#fee2e2' };

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
                    <p>Trạng thái: <span style="padding:2px 10px;border-radius:10px;font-size:.85em;font-weight:600;background:${statusBg[o.status]||'#eee'};color:${statusColor[o.status]||'#333'}">${o.status}</span></p>
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