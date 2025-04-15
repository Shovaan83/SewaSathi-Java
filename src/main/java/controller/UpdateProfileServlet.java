package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.User;
import model.UserDAO;

import java.io.IOException;
import java.io.InputStream;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.io.ByteArrayOutputStream;

@WebServlet(name = "UpdateProfileServlet", value = "/UpdateProfileServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,  // 1 MB
        maxFileSize = 1024 * 1024 * 5,     // 5 MB
        maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class UpdateProfileServlet extends HttpServlet {
    private static final int MAX_IMAGE_WIDTH = 800;
    private static final int MAX_IMAGE_HEIGHT = 800;
    private static final int MAX_IMAGE_SIZE_BYTES = 900 * 1024; // 900KB

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // User not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Forward to the profile update form
        request.getRequestDispatcher("/WEB-INF/view/editprofile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        // Get form parameters
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        Part filePart = request.getPart("profilePicture");
        String password = request.getParameter("password");

        // Validate password - simplified validation since PasswordHasher is not available
        if (!password.equals(currentUser.getPassword())) {
            request.setAttribute("error", "Incorrect password. Profile not updated.");
            request.getRequestDispatcher("/WEB-INF/view/editprofile.jsp").forward(request, response);
            return;
        }

        // If username is changed, check if it's already taken
        if (!username.equals(currentUser.getUsername())) {
            // Using the correct method signature with password parameter
            User existingUser = UserDAO.getUserByEmailOrUsername(username, password);
            if (existingUser != null && existingUser.getId() != currentUser.getId()) {
                request.setAttribute("error", "Username already exists. Choose a different username.");
                request.getRequestDispatcher("/WEB-INF/view/editprofile.jsp").forward(request, response);
                return;
            }
        }

        // If email is changed, check if it's already taken
        if (!email.equals(currentUser.getEmail())) {
            // Using the correct method signature with password parameter
            User existingUser = UserDAO.getUserByEmailOrUsername(email, password);
            if (existingUser != null && existingUser.getId() != currentUser.getId()) {
                request.setAttribute("error", "Email already exists. Choose a different email.");
                request.getRequestDispatcher("/WEB-INF/view/editprofile.jsp").forward(request, response);
                return;
            }
        }

        // Process profile picture if provided
        byte[] profilePicture = currentUser.getProfilePicture();
        if (filePart != null && filePart.getSize() > 0) {
            try (InputStream fileContent = filePart.getInputStream()) {
                profilePicture = new byte[(int) filePart.getSize()];
                fileContent.read(profilePicture);
            }
        }

        // Create updated user object
        User updatedUser = new User(
                currentUser.getId(),
                username,
                email,
                currentUser.getPassword(),
                fullName,
                phone,
                address,
                profilePicture,
                currentUser.isAdmin()
        );

        // Update user in database
        boolean updateSuccess = UserDAO.updateUser(updatedUser);

        if (updateSuccess) {
            // Update session with new user data
            session.setAttribute("user", updatedUser);
            request.setAttribute("success", "Profile updated successfully!");
            response.sendRedirect(request.getContextPath() + "/UserProfileServlet?success=Profile updated successfully!");
        } else {
            request.setAttribute("error", "Failed to update profile. Please try again.");
            request.getRequestDispatcher("/WEB-INF/view/editprofile.jsp").forward(request, response);
        }
    }
    
    // Helper method to resize image
    private BufferedImage resizeImage(BufferedImage originalImage) {
        int originalWidth = originalImage.getWidth();
        int originalHeight = originalImage.getHeight();
        
        // Calculate new dimensions while maintaining aspect ratio
        int newWidth = originalWidth;
        int newHeight = originalHeight;
        
        // Scale down if the image is too large
        if (originalWidth > MAX_IMAGE_WIDTH || originalHeight > MAX_IMAGE_HEIGHT) {
            if (originalWidth > originalHeight) {
                newWidth = MAX_IMAGE_WIDTH;
                newHeight = (int) (originalHeight * ((double) MAX_IMAGE_WIDTH / originalWidth));
            } else {
                newHeight = MAX_IMAGE_HEIGHT;
                newWidth = (int) (originalWidth * ((double) MAX_IMAGE_HEIGHT / originalHeight));
            }
        }
        
        // Create the resized image
        BufferedImage resizedImage = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = resizedImage.createGraphics();
        g.drawImage(originalImage.getScaledInstance(newWidth, newHeight, Image.SCALE_SMOOTH), 0, 0, null);
        g.dispose();
        
        return resizedImage;
    }
    
    // Helper method to determine image format from filename
    private String getImageFormat(String fileName) {
        if (fileName == null) {
            return "jpeg"; // Default format
        }
        String lowerCaseFileName = fileName.toLowerCase();
        if (lowerCaseFileName.endsWith(".png")) {
            return "png";
        } else if (lowerCaseFileName.endsWith(".gif")) {
            return "gif";
        } else {
            return "jpeg"; // Default to JPEG for jpg, jpeg, or any other format
        }
    }
}