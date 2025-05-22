package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DatabaseFix {
    
    private static final String URL = "jdbc:mysql://localhost:3306/sewasathidb";
    private static final String USER = "root";
    private static final String PASS = "";
    
    public static void main(String[] args) {
        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Connect to database
            System.out.println("Connecting to database...");
            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            
            // Add status column if it doesn't exist
            System.out.println("Checking for status column...");
            Statement stmt = conn.createStatement();
            
            // Check if column exists
            boolean columnExists = false;
            try {
                stmt.executeQuery("SELECT status FROM campaigns LIMIT 1");
                columnExists = true;
                System.out.println("Status column already exists in campaigns table.");
            } catch (Exception e) {
                System.out.println("Status column does not exist. Adding it now...");
            }
            
            // Add column if it doesn't exist
            if (!columnExists) {
                String addColumnSQL = "ALTER TABLE campaigns ADD COLUMN status VARCHAR(20) DEFAULT 'pending'";
                stmt.executeUpdate(addColumnSQL);
                System.out.println("Status column added successfully!");
            }
            
            System.out.println("Database fix completed successfully!");
            conn.close();
            
        } catch (Exception e) {
            System.err.println("Error fixing database: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 