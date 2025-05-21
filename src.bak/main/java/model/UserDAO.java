package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    //Instance variables for database connection
    private static final String URL = "jdbc:mysql://localhost:3306/sewasathidb";
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
        String query = "INSERT INTO users (full_name, email, password, role_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getFull_name());
            ps.setString(2, user.getEmail());
            
            // Hash the password before storing it
            String hashedPassword = util.PasswordUtil.hashPassword(user.getPassword());
            ps.setString(3, hashedPassword);
            
            ps.setInt(4, user.getRole_id());

            // Execute Update
            int affectedRows = ps.executeUpdate();

            // Retrieve Auto-Generated User ID
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
    public static User getUserByEmail(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Get the stored hash
                String storedHash = rs.getString("password");
                
                // Verify the password
                if (util.PasswordUtil.verifyPassword(password, storedHash)) {
                    return new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            storedHash, // Don't expose the actual hash, but we need it for the User object
                            rs.getInt("role_id"),
                            rs.getString("profile_picture_url"),
                            rs.getString("profile_picture_public_id")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return null; // Return null if authentication fails
    }
    
    // Method to update user details
    public static boolean updateUser(User user) {
        String query = "UPDATE users SET full_name = ?, password = ?, role_id = ?, profile_picture_url = ?, profile_picture_public_id = ? WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, user.getFull_name());
            
            // Check if the password is already hashed (contains :)
            String password = user.getPassword();
            if (!password.contains(":")) {
                // Hash the password before storing it
                password = util.PasswordUtil.hashPassword(password);
            }
            ps.setString(2, password);
            
            ps.setInt(3, user.getRole_id());
            ps.setString(4, user.getProfile_picture_url());
            ps.setString(5, user.getProfile_picture_public_id());
            ps.setInt(6, user.getUser_id()); // WHERE condition

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
        String verifyQuery = "SELECT password FROM users WHERE user_id = ?";
        String updateQuery = "UPDATE users SET password = ? WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement psVerify = conn.prepareStatement(verifyQuery);
             PreparedStatement psUpdate = conn.prepareStatement(updateQuery)) {

            // Verify current password
            psVerify.setInt(1, userId);
            ResultSet rs = psVerify.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");

                // Verify the current password
                if (util.PasswordUtil.verifyPassword(currentPassword, storedHash)) {
                    // Hash the new password
                    String newHash = util.PasswordUtil.hashPassword(newPassword);
                    psUpdate.setString(1, newHash);
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

    // Method to delete user by email and password
    public static boolean deleteUser(String email, String password) {
        String queryCheck = "SELECT user_id, password FROM users WHERE email = ?";
        String queryDelete = "DELETE FROM users WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement psCheck = conn.prepareStatement(queryCheck);
             PreparedStatement psDelete = conn.prepareStatement(queryDelete)) {

            // Step 1: Check if the email and password match
            psCheck.setString(1, email);
            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("user_id");
                String storedHash = rs.getString("password"); // Get stored hash

                // Verify password
                if (!util.PasswordUtil.verifyPassword(password, storedHash)) {
                    System.out.println("Incorrect password. User deletion failed.");
                    return false;
                }

                // Step 2: If password matches, delete the user
                psDelete.setInt(1, userId);
                int affectedRows = psDelete.executeUpdate();
                return affectedRows > 0; // Returns true if deletion was successful
            } else {
                System.out.println("User not found with that email.");
                return false;
            }

        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return false; // Return false if deletion fails
    }

    // Method to retrieve all users
    public static List<User> getAllUsers() {
        String query = "SELECT * FROM Users ORDER BY user_id";
        List<User> users = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User(
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getInt("role_id"),
                    rs.getString("profile_picture_url"),
                    rs.getString("profile_picture_public_id")
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
        String query = "SELECT * FROM users WHERE user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
             
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getInt("role_id"),
                    rs.getString("profile_picture_url"),
                    rs.getString("profile_picture_public_id")
                );
            }
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return null;
    }
    
    // Method to delete user by ID
    public static boolean deleteUserById(int userId) {
        String query = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, userId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return false;
    }
    
    // Method to update role of a user
    public static boolean updateUserRole(int userId, int roleId) {
        String query = "UPDATE users SET role_id = ? WHERE user_id = ?";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, roleId);
            ps.setInt(2, userId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        } catch (SQLException e) {
            System.err.println(e.getMessage());
        }
        return false;
    }
    
    // Method to get available roles
    public static List<Role> getAllRoles() {
        String query = "SELECT * FROM Roles ORDER BY role_id";
        List<Role> roles = new ArrayList<>();
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Role role = new Role(
                    rs.getInt("role_id"),
                    rs.getString("role_name")
                );
                roles.add(role);
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving roles: " + e.getMessage());
        }
        return roles;
    }
}
