package config;

/**
 * Cấu hình gửi email xác nhận đơn hàng.
 *
 * Hướng dẫn bật tính năng:
 *  1. Đặt ENABLED = true.
 *  2. Với Gmail: bật 2FA cho tài khoản, tạo "App Password" (16 ký tự) tại
 *     https://myaccount.google.com/apppasswords và điền vào PASSWORD bên dưới
 *     (KHÔNG dùng mật khẩu đăng nhập thường).
 *  3. Điền USERNAME / FROM_EMAIL = địa chỉ Gmail của shop.
 *
 * Khi ENABLED = false, toàn bộ chức năng gửi mail là no-op (không ảnh hưởng đặt hàng).
 */
public class MailConfig {

    public static final boolean ENABLED = false;

    public static final String SMTP_HOST = "smtp.gmail.com";
    public static final String SMTP_PORT = "587";
    public static final boolean USE_TLS  = true;

    public static final String USERNAME   = "your-email@gmail.com";
    public static final String PASSWORD   = "your-16-char-app-password";
    public static final String FROM_EMAIL = "your-email@gmail.com";
    public static final String FROM_NAME  = "Góc Sách";

    private MailConfig() {}
}
