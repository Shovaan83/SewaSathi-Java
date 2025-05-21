package util;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 * Utility class for handling user sessions and cookies
 */
public class SessionUtil {
    private static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes
    private static final String REMEMBER_ME_COOKIE = "sewasathi_remember";
    private static final int REMEMBER_ME_EXPIRY = 30 * 24 * 60 * 60; // 30 days

    /**
     * Create a user session when they log in
     * 
     * @param request HTTP request
     * @param user User object
     * @param rememberMe Whether to create a remember-me cookie
     * @param response HTTP response for cookie creation
     */
    public static void createUserSession(HttpServletRequest request, User user, boolean rememberMe, HttpServletResponse response) {
        HttpSession session = request.getSession();
        
        // Store user in session
        session.setAttribute("user", user);
        
        // Set session timeout
        session.setMaxInactiveInterval(SESSION_TIMEOUT);
        
        // Create CSRF token
        String csrfToken = java.util.UUID.randomUUID().toString();
        session.setAttribute("csrfToken", csrfToken);
        
        // If remember me is checked, create a persistent cookie
        if (rememberMe) {
            // Create a secure token (in production, this should be a secure random token stored in the DB)
            String token = user.getUser_id() + ":" + java.util.UUID.randomUUID().toString();
            
            // Create remember-me cookie
            Cookie rememberMeCookie = new Cookie(REMEMBER_ME_COOKIE, token);
            rememberMeCookie.setMaxAge(REMEMBER_ME_EXPIRY);
            rememberMeCookie.setPath("/");
            rememberMeCookie.setHttpOnly(true); // Prevent JavaScript access
            
            // In production environment with HTTPS
            // rememberMeCookie.setSecure(true);
            
            response.addCookie(rememberMeCookie);
        }
    }
    
    /**
     * Invalidate user session on logout
     * 
     * @param request HTTP request
     * @param response HTTP response for cookie deletion
     */
    public static void invalidateUserSession(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            session.invalidate();
        }
        
        // Delete remember-me cookie if it exists
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_ME_COOKIE.equals(cookie.getName())) {
                    cookie.setMaxAge(0); // Delete cookie
                    cookie.setPath("/");
                    response.addCookie(cookie);
                    break;
                }
            }
        }
    }
    
    /**
     * Get the current logged-in user from session
     * 
     * @param request HTTP request
     * @return User object or null if not logged in
     */
    public static User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
    
    /**
     * Check if the user is authenticated
     * 
     * @param request HTTP request
     * @return true if authenticated, false otherwise
     */
    public static boolean isAuthenticated(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }
    
    /**
     * Check if the current user has admin role
     * 
     * @param request HTTP request
     * @return true if user is admin, false otherwise
     */
    public static boolean isAdmin(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null && user.isAdmin();
    }
} 