package utils;

import java.sql.*;

public class DatabaseSetup {

    private static final String URL = "jdbc:mysql://localhost:3306/";
    private static final String USER = "root";
    private static final String PASS = "";
    private static final String DB_NAME = "user_authentication";

    public static void initializeDatabase() {
        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Create database if it doesn't exist
            createDatabaseIfNotExists();
            
            // Create users table if it doesn't exist
            createUsersTableIfNotExists();
            
            System.out.println("Database setup completed successfully.");
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Database initialization error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void createDatabaseIfNotExists() throws SQLException {
        try (Connection conn = DriverManager.getConnection(URL, USER, PASS);
             Statement stmt = conn.createStatement()) {
            
            String sql = "CREATE DATABASE IF NOT EXISTS " + DB_NAME;
            stmt.executeUpdate(sql);
            System.out.println("Database created or already exists: " + DB_NAME);
        }
    }
    
    private static void createUsersTableIfNotExists() throws SQLException {
        String fullUrl = URL + DB_NAME;
        try (Connection conn = DriverManager.getConnection(fullUrl, USER, PASS);
             Statement stmt = conn.createStatement()) {
            
            String sql = "CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "username VARCHAR(50) UNIQUE NOT NULL," +
                    "email VARCHAR(100) UNIQUE NOT NULL," +
                    "password VARCHAR(255) NOT NULL," +
                    "fullName VARCHAR(100)," +
                    "phone VARCHAR(20)," +
                    "address VARCHAR(255)," +
                    "profilePicture MEDIUMBLOB," +
                    "isAdmin BOOLEAN DEFAULT FALSE" +
                    ")";
            
            stmt.executeUpdate(sql);
            System.out.println("Users table created or already exists.");
            
            // Check if isAdmin column exists, add it if it doesn't
            try {
                // Try to select from the isAdmin column to see if it exists
                stmt.executeQuery("SELECT isAdmin FROM users LIMIT 1");
            } catch (SQLException e) {
                // Column doesn't exist, add it
                if (e.getMessage().contains("Unknown column")) {
                    String addColumnSql = "ALTER TABLE users ADD COLUMN isAdmin BOOLEAN DEFAULT FALSE";
                    stmt.executeUpdate(addColumnSql);
                    System.out.println("Added isAdmin column to users table");
                } else {
                    // Some other error occurred
                    throw e;
                }
            }
            
            // Create default admin user if none exists
            String checkAdminSql = "SELECT COUNT(*) as adminCount FROM users WHERE isAdmin = TRUE";
            ResultSet rs = stmt.executeQuery(checkAdminSql);
            
            if (rs.next() && rs.getInt("adminCount") == 0) {
                // No admin users, create a default one
                String insertAdminSql = "INSERT INTO users (username, email, password, fullName, isAdmin) " +
                                       "VALUES ('admin', 'admin@sewasathi.com', 'admin123', 'System Administrator', TRUE)";
                stmt.executeUpdate(insertAdminSql);
                System.out.println("Default admin user created");
            }
        }
    }
    
    // Method to test database connection
    public static boolean testConnection() {
        String fullUrl = URL + DB_NAME;
        try (Connection conn = DriverManager.getConnection(fullUrl, USER, PASS)) {
            return true;
        } catch (SQLException e) {
            System.err.println("Database connection test failed: " + e.getMessage());
            return false;
        }
    }
} 