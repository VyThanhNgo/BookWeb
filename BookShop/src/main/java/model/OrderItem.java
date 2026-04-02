package model;

public class OrderItem {
    private int orderDetailId;
    private int orderId;
    private int bookId;
    private String bookTitle;
    private String image;
    private int quantity;
    private double unitPrice;
    private double lineTotal;

    public OrderItem() {
    }

    public OrderItem(int bookId, String bookTitle, String image, int quantity, double unitPrice) {
        this.bookId = bookId;
        this.bookTitle = bookTitle;
        this.image = image;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = unitPrice * quantity;
    }

    public int getOrderDetailId() {
        return orderDetailId;
    }

    public void setOrderDetailId(int orderDetailId) {
        this.orderDetailId = orderDetailId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getBookId() {
        return bookId;
    }

    public void setBookId(int bookId) {
        this.bookId = bookId;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
        this.lineTotal = this.unitPrice * this.quantity;
    }

    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
        this.lineTotal = this.unitPrice * this.quantity;
    }

    public double getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(double lineTotal) {
        this.lineTotal = lineTotal;
    }
}