package main.java.model;

import java.util.*;

public class Cart {
    private Map<Integer, CartItem> items = new HashMap<>();

    public void addItem(CartItem item) {
        if (items.containsKey(item.getBookId())) {
            CartItem existing = items.get(item.getBookId());
            existing.setQuantity(existing.getQuantity() + item.getQuantity());
        } else {
            items.put(item.getBookId(), item);
        }
    }

    public void removeItem(int bookId) {
        items.remove(bookId);
    }

    public void updateItem(int bookId, int quantity) {
        if (items.containsKey(bookId)) {
            items.get(bookId).setQuantity(quantity);
        }
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public double getTotalPrice() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getTotal();
        }
        return total;
    }
}
