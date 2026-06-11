package util;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import model.Author;
import model.Book;
import model.Category;

import java.util.List;

public class AdminJsonUtil {

    public static String serializeBooks(List<Book> books) {
        JsonArray arr = new JsonArray();
        for (Book b : books) {
            JsonObject o = new JsonObject();
            o.addProperty("id",           b.getId());
            o.addProperty("title",        b.getTitle());
            o.addProperty("author_id",    b.getAuthor() != null ? b.getAuthor().getId() : 0);
            o.addProperty("category_id",  b.getCategory() != null ? b.getCategory().getId() : 0);
            o.addProperty("price",        b.getPrice());
            o.addProperty("origin_price", b.getOriginPrice());
            o.addProperty("stock",        b.getStock());
            o.addProperty("sold",         b.getSoldQuantity());
            o.addProperty("isbn",         b.getIsbn() != null ? b.getIsbn() : "");
            o.addProperty("publisher",    b.getPublisher() != null ? b.getPublisher() : "");
            o.addProperty("language",     b.getLanguage() != null ? b.getLanguage() : "");
            o.addProperty("cover",        b.getCoverType() != null ? b.getCoverType() : "");
            o.addProperty("image",        b.getImage() != null ? b.getImage() : "");
            o.addProperty("year",         b.getPublishYear());
            o.addProperty("desc",         b.getDescription() != null ? b.getDescription() : "");
            arr.add(o);
        }
        return arr.toString();
    }

    public static String serializeCategories(List<Category> categories) {
        JsonArray arr = new JsonArray();
        for (Category c : categories) {
            JsonObject o = new JsonObject();
            o.addProperty("id",   c.getId());
            o.addProperty("name", c.getName() != null ? c.getName() : "");
            arr.add(o);
        }
        return arr.toString();
    }

    public static String serializeAuthors(List<Author> authors) {
        JsonArray arr = new JsonArray();
        for (Author a : authors) {
            JsonObject o = new JsonObject();
            o.addProperty("id",    a.getId());
            o.addProperty("name",  a.getName() != null ? a.getName() : "");
            o.addProperty("image", a.getImage() != null ? a.getImage() : "");
            arr.add(o);
        }
        return arr.toString();
    }
}