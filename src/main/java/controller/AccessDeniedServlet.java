package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet that handles requests to the access denied page
 */
@WebServlet("/access-denied")
public class AccessDeniedServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Set HTTP status code to 403 Forbidden
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        
        // Forward to the access denied JSP page
        request.getRequestDispatcher("/WEB-INF/view/access-denied.jsp").forward(request, response);
    }
} 