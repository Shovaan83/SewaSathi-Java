package model;

import java.util.Date;

public class ClothesDonation {
    private int donation_id;
    private int campaign_id;
    private int user_id;
    private String description;
    private String address;
    private String status;
    private Date donated_at;
    
    // Constructor
    public ClothesDonation(int donation_id, int campaign_id, int user_id, 
                         String description, String address, String status, Date donated_at) {
        this.donation_id = donation_id;
        this.campaign_id = campaign_id;
        this.user_id = user_id;
        this.description = description;
        this.address = address;
        this.status = status;
        this.donated_at = donated_at;
    }
    
    // Constructor for new donation (no ID yet)
    public ClothesDonation(int campaign_id, int user_id, 
                         String description, String address) {
        this.campaign_id = campaign_id;
        this.user_id = user_id;
        this.description = description;
        this.address = address;
        this.status = "pending";
    }
    
    // Getters and Setters
    public int getDonation_id() {
        return donation_id;
    }

    public void setDonation_id(int donation_id) {
        this.donation_id = donation_id;
    }

    public int getCampaign_id() {
        return campaign_id;
    }

    public void setCampaign_id(int campaign_id) {
        this.campaign_id = campaign_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDonated_at() {
        return donated_at;
    }

    public void setDonated_at(Date donated_at) {
        this.donated_at = donated_at;
    }
} 