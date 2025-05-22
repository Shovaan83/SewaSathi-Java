package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

/**
 * Filter that restricts admin users from accessing regular user pages
 * and redirects them to the admin dashboard
 */
@WebFilter(filterName = "UserAuthorizationFilter", urlPatterns = {
        /* User-specific friendly URLs */
        "/dashboard", "/profile", "/create-campaign", "/edit-campaign", 
        "/my-campaigns", "/my-donations", "/account-settings",
        
        /* User-specific servlet URLs */
        "/UserProfileServlet", "/UpdateProfileServlet", "/ResetPasswordServlet",
        "/CreateCampaignServlet", "/EditCampaignServlet", "/MyCampaignsServlet",
        "/MyDonationsServlet", "/AccountSettingsServlet"
})
public class UserAuthorizationFilter implements Filter {
    
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
        
        // Get the requested URI to check if it's an admin path
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Skip this filter if path starts with /admin/ to avoid redirect loops
        if (path.startsWith("/admin/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Skip this filter for admin-specific servlets
        if (path.equals("/AdminDashboardServlet") || 
            path.equals("/AdminUsersServlet") || 
            path.equals("/AdminCampaignsServlet") || 
            path.equals("/AdminDonationsServlet")) {
            chain.doFilter(request, response);
            return;
        }
        
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        if (isLoggedIn) {
            User user = (User) session.getAttribute("user");
            boolean isAdmin = user.isAdmin();
            
            if (isAdmin) {
                // User is an admin, redirect to admin dashboard
                // Check if we're already redirecting to admin dashboard to prevent loop
                if (!path.equals("/admin/dashboard") && !path.equals("/AdminDashboardServlet")) {
                    httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/dashboard");
                    return;
                }
            }
        }
        
        // User is not an admin or not logged in, continue with the request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
} 