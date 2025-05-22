package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.util.UUID;

/**
 * Servlet that handles monetary donation requests
 */
@WebServlet(urlPatterns = {"/monetary-donation", "/donation.do"})
public class MonetaryDonationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Get the campaign ID
        String campaignIdStr = request.getParameter("campaignId");
        if (campaignIdStr == null || campaignIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Campaign ID is required");
            response.sendRedirect(request.getContextPath() + "/campaigns");
            return;
        }
        
        try {
            int campaignId = Integer.parseInt(campaignIdStr);
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                // Get the campaign details
                CampaignDAO campaignDAO = new CampaignDAO(conn);
                Campaign campaign = campaignDAO.getCampaignById(campaignId);
                
                if (campaign == null) {
                    session.setAttribute("error", "Campaign not found");
                    response.sendRedirect(request.getContextPath() + "/campaigns");
                    return;
                }
                
                // Check if campaign is active
                if (!"active".equals(campaign.getStatus())) {
                    session.setAttribute("error", "This campaign is not currently accepting donations");
                    response.sendRedirect(request.getContextPath() + "/campaign?id=" + campaignId);
                    return;
                }
                
                // Check if this campaign accepts monetary donations
                if (!"monetary".equals(campaign.getDonation_type())) {
                    session.setAttribute("error", "This campaign does not accept monetary donations");
                    response.sendRedirect(request.getContextPath() + "/campaign?id=" + campaignId);
                    return;
                }
                
                // Set the campaign in request for the JSP
                request.setAttribute("campaign", campaign);
                
                // Forward to the monetary donation JSP page
                request.getRequestDispatcher("/WEB-INF/view/monetarydonation.jsp").forward(request, response);
                
            } catch (Exception e) {
                session.setAttribute("error", "Error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/campaigns");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid campaign ID");
            response.sendRedirect(request.getContextPath() + "/campaigns");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Extract form data
        String campaignIdStr = request.getParameter("campaignId");
        String amountStr = request.getParameter("amount");
        String donorName = request.getParameter("donorName");
        String donorEmail = request.getParameter("donorEmail");
        String donorPhone = request.getParameter("donorPhone");
        String message = request.getParameter("message");
        boolean isAnonymous = "true".equals(request.getParameter("anonymous"));
        
        // Validate required fields
        if (campaignIdStr == null || campaignIdStr.trim().isEmpty() ||
            amountStr == null || amountStr.trim().isEmpty() ||
            donorName == null || donorName.trim().isEmpty() ||
            donorEmail == null || donorEmail.trim().isEmpty()) {
            
            request.setAttribute("error", "All required fields must be filled");
            request.getRequestDispatcher("/monetary-donation?campaignId=" + campaignIdStr).forward(request, response);
            return;
        }
        
        try {
            int campaignId = Integer.parseInt(campaignIdStr);
            BigDecimal amount = new BigDecimal(amountStr);
            
            // Validate amount
            if (amount.compareTo(BigDecimal.TEN) < 0) {
                request.setAttribute("error", "Donation amount must be at least NPR 10");
                request.getRequestDispatcher("/monetary-donation?campaignId=" + campaignIdStr).forward(request, response);
                return;
            }
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                // Get campaign details
                CampaignDAO campaignDAO = new CampaignDAO(conn);
                Campaign campaign = campaignDAO.getCampaignById(campaignId);
                
                if (campaign == null) {
                    request.setAttribute("error", "Campaign not found");
                    request.getRequestDispatcher("/campaigns").forward(request, response);
                    return;
                }
                
                // Check if campaign is active
                if (!"active".equals(campaign.getStatus())) {
                    request.setAttribute("error", "This campaign is not currently accepting donations");
                    request.getRequestDispatcher("/campaign?id=" + campaignId).forward(request, response);
                    return;
                }
                
                // Create a transaction ID
                String transactionId = UUID.randomUUID().toString();
                
                // Create donation record
                MonetaryDonation donation = new MonetaryDonation(
                    campaignId,
                    currentUser != null ? currentUser.getUser_id() : 0, // 0 for anonymous or guest
                    amount,
                    transactionId
                );
                
                // Set additional donor info
                donation.setDonorName(isAnonymous ? "Anonymous" : donorName);
                donation.setDonorEmail(donorEmail);
                donation.setDonorPhone(donorPhone);
                donation.setMessage(message);
                donation.setAnonymous(isAnonymous);
                
                // Save donation
                boolean success = MonetaryDonationDAO.addDonation(donation);
                
                if (success) {
                    session.setAttribute("success", "Thank you for your donation of NPR " + amount + "! Your donation has been recorded successfully.");
                    response.sendRedirect(request.getContextPath() + "/campaign?id=" + campaignId);
                } else {
                    request.setAttribute("error", "Failed to process donation. Please try again.");
                    request.getRequestDispatcher("/monetary-donation?campaignId=" + campaignId).forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("error", "Error processing donation: " + e.getMessage());
                request.getRequestDispatcher("/monetary-donation?campaignId=" + campaignId).forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid campaign ID or donation amount");
            request.getRequestDispatcher("/campaigns").forward(request, response);
        }
    }
}