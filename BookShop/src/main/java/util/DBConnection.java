package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

	private static final String URL = "jdbc:mysql://localhost:3306/bookstore";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";
//    private static final String URL =
//            "jdbc:mysql://localhost:3306/bookstore?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
//    private static final String USER = "bookuser";
//    private static final String PASSWORD = "123456";

    public static Connection getConnection() {
        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("Kết nối DB thành công!");
        } catch (Exception e) {
            System.out.println("Lỗi kết nối DB!");
            e.printStackTrace();
        }

        return conn;
    }
}