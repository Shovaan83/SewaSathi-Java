package controller;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Campaign;
import model.CampaignDAO;

@WebServlet("/campaign-search")
public class SearchCampaignServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("q");
        
        if (query != null && !query.trim().isEmpty()) {
            List<Campaign> searchResults = CampaignDAO.searchCampaigns(query);
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("searchQuery", query);
        }
        
        request.getRequestDispatcher("/WEB-INF/view/searchresults.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
} 