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
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                CampaignDAO campaignDAO = new CampaignDAO(conn);
                Campaign campaign = campaignDAO.getCampaignById(campaignId);
                
                if (campaign == null) {
                    request.setAttribute("error", "Campaign not found");
                    request.getRequestDispatcher("/campaigns").forward(request, response);
                    return;
                }
                
                // Check if campaign accepts clothes donations
                if (!"clothes".equals(campaign.getDonation_type())) {
                    request.setAttribute("error", "This campaign does not accept clothes donations");
                    request.getRequestDispatcher("/campaign?id=" + campaignId).forward(request, response);
                    return;
                }
                
                // Set campaign in request for the donation form
                request.setAttribute("campaign", campaign);
                
                // Forward to the clothes donation form
                request.getRequestDispatcher("/WEB-INF/view/clothes-donate.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid campaign ID");
            request.getRequestDispatcher("/campaigns").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/campaigns").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            session.setAttribute("error", "You must be logged in to donate clothes");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        // Extract form data
        String campaignIdStr = request.getParameter("campaignId");
        String clothesType = request.getParameter("clothesType");
        String quantityStr = request.getParameter("quantity");
        String size = request.getParameter("size");
        String condition = request.getParameter("condition");
        String pickupAddress = request.getParameter("pickupAddress");
        String pickupDateStr = request.getParameter("pickupDate");
        
        // Validate form data
        if (campaignIdStr == null || campaignIdStr.trim().isEmpty() ||
            clothesType == null || clothesType.trim().isEmpty() ||
            quantityStr == null || quantityStr.trim().isEmpty() ||
            size == null || size.trim().isEmpty() ||
            condition == null || condition.trim().isEmpty() ||
            pickupAddress == null || pickupAddress.trim().isEmpty() ||
            pickupDateStr == null || pickupDateStr.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            doGet(request, response);
            return;
        }
        
        try {
            int campaignId = Integer.parseInt(campaignIdStr);
            int quantity = Integer.parseInt(quantityStr);
            
            if (quantity <= 0) {
                request.setAttribute("error", "Quantity must be greater than zero");
                doGet(request, response);
                return;
            }
            
            // Parse pickup date
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date pickupDate = dateFormat.parse(pickupDateStr);
            
            // Check if pickup date is in the future
            Date today = new Date();
            if (pickupDate.before(today)) {
                request.setAttribute("error", "Pickup date must be in the future");
                doGet(request, response);
                return;
            }
            
            try (Connection conn = DatabaseConnection.getConnection()) {
                // Create clothes donation object
                ClothesDonation donation = new ClothesDonation(
                    campaignId,
                    currentUser.getUser_id(),
                    clothesType,
                    quantity,
                    size,
                    condition,
                    pickupAddress,
                    pickupDate
                );
                
                // Save to database
                ClothesDonationDAO donationDAO = new ClothesDonationDAO(conn);
                boolean success = donationDAO.addClothesDonation(donation);
                
                if (success) {
                    session.setAttribute("success", "Thank you for your donation! We will contact you to arrange the pickup.");
                    response.sendRedirect(request.getContextPath() + "/campaign?id=" + campaignId);
                } else {
                    request.setAttribute("error", "Failed to process your donation. Please try again.");
                    doGet(request, response);
                }
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Please enter valid numbers");
            doGet(request, response);
        } catch (ParseException e) {
            request.setAttribute("error", "Please enter a valid date format (YYYY-MM-DD)");
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error processing donation: " + e.getMessage());
            doGet(request, response);
        }
    }
} 