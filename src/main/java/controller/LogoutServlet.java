package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/LogoutServlet", "/logout", "/admin/logout"})
public class LogoutServlet extends HttpServlet {
    private static final String REMEMBER_ME_COOKIE_NAME = "rememberMe";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if this is an admin logout
        String referer = request.getHeader("Referer");
        boolean isAdminLogout = request.getServletPath().contains("/admin/") || 
                               (referer != null && referer.contains("/admin/"));
        
        // Get the current session
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Remove user attribute
            session.removeAttribute("user");
            session.removeAttribute("loggedIn");

            // Invalidate the session
            session.invalidate();
        }

        // Clear the remember me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_ME_COOKIE_NAME.equals(cookie.getName())) {
                    cookie.setValue("");
                    cookie.setPath(request.getContextPath());
                    cookie.setMaxAge(0); // This will delete the cookie
                    response.addCookie(cookie);
                    break;
                }
            }
        }

        // Create a new session for the success message
        request.getSession().setAttribute("success", "You have been successfully logged out.");
        
        // Redirect to login page with a clean URL that won't be intercepted by filters
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Call doGet to handle post requests as well
        doGet(request, response);
    }
}