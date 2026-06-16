package util;

import config.VNPayConfig;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

public class VNPayUtil {

    private VNPayUtil() {}

    public static String hmacSHA512(String key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA512");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512"));
        byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder(128);
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    // Tạo URL thanh toán VNPay từ danh sách tham số:
    // sắp xếp theo tên, ký bằng HMAC-SHA512 rồi trả về URL đầy đủ.
    public static String buildPaymentUrl(Map<String, String> params) throws Exception {
        List<String> fieldNames = new ArrayList<>(params.keySet());
        Collections.sort(fieldNames);

        List<String> hashParts  = new ArrayList<>();
        List<String> queryParts = new ArrayList<>();

        for (String name : fieldNames) {
            String value = params.get(name);
            if (value != null && !value.isEmpty()) {
                // URL-encode value (chuẩn VNPay v2.1.0 Java demo)
                String encodedValue = URLEncoder.encode(value, StandardCharsets.UTF_8.toString());
                String encodedName  = URLEncoder.encode(name,  StandardCharsets.UTF_8.toString());
                hashParts.add(name + "=" + encodedValue);
                queryParts.add(encodedName + "=" + encodedValue);
            }
        }

        String hashData   = String.join("&", hashParts);
        String query      = String.join("&", queryParts);
        String secureHash = hmacSHA512(VNPayConfig.HASH_SECRET, hashData);

        // vnp_SecureHashType bắt buộc với một số version sandbox
        return VNPayConfig.PAY_URL + "?" + query
                + "&vnp_SecureHash=" + secureHash
                + "&vnp_SecureHashType=HmacSHA512";
    }

    // Kiểm tra chữ ký trong dữ liệu VNPay trả về
    public static boolean verifyReturn(HttpServletRequest request) throws Exception {
        String receivedHash = request.getParameter("vnp_SecureHash");
        if (receivedHash == null || receivedHash.isEmpty()) return false;

        Map<String, String> fields = new TreeMap<>();
        for (Map.Entry<String, String[]> e : request.getParameterMap().entrySet()) {
            String key = e.getKey();
            if (!"vnp_SecureHash".equals(key) && !"vnp_SecureHashType".equals(key)) {
                fields.put(key, e.getValue()[0]);
            }
        }

        List<String> hashParts = new ArrayList<>();
        for (Map.Entry<String, String> entry : fields.entrySet()) {
            String value = entry.getValue();
            if (value != null && !value.isEmpty()) {
                // Re-encode về dạng URL-encoded (nhất quán với cách VNPay ký)
                hashParts.add(entry.getKey() + "=" +
                        URLEncoder.encode(value, StandardCharsets.UTF_8.toString()));
            }
        }
        String hashData = String.join("&", hashParts);

        String computed = hmacSHA512(VNPayConfig.HASH_SECRET, hashData);
        return computed.equalsIgnoreCase(receivedHash);
    }

    public static String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) ip = request.getRemoteAddr();
        if (ip != null && ip.contains(",")) ip = ip.split(",")[0].trim();
        // Đổi IPv6 loopback về IPv4 (VNPay không chấp nhận IPv6)
        if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) ip = "127.0.0.1";
        return ip;
    }

    public static String formatDate(Date date) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        sdf.setTimeZone(TimeZone.getTimeZone(VNPayConfig.TIMEZONE));
        return sdf.format(date);
    }
}
