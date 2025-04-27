package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

/**
 * Filter that checks if user is authenticated for protected pages
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
        "/dashboard", "/profile", "/create-campaign", "/edit-campaign", 
        "/my-campaigns", "/my-donations", "/account-settings", "/admin/*"
})
public class AuthenticationFilter implements Filter {
    
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
        
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        String requestURI = httpRequest.getRequestURI();
        
        if (isLoggedIn) {
            // Add a header for CSRF protection
            if (session.getAttribute("csrfToken") == null) {
                String csrfToken = generateCSRFToken();
                session.setAttribute("csrfToken", csrfToken);
            }
            
            // User is logged in, continue with the request
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            // Save the requested URL for redirect after login
            httpRequest.getSession().setAttribute("redirectURL", requestURI);
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
    
    /**
     * Generate a random token for CSRF protection
     */
    private String generateCSRFToken() {
        return java.util.UUID.randomUUID().toString();
    }
} 