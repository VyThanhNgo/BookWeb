package config;

public class MomoConfig {
    /*
     * Sandbox credentials — thay bằng credentials production khi deploy thật.
     *
     * Test qua app MoMo sandbox: https://developers.momo.vn/
     */
    public static final String PARTNER_CODE = "MOMO";
    public static final String ACCESS_KEY   = "F8BBA842ECF85";
    public static final String SECRET_KEY   = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    public static final String ENDPOINT     = "https://test-payment.momo.vn/v2/gateway/api/create";
    public static final String REQUEST_TYPE = "payWithMethod";
    public static final String LANG         = "vi";
}
