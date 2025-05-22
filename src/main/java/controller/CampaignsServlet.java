package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.math.BigDecimal;

@WebServlet(name = "CampaignsServlet", value = {"/CampaignsServlet", "/campaigns"})
public class CampaignsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = DatabaseConnection.getConnection()) {
            CampaignDAO campaignDAO = new CampaignDAO(conn);
            List<Campaign> campaigns = campaignDAO.getAllCampaignsForDisplay();
            
            // Calculate stats for each campaign
            for (Campaign campaign : campaigns) {
                // Set creator name
                String creatorName = campaignDAO.getCampaignCreatorName(campaign.getCampaign_id());
                campaign.setCreatorName(creatorName);

                if ("clothes".equals(campaign.getDonation_type())) {
                    ClothesDonationDAO clothesDonationDAO = new ClothesDonationDAO(conn);
                    int totalDonations = clothesDonationDAO.getTotalClothesDonationsCount(campaign.getCampaign_id());
                    campaign.setTotalDonations(totalDonations);
                } else {
                    MonetaryDonationDAO monetaryDonationDAO = new MonetaryDonationDAO();
                    BigDecimal collectedAmount = monetaryDonationDAO.getTotalDonationAmountByCampaignId(campaign.getCampaign_id());
                    campaign.setCollectedAmount(collectedAmount != null ? collectedAmount : BigDecimal.ZERO);
                }
            }
            
            request.setAttribute("campaigns", campaigns);
            request.getRequestDispatcher("/WEB-INF/view/campaigns.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
} 