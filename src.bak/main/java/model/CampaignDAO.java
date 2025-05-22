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
             ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM campaigns")) {
            
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
        String sql = "SELECT * FROM campaigns ORDER BY campaign_id DESC LIMIT ?";
        
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
        String sql = "SELECT * FROM campaigns ORDER BY campaign_id DESC";
        
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
        String query = "SELECT * FROM campaigns WHERE campaign_id = ?";

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
        String query = "SELECT SUM(amount) FROM donations WHERE campaign_id = ?";
        
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
        String query = "SELECT u.full_name FROM users u " +
                      "JOIN campaigns c ON u.user_id = c.created_by " +
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
        String searchQuery = "SELECT * FROM campaigns WHERE title LIKE ? OR description LIKE ?";
        List<Campaign> campaigns = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
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
        String sql = "DELETE FROM campaigns WHERE campaign_id = ?";
        
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
        String sql = "UPDATE campaigns SET status = 'active' WHERE campaign_id = ?";
        
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
        String sql = "UPDATE campaigns SET status = 'rejected' WHERE campaign_id = ?";
        
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
        String donationType = rs.getString("donation_type");
        
        if (status == null) {
            status = "pending"; // Default status if null
        }
        
        if (donationType == null) {
            donationType = "monetary"; // Default donation type if null
        }
        
        return new Campaign(campaignId, title, description, goalAmount, deadline, createdBy, categoryId, imageUrl, imagePublicId, status, donationType);
    }
    
    // Method to create a new campaign
    public boolean createCampaign(Campaign campaign) {
        try {
            // First check if donation_type column exists
            DatabaseMetaData meta = connection.getMetaData();
            ResultSet rs = meta.getColumns(null, null, "campaigns", "donation_type");
            
            if (!rs.next()) {
                // Column doesn't exist, add it
                try (Statement stmt = connection.createStatement()) {
                    String addColumn = "ALTER TABLE campaigns ADD COLUMN donation_type VARCHAR(20) DEFAULT 'monetary'";
                    stmt.executeUpdate(addColumn);
                    System.out.println("donation_type column has been added to campaigns table");
                }
            }
            
            // Now proceed with creating the campaign
            String sql;
            if (campaign.getDonation_type() != null) {
                sql = "INSERT INTO campaigns (title, description, goal_amount, deadline, created_by, category_id, campaign_image_url, campaign_image_public_id, status, donation_type) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            } else {
                sql = "INSERT INTO campaigns (title, description, goal_amount, deadline, created_by, category_id, campaign_image_url, campaign_image_public_id, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            }
            
            try (PreparedStatement pstmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, campaign.getTitle());
                pstmt.setString(2, campaign.getDescription());
                pstmt.setBigDecimal(3, campaign.getGoal_amount());
                pstmt.setDate(4, new java.sql.Date(campaign.getDeadline().getTime()));
                pstmt.setInt(5, campaign.getCreated_by());
                pstmt.setInt(6, campaign.getCategory_id());
                pstmt.setString(7, campaign.getCampaign_image_url());
                pstmt.setString(8, campaign.getCampaign_image_public_id());
                pstmt.setString(9, campaign.getStatus());
                
                if (campaign.getDonation_type() != null) {
                    pstmt.setString(10, campaign.getDonation_type());
                }
                
                int affectedRows = pstmt.executeUpdate();
                
                if (affectedRows > 0) {
                    // Get the generated ID
                    try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            campaign.setCampaign_id(generatedKeys.getInt(1));
                        }
                    }
                    return true;
                }
                return false;
            }
        } catch (SQLException e) {
            System.err.println("Error creating campaign: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to get campaigns created by a specific user
    public List<Campaign> getCampaignsByUser(int userId) {
        List<Campaign> userCampaigns = new ArrayList<>();
        String sql = "SELECT * FROM campaigns WHERE created_by = ? ORDER BY campaign_id DESC";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Campaign campaign = extractCampaignFromResultSet(rs);
                userCampaigns.add(campaign);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving user campaigns: " + e.getMessage());
            e.printStackTrace();
        }
        
        return userCampaigns;
    }
    
    // Method to get all active campaigns
    public List<Campaign> getAllActiveCampaigns() {
        List<Campaign> activeCampaigns = new ArrayList<>();
        String sql = "SELECT * FROM campaigns WHERE status = 'active' ORDER BY campaign_id DESC";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Campaign campaign = extractCampaignFromResultSet(rs);
                activeCampaigns.add(campaign);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving active campaigns: " + e.getMessage());
            e.printStackTrace();
        }
        
        return activeCampaigns;
    }
    
    // Method to get all campaigns for display (all statuses)
    public List<Campaign> getAllCampaignsForDisplay() {
        List<Campaign> allCampaigns = new ArrayList<>();
        String sql = "SELECT * FROM campaigns ORDER BY campaign_id DESC";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Campaign campaign = extractCampaignFromResultSet(rs);
                allCampaigns.add(campaign);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all campaigns: " + e.getMessage());
            e.printStackTrace();
        }
        
        return allCampaigns;
    }
    
    // Method to update campaign image
    public boolean updateCampaignImage(int campaignId, String imageUrl, String imagePublicId) {
        String sql = "UPDATE campaigns SET campaign_image_url = ?, campaign_image_public_id = ? WHERE campaign_id = ?";
        
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, imageUrl);
            pstmt.setString(2, imagePublicId);
            pstmt.setInt(3, campaignId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating campaign image: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
} 