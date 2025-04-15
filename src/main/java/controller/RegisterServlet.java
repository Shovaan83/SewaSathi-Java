package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import model.UserDAO;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/RegisterServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1 MB
        maxFileSize = 1024 * 1024 * 5,     // 5 MB
        maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Redirect to the registration page
        request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

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
            request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
            return;
        }

        // Create user object - pass null for profilePicture
        User newUser = new User(
                username,
                email,
                password,
                fullName,
                phone,
                address,
                null  // No profile picture during registration
        );

        // Add user to database
        int userId = UserDAO.addUser(newUser);

        if (userId > 0) {
            // Registration successful, redirect to login page with success message
            request.getSession().setAttribute("registrationSuccess", "Registration successful! Please login.");
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
        } else {
            // Registration failed, redirect back to registration form with error
            request.setAttribute("error", "Registration failed. Username or email may already be in use.");
            request.getRequestDispatcher("/WEB-INF/view/register.jsp").forward(request, response);
        }
    }
}