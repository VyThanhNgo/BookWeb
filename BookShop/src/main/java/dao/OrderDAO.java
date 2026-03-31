package dao;

import util.DBConnection;
import model.OrderDetail;

import java.sql.*;
import java.util.List;

public class OrderDAO {

    public int createOrder(int userId, double totalPrice) {
        int orderId = 0;
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO orders(user_id, total_price) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, userId);
            ps.setDouble(2, totalPrice);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                orderId = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return orderId;
    }

    public void insertOrderDetail(int orderId, List<OrderDetail> cart) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO order_details(order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            for (OrderDetail item : cart) {
                ps.setInt(1, orderId);
                ps.setInt(2, item.getBookId());
                ps.setInt(3, item.getQuantity());
                ps.setDouble(4, item.getPrice());
                ps.addBatch();
            }

            ps.executeBatch();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}