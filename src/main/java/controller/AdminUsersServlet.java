package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import model.UserDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUsersServlet", value = "/AdminUsersServlet")
public class AdminUsersServlet extends HttpServlet {
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

        // Handle actions like delete or toggleAdmin
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
        
        // Set user's first letter for avatar
        String userFirstLetter = "";
        if (user.getFull_name() != null && !user.getFull_name().isEmpty()) {
            userFirstLetter = user.getFull_name().substring(0, 1).toUpperCase();
        } else {
            userFirstLetter = user.getEmail().substring(0, 1).toUpperCase();
        }
        request.setAttribute("firstLetterOfName", userFirstLetter);
        
        // Set attributes for the JSP
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("totalUsers", allUsers.size());
        request.setAttribute("adminCount", adminCount);
        
        if (message != null) {
            request.setAttribute("message", message);
        }
        
        // Forward to the admin users view
        request.getRequestDispatcher("/WEB-INF/view/admin-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // For now, just redirect to doGet
        doGet(request, response);
    }
} 