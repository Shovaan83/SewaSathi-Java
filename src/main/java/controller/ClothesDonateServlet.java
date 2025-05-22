package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;

import java.io.IOException;
import java.sql.Connection;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "ClothesDonateServlet", value = {"/ClothesDonateServlet", "/clothes-donate", "/clothesdonation"})
public class ClothesDonateServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is coming from the general clothes donation page
        String path = request.getServletPath();
        if (path.equals("/clothesdonation")) {
            request.getRequestDispatcher("/WEB-INF/view/clothesdonation.jsp").forward(request, response);
            return;
        }
        
        if (currentUser == null) {
            session.setAttribute("error", "You must be logged in to donate clothes");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        String campaignIdStr = request.getParameter("campaignId");
        if (campaignIdStr == null || campaignIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Campaign ID is required");
            request.getRequestDispatcher("/campaigns").forward(request, response);
            return;
        }
        
        try {
            int campaignId = Integer.parseInt(campaignIdStr);
            
            // Get campaign details
            try (Connection conn = DatabaseConnection.getConnection()) {
                CampaignDAO campaignDAO = new CampaignDAO(conn);
                Campaign campaign = campaignDAO.getCampaignById(campaignId);
                
                if (campaign == null) {
                    request.setAttribute("error", "Campaign not found");
                    request.getRequestDispatcher("/campaigns").forward(request, response);
                    return;
                }
                
                request.setAttribute("campaign", campaign);
                request.getRequestDispatcher("/WEB-INF/view/clothes-donate.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid campaign ID");
            request.getRequestDispatcher("/campaigns").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading campaign: " + e.getMessage());
            request.getRequestDispatcher("/campaigns").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String campaignId = request.getParameter("campaignId");
        String description = request.getParameter("description");
        String address = request.getParameter("address");

        if (campaignId == null || description == null || address == null || 
            campaignId.trim().isEmpty() || description.trim().isEmpty() || address.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/WEB-INF/view/clothes-donate.jsp").forward(request, response);
            return;
        }

        try {
            CampaignDAO campaignDAO = new CampaignDAO(DatabaseConnection.getConnection());
            Campaign campaign = campaignDAO.getCampaignById(Integer.parseInt(campaignId));
            
            if (campaign == null) {
                request.setAttribute("error", "Campaign not found");
                request.getRequestDispatcher("/WEB-INF/view/clothes-donate.jsp").forward(request, response);
                return;
            }

            ClothesDonationDAO clothesDonationDAO = new ClothesDonationDAO(DatabaseConnection.getConnection());
            ClothesDonation donation = new ClothesDonation(
                Integer.parseInt(campaignId),
                user.getUser_id(),
                description,
                address
            );

            boolean success = clothesDonationDAO.addClothesDonation(donation);
            
            if (success) {
                // Set success message and redirect to campaign detail page
                session.setAttribute("successMessage", "Thank you for your donation! We will contact you shortly to arrange pickup.");
                response.sendRedirect(request.getContextPath() + "/campaign-detail?id=" + campaignId + "&type=clothes");
            } else {
                request.setAttribute("error", "Failed to process donation. Please try again.");
                request.getRequestDispatcher("/WEB-INF/view/clothes-donate.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("/WEB-INF/view/clothes-donate.jsp").forward(request, response);
        }
    }
} 