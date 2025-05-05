package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDonationsServlet", value = "/AdminDonationsServlet")
public class AdminDonationsServlet extends HttpServlet {
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

        // Handle actions like delete
        String action = request.getParameter("action");
        int donationId = 0;
        
        try {
            String donationIdParam = request.getParameter("donationId");
            if (donationIdParam != null && !donationIdParam.isEmpty()) {
                donationId = Integer.parseInt(donationIdParam);
            }
        } catch (NumberFormatException e) {
            // Invalid donation ID, just continue
        }
        
        // Handle admin actions
        String message = null;
        if (action != null && donationId > 0) {
            if (action.equals("delete")) {
                boolean success = MonetaryDonationDAO.deleteDonation(donationId);
                if (success) {
                    message = "Donation deleted successfully.";
                } else {
                    message = "Failed to delete donation.";
                }
            }
        }

        // Get all donations
        List<MonetaryDonation> allDonations = MonetaryDonationDAO.getAllDonations();
        
        // Calculate donation statistics
        double totalDonationAmount = 0;
        
        for (MonetaryDonation donation : allDonations) {
            if (donation.getAmount() != null) {
                totalDonationAmount += donation.getAmount().doubleValue();
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
        request.setAttribute("allDonations", allDonations);
        request.setAttribute("totalDonations", allDonations.size());
        request.setAttribute("totalDonationAmount", String.format("%.2f", totalDonationAmount));
        
        if (message != null) {
            request.setAttribute("message", message);
        }
        
        // Forward to the admin donations view
        request.getRequestDispatcher("/WEB-INF/view/admin-donations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For now, just redirect to doGet
        doGet(request, response);
    }
} 