package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.math.BigDecimal;

public class CampaignDAO {
    private Connection connection;
    
    // Constructor that accepts a Connection
    public CampaignDAO(Connection connection) {
        this.connection = connection;
    }
    
    // Method to get total count of campaigns
    public static int getTotalCampaignsCount() {
        int count = 0;
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM campaign")) {
            
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // Method to get recent campaigns (limited by count parameter)
    public static List<Campaign> getRecentCampaigns(int count) {
        List<Campaign> campaigns = new ArrayList<>();
        String sql = "SELECT * FROM campaign ORDER BY campaign_id DESC LIMIT ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, count);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Campaign campaign = extractCampaignFromResultSet(rs);
                campaigns.add(campaign);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return campaigns;
    }

    // Method to get all campaigns
    public static List<Campaign> getAllCampaigns() {
        List<Campaign> campaigns = new ArrayList<>();
        String sql = "SELECT * FROM campaign ORDER BY campaign_id DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Campaign campaign = extractCampaignFromResultSet(rs);
                campaigns.add(campaign);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return campaigns;
    }

    // Method to get campaign by ID - instance method using the connection from constructor
    public Campaign getCampaignById(int campaignId) {
        String query = "SELECT * FROM Campaigns WHERE campaign_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, campaignId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Campaign(
                    rs.getInt("campaign_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getBigDecimal("goal_amount"),
                    rs.getDate("deadline"),
                    rs.getInt("created_by"),
                    rs.getInt("category_id"),
                    rs.getString("campaign_image_url"),
                    rs.getString("campaign_image_public_id")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving campaign by ID: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }
    
    // Method to get total collected amount for a campaign
    public double getCollectedAmount(int campaignId) {
        String query = "SELECT SUM(amount) FROM Donations WHERE campaign_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, campaignId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                BigDecimal amount = rs.getBigDecimal(1);
                return amount != null ? amount.doubleValue() : 0;
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving collected amount: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Method to get campaign creator name
    public String getCampaignCreatorName(int campaignId) {
        String query = "SELECT u.full_name FROM Users u " +
                      "JOIN Campaigns c ON u.user_id = c.created_by " +
                      "WHERE c.campaign_id = ?";
        
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, campaignId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getString("full_name");
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving campaign creator name: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "Unknown";
    }

    // Method to search campaigns by title or description
    public static List<Campaign> searchCampaigns(String query) {
        String searchQuery = "SELECT * FROM Campaigns WHERE title LIKE ? OR description LIKE ?";
        List<Campaign> campaigns = new ArrayList<>();
        
        try (Connection conn = UserDAO.getConnection();
             PreparedStatement ps = conn.prepareStatement(searchQuery)) {
            
            String searchParam = "%" + query + "%";
            ps.setString(1, searchParam);
            ps.setString(2, searchParam);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Campaign campaign = new Campaign(
                    rs.getInt("campaign_id"),
                    rs.getString("title"),
                    rs.getString("description"),
                    rs.getBigDecimal("goal_amount"),
                    rs.getDate("deadline"),
                    rs.getInt("created_by"),
                    rs.getInt("category_id"),
                    rs.getString("campaign_image_url"),
                    rs.getString("campaign_image_public_id")
                );
                campaigns.add(campaign);
            }
        } catch (SQLException e) {
            System.err.println("Error searching campaigns: " + e.getMessage());
            e.printStackTrace();
        }
        
        return campaigns;
    }

    // Method to delete a campaign
    public static boolean deleteCampaign(int campaignId) {
        String sql = "DELETE FROM campaign WHERE campaign_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, campaignId);
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to approve a campaign
    public static boolean approveCampaign(int campaignId) {
        String sql = "UPDATE campaign SET status = 'active' WHERE campaign_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, campaignId);
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to reject a campaign
    public static boolean rejectCampaign(int campaignId) {
        String sql = "UPDATE campaign SET status = 'rejected' WHERE campaign_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, campaignId);
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Helper method to extract a Campaign from ResultSet
    private static Campaign extractCampaignFromResultSet(ResultSet rs) throws SQLException {
        int campaignId = rs.getInt("campaign_id");
        String title = rs.getString("title");
        String description = rs.getString("description");
        BigDecimal goalAmount = rs.getBigDecimal("goal_amount");
        java.sql.Date sqlDeadline = rs.getDate("deadline");
        Date deadline = sqlDeadline != null ? new Date(sqlDeadline.getTime()) : null;
        int createdBy = rs.getInt("created_by");
        int categoryId = rs.getInt("category_id");
        String imageUrl = rs.getString("campaign_image_url");
        String imagePublicId = rs.getString("campaign_image_public_id");
        String status = rs.getString("status");
        
        if (status == null) {
            status = "pending"; // Default status if null
        }
        
        return new Campaign(campaignId, title, description, goalAmount, deadline, createdBy, categoryId, imageUrl, imagePublicId, status);
    }
} 