package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "EditCampaignServlet", urlPatterns = {"/EditCampaignServlet", "/admin/edit-campaign"})
public class EditCampaignServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // User not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (!user.isAdmin()) {
            // User is not an admin, redirect to access denied
            response.sendRedirect(request.getContextPath() + "/access-denied");
            return;
        }
        
        // Get campaign ID from request
        String campaignIdParam = request.getParameter("id");
        if (campaignIdParam == null || campaignIdParam.isEmpty()) {
            // Campaign ID is missing, redirect to admin campaigns
            response.sendRedirect(request.getContextPath() + "/admin/campaigns");
            return;
        }
        
        int campaignId;
        try {
            campaignId = Integer.parseInt(campaignIdParam);
        } catch (NumberFormatException e) {
            // Invalid campaign ID, redirect to admin campaigns
            response.sendRedirect(request.getContextPath() + "/admin/campaigns");
            return;
        }
        
        // Get the campaign
        try (java.sql.Connection conn = DatabaseConnection.getConnection()) {
            CampaignDAO campaignDAO = new CampaignDAO(conn);
            Campaign campaign = campaignDAO.getCampaignById(campaignId);
            
            if (campaign == null) {
                // Campaign not found, redirect to admin campaigns
                response.sendRedirect(request.getContextPath() + "/admin/campaigns");
                return;
            }
            
            // Get campaign creator name
            String creatorName = campaignDAO.getCampaignCreatorName(campaignId);
            campaign.setCreatorName(creatorName);
            
            // Set attributes for the JSP
            request.setAttribute("campaign", campaign);
            
            // Get the user's first letter for the avatar
            String userFirstLetter = "";
            if (user.getFull_name() != null && !user.getFull_name().isEmpty()) {
                userFirstLetter = user.getFull_name().substring(0, 1).toUpperCase();
            } else {
                userFirstLetter = user.getEmail().substring(0, 1).toUpperCase();
            }
            request.setAttribute("firstLetterOfName", userFirstLetter);
            
            // Forward to the edit form
            request.getRequestDispatcher("/WEB-INF/view/admin-edit-campaign.jsp").forward(request, response);
        } catch (Exception e) {
            // Handle database errors
            request.setAttribute("error", "Failed to load campaign: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/view/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !user.isAdmin()) {
            // User not logged in or not an admin, redirect appropriately
            response.sendRedirect(request.getContextPath() + (user == null ? "/login" : "/access-denied"));
            return;
        }
        
        // Get campaign ID and other form data
        String campaignId = request.getParameter("campaign_id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String goalAmount = request.getParameter("goal_amount");
        String deadline = request.getParameter("deadline");
        String status = request.getParameter("status");
        String donationType = request.getParameter("donation_type");
        
        // Validate required fields
        if (campaignId == null || title == null || description == null || goalAmount == null || 
            deadline == null || status == null || donationType == null ||
            campaignId.isEmpty() || title.isEmpty() || description.isEmpty() || goalAmount.isEmpty() || 
            deadline.isEmpty() || status.isEmpty() || donationType.isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            doGet(request, response);
            return;
        }
        
        try {
            // Parse campaign ID
            int campaignIdInt = Integer.parseInt(campaignId);
            
            // Parse goal amount
            BigDecimal goalAmountDecimal = new BigDecimal(goalAmount);
            if (goalAmountDecimal.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("error", "Goal amount must be greater than zero");
                doGet(request, response);
                return;
            }
            
            // Parse deadline
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date deadlineDate = dateFormat.parse(deadline);
            
            // Get the existing campaign first
            try (java.sql.Connection conn = DatabaseConnection.getConnection()) {
                CampaignDAO campaignDAO = new CampaignDAO(conn);
                Campaign existingCampaign = campaignDAO.getCampaignById(campaignIdInt);
                
                if (existingCampaign == null) {
                    request.setAttribute("error", "Campaign not found");
                    doGet(request, response);
                    return;
                }
                
                // Update the campaign with new values
                existingCampaign.setTitle(title);
                existingCampaign.setDescription(description);
                existingCampaign.setGoal_amount(goalAmountDecimal);
                existingCampaign.setDeadline(deadlineDate);
                existingCampaign.setStatus(status);
                existingCampaign.setDonation_type(donationType);
                
                // Save the updated campaign
                boolean success = campaignDAO.updateCampaign(existingCampaign);
                if (success) {
                    // Set success message and redirect to admin campaigns
                    request.getSession().setAttribute("message", "Campaign updated successfully");
                    response.sendRedirect(request.getContextPath() + "/admin/campaigns");
                    return;
                } else {
                    request.setAttribute("error", "Failed to update campaign");
                    doGet(request, response);
                    return;
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format: " + e.getMessage());
            doGet(request, response);
        } catch (ParseException e) {
            request.setAttribute("error", "Invalid date format: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error updating campaign: " + e.getMessage());
            doGet(request, response);
        }
    }
} 