package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ClothesDonationDAO {
    private Connection connection;
    
    // Constructor
    public ClothesDonationDAO(Connection connection) {
        this.connection = connection;
    }
    
    // Method to create clothes donation table if it doesn't exist
    public static void createClothesDonationTableIfNotExists() {
        try (Connection conn = DatabaseConnection.getConnection()) {
            String sql = "CREATE TABLE IF NOT EXISTS clothes_donations (" +
                    "donation_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "campaign_id INT NOT NULL," +
                    "user_id INT NOT NULL," +
                    "clothes_type VARCHAR(50) NOT NULL," +
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
            
            try (Statement stmt = conn.createStatement()) {
                stmt.executeUpdate(sql);
                System.out.println("Clothes donations table created or already exists.");
            }
        } catch (SQLException e) {
            System.err.println("Error creating clothes donations table: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Method to add a new clothes donation
    public boolean addClothesDonation(ClothesDonation donation) {
        String sql = "INSERT INTO clothingdonations (campaign_id, user_id, clothes_type, quantity, size, `condition`, pickup_address, pickup_date, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, donation.getCampaign_id());
            pstmt.setInt(2, donation.getUser_id());
            pstmt.setString(3, donation.getClothes_type());
            pstmt.setInt(4, donation.getQuantity());
            pstmt.setString(5, donation.getSize());
            pstmt.setString(6, donation.getCondition());
            pstmt.setString(7, donation.getPickup_address());
            pstmt.setDate(8, new java.sql.Date(donation.getPickup_date().getTime()));
            pstmt.setString(9, donation.getStatus());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                // Get the generated ID
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        donation.setDonation_id(generatedKeys.getInt(1));
                    }
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            System.err.println("Error adding clothes donation: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to get clothes donations by campaign ID
    public List<ClothesDonation> getClothesDonationsByCampaign(int campaignId) {
        List<ClothesDonation> donations = new ArrayList<>();
        String sql = "SELECT * FROM clothingdonations WHERE campaign_id = ? ORDER BY created_at DESC";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, campaignId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ClothesDonation donation = extractClothesDonationFromResultSet(rs);
                donations.add(donation);
            }
        } catch (SQLException e) {
            System.err.println("Error getting clothes donations by campaign: " + e.getMessage());
            e.printStackTrace();
        }
        
        return donations;
    }
    
    // Method to get clothes donations by user ID
    public List<ClothesDonation> getClothesDonationsByUser(int userId) {
        List<ClothesDonation> donations = new ArrayList<>();
        String sql = "SELECT * FROM clothingdonations WHERE user_id = ? ORDER BY created_at DESC";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ClothesDonation donation = extractClothesDonationFromResultSet(rs);
                donations.add(donation);
            }
        } catch (SQLException e) {
            System.err.println("Error getting clothes donations by user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return donations;
    }
    
    // Method to update donation status
    public boolean updateDonationStatus(int donationId, String status) {
        String sql = "UPDATE clothingdonations SET status = ? WHERE donation_id = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, donationId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating donation status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Helper method to extract ClothesDonation from ResultSet
    private ClothesDonation extractClothesDonationFromResultSet(ResultSet rs) throws SQLException {
        int donationId = rs.getInt("donation_id");
        int campaignId = rs.getInt("campaign_id");
        int userId = rs.getInt("user_id");
        String clothesType = rs.getString("clothes_type");
        int quantity = rs.getInt("quantity");
        String size = rs.getString("size");
        String condition = rs.getString("condition");
        String pickupAddress = rs.getString("pickup_address");
        Date pickupDate = rs.getDate("pickup_date");
        String status = rs.getString("status");
        Date createdAt = rs.getTimestamp("created_at");
        
        return new ClothesDonation(donationId, campaignId, userId, clothesType, quantity, size, 
                                  condition, pickupAddress, pickupDate, status, createdAt);
    }
    
    // Method to get total clothes donations count by campaign
    public int getTotalClothesDonationsCount(int campaignId) {
        String sql = "SELECT COUNT(*) FROM clothes_donations WHERE campaign_id = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, campaignId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error getting total clothes donations count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
}
