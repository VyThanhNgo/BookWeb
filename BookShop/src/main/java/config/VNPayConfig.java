package config;

public class VNPayConfig {
    /*
     * Sandbox credentials — thay bằng credentials production khi deploy thật.
     *
     * Thẻ test:
     *   Ngân hàng : NCB
     *   Số thẻ   : 9704198526191432198
     *   Tên      : NGUYEN VAN A
     *   Ngày HH  : 07/15
     *   OTP      : 123456
     */
    public static final String TMN_CODE    = "E3ODI01R";
    public static final String HASH_SECRET = "94RRTHNZ51CB48SNR5FRSL06PBRRDNDP";
    public static final String PAY_URL     = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    public static final String VERSION     = "2.1.0";
    public static final String COMMAND     = "pay";
    public static final String CURR_CODE   = "VND";
    public static final String ORDER_TYPE  = "billpayment";
    public static final String LOCALE      = "vn";
    public static final String TIMEZONE    = "Asia/Ho_Chi_Minh";
}
