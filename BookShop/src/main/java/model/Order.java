package model;

import java.util.Date;

public class Order {
    private int orderId;
    private int userId;
    private double total;
    private String status;
    private Date createdAt;

    public Order() {}

    public Order(int orderId, int userId, double total, String status, Date createdAt) {
        this.orderId = orderId;
        this.userId = userId;
        this.total = total;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getter & Setter
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}