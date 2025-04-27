package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.UUID;

/**
 * Debug servlet to check and regenerate CSRF tokens
 */
@WebServlet("/debug")
public class DebugServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(true);
        String csrfToken = (String) session.getAttribute("csrfToken");
        
        // If no CSRF token exists, generate one
        if (csrfToken == null) {
            csrfToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
        }
        
        out.println("<html><head><title>Debug CSRF Token</title></head><body>");
        out.println("<h1>Session and CSRF Token Information</h1>");
        out.println("<p>Session ID: " + session.getId() + "</p>");
        out.println("<p>CSRF Token: " + csrfToken + "</p>");
        out.println("<h2>Test Form</h2>");
        out.println("<form action=\"" + request.getContextPath() + "/debug\" method=\"post\">");
        out.println("<input type=\"hidden\" name=\"csrfToken\" value=\"" + csrfToken + "\">");
        out.println("<input type=\"submit\" value=\"Test CSRF Protection\">");
        out.println("</form>");
        out.println("<p><a href=\"" + request.getContextPath() + "\">Return to Home</a></p>");
        out.println("</body></html>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession(false);
        String sessionToken = session != null ? (String) session.getAttribute("csrfToken") : null;
        String requestToken = request.getParameter("csrfToken");
        
        out.println("<html><head><title>CSRF Test Result</title></head><body>");
        out.println("<h1>CSRF Token Validation</h1>");
        
        out.println("<p>Session Token: " + sessionToken + "</p>");
        out.println("<p>Request Token: " + requestToken + "</p>");
        
        if (sessionToken != null && requestToken != null && sessionToken.equals(requestToken)) {
            out.println("<p style=\"color: green\">SUCCESS: CSRF token validation passed!</p>");
        } else {
            out.println("<p style=\"color: red\">ERROR: CSRF token validation failed!</p>");
            if (sessionToken == null) {
                out.println("<p>Reason: No CSRF token in session</p>");
            } else if (requestToken == null) {
                out.println("<p>Reason: No CSRF token in request</p>");
            } else {
                out.println("<p>Reason: Tokens don't match</p>");
            }
        }
        
        out.println("<p><a href=\"" + request.getContextPath() + "/debug\">Try Again</a></p>");
        out.println("<p><a href=\"" + request.getContextPath() + "\">Return to Home</a></p>");
        out.println("</body></html>");
    }
} 