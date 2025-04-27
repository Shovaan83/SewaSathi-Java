package model;

public class User {
    // Instance variables based on new schema
    private int user_id;
    private String full_name;
    private String email;
    private String password;
    private int role_id;
    private String profile_picture_url;
    private String profile_picture_public_id;

    // Constructors

    // Constructor for registration
    public User(String full_name, String email, String password, int role_id) {
        this.full_name = full_name;
        this.email = email;
        this.password = password;
        this.role_id = role_id;
    }

    // Constructor with all fields except images
    public User(int user_id, String full_name, String email, String password, int role_id) {
        this.user_id = user_id;
        this.full_name = full_name;
        this.email = email;
        this.password = password;
        this.role_id = role_id;
    }

    // Constructor with all fields
    public User(int user_id, String full_name, String email, String password, int role_id, 
                String profile_picture_url, String profile_picture_public_id) {
        this.user_id = user_id;
        this.full_name = full_name;
        this.email = email;
        this.password = password;
        this.role_id = role_id;
        this.profile_picture_url = profile_picture_url;
        this.profile_picture_public_id = profile_picture_public_id;
    }
    
    // Getters and setters

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getFull_name() {
        return full_name;
    }

    public void setFull_name(String full_name) {
        this.full_name = full_name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getRole_id() {
        return role_id;
    }

    public void setRole_id(int role_id) {
        this.role_id = role_id;
    }

    public String getProfile_picture_url() {
        return profile_picture_url;
    }

    public void setProfile_picture_url(String profile_picture_url) {
        this.profile_picture_url = profile_picture_url;
    }

    public String getProfile_picture_public_id() {
        return profile_picture_public_id;
    }

    public void setProfile_picture_public_id(String profile_picture_public_id) {
        this.profile_picture_public_id = profile_picture_public_id;
    }

    // Helper method to check if user is admin
    public boolean isAdmin() {
        // Assuming role_id 1 is for admins, adjust as needed based on your roles setup
        return role_id == 1;
    }
}
