package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    //Instance variables for database connection
    private static final String URL = "jdbc:mysql://localhost:3306/user_authentication";
    private static final String USER = "root";
    private static final String PASS = "";

    static{
        //Calling the driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("Failed to load MySQL driver: " + e.getMessage());
            throw new RuntimeException(e);
        }
    }
    //Method for database connection
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USER, PASS);
        } catch (SQLException e) {
            System.err.println("Database connection error: " + e.getMessage());
            throw e;
        }
    }
    //Method for storing user into database
    // Method to Add User to Database
    public static int addUser(User user) {
        String query = "INSERT INTO users (username, email, password, fullName, phone, address, profilePicture) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // Ensure password is hashed before inserting
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());

            // Handling Profile Picture (if not null)
            if (user.getProfilePicture() != null) {
                ps.setBytes(7, user.getProfilePicture()); // Store image as BLOB
            } else {
                ps.setNull(7, Types.BLOB); // If no image, set NULL
            }

            // Execute Update
            int affectedRows = ps.executeUpdate();

            // Retrieve Auto-Generated User ID (Optional)
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Return the new user ID
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Database Error in addUser: " + e.getMessage());
            e.printStackTrace();
        }
        return -1; // Return -1 if insertion fails
    }

    // Method to authenticate user
    public static User getUserByEmailOrUsername(String emailOrUsername, String password) {
        String query = "SELECT * FROM users WHERE (email = ? OR username = ?) AND password = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, emailOrUsername);
            ps.setString(2, emailOrUsername);
            ps.setString(3, password); // Ensure password is hashed before comparison

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getBytes("profilePicture"), // Binary image data
                        rs.getBoolean("isAdmin") // Get admin status
                );
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return null; // Return null if authentication fails
    }
    // Method to update user details
    public static boolean updateUser(User user) {
        String query = "UPDATE users SET password = ?, fullName = ?, phone = ?, address = ?, profilePicture = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, user.getPassword()); // Ensure password is hashed before storing
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAddress());

            // Handling Profile Picture
            if (user.getProfilePicture() != null) {
                ps.setBytes(5, user.getProfilePicture()); // Update image
            } else {
                ps.setNull(5, Types.BLOB); // If no new image, set NULL
            }

            ps.setInt(6, user.getId()); // WHERE condition (ensures ID remains unchanged)

            // Execute update and check if successful
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0; // Returns true if update was successful

        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return false; // Return false if update fails
    }

    // Method to update user password
    public static boolean updatePassword(int userId, String currentPassword, String newPassword) {
        // First verify the current password
        String verifyQuery = "SELECT password FROM users WHERE id = ?";
        String updateQuery = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement psVerify = conn.prepareStatement(verifyQuery);
             PreparedStatement psUpdate = conn.prepareStatement(updateQuery)) {

            // Verify current password
            psVerify.setInt(1, userId);
            ResultSet rs = psVerify.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                // If current password matches, update to new password
                if (storedPassword.equals(currentPassword)) {
                    psUpdate.setString(1, newPassword); // Should hash the password in a real application
                    psUpdate.setInt(2, userId);

                    int affectedRows = psUpdate.executeUpdate();
                    return affectedRows > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }

        return false; // Return false if password update fails
    }

    // Method to delete user by username/email and password
    public static boolean deleteUser(String emailOrUsername, String password) {
        String queryCheck = "SELECT id, password FROM users WHERE (email = ? OR username = ?)";
        String queryDelete = "DELETE FROM users WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement psCheck = conn.prepareStatement(queryCheck);
             PreparedStatement psDelete = conn.prepareStatement(queryDelete)) {

            // Step 1: Check if the username/email and password match
            psCheck.setString(1, emailOrUsername);
            psCheck.setString(2, emailOrUsername);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");
                String storedPassword = rs.getString("password"); // Get stored password

                if (!storedPassword.equals(password)) { // Compare passwords
                    System.out.println("Incorrect password. User deletion failed.");
                    return false;
                }

                // Step 2: If password matches, delete the user
                psDelete.setInt(1, userId);
                int affectedRows = psDelete.executeUpdate();
                return affectedRows > 0; // Returns true if deletion was successful
            } else {
                System.out.println("User not found with that username/email.");
                return false;
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return false; // Return false if deletion fails
    }

    // Method to retrieve all users
    public static List<User> getAllUsers() {
        String query = "SELECT * FROM users ORDER BY id";
        List<User> users = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("fullName"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getBytes("profilePicture"),
                    rs.getBoolean("isAdmin")
                );
                users.add(user);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving all users: " + e.getMessage());
        }
        return users;
    }
    
    // Method to get user by id
    public static User getUserById(int userId) {
        String query = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                    rs.getInt("id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("fullName"),
                    rs.getString("phone"),
                    rs.getString("address"),
                    rs.getBytes("profilePicture"),
                    rs.getBoolean("isAdmin")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving user by ID: " + e.getMessage());
        }
        return null;
    }
    
    // Method to delete user by id (for admin use)
    public static boolean deleteUserById(int userId) {
        String query = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, userId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting user by ID: " + e.getMessage());
            return false;
        }
    }

    // Method to toggle admin status
    public static boolean toggleAdminStatus(int userId) {
        String queryGet = "SELECT isAdmin FROM users WHERE id = ?";
        String queryUpdate = "UPDATE users SET isAdmin = ? WHERE id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement psGet = conn.prepareStatement(queryGet);
             PreparedStatement psUpdate = conn.prepareStatement(queryUpdate)) {
             
            psGet.setInt(1, userId);
            ResultSet rs = psGet.executeQuery();
            
            if (rs.next()) {
                boolean currentStatus = rs.getBoolean("isAdmin");
                
                // Toggle the status
                psUpdate.setBoolean(1, !currentStatus);
                psUpdate.setInt(2, userId);
                
                int affectedRows = psUpdate.executeUpdate();
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error toggling admin status: " + e.getMessage());
        }
        return false;
    }
}
