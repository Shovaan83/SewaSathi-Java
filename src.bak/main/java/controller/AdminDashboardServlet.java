package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import model.UserDAO;
import model.Campaign;
import model.CampaignDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/AdminDashboardServlet", "/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
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
            // User is not an admin, redirect to normal dashboard
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Get the action parameter (if any)
        String action = request.getParameter("action");
        int userId = 0;
        
        try {
            String userIdParam = request.getParameter("userId");
            if (userIdParam != null && !userIdParam.isEmpty()) {
                userId = Integer.parseInt(userIdParam);
            }
        } catch (NumberFormatException e) {
            // Invalid user ID, just continue
        }
        
        // Handle admin actions
        String message = null;
        if (action != null && userId > 0) {
            if (action.equals("delete")) {
                // Don't allow deleting self
                if (userId != user.getUser_id()) {
                    boolean success = UserDAO.deleteUserById(userId);
                    if (success) {
                        message = "User deleted successfully.";
                    } else {
                        message = "Failed to delete user.";
                    }
                } else {
                    message = "You cannot delete your own account.";
                }
            } else if (action.equals("toggleAdmin")) {
                // Don't allow changing own admin status
                if (userId != user.getUser_id()) {
                    // Toggle between admin (1) and regular user (2) roles
                    User targetUser = UserDAO.getUserById(userId);
                    int newRoleId = targetUser.getRole_id() == 1 ? 2 : 1;
                    boolean success = UserDAO.updateUserRole(userId, newRoleId);
                    if (success) {
                        message = "Admin status updated successfully.";
                    } else {
                        message = "Failed to update admin status.";
                    }
                } else {
                    message = "You cannot change your own admin status.";
                }
            }
        }
        
        // Get all users
        List<User> allUsers = UserDAO.getAllUsers();
        
        // Calculate admin count
        int adminCount = 0;
        for (User u : allUsers) {
            if (u.isAdmin()) {
                adminCount++;
            }
        }
        
        // Add first letter of name to each user for avatar display
        for (User u : allUsers) {
            String firstLetter = "";
            if (u.getFull_name() != null && !u.getFull_name().isEmpty()) {
                firstLetter = u.getFull_name().substring(0, 1).toUpperCase();
            } else {
                firstLetter = u.getEmail().substring(0, 1).toUpperCase();
            }
            request.setAttribute("firstLetterOf" + u.getUser_id(), firstLetter);
        }
        
        // Get total campaigns count (assuming you have CampaignDAO)
        int totalCampaigns = 0;
        List<Campaign> recentCampaigns = null;
        try {
            totalCampaigns = CampaignDAO.getTotalCampaignsCount();
            recentCampaigns = CampaignDAO.getRecentCampaigns(5); // Get 5 most recent campaigns
        } catch (Exception e) {
            // If CampaignDAO is not implemented yet, we'll just use 0 and empty list
            System.err.println("Error fetching campaign data: " + e.getMessage());
        }
        
        // Set attributes for the JSP
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("totalUsers", allUsers.size());
        request.setAttribute("adminCount", adminCount);
        request.setAttribute("totalCampaigns", totalCampaigns);
        request.setAttribute("recentCampaigns", recentCampaigns);
        
        // Set user's first letter for avatar
        String userFirstLetter = "";
        if (user.getFull_name() != null && !user.getFull_name().isEmpty()) {
            userFirstLetter = user.getFull_name().substring(0, 1).toUpperCase();
        } else {
            userFirstLetter = user.getEmail().substring(0, 1).toUpperCase();
        }
        request.setAttribute("firstLetterOfName", userFirstLetter);
        session.setAttribute("user", user);
        
        if (message != null) {
            request.setAttribute("message", message);
        }
        
        // Forward to the admin dashboard
        request.getRequestDispatcher("/WEB-INF/view/admin-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For simplicity, just redirect to doGet
        doGet(request, response);
    }
} 