package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Campaign;
import model.CampaignDAO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling campaign searches
 */
@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get search query parameter
        String query = request.getParameter("q");
        
        if (query != null && !query.trim().isEmpty()) {
            // Perform search
            List<Campaign> searchResults = CampaignDAO.searchCampaigns(query);
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("searchQuery", query);
        }
        
        // Forward to the search results page
        request.getRequestDispatcher("/WEB-INF/view/searchresults.jsp").forward(request, response);
    }
} 