package model;

import java.math.BigDecimal;
import java.util.Date;

public class MonetaryDonation {
    private int donation_id;
    private int campaign_id;
    private int user_id;
    private BigDecimal amount;
    private String payment_method;
    private String transaction_id;
    private Date donation_date;
    
    // Transient properties for UI display
    private transient String campaignTitle;
    private transient String donorName;
    
    // Constructors
    public MonetaryDonation(int donation_id, int campaign_id, int user_id, BigDecimal amount, 
                          String payment_method, String transaction_id, Date donation_date) {
        this.donation_id = donation_id;
        this.campaign_id = campaign_id;
        this.user_id = user_id;
        this.amount = amount;
        this.payment_method = payment_method;
        this.transaction_id = transaction_id;
        this.donation_date = donation_date;
    }
    
    public MonetaryDonation(int campaign_id, int user_id, BigDecimal amount, 
                          String payment_method, String transaction_id) {
        this.campaign_id = campaign_id;
        this.user_id = user_id;
        this.amount = amount;
        this.payment_method = payment_method;
        this.transaction_id = transaction_id;
        this.donation_date = new Date(); // Current date
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
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getPayment_method() {
        return payment_method;
    }
    
    public void setPayment_method(String payment_method) {
        this.payment_method = payment_method;
    }
    
    public String getTransaction_id() {
        return transaction_id;
    }
    
    public void setTransaction_id(String transaction_id) {
        this.transaction_id = transaction_id;
    }
    
    public Date getDonation_date() {
        return donation_date;
    }
    
    public void setDonation_date(Date donation_date) {
        this.donation_date = donation_date;
    }
    
    // Getters and setters for transient properties
    public String getCampaignTitle() {
        return campaignTitle;
    }
    
    public void setCampaignTitle(String campaignTitle) {
        this.campaignTitle = campaignTitle;
    }
    
    public String getDonorName() {
        return donorName;
    }
    
    public void setDonorName(String donorName) {
        this.donorName = donorName;
    }
    
    // Convenience methods for JSP
    public int getDonationId() {
        return donation_id;
    }
    
    public int getCampaignId() {
        return campaign_id;
    }
    
    public int getUserId() {
        return user_id;
    }
}
