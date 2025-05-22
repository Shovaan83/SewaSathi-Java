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
            String sql = "CREATE TABLE IF NOT EXISTS ClothingDonations (" +
                    "donation_id INT AUTO_INCREMENT PRIMARY KEY," +
                    "user_id INT," +
                    "campaign_id INT," +
                    "description TEXT," +
                    "address VARCHAR(255)," +
                    "status ENUM('pending', 'picked_up', 'rejected') DEFAULT 'pending'," +
                    "donated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "FOREIGN KEY (user_id) REFERENCES Users(user_id)," +
                    "FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)" +
                    ")";
            
            try (Statement stmt = conn.createStatement()) {
                stmt.executeUpdate(sql);
                System.out.println("Clothing donations table created or already exists.");
            }
        } catch (SQLException e) {
            System.err.println("Error creating clothing donations table: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Method to add a new clothes donation
    public boolean addClothesDonation(ClothesDonation donation) {
        String sql = "INSERT INTO ClothingDonations (campaign_id, user_id, description, address, status) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, donation.getCampaign_id());
            pstmt.setInt(2, donation.getUser_id());
            pstmt.setString(3, donation.getDescription());
            pstmt.setString(4, donation.getAddress());
            pstmt.setString(5, donation.getStatus());
            
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
        String sql = "SELECT * FROM ClothingDonations WHERE campaign_id = ? ORDER BY donated_at DESC";
        
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
        String sql = "SELECT * FROM ClothingDonations WHERE user_id = ? ORDER BY donated_at DESC";
        
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
        String sql = "UPDATE ClothingDonations SET status = ? WHERE donation_id = ?";
        
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
        String description = rs.getString("description");
        String address = rs.getString("address");
        String status = rs.getString("status");
        Date donatedAt = rs.getTimestamp("donated_at");
        
        return new ClothesDonation(donationId, campaignId, userId, description, address, status, donatedAt);
    }
    
    // Method to get total clothes donations count by campaign
    public int getTotalClothesDonationsCount(int campaignId) {
        String sql = "SELECT COUNT(*) FROM ClothingDonations WHERE campaign_id = ?";
        
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
