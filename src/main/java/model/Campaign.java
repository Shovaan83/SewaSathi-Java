package model;

import java.math.BigDecimal;
import java.util.Date;

public class Campaign {
    private int campaign_id;
    private String title;
    private String description;
    private BigDecimal goal_amount;
    private Date deadline;
    private int created_by;
    private int category_id;
    private String campaign_image_url;
    private String campaign_image_public_id;
    private String status;
    private String donation_type;

    // Constructors
    public Campaign(int campaign_id, String title, String description, BigDecimal goal_amount, 
                  Date deadline, int created_by, int category_id, 
                  String campaign_image_url, String campaign_image_public_id, String status,
                  String donation_type) {
        this.campaign_id = campaign_id;
        this.title = title;
        this.description = description;
        this.goal_amount = goal_amount;
        this.deadline = deadline;
        this.created_by = created_by;
        this.category_id = category_id;
        this.campaign_image_url = campaign_image_url;
        this.campaign_image_public_id = campaign_image_public_id;
        this.status = status;
        this.donation_type = donation_type;
    }

    public Campaign(int campaign_id, String title, String description, BigDecimal goal_amount, 
                  Date deadline, int created_by, int category_id, 
                  String campaign_image_url, String campaign_image_public_id, String status) {
        this(campaign_id, title, description, goal_amount, deadline, created_by, category_id, 
             campaign_image_url, campaign_image_public_id, status, "monetary");
    }

    public Campaign(int campaign_id, String title, String description, BigDecimal goal_amount, 
                  Date deadline, int created_by, int category_id, String status) {
        this.campaign_id = campaign_id;
        this.title = title;
        this.description = description;
        this.goal_amount = goal_amount;
        this.deadline = deadline;
        this.created_by = created_by;
        this.category_id = category_id;
        this.status = status;
        this.donation_type = "monetary";
    }

    public Campaign(String title, String description, BigDecimal goal_amount, 
                  Date deadline, int created_by, int category_id) {
        this.title = title;
        this.description = description;
        this.goal_amount = goal_amount;
        this.deadline = deadline;
        this.created_by = created_by;
        this.category_id = category_id;
        this.status = "pending";
        this.donation_type = "monetary";
    }

    public Campaign(int campaignId, String title, String description, BigDecimal goalAmount, java.sql.Date deadline, int createdBy, int categoryId, String campaignImageUrl, String campaignImagePublicId) {
        this(campaignId, title, description, goalAmount, deadline, createdBy, categoryId, 
             campaignImageUrl, campaignImagePublicId, "pending", "monetary");
    }

    // Getters and Setters
    public int getCampaign_id() {
        return campaign_id;
    }

    public void setCampaign_id(int campaign_id) {
        this.campaign_id = campaign_id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getGoal_amount() {
        return goal_amount;
    }

    public void setGoal_amount(BigDecimal goal_amount) {
        this.goal_amount = goal_amount;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public int getCreated_by() {
        return created_by;
    }

    public void setCreated_by(int created_by) {
        this.created_by = created_by;
    }

    public int getCategory_id() {
        return category_id;
    }

    public void setCategory_id(int category_id) {
        this.category_id = category_id;
    }

    public String getCampaign_image_url() {
        return campaign_image_url;
    }

    public void setCampaign_image_url(String campaign_image_url) {
        this.campaign_image_url = campaign_image_url;
    }

    public String getCampaign_image_public_id() {
        return campaign_image_public_id;
    }

    public void setCampaign_image_public_id(String campaign_image_public_id) {
        this.campaign_image_public_id = campaign_image_public_id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDonation_type() {
        return donation_type;
    }

    public void setDonation_type(String donation_type) {
        this.donation_type = donation_type;
    }

    // Convenience getters for JSP
    public int getCampaignId() {
        return campaign_id;
    }

    public BigDecimal getGoalAmount() {
        return goal_amount;
    }

    public String getDonationType() {
        return donation_type;
    }
    
    public String getCampaignImageUrl() {
        return campaign_image_url;
    }
    
    public String getCampaignImagePublicId() {
        return campaign_image_public_id;
    }

    // Additional transient fields for JSP display
    private transient String creatorName;
    private transient int progressPercentage;
    private transient BigDecimal collectedAmount;
    private transient int totalDonations;
    
    public String getCreatorName() {
        return creatorName;
    }
    
    public void setCreatorName(String creatorName) {
        this.creatorName = creatorName;
    }
    
    public int getProgressPercentage() {
        return progressPercentage;
    }
    
    public void setProgressPercentage(int progressPercentage) {
        this.progressPercentage = progressPercentage;
    }
    
    public BigDecimal getCollectedAmount() {
        return collectedAmount;
    }
    
    public void setCollectedAmount(BigDecimal collectedAmount) {
        this.collectedAmount = collectedAmount;
    }

    public int getTotalDonations() {
        return totalDonations;
    }

    public void setTotalDonations(int totalDonations) {
        this.totalDonations = totalDonations;
    }
} 