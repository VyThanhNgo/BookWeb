package model;

public class CartItem {
    private int bookId;
    private String title;
    private double price;
    private int quantity;
    private String image;

    public CartItem() {}

    public CartItem(int bookId, String title, double price, int quantity, String image) {
        this.bookId = bookId;
        this.title = title;
        this.price = price;
        this.quantity = quantity;
        this.image = image;
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

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
}