package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;

@WebServlet(name = "CampaignDetailServlet", value = {"/CampaignDetailServlet", "/campaign"})
public class CampaignDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String campaignIdStr = request.getParameter("id");
        
        if (campaignIdStr == null || campaignIdStr.trim().isEmpty()) {
            // If no ID provided, redirect to campaigns list
            response.sendRedirect(request.getContextPath() + "/campaigns");
            return;
        }
        
        try {
            int campaignId = Integer.parseInt(campaignIdStr);
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                CampaignDAO campaignDAO = new CampaignDAO(conn);
                Campaign campaign = campaignDAO.getCampaignById(campaignId);
                
                if (campaign == null) {
                    // Campaign not found
                    request.setAttribute("error", "Campaign not found");
                    request.getRequestDispatcher("/WEB-INF/view/campaign-detail.jsp").forward(request, response);
                    return;
                }
                
                // Get additional campaign information
                double collectedAmount = campaignDAO.getCollectedAmount(campaignId);
                campaign.setCollectedAmount(collectedAmount);
                
                BigDecimal goalAmount = campaign.getGoal_amount();
                int progressPercentage = 0;
                
                if (goalAmount != null && goalAmount.doubleValue() > 0) {
                    progressPercentage = (int) ((collectedAmount / goalAmount.doubleValue()) * 100);
                    if (progressPercentage > 100) {
                        progressPercentage = 100;
                    }
                }
                
                campaign.setProgressPercentage(progressPercentage);
                
                // Get creator name
                String creatorName = campaignDAO.getCampaignCreatorName(campaignId);
                campaign.setCreatorName(creatorName);
                
                // Set campaign in request
                request.setAttribute("campaign", campaign);
                
                // Get current user from session and set in request
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("user");
                if (currentUser != null) {
                    request.setAttribute("user", currentUser);
                }
                
                // Forward to campaign detail page
                request.getRequestDispatcher("/WEB-INF/view/campaign-detail.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid campaign ID");
            request.getRequestDispatcher("/WEB-INF/view/campaign-detail.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading campaign: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/campaign-detail.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
} 