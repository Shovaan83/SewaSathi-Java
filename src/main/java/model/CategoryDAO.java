package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    private Connection connection;
    
    // Constructor that accepts a Connection
    public CategoryDAO(Connection connection) {
        this.connection = connection;
    }
    
    // Method to get all categories
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Category category = new Category(
                    rs.getInt("category_id"),
                    rs.getString("name"),
                    rs.getString("description")
                );
                categories.add(category);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving categories: " + e.getMessage());
            e.printStackTrace();
        }
        
        return categories;
    }
    
    // Method to get a category by ID
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, categoryId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return new Category(
                    rs.getInt("category_id"),
                    rs.getString("name"),
                    rs.getString("description")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving category by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    // Method to create a new category
    public boolean createCategory(Category category) {
        String sql = "INSERT INTO categories (name, description) VALUES (?, ?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        category.setCategory_id(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("Error creating category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to update a category
    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET name = ?, description = ? WHERE category_id = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, category.getName());
            pstmt.setString(2, category.getDescription());
            pstmt.setInt(3, category.getCategory_id());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to delete a category
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, categoryId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting category: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
} 