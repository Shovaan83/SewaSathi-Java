package model;

import java.sql.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MonetaryDonationDAO {
    
    // Get all donations
    public static List<MonetaryDonation> getAllDonations() {
        List<MonetaryDonation> donations = new ArrayList<>();
        String sql = "SELECT d.*, c.title as campaign_title, u.full_name as donor_name " +
                     "FROM monetary_donation d " +
                     "LEFT JOIN campaign c ON d.campaign_id = c.campaign_id " +
                     "LEFT JOIN user u ON d.user_id = u.user_id " +
                     "ORDER BY d.donation_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                MonetaryDonation donation = extractDonationFromResultSet(rs);
                
                // Set transient properties
                String campaignTitle = rs.getString("campaign_title");
                String donorName = rs.getString("donor_name");
                
                donation.setCampaignTitle(campaignTitle);
                donation.setDonorName(donorName);
                
                donations.add(donation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return donations;
    }
    
    // Get donations by campaign ID
    public static List<MonetaryDonation> getDonationsByCampaignId(int campaignId) {
        List<MonetaryDonation> donations = new ArrayList<>();
        String sql = "SELECT d.*, u.full_name as donor_name " +
                     "FROM monetary_donation d " +
                     "LEFT JOIN user u ON d.user_id = u.user_id " +
                     "WHERE d.campaign_id = ? " +
                     "ORDER BY d.donation_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, campaignId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                MonetaryDonation donation = extractDonationFromResultSet(rs);
                
                // Set donor name
                String donorName = rs.getString("donor_name");
                donation.setDonorName(donorName);
                
                donations.add(donation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return donations;
    }
    
    // Get donations by user ID
    public static List<MonetaryDonation> getDonationsByUserId(int userId) {
        List<MonetaryDonation> donations = new ArrayList<>();
        String sql = "SELECT d.*, c.title as campaign_title " +
                     "FROM monetary_donation d " +
                     "LEFT JOIN campaign c ON d.campaign_id = c.campaign_id " +
                     "WHERE d.user_id = ? " +
                     "ORDER BY d.donation_date DESC";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                MonetaryDonation donation = extractDonationFromResultSet(rs);
                
                // Set campaign title
                String campaignTitle = rs.getString("campaign_title");
                donation.setCampaignTitle(campaignTitle);
                
                donations.add(donation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return donations;
    }
    
    // Add a new donation
    public static boolean addDonation(MonetaryDonation donation) {
        String sql = "INSERT INTO monetary_donation (campaign_id, user_id, amount, payment_method, transaction_id, donation_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, donation.getCampaign_id());
            pstmt.setInt(2, donation.getUser_id());
            pstmt.setBigDecimal(3, donation.getAmount());
            pstmt.setString(4, donation.getPayment_method());
            pstmt.setString(5, donation.getTransaction_id());
            pstmt.setTimestamp(6, new Timestamp(donation.getDonation_date().getTime()));
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Delete a donation
    public static boolean deleteDonation(int donationId) {
        String sql = "DELETE FROM monetary_donation WHERE donation_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, donationId);
            int rowsAffected = pstmt.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Get total donation amount by campaign ID
    public static BigDecimal getTotalDonationAmountByCampaignId(int campaignId) {
        String sql = "SELECT SUM(amount) FROM monetary_donation WHERE campaign_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, campaignId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    // Helper method to extract donation from ResultSet
    private static MonetaryDonation extractDonationFromResultSet(ResultSet rs) throws SQLException {
        int donationId = rs.getInt("donation_id");
        int campaignId = rs.getInt("campaign_id");
        int userId = rs.getInt("user_id");
        BigDecimal amount = rs.getBigDecimal("amount");
        String paymentMethod = rs.getString("payment_method");
        String transactionId = rs.getString("transaction_id");
        Timestamp timestamp = rs.getTimestamp("donation_date");
        Date donationDate = timestamp != null ? new Date(timestamp.getTime()) : null;
        
        return new MonetaryDonation(donationId, campaignId, userId, amount, paymentMethod, transactionId, donationDate);
    }
}
