package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // Database connection parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/sewasathi";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";
    
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