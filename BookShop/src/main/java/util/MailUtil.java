package util;

import config.MailConfig;
import model.Order;
import model.OrderItem;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.List;
import java.util.Properties;

/**
 * Gửi email xác nhận đơn hàng (HTML). Gửi nền (thread riêng) để không chặn response,
 * và nuốt mọi lỗi để không làm hỏng luồng đặt hàng. No-op khi MailConfig.ENABLED = false.
 */
public class MailUtil {

    public static void sendOrderConfirmationAsync(final Order order, final List<OrderItem> items) {
        if (!MailConfig.ENABLED) return;
        if (order == null || isBlank(order.getEmail())) return;

        new Thread(new Runnable() {
            @Override public void run() {
                try {
                    sendOrderConfirmation(order, items);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }, "mail-order-" + order.getOrderCode()).start();
    }

    private static void sendOrderConfirmation(Order order, List<OrderItem> items) throws Exception {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", MailConfig.SMTP_HOST);
        props.put("mail.smtp.port", MailConfig.SMTP_PORT);
        if (MailConfig.USE_TLS) {
            props.put("mail.smtp.starttls.enable", "true");
        }

        Session session = Session.getInstance(props, new Authenticator() {
            @Override protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(MailConfig.USERNAME, MailConfig.PASSWORD);
            }
        });

        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(MailConfig.FROM_EMAIL, MailConfig.FROM_NAME, "UTF-8"));
        msg.addRecipient(Message.RecipientType.TO, new InternetAddress(order.getEmail().trim()));
        msg.setSubject("Xác nhận đơn hàng " + order.getOrderCode(), "UTF-8");
        msg.setContent(buildHtml(order, items), "text/html; charset=UTF-8");
        Transport.send(msg);
    }

    private static String buildHtml(Order order, List<OrderItem> items) {
        StringBuilder rows = new StringBuilder();
        if (items != null) {
            for (OrderItem it : items) {
                double line = it.getUnitPrice() * it.getQuantity();
                rows.append("<tr>")
                    .append("<td style='padding:6px 10px;border-bottom:1px solid #eee'>").append(esc(it.getBookTitle())).append("</td>")
                    .append("<td style='padding:6px 10px;border-bottom:1px solid #eee;text-align:center'>").append(it.getQuantity()).append("</td>")
                    .append("<td style='padding:6px 10px;border-bottom:1px solid #eee;text-align:right'>").append(money(it.getUnitPrice())).append("đ</td>")
                    .append("<td style='padding:6px 10px;border-bottom:1px solid #eee;text-align:right'>").append(money(line)).append("đ</td>")
                    .append("</tr>");
            }
        }
        return "<div style='font-family:Arial,sans-serif;max-width:600px;margin:auto;color:#333'>"
            + "<h2 style='color:#241c7a'>Cảm ơn bạn đã đặt hàng tại Góc Sách!</h2>"
            + "<p>Mã đơn hàng: <strong>" + esc(order.getOrderCode()) + "</strong></p>"
            + "<p>Người nhận: " + esc(order.getCustomerName()) + " — " + esc(order.getPhone()) + "</p>"
            + "<p>Địa chỉ: " + esc(order.getFullAddress()) + "</p>"
            + "<p>Phương thức thanh toán: " + esc(order.getPaymentMethod()) + "</p>"
            + "<table style='width:100%;border-collapse:collapse;margin-top:12px'>"
            + "<thead><tr style='background:#f5f5f5'>"
            + "<th style='padding:6px 10px;text-align:left'>Sản phẩm</th>"
            + "<th style='padding:6px 10px'>SL</th>"
            + "<th style='padding:6px 10px;text-align:right'>Đơn giá</th>"
            + "<th style='padding:6px 10px;text-align:right'>Thành tiền</th>"
            + "</tr></thead><tbody>" + rows + "</tbody></table>"
            + "<div style='text-align:right;margin-top:12px'>"
            + "<p>Tạm tính: " + money(order.getSubtotal()) + "đ</p>"
            + "<p>Phí vận chuyển: " + money(order.getShippingFee()) + "đ</p>"
            + "<p>Giảm giá: -" + money(order.getDiscountAmount()) + "đ</p>"
            + "<p style='font-size:18px;color:#241c7a'><strong>Tổng cộng: " + money(order.getTotalAmount()) + "đ</strong></p>"
            + "</div>"
            + "<p style='color:#888;font-size:13px'>Chúng tôi sẽ xử lý đơn hàng và liên hệ với bạn trong thời gian sớm nhất.</p>"
            + "</div>";
    }

    private static String money(double v) {
        return String.format("%,d", Math.round(v)).replace(',', '.');
    }

    private static String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
