package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;
import model.DatabaseConnection;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.math.BigDecimal;

@WebServlet(name = "CampaignDetailServlet", value = {"/campaign", "/campaign-detail"})
public class CampaignDetailServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String campaignId = request.getParameter("id");
        String type = request.getParameter("type");
        
        if (campaignId == null || campaignId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/campaigns");
            return;
        }
        
        try {
            Connection conn = DatabaseConnection.getConnection();
            CampaignDAO campaignDAO = new CampaignDAO(conn);
            Campaign campaign = campaignDAO.getCampaignById(Integer.parseInt(campaignId));
            
            if (campaign == null) {
                response.sendRedirect(request.getContextPath() + "/campaigns");
                return;
            }
            
            // Get campaign statistics
            int totalDonations = 0;
            int daysLeft = 0;
            
            if ("clothes".equals(type)) {
                ClothesDonationDAO clothesDonationDAO = new ClothesDonationDAO(conn);
                totalDonations = clothesDonationDAO.getTotalClothesDonationsCount(campaign.getCampaign_id());
            } else {
                MonetaryDonationDAO monetaryDonationDAO = new MonetaryDonationDAO();
                BigDecimal totalAmount = monetaryDonationDAO.getTotalDonationAmountByCampaignId(campaign.getCampaign_id());
                totalDonations = (totalAmount != null) ? totalAmount.intValue() : 0;
            }
            
            // Calculate days left
            long currentTime = System.currentTimeMillis();
            long deadlineTime = campaign.getDeadline().getTime();
            daysLeft = (int) ((deadlineTime - currentTime) / (1000 * 60 * 60 * 24));
            
            // Set attributes
            request.setAttribute("campaign", campaign);
            request.setAttribute("totalDonations", totalDonations);
            request.setAttribute("daysLeft", daysLeft);
            
            // Forward to appropriate JSP
            if ("clothes".equals(type)) {
                request.getRequestDispatcher("/WEB-INF/view/clothes-campaign-detail.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/WEB-INF/view/campaign-detail.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/campaigns");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
} 