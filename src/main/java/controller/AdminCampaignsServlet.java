package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import model.Campaign;
import model.CampaignDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminCampaignsServlet", value = "/AdminCampaignsServlet")
public class AdminCampaignsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // User not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        if (!user.isAdmin()) {
            // User is not an admin, redirect to normal dashboard
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Handle actions like delete or approve
        String action = request.getParameter("action");
        int campaignId = 0;
        
        try {
            String campaignIdParam = request.getParameter("campaignId");
            if (campaignIdParam != null && !campaignIdParam.isEmpty()) {
                campaignId = Integer.parseInt(campaignIdParam);
            }
        } catch (NumberFormatException e) {
            // Invalid campaign ID, just continue
        }
        
        // Handle admin actions
        String message = null;
        if (action != null && campaignId > 0) {
            if (action.equals("delete")) {
                boolean success = CampaignDAO.deleteCampaign(campaignId);
                if (success) {
                    message = "Campaign deleted successfully.";
                } else {
                    message = "Failed to delete campaign.";
                }
            } else if (action.equals("approve")) {
                // Implement approval logic if needed
                boolean success = CampaignDAO.approveCampaign(campaignId);
                if (success) {
                    message = "Campaign approved successfully.";
                } else {
                    message = "Failed to approve campaign.";
                }
            } else if (action.equals("reject")) {
                // Implement rejection logic if needed
                boolean success = CampaignDAO.rejectCampaign(campaignId);
                if (success) {
                    message = "Campaign rejected successfully.";
                } else {
                    message = "Failed to reject campaign.";
                }
            }
        }

        // Get all campaigns
        List<Campaign> allCampaigns = CampaignDAO.getAllCampaigns();
        
        // Get campaign statistics
        int totalCampaigns = allCampaigns.size();
        int activeCampaigns = 0;
        int pendingCampaigns = 0;
        
        for (Campaign campaign : allCampaigns) {
            if (campaign.getStatus() != null) {
                if (campaign.getStatus().equals("active")) {
                    activeCampaigns++;
                } else if (campaign.getStatus().equals("pending")) {
                    pendingCampaigns++;
                }
            }
        }
        
        // Set user's first letter for avatar
        String userFirstLetter = "";
        if (user.getFull_name() != null && !user.getFull_name().isEmpty()) {
            userFirstLetter = user.getFull_name().substring(0, 1).toUpperCase();
        } else {
            userFirstLetter = user.getEmail().substring(0, 1).toUpperCase();
        }
        request.setAttribute("firstLetterOfName", userFirstLetter);
        
        // Set attributes for the JSP
        request.setAttribute("allCampaigns", allCampaigns);
        request.setAttribute("totalCampaigns", totalCampaigns);
        request.setAttribute("activeCampaigns", activeCampaigns);
        request.setAttribute("pendingCampaigns", pendingCampaigns);
        
        if (message != null) {
            request.setAttribute("message", message);
        }
        
        // Forward to the admin campaigns view
        request.getRequestDispatcher("/WEB-INF/view/admin-campaigns.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For now, just redirect to doGet
        doGet(request, response);
    }
} 