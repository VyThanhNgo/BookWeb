package util;

import config.GhnConfig;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class GhnApiUtil {

    private GhnApiUtil() {}

    public static String doGet(String endpoint) throws IOException {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(GhnConfig.BASE_URL + endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Token", GhnConfig.TOKEN);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            int status = conn.getResponseCode();
            InputStream is = (status >= 200 && status < 300)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            return readAll(is);
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    public static String doPost(String endpoint, String jsonBody, boolean includeShopId) throws IOException {
        HttpURLConnection conn = null;
        try {
            URL url = new URL(GhnConfig.BASE_URL + endpoint);
            conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Token", GhnConfig.TOKEN);
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");

            if (includeShopId) {
                conn.setRequestProperty("ShopId", String.valueOf(GhnConfig.SHOP_ID));
            }

            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            InputStream is = (status >= 200 && status < 300)
                    ? conn.getInputStream()
                    : conn.getErrorStream();

            return readAll(is);
        } finally {
            if (conn != null) conn.disconnect();
        }
    }

    private static String readAll(InputStream is) throws IOException {
        if (is == null) return "";
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        }
        return sb.toString();
    }

    public static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    public static int parseInt(String s, int defaultValue) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return defaultValue;
        }
    }
}