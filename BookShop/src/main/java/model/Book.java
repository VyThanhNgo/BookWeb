package model;

public class Book {
	 private int id;
	    private String title;
	    private int authorId;
	    private int categoryId;
	    private double price;
	    private int stock;
	    private String description;
	    private String image;
	    private int publishYear;
	    
		public Book(int id, String title, int authorId, int categoryId, double price, int stock, String description,
				String image, int publishYear) {
			super();
			this.id = id;
			this.title = title;
			this.authorId = authorId;
			this.categoryId = categoryId;
			this.price = price;
			this.stock = stock;
			this.description = description;
			this.image = image;
			this.publishYear = publishYear;
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

		public int getAuthorId() {
			return authorId;
		}

		public void setAuthorId(int authorId) {
			this.authorId = authorId;
		}

		public int getCategoryId() {
			return categoryId;
		}

		public void setCategoryId(int categoryId) {
			this.categoryId = categoryId;
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
