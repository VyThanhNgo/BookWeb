package main.java.model;

public class CartItem {
    private int bookId;
    private String title;
    private double price;
    private int quantity;

    public CartItem() {}

    public CartItem(int bookId, String title, double price, int quantity) {
        this.bookId = bookId;
        this.title = title;
        this.price = price;
        this.quantity = quantity;
    }

    public double getTotal() {
        return price * quantity;
    }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
