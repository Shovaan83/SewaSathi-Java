package model;

public class Category {
    private int category_id;
    private String name;
    private String description;
    
    // Constructors
    public Category(int category_id, String name, String description) {
        this.category_id = category_id;
        this.name = name;
        this.description = description;
    }
    
    public Category(int category_id, String name) {
        this.category_id = category_id;
        this.name = name;
        this.description = "";
    }
    
    // Getters and Setters
    public int getCategory_id() {
        return category_id;
    }
    
    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    // Convenience getters for JSP
    public int getCategoryId() {
        return category_id;
    }
} 