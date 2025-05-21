package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;

import java.io.IOException;
import java.sql.Connection;

/**
 * Servlet that handles donation requests and redirects based on campaign type
 */
@WebServlet(name = "DonateServlet", urlPatterns = {"/donate"})
public class DonateServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
                
                // Redirect based on donation type
                if ("clothes".equals(campaign.getDonation_type())) {
                    // Redirect to clothes donation page
                    response.sendRedirect(request.getContextPath() + "/clothes-donate?campaignId=" + campaignId);
                } else {
                    // Default to monetary donation 
                    response.sendRedirect(request.getContextPath() + "/monetary-donation?campaignId=" + campaignId);
                }
                
            } catch (Exception e) {
                session.setAttribute("error", "Error: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/campaigns");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid campaign ID");
            response.sendRedirect(request.getContextPath() + "/campaigns");
        }
    }
} 