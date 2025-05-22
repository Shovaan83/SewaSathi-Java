package controller;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import model.UserDAO;

import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "LoginServlet", value = "/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final String REMEMBER_ME_COOKIE_NAME = "rememberMe";
    private static final int COOKIE_MAX_AGE = 7 * 24 * 60 * 60; // 7 days in seconds

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Generate a CSRF token for the login form
        HttpSession session = request.getSession(true);
        
        // Ensure csrf token is set
        if (session.getAttribute("csrfToken") == null) {
            String csrfToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
            System.out.println("New CSRF token generated in LoginServlet GET: " + csrfToken);
        } else {
            System.out.println("Existing CSRF token in LoginServlet GET: " + session.getAttribute("csrfToken"));
        }
        
        // Check if user is already logged in via remember me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (REMEMBER_ME_COOKIE_NAME.equals(cookie.getName())) {
                    String[] credentials = decodeCookieValue(cookie.getValue());
                    if (credentials != null && credentials.length == 2) {
                        String email = credentials[0];
                        String password = credentials[1];
                        User user = UserDAO.getUserByEmail(email, password);
                        if (user != null) {
                            // Auto login successful - use existing session
                            session.setAttribute("user", user);
                            session.setAttribute("loggedIn", true);
                            session.setAttribute("isAdmin", user.isAdmin());
                            response.sendRedirect(request.getContextPath() + "/");
                            return;
                        }
                    }
                }
            }
        }

        // Check if there's a success message
        String registrationSuccess = (String) request.getSession().getAttribute("registrationSuccess");
        if (registrationSuccess != null) {
            request.setAttribute("registrationSuccess", registrationSuccess);
            // Remove the session attribute to prevent showing the message again
            request.getSession().removeAttribute("registrationSuccess");
        }

        // Redirect to the login.jsp page in WEB-INF/view directory
        request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Print debug info
        HttpSession session = request.getSession(false);
        if (session != null) {
            System.out.println("Session exists in LoginServlet POST. CSRF token: " + session.getAttribute("csrfToken"));
        } else {
            System.out.println("No session in LoginServlet POST");
            session = request.getSession(true);
        }
        
        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        User user = UserDAO.getUserByEmail(email, password);

        if (user != null) {
            // Authentication successful - use existing session
            
            // Store user in session
            session.setAttribute("user", user);
            session.setAttribute("loggedIn", true);
            session.setAttribute("isAdmin", user.isAdmin());
            
            // Create a new CSRF token
            String csrfToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
            System.out.println("New CSRF token set in LoginServlet POST after successful login: " + csrfToken);
            
            // Handle remember me functionality
            String rememberMe = request.getParameter("rememberMe");
            if (rememberMe != null && rememberMe.equals("on")) {
                String cookieValue = encodeCookieValue(email, password);
                Cookie rememberMeCookie = new Cookie(REMEMBER_ME_COOKIE_NAME, cookieValue);
                rememberMeCookie.setMaxAge(COOKIE_MAX_AGE);
                rememberMeCookie.setPath(request.getContextPath());
                response.addCookie(rememberMeCookie);
            }

            // Redirect based on role
            if (user.isAdmin()) {
                // Set a session attribute to indicate this is a direct admin login
                session.setAttribute("directAdminAccess", true);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
        } else {
            // Authentication failed
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/WEB-INF/view/login.jsp").forward(request, response);
        }
    }

    // Helper method to encode email and password for cookie
    private String encodeCookieValue(String email, String password) {
        // Simple encoding - in production, use more secure methods
        return email + ":"+password;
    }

    // Helper method to decode cookie value
    private String[] decodeCookieValue(String cookieValue) {
        // Simple decoding - in production, use more secure methods
        return cookieValue.split(":");
    }
}