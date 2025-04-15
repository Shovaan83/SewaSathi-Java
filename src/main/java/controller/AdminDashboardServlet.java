package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import model.UserDAO;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", value = "/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
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
                if (userId != user.getId()) {
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
                if (userId != user.getId()) {
                    boolean success = UserDAO.toggleAdminStatus(userId);
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
        
        // Set attributes for the JSP
        request.setAttribute("users", allUsers);
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