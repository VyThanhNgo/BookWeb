# 📚 Dự Án BookWeb - Java Servlet & JSP (Dynamic Web Project)

## 1. Giới thiệu dự án
Hệ thống thương mại điện tử chuyên biệt cho lĩnh vực kinh doanh sách trực tuyến.
* **Kiến trúc:** Model-View-Controller (MVC)
* **Công nghệ:** Servlet, JSP, JSTL, JDBC.
* **Môi trường:** Java 8/11, Tomcat 9.0, MySQL.



---

## 2. Tổ chức Git & Quy trình phát triển
Nhóm tuân thủ quy trình Git Workflow chuyên nghiệp để quản lý mã nguồn:

###  Cấu trúc Branches
* **`main`**: Nhánh chính chứa mã nguồn hoàn chỉnh, ổn định.
* **`dev`**: Nhánh tích hợp dùng để tổng hợp và kiểm thử code từ các thành viên.
* **`user-branch`**: Phát triển module Người dùng & Đánh giá (Người 1).
* **`book-branch`**: Phát triển module Sản phẩm & Tìm kiếm (Người 2).
* **`order-branch`**: Phát triển module Giỏ hàng & Thanh toán (Người 3).

###  Quy định Commit Message
Mọi commit phải bắt đầu bằng một **Prefix** để dễ dàng quản lý:
- `feat:` Thêm một chức năng mới.
- `fix:` Sửa lỗi (bug).
- `refactor:` Tối ưu hóa cấu trúc code (không thay đổi tính năng).
- `style:` Cập nhật giao diện (CSS, HTML).
- `docs:` Cập nhật tài liệu (README, SQL script).



---

## 3. Thiết kế Cơ sở dữ liệu
Hệ thống sử dụng cơ sở dữ liệu **BookStoreDB** với 9 bảng đã được chuẩn hóa:

1.  **Người dùng & Tương tác:** `users`, `reviews`.
2.  **Sản phẩm:** `books`, `categories`, `authors`.
3.  **Giao dịch:** `cart`, `orders`, `order_details`, `payments`.

> *Chi tiết script khởi tạo nằm trong thư mục `/database`.*



---

## 4. Phân công nhiệm vụ (Roles)

| Thành viên | Module phụ trách (User Side) | Module phụ trách (Admin Side) |
| :--- | :--- | :--- |
| **Người 1** | Đăng ký, Đăng nhập, Profile, Review | Quản lý User & Đánh giá |
| **Người 2** | Danh mục sách, Chi tiết sách, Tìm kiếm | Quản lý Kho sách & Tác giả |
| **Người 3** | Giỏ hàng, Đặt hàng, Thanh toán | Quản lý Đơn hàng & Doanh thu |

---

## 5. Cấu trúc thư mục (Dynamic Web Project)
Dự án được tổ chức theo cấu trúc chuẩn của Eclipse dành cho Tomcat:

BookWeb/
├── src/                    # Chứa mã nguồn Java (.java)
│   ├── context/            # Kết nối Database (DBConnection.java)
│   ├── controller/         # Các Servlet xử lý yêu cầu
│   ├── dao/                # Lớp truy vấn dữ liệu (DAO)
│   └── model/              # Các đối tượng dữ liệu (POJO)
├── WebContent/             # Thư mục gốc của web (Web Root)
│   ├── WEB-INF/            # Cấu hình bảo mật hệ thống
│   │   ├── lib/            # Chứa các file thư viện (.jar)
│   │   └── web.xml         # File cấu hình Deployment Descriptor
│   ├── views/              # Các trang giao diện JSP
│   └── assets/             # Tài nguyên tĩnh (CSS, JS, Images)
└── database/               # Chứa file script SQL
