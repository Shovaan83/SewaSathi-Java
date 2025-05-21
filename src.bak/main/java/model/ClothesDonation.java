package model;

import java.util.Date;

public class ClothesDonation {
    private int donation_id;
    private int campaign_id;
    private int user_id;
    private String clothes_type;
    private int quantity;
    private String size;
    private String condition;
    private String pickup_address;
    private Date pickup_date;
    private String status;
    private Date created_at;
    
    // Constructor
    public ClothesDonation(int donation_id, int campaign_id, int user_id, String clothes_type, 
                         int quantity, String size, String condition, String pickup_address,
                         Date pickup_date, String status, Date created_at) {
        this.donation_id = donation_id;
        this.campaign_id = campaign_id;
        this.user_id = user_id;
        this.clothes_type = clothes_type;
        this.quantity = quantity;
        this.size = size;
        this.condition = condition;
        this.pickup_address = pickup_address;
        this.pickup_date = pickup_date;
        this.status = status;
        this.created_at = created_at;
    }
    
    // Constructor for new donation (no ID yet)
    public ClothesDonation(int campaign_id, int user_id, String clothes_type, 
                         int quantity, String size, String condition, String pickup_address,
                         Date pickup_date) {
        this.campaign_id = campaign_id;
        this.user_id = user_id;
        this.clothes_type = clothes_type;
        this.quantity = quantity;
        this.size = size;
        this.condition = condition;
        this.pickup_address = pickup_address;
        this.pickup_date = pickup_date;
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

    public String getClothes_type() {
        return clothes_type;
    }

    public void setClothes_type(String clothes_type) {
        this.clothes_type = clothes_type;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getPickup_address() {
        return pickup_address;
    }

    public void setPickup_address(String pickup_address) {
        this.pickup_address = pickup_address;
    }

    public Date getPickup_date() {
        return pickup_date;
    }

    public void setPickup_date(Date pickup_date) {
        this.pickup_date = pickup_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Date created_at) {
        this.created_at = created_at;
    }
} 