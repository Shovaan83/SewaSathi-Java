package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet(name = "CampaignsServlet", value = {"/CampaignsServlet", "/campaigns"})
public class CampaignsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            CampaignDAO campaignDAO = new CampaignDAO(conn);
            List<Campaign> campaigns = campaignDAO.getAllCampaignsForDisplay();
            
            // Calculate progress for each campaign
            for (Campaign campaign : campaigns) {
                double collectedAmount = campaignDAO.getCollectedAmount(campaign.getCampaign_id());
                campaign.setCollectedAmount(collectedAmount);
                
                // Calculate progress percentage
                double goalAmount = campaign.getGoal_amount().doubleValue();
                int progressPercentage = 0;
                
                if (goalAmount > 0) {
                    progressPercentage = (int) ((collectedAmount / goalAmount) * 100);
                    if (progressPercentage > 100) {
                        progressPercentage = 100;
                    }
                }
                
                campaign.setProgressPercentage(progressPercentage);
                
                // Get creator name
                String creatorName = campaignDAO.getCampaignCreatorName(campaign.getCampaign_id());
                campaign.setCreatorName(creatorName);
            }
            
            request.setAttribute("campaigns", campaigns);
            request.getRequestDispatcher("/WEB-INF/view/campaigns.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading campaigns: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/campaigns.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
} 