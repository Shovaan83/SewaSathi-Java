-- Create Database
CREATE DATABASE SewaSathiDB;
USE SewaSathiDB;

-- Roles table
CREATE TABLE Roles (
                       role_id INT AUTO_INCREMENT PRIMARY KEY,
                       role_name VARCHAR(50) NOT NULL
);

-- Users table
CREATE TABLE Users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       full_name VARCHAR(100),
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       role_id INT,
                       profile_picture_url VARCHAR(255),
                       profile_picture_public_id VARCHAR(100),
                       FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- Campaign categories
CREATE TABLE CampaignCategories (
                                    category_id INT AUTO_INCREMENT PRIMARY KEY,
                                    category_name VARCHAR(100)
);

-- Campaigns table
CREATE TABLE Campaigns (
                           campaign_id INT AUTO_INCREMENT PRIMARY KEY,
                           title VARCHAR(255),
                           description TEXT,
                           goal_amount DECIMAL(10,2),
                           deadline DATE,
                           created_by INT,
                           category_id INT,
                           campaign_image_url VARCHAR(255),
                           campaign_image_public_id VARCHAR(100),
                           FOREIGN KEY (created_by) REFERENCES Users(user_id),
                           FOREIGN KEY (category_id) REFERENCES CampaignCategories(category_id)
);

-- Campaign images
CREATE TABLE CampaignImages (
                                image_id INT AUTO_INCREMENT PRIMARY KEY,
                                campaign_id INT,
                                image_url VARCHAR(255),
                                public_id VARCHAR(100),
                                uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

-- Clothing Donations
CREATE TABLE ClothingDonations (
                                   donation_id INT AUTO_INCREMENT PRIMARY KEY,
                                   user_id INT,
                                   campaign_id INT,
                                   description TEXT,
                                   address VARCHAR(255),
                                   status ENUM('pending', 'picked_up', 'rejected') DEFAULT 'pending',
                                   donated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   FOREIGN KEY (user_id) REFERENCES Users(user_id),
                                   FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

-- Images for Clothing Donations
CREATE TABLE ClothingDonationImages (
                                        image_id INT AUTO_INCREMENT PRIMARY KEY,
                                        donation_id INT,
                                        image_url VARCHAR(255),
                                        public_id VARCHAR(100),
                                        uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        FOREIGN KEY (donation_id) REFERENCES ClothingDonations(donation_id)
);

-- Monetary Donations
CREATE TABLE MonetaryDonations (
    donation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    campaign_id INT,
    amount DECIMAL(10,2),
    transaction_id VARCHAR(100),
    donation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (campaign_id) REFERENCES Campaigns(campaign_id)
);

-- Images for Monetary Donations (e.g. receipt)
CREATE TABLE MonetaryDonationImages (
                                        image_id INT AUTO_INCREMENT PRIMARY KEY,
                                        donation_id INT,
                                        image_url VARCHAR(255),
                                        public_id VARCHAR(100),
                                        uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                        FOREIGN KEY (donation_id) REFERENCES MonetaryDonations(donation_id)
);

-- Donation Tracking for Clothing Donations
CREATE TABLE DonationTracking (
                                  tracking_id INT AUTO_INCREMENT PRIMARY KEY,
                                  donation_id INT,
                                  status ENUM('pending', 'picked_up', 'delivered', 'cancelled') DEFAULT 'pending',
                                  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                  FOREIGN KEY (donation_id) REFERENCES ClothingDonations(donation_id)
);
