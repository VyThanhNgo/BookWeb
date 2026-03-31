package model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {
    private final Map<Integer, CartItem> items = new LinkedHashMap<>();

    public void addItem(CartItem item) {
        if (item == null) return;

        int quantity = item.getQuantity() <= 0 ? 1 : item.getQuantity();

        if (items.containsKey(item.getBookId())) {
            CartItem existing = items.get(item.getBookId());
            existing.setQuantity(existing.getQuantity() + quantity);
        } else {
            item.setQuantity(quantity);
            items.put(item.getBookId(), item);
        }
    }

    public void removeItem(int bookId) {
        items.remove(bookId);
    }

    public void updateItem(int bookId, int quantity) {
        if (!items.containsKey(bookId)) return;

        if (quantity <= 0) {
            items.remove(bookId);
        } else {
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

    public int getTotalItems() {
        int total = 0;
        for (CartItem item : items.values()) {
            total += item.getQuantity();
        }
        return total;
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public void clear() {
        items.clear();
    }
}