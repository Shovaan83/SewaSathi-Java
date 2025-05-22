<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donate Clothes - ${campaign.title}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/clothes-donation.css">
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<div class="clothes-donation-container">
    <div class="donation-header">
        <h1>Donate Clothes - ${campaign.title}</h1>
        <p>Your donated clothes can provide warmth and dignity to those in need</p>
    </div>

    <div class="donation-content">
        <div class="donation-info">
            <div class="info-card">
                <div class="info-icon">
                    <i class="fas fa-tshirt"></i>
                </div>
                <div class="info-text">
                    <h3>Campaign Details</h3>
                    <p>${campaign.description}</p>
                </div>
            </div>

            <div class="info-card">
                <div class="info-icon">
                    <i class="fas fa-hand-holding-heart"></i>
                </div>
                <div class="info-text">
                    <h3>How It Helps</h3>
                    <p>Your donated clothes will be distributed to:</p>
                    <ul>
                        <li>Homeless shelters</li>
                        <li>Disaster victims</li>
                        <li>Low-income families</li>
                        <li>Children's homes</li>
                        <li>Rural communities</li>
                    </ul>
                </div>
            </div>

            <div class="info-card">
                <div class="info-icon">
                    <i class="fas fa-truck"></i>
                </div>
                <div class="info-text">
                    <h3>Pickup Information</h3>
                    <p>We offer convenient pickup services:</p>
                    <ul>
                        <li>Schedule a pickup from your location</li>
                        <li>Flexible pickup times</li>
                        <li>Free pickup service</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="donation-form-container">
            <form action="${pageContext.request.contextPath}/clothes-donate" method="post" class="donation-form">
                <input type="hidden" name="campaignId" value="${campaign.campaign_id}">
                
                <div class="form-group">
                    <label for="description" class="required-label">Description of Donation</label>
                    <textarea id="description" name="description" class="form-control" rows="4" required 
                              placeholder="Please describe the clothes you are donating (e.g., type, quantity, condition)"></textarea>
                </div>
                
                <div class="form-group">
                    <label for="address" class="required-label">Pickup Address</label>
                    <textarea id="address" name="address" class="form-control" rows="3" required 
                              placeholder="Please provide your complete address for pickup"></textarea>
                </div>

                <div class="form-group checkbox-group terms-group">
                    <input type="checkbox" id="terms" name="terms" required>
                    <label for="terms">I confirm that all items are clean and in usable condition</label>
                </div>

                <div class="form-actions">
                    <button type="submit" class="donate-btn">
                        <i class="fas fa-tshirt"></i> Submit Donation
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/components/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const donationForm = document.querySelector('.donation-form');
        
        donationForm.addEventListener('submit', function(event) {
            const description = document.getElementById('description').value.trim();
            const address = document.getElementById('address').value.trim();
            
            if (!description || !address) {
                event.preventDefault();
                alert('Please fill in all required fields.');
            }
        });
    });
</script>
</body>
</html> 
