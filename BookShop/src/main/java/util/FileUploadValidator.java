package util;

import javax.servlet.http.Part;
import java.io.*;
import java.util.Arrays;
import java.util.List;

public class FileUploadValidator {

    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

    private static final List<String> ALLOWED_MIME_TYPES = Arrays.asList(
        "image/jpeg", "image/png", "image/gif", "image/webp"
    );

    // Magic bytes của từng định dạng ảnh thật
    private static final byte[] MAGIC_JPEG = {(byte)0xFF, (byte)0xD8, (byte)0xFF};
    private static final byte[] MAGIC_PNG  = {(byte)0x89, 0x50, 0x4E, 0x47};
    private static final byte[] MAGIC_GIF  = {0x47, 0x49, 0x46, 0x38};
    private static final byte[] MAGIC_WEBP = {0x52, 0x49, 0x46, 0x46};

    /**
     * Trả về null nếu hợp lệ, trả về chuỗi lỗi nếu không hợp lệ.
     */
    public static String validate(Part filePart) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return "Vui lòng chọn file ảnh.";
        }

        // 1. Kiểm tra kích thước
        if (filePart.getSize() > MAX_FILE_SIZE) {
            return "File quá lớn. Tối đa 5MB.";
        }

        // 2. Kiểm tra MIME type do client khai báo
        String mimeType = filePart.getContentType();
        if (mimeType == null || !ALLOWED_MIME_TYPES.contains(mimeType.toLowerCase())) {
            return "Loại file không hợp lệ. Chỉ chấp nhận JPG, PNG, GIF, WEBP.";
        }

        // 3. Kiểm tra magic bytes — quan trọng nhất
        //    Kẻ tấn công đổi virus.exe -> anh.jpg vẫn bị chặn ở đây
        try (InputStream is = filePart.getInputStream()) {
            byte[] header = new byte[8];
            int bytesRead = is.read(header);
            if (bytesRead < 4) {
                return "File không hợp lệ.";
            }
            if (!isValidImageHeader(header)) {
                return "Nội dung file không phải ảnh thật. File có thể đã bị đổi tên để qua mặt hệ thống.";
            }
        }

        return null; // hợp lệ
    }

    private static boolean isValidImageHeader(byte[] header) {
        return startsWith(header, MAGIC_JPEG)
            || startsWith(header, MAGIC_PNG)
            || startsWith(header, MAGIC_GIF)
            || startsWith(header, MAGIC_WEBP);
    }

    private static boolean startsWith(byte[] data, byte[] prefix) {
        if (data.length < prefix.length) return false;
        for (int i = 0; i < prefix.length; i++) {
            if (data[i] != prefix[i]) return false;
        }
        return true;
    }
}