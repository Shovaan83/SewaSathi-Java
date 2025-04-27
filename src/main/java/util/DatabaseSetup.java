package util;

import java.sql.*;

public class DatabaseSetup {

    private static final String URL = "jdbc:mysql://localhost:3306/";
    private static final String USER = "root";
    private static final String PASS = "";
    private static final String DB_NAME = "sewasathidb";

    public static void initialize() {
        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Create database if it doesn't exist
            createDatabaseIfNotExists();
            
            // Create necessary tables if they don't exist
            createTablesIfNotExist();
            
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
    
    private static void createTablesIfNotExist() throws SQLException {
        String fullUrl = URL + DB_NAME;
        try (Connection conn = DriverManager.getConnection(fullUrl, USER, PASS);
             Statement stmt = conn.createStatement()) {
            
            // Create roles table
            String createRolesTable = "CREATE TABLE IF NOT EXISTS Roles (" +
                    "role_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "role_name VARCHAR(50) NOT NULL UNIQUE" +
                    ")";
            stmt.executeUpdate(createRolesTable);
            System.out.println("Roles table created or already exists.");
            
            // Create users table
            String createUsersTable = "CREATE TABLE IF NOT EXISTS Users (" +
                    "user_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "full_name VARCHAR(100) NOT NULL," +
                    "email VARCHAR(100) NOT NULL UNIQUE," +
                    "password VARCHAR(255) NOT NULL," +
                    "role_id INT DEFAULT 2," +
                    "profile_picture_url VARCHAR(255)," +
                    "profile_picture_public_id VARCHAR(100)," +
                    "FOREIGN KEY (role_id) REFERENCES Roles(role_id)" +
                    ")";
            stmt.executeUpdate(createUsersTable);
            System.out.println("Users table created or already exists.");
            
            // Create campaigns table
            String createCampaignsTable = "CREATE TABLE IF NOT EXISTS Campaigns (" +
                    "campaign_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "title VARCHAR(100) NOT NULL," +
                    "description TEXT NOT NULL," +
                    "goal_amount DECIMAL(10,2) NOT NULL," +
                    "deadline DATE NOT NULL," +
                    "created_by INT NOT NULL," +
                    "category_id INT," +
                    "campaign_image_url VARCHAR(255)," +
                    "campaign_image_public_id VARCHAR(100)," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "FOREIGN KEY (created_by) REFERENCES Users(user_id)" +
                    ")";
            stmt.executeUpdate(createCampaignsTable);
            System.out.println("Campaigns table created or already exists.");
            
            // Insert default roles if not exist
            String checkRolesSql = "SELECT COUNT(*) as roleCount FROM Roles";
            ResultSet rs = stmt.executeQuery(checkRolesSql);
            
            if (rs.next() && rs.getInt("roleCount") == 0) {
                // Insert default roles
                String insertRolesSql = "INSERT INTO Roles (role_id, role_name) VALUES " +
                                       "(1, 'Admin'), " +
                                       "(2, 'User')";
                stmt.executeUpdate(insertRolesSql);
                System.out.println("Default roles created");
            }
            
            // Create default admin user if none exists
            String checkAdminSql = "SELECT COUNT(*) as adminCount FROM Users WHERE role_id = 1";
            rs = stmt.executeQuery(checkAdminSql);
            
            if (rs.next() && rs.getInt("adminCount") == 0) {
                // No admin users, create a default one
                // Password is hashed version of "admin123"
                String defaultHashedPassword = "10000:Wm1uGaFQaC/ykpnx6bLd/g==:W3Gg/SEJ7O/+/JvRpTl7j0lyVZP4ETmEhjnLH4IS+P0=";
                String insertAdminSql = "INSERT INTO Users (full_name, email, password, role_id) " +
                                       "VALUES ('System Administrator', 'admin@sewasathi.com', '" + defaultHashedPassword + "', 1)";
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