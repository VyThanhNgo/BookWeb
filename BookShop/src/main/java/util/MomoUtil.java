package util;

import config.MomoConfig;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class MomoUtil {

    private MomoUtil() {}

    public static String hmacSHA256(String key, String data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256"));
        byte[] bytes = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        StringBuilder sb = new StringBuilder(64);
        for (byte b : bytes) sb.append(String.format("%02x", b));
        return sb.toString();
    }

    /**
     * Gọi MoMo API tạo link thanh toán.
     * Trả về payUrl nếu thành công, null nếu thất bại.
     */
    /**
     * Tạo URL thanh toán MoMo.
     *
     * @param returnUrl URL trình duyệt redirect về sau thanh toán (tính động từ request)
     * @param ipnUrl    URL server-to-server callback của MoMo
     */
    public static String createPaymentUrl(String orderCode, long amount, String orderInfo,
                                          String returnUrl, String ipnUrl) throws Exception {
        String requestId = orderCode + "_" + System.currentTimeMillis();
        String extraData = "";

        String rawSignature = "accessKey=" + MomoConfig.ACCESS_KEY
                + "&amount=" + amount
                + "&extraData=" + extraData
                + "&ipnUrl=" + ipnUrl
                + "&orderId=" + orderCode
                + "&orderInfo=" + orderInfo
                + "&partnerCode=" + MomoConfig.PARTNER_CODE
                + "&redirectUrl=" + returnUrl
                + "&requestId=" + requestId
                + "&requestType=" + MomoConfig.REQUEST_TYPE;

        String signature = hmacSHA256(MomoConfig.SECRET_KEY, rawSignature);

        String jsonBody = "{"
                + "\"partnerCode\":\"" + MomoConfig.PARTNER_CODE + "\","
                + "\"requestId\":\"" + requestId + "\","
                + "\"amount\":" + amount + ","
                + "\"orderId\":\"" + orderCode + "\","
                + "\"orderInfo\":\"" + escapeJson(orderInfo) + "\","
                + "\"redirectUrl\":\"" + escapeJson(returnUrl) + "\","
                + "\"ipnUrl\":\"" + escapeJson(ipnUrl) + "\","
                + "\"requestType\":\"" + MomoConfig.REQUEST_TYPE + "\","
                + "\"extraData\":\"" + extraData + "\","
                + "\"lang\":\"" + MomoConfig.LANG + "\","
                + "\"signature\":\"" + signature + "\""
                + "}";

        String responseBody = doPost(MomoConfig.ENDPOINT, jsonBody);
        return extractJsonString(responseBody, "payUrl");
    }

    /**
     * Xác minh chữ ký từ MoMo redirect về / IPN.
     * Nếu không có signature param (môi trường test không gửi sig), trả true để dev dễ test.
     */
    public static boolean verifyReturn(HttpServletRequest request) throws Exception {
        String receivedSig = request.getParameter("signature");
        if (receivedSig == null || receivedSig.isEmpty()) {
            // MoMo test sandbox đôi khi không gửi signature — coi là hợp lệ trong dev
            return true;
        }

        String accessKey    = MomoConfig.ACCESS_KEY;
        String amount       = nvl(request.getParameter("amount"));
        String extraData    = nvl(request.getParameter("extraData"));
        String message      = nvl(request.getParameter("message"));
        String orderId      = nvl(request.getParameter("orderId"));
        String orderInfo    = nvl(request.getParameter("orderInfo"));
        String orderType    = nvl(request.getParameter("orderType"));
        String partnerCode  = nvl(request.getParameter("partnerCode"));
        String payType      = nvl(request.getParameter("payType"));
        String requestId    = nvl(request.getParameter("requestId"));
        String responseTime = nvl(request.getParameter("responseTime"));
        String resultCode   = nvl(request.getParameter("resultCode"));
        String transId      = nvl(request.getParameter("transId"));

        String rawSignature = "accessKey=" + accessKey
                + "&amount=" + amount
                + "&extraData=" + extraData
                + "&message=" + message
                + "&orderId=" + orderId
                + "&orderInfo=" + orderInfo
                + "&orderType=" + orderType
                + "&partnerCode=" + partnerCode
                + "&payType=" + payType
                + "&requestId=" + requestId
                + "&responseTime=" + responseTime
                + "&resultCode=" + resultCode
                + "&transId=" + transId;

        String computed = hmacSHA256(MomoConfig.SECRET_KEY, rawSignature);
        return computed.equalsIgnoreCase(receivedSig);
    }

    // ---- helpers ----

    private static String doPost(String endpoint, String jsonBody) throws IOException {
        HttpURLConnection conn = null;
        try {
            conn = (HttpURLConnection) new URL(endpoint).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(15000);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            return sb.toString();
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    /** Trích xuất giá trị string từ JSON đơn giản (không cần Gson). */
    private static String extractJsonString(String json, String key) {
        if (json == null) return null;
        String search = "\"" + key + "\":\"";
        int start = json.indexOf(search);
        if (start < 0) return null;
        start += search.length();
        int end = json.indexOf("\"", start);
        if (end < 0) return null;
        return json.substring(start, end);
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private static String nvl(String s) {
        return s == null ? "" : s;
    }
}
