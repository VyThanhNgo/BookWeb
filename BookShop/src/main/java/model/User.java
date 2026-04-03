package model;

import java.sql.Timestamp;

public class User {
	private int id;
	private String username;
	private String password; 
	private String email;
	private String fullName;
	private String phone;
	private String address;
	private String role; 
	private boolean isActive; 
	private Timestamp createdAt;

	public User() {
		super();
	}

	public User(String username, String email, String password, String fullName) {
		this.username = username;
		this.email = email;
		this.password = password;
		this.fullName = fullName;
		this.role = "user"; 
		this.isActive = true;
	}

	public User(int id, String username, String password, String email, String fullName,
			String phone, String address, String role, boolean isActive, Timestamp createdAt) {
		super();
		this.id = id;
		this.username = username;
		this.password = password;
		this.email = email;
		this.fullName = fullName;
		this.phone = phone;
		this.address = address;
		this.role = role;
		this.isActive = isActive;
		this.createdAt = createdAt;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public boolean isActive() {
		return isActive;
	}

	public void setActive(boolean isActive) {
		this.isActive = isActive;
	}

	public boolean isAdmin() {
		return "admin".equalsIgnoreCase(role);
	}

	public boolean isUser() {
		return "user".equalsIgnoreCase(role);
	}

	public String getStatusDisplay() {
		return isActive ? "Active" : "Locked";
	}
}
