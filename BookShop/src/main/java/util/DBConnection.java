package util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {

    // ========== Cấu hình kết nối ==========
   
	//private static final String URL = "jdbc:mysql://192.168.1.40:3306/bookstore";
	private static final String URL = "jdbc:mysql://localhost:3306/bookstore";
	private static final String USER = "root";
    private static final String PASSWORD = "1234";
    //private static final String PASSWORD = "12345";

 
//    private static final String URL =
//            "jdbc:mysql://localhost:3306/bookstore?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
//    private static final String USER = "bookuser";
//    private static final String PASSWORD = "123456";

    // ========== HikariCP Connection Pool ==========
    private static HikariDataSource dataSource;

    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(URL + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8");
        config.setUsername(USER);
        config.setPassword(PASSWORD);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        config.setMaximumPoolSize(10);       // Tối đa 10 connection dùng cùng lúc
        config.setMinimumIdle(2);            // Giữ sẵn 2 connection chờ
        config.setConnectionTimeout(30000);  // Chờ lấy connection tối đa 30 giây
        config.setIdleTimeout(600000);       // Đóng connection nhàn rỗi sau 10 phút
        config.setMaxLifetime(1800000);      // Connection sống tối đa 30 phút
        config.setPoolName("BookShopPool");

        dataSource = new HikariDataSource(config);
        System.out.println("Kết nối DB thành công!");
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}