package model;

import java.util.List;

public class Book {
	private int id;
	private String title;
	private Author author;
	private Category category;
	private double price;
	private int stock;
	private String description;
	private String image; // ảnh chính
	private int publishYear;
	
	private String isbn;
    private String publisher;
    private String language;
    private String coverType;
    private int soldQuantity;
    private List<String> subImages; // Danh sách các ảnh phụ
	
	

	public Book(int id, String title, Author author, Category category, double price, int stock, String description,
			String image, int publishYear, String isbn, String publisher, String language, String coverType,
			int soldQuantity, List<String> subImages) {
		super();
		this.id = id;
		this.title = title;
		this.author = author;
		this.category = category;
		this.price = price;
		this.stock = stock;
		this.description = description;
		this.image = image;
		this.publishYear = publishYear;
		this.isbn = isbn;
		this.publisher = publisher;
		this.language = language;
		this.coverType = coverType;
		this.soldQuantity = soldQuantity;
		this.subImages = subImages;
	}

	public String getIsbn() {
		return isbn;
	}

	public void setIsbn(String isbn) {
		this.isbn = isbn;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getLanguage() {
		return language;
	}

	public void setLanguage(String language) {
		this.language = language;
	}

	public String getCoverType() {
		return coverType;
	}

	public void setCoverType(String coverType) {
		this.coverType = coverType;
	}

	public int getSoldQuantity() {
		return soldQuantity;
	}

	public void setSoldQuantity(int soldQuantity) {
		this.soldQuantity = soldQuantity;
	}

	public List<String> getSubImages() {
		return subImages;
	}

	public void setSubImages(List<String> subImages) {
		this.subImages = subImages;
	}

	public Book() {
		super();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Author getAuthor() {
		return author;
	}

	public void setAuthor(Author author) {
		this.author = author;
	}

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public int getPublishYear() {
		return publishYear;
	}

	public void setPublishYear(int publishYear) {
		this.publishYear = publishYear;
	}

}
