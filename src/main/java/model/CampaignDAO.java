package model;

import java.sql.*;
import java.util.ArrayList;
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
        String query = "SELECT COUNT(*) FROM Campaigns";
        int count = 0;

        try (Connection conn = UserDAO.getConnection(); // Reuse the connection method from UserDAO
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting campaigns: " + e.getMessage());
            e.printStackTrace();
        }

        return count;
    }

    // Method to get recent campaigns (limited by count parameter)
    public static List<Campaign> getRecentCampaigns(int count) {
        String query = "SELECT * FROM Campaigns ORDER BY campaign_id DESC LIMIT ?";
        List<Campaign> campaigns = new ArrayList<>();

        try (Connection conn = UserDAO.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, count);
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
            System.err.println("Error retrieving recent campaigns: " + e.getMessage());
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
} 