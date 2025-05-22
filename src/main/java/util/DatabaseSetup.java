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
            String createRolesTable = "CREATE TABLE IF NOT EXISTS roles (" +
                    "role_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "role_name VARCHAR(50) NOT NULL UNIQUE" +
                    ")";
            stmt.executeUpdate(createRolesTable);
            System.out.println("Roles table created or already exists.");
            
            // Create users table
            String createUsersTable = "CREATE TABLE IF NOT EXISTS users (" +
                    "user_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "full_name VARCHAR(100) NOT NULL," +
                    "email VARCHAR(100) NOT NULL UNIQUE," +
                    "password VARCHAR(255) NOT NULL," +
                    "role_id INT DEFAULT 2," +
                    "profile_picture_url VARCHAR(255)," +
                    "profile_picture_public_id VARCHAR(100)," +
                    "FOREIGN KEY (role_id) REFERENCES roles(role_id)" +
                    ")";
            stmt.executeUpdate(createUsersTable);
            System.out.println("Users table created or already exists.");
            
            // Create campaigns table
            String createCampaignsTable = "CREATE TABLE IF NOT EXISTS campaigns (" +
                    "campaign_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "title VARCHAR(100) NOT NULL," +
                    "description TEXT NOT NULL," +
                    "goal_amount DECIMAL(10,2) NOT NULL," +
                    "deadline DATE NOT NULL," +
                    "created_by INT NOT NULL," +
                    "category_id INT," +
                    "campaign_image_url VARCHAR(255)," +
                    "campaign_image_public_id VARCHAR(100)," +
                    "status VARCHAR(20) DEFAULT 'pending'," +
                    "donation_type VARCHAR(20) DEFAULT 'monetary'," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "FOREIGN KEY (created_by) REFERENCES users(user_id)" +
                    ")";
            stmt.executeUpdate(createCampaignsTable);
            System.out.println("Campaigns table created or already exists.");
            
            // Create clothes donations table
            String createClothesDonationsTable = "CREATE TABLE IF NOT EXISTS clothes_donations (" +
                    "donation_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "campaign_id INT NOT NULL," +
                    "user_id INT NOT NULL," +
                    "quantity INT NOT NULL," +
                    "size VARCHAR(20)," +
                    "`condition` VARCHAR(20) NOT NULL," +
                    "pickup_address TEXT NOT NULL," +
                    "pickup_date DATE NOT NULL," +
                    "status VARCHAR(20) DEFAULT 'pending'," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)," +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id)" +
                    ")";
            stmt.executeUpdate(createClothesDonationsTable);
            System.out.println("Clothes donations table created or already exists.");
            
            // Check and add columns if they don't exist
            addStatusColumnIfNotExists(conn);
            addDonationTypeColumnIfNotExists(conn);
            
            // Insert default roles if not exist
            String checkRolesSql = "SELECT COUNT(*) as roleCount FROM roles";
            ResultSet rs = stmt.executeQuery(checkRolesSql);
            
            if (rs.next() && rs.getInt("roleCount") == 0) {
                // Insert default roles
                String insertRolesSql = "INSERT INTO roles (role_id, role_name) VALUES " +
                                       "(1, 'Admin'), " +
                                       "(2, 'User')";
                stmt.executeUpdate(insertRolesSql);
                System.out.println("Default roles created");
            }
            
            // Create default admin user if none exists
            String checkAdminSql = "SELECT COUNT(*) as adminCount FROM users WHERE role_id = 1";
            rs = stmt.executeQuery(checkAdminSql);
            
            if (rs.next() && rs.getInt("adminCount") == 0) {
                // No admin users, create a default one
                // Password is hashed version of "admin123"
                String defaultHashedPassword = "10000:Wm1uGaFQaC/ykpnx6bLd/g==:W3Gg/SEJ7O/+/JvRpTl7j0lyVZP4ETmEhjnLH4IS+P0=";
                String insertAdminSql = "INSERT INTO users (full_name, email, password, role_id) " +
                                       "VALUES ('System Administrator', 'admin@sewasathi.com', '" + defaultHashedPassword + "', 1)";
                stmt.executeUpdate(insertAdminSql);
                System.out.println("Default admin user created");
            }
        }
    }
    
    private static void addStatusColumnIfNotExists(Connection conn) throws SQLException {
        String checkStatusColumn = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'campaigns' AND COLUMN_NAME = 'status'";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(checkStatusColumn)) {
            if (!rs.next()) {
                String addStatusColumn = "ALTER TABLE campaigns ADD COLUMN status VARCHAR(20) DEFAULT 'pending'";
                stmt.executeUpdate(addStatusColumn);
                System.out.println("Status column added to Campaigns table");
            }
        }
    }
    
    private static void addDonationTypeColumnIfNotExists(Connection conn) throws SQLException {
        String checkColumn = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'campaigns' AND COLUMN_NAME = 'donation_type'";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(checkColumn)) {
            if (!rs.next()) {
                String addColumn = "ALTER TABLE campaigns ADD COLUMN donation_type VARCHAR(20) DEFAULT 'monetary'";
                stmt.executeUpdate(addColumn);
                System.out.println("Donation type column added to Campaigns table");
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