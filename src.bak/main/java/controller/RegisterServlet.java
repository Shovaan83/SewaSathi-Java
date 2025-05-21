package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import model.UserDAO;
import model.Role;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "RegisterServlet", value = "/RegisterServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1 MB
        maxFileSize = 1024 * 1024 * 5,     // 5 MB
        maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Ensure CSRF token is set
        HttpSession session = request.getSession(true);
        if (session.getAttribute("csrfToken") == null) {
            String csrfToken = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", csrfToken);
            System.out.println("New CSRF token generated in RegisterServlet GET: " + csrfToken);
        } else {
            System.out.println("Existing CSRF token in RegisterServlet GET: " + session.getAttribute("csrfToken"));
        }
        
        // Get roles for the dropdown
        List<Role> roles = UserDAO.getAllRoles();
        request.setAttribute("roles", roles);
        
        // Redirect to the registration page
        request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String full_name = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Set role_id to 2 (regular user role) by default
        int role_id = 2; // Default to regular user role
        
        // Check if role_id is provided (this should only happen when an admin is creating a user)
        String roleIdParam = request.getParameter("role_id");
        if (roleIdParam != null && !roleIdParam.isEmpty()) {
            try {
                role_id = Integer.parseInt(roleIdParam);
            } catch (NumberFormatException e) {
                // Use default role (2) if parsing fails
            }
        }

        // Validation
        boolean hasError = false;
        String errorMessage = "";

        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            hasError = true;
            errorMessage = "Passwords do not match";
        }

        // If validation fails, redirect back to registration form with error
        if (hasError) {
            request.setAttribute("error", errorMessage);
            List<Role> roles = UserDAO.getAllRoles();
            request.setAttribute("roles", roles);
            request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
            return;
        }

        // Create user object
        User newUser;
        
        // Only allow admins to specify role_id
        // For regular user registration, use the default constructor that sets role_id to 2
        boolean isAdminCreation = false;
        if (request.getSession(false) != null && request.getSession(false).getAttribute("user") != null) {
            User currentUser = (User) request.getSession(false).getAttribute("user");
            isAdminCreation = currentUser.isAdmin();
        }
        
        if (isAdminCreation && roleIdParam != null && !roleIdParam.isEmpty()) {
            // Admin is creating a user with specified role_id
            newUser = new User(
                full_name,
                email,
                password,
                role_id
            );
        } else {
            // Regular registration, always use role_id 2
            newUser = new User(
                full_name,
                email,
                password
            );
        }

        // Add user to database
        int userId = UserDAO.addUser(newUser);

        if (userId > 0) {
            // Registration successful, redirect to login page with success message
            HttpSession session = request.getSession();
            session.setAttribute("registrationSuccess", "Registration successful! Please login.");
            
            // Ensure a valid CSRF token exists for the next page
            if (session.getAttribute("csrfToken") == null) {
                String csrfToken = UUID.randomUUID().toString();
                session.setAttribute("csrfToken", csrfToken);
                System.out.println("New CSRF token set after successful registration: " + csrfToken);
            }
            
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
        } else {
            // Registration failed, redirect back to registration form with error
            request.setAttribute("error", "Registration failed. Email may already be in use.");
            List<Role> roles = UserDAO.getAllRoles();
            request.setAttribute("roles", roles);
            request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
        }
    }
}