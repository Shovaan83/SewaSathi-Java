package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import util.DatabaseSetup;

public class DatabaseConnection {
    // Database connection parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/sewasathidb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    
    // Static initialization block to ensure database setup
    static {
        try {
            // Initialize database and tables
            DatabaseSetup.initialize();
        } catch (Exception e) {
            System.err.println("Error initializing database: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Get database connection
    public static Connection getConnection() throws SQLException {
        try {
            // Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Return connection
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found: " + e.getMessage());
        }
    }
} 