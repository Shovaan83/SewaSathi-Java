package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

/**
 * Filter that ensures only admin users can access admin pages
 */
@WebFilter(filterName = "AdminAuthorizationFilter", urlPatterns = {
    "/admin/*", 
    "/AdminDashboardServlet", 
    "/AdminUsersServlet", 
    "/AdminCampaignsServlet", 
    "/AdminDonationsServlet"
})
public class AdminAuthorizationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Exclude logout URL from admin authorization
        String requestPath = httpRequest.getServletPath();
        if (requestPath.equals("/admin/logout")) {
            chain.doFilter(request, response);
            return;
        }
        
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            // Check if user has admin role
            boolean isAdmin = user.isAdmin();
            
            if (isAdmin) {
                // If this was a direct admin login, clear the flag to prevent further issues
                if (session.getAttribute("directAdminAccess") != null) {
                    session.removeAttribute("directAdminAccess");
                }
                
                // User is an admin, continue with the request
                chain.doFilter(request, response);
                return;
            }
        }
        
        // User is not an admin or not logged in, redirect to access denied page
        httpResponse.sendRedirect(httpRequest.getContextPath() + "/access-denied");
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
} 