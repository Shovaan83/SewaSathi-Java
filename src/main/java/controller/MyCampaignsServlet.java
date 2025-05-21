package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet(name = "MyCampaignsServlet", value = {"/MyCampaignsServlet", "/my-campaigns"})
public class MyCampaignsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            session.setAttribute("error", "You must be logged in to view your campaigns");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            CampaignDAO campaignDAO = new CampaignDAO(conn);
            List<Campaign> userCampaigns = campaignDAO.getCampaignsByUser(currentUser.getUser_id());
            
            request.setAttribute("campaigns", userCampaigns);
            request.getRequestDispatcher("/WEB-INF/view/my-campaigns.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error loading your campaigns: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
} 