<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make a Donation - SewaSathi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/monetary-donation.css">
    <style>
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            text-align: center;
        }
        .alert {
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1.5rem;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            border-radius: 5px;
            transition: all 0.3s;
            border: none;
            font-size: 1rem;
        }
        .btn-primary {
            background-color: #ff6b6b;
            color: white;
        }
        .btn-primary:hover {
            background-color: #ff5252;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<div class="donation-container">
    <div class="donation-header">
        <h1>Make a Donation</h1>
        <p>Your generosity makes a difference in someone's life</p>
    </div>

    <c:if test="${not empty error}">
        <div class="error-message alert alert-danger">
            ${error}
        </div>
        <div style="text-align: center; margin: 20px 0;">
            <a href="${pageContext.request.contextPath}/campaigns" class="btn btn-primary">View All Campaigns</a>
        </div>
    </c:if>
    
    <c:if test="${not empty campaign}">
        <div class="donation-content">
            <div class="campaign-details">
                <div class="campaign-image">
                    <c:choose>
                        <c:when test="${not empty campaign.campaign_image_url}">
                            <img src="${campaign.campaign_image_url}" alt="${campaign.title}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/img/default-campaign.jpg" alt="${campaign.title}">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="campaign-info">
                    <h2>${campaign.title}</h2>
                    <p class="campaign-creator">By ${campaign.creatorName}</p>
                    <div class="progress-container">
                        <div class="progress-bar">
                            <div class="progress" style="width:${campaign.progressPercentage}%"></div>
                        </div>
                        <div class="progress-stats">
                            <span class="raised">NPR <fmt:formatNumber value="${campaign.collectedAmount}" type="number" pattern="#,##0.00" /></span>
                            <span class="goal">of NPR <fmt:formatNumber value="${campaign.goal_amount}" type="number" pattern="#,##0.00" /></span>
                            <span class="percentage">${campaign.progressPercentage}%</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="donation-form-container">
                <form method="post" class="donation-form" id="donationForm">
                    <input type="hidden" name="campaignId" value="${campaign.campaign_id}">

                    <div class="form-group">
                        <label for="amount">Donation Amount (NPR)</label>
                        <div class="amount-input">
                            <span class="currency-symbol">Rs</span>
                            <input type="number" id="amount" name="amount" min="10" step="1" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Suggested Amounts</label>
                        <div class="suggested-amounts">
                            <button type="button" class="amount-btn" data-amount="500">Rs 500</button>
                            <button type="button" class="amount-btn" data-amount="1000">Rs 1000</button>
                            <button type="button" class="amount-btn" data-amount="2000">Rs 2000</button>
                            <button type="button" class="amount-btn" data-amount="5000">Rs 5000</button>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="donorName">Your Name</label>
                        <input type="text" id="donorName" name="donorName" required>
                    </div>

                    <div class="form-group">
                        <label for="donorEmail">Email Address</label>
                        <input type="email" id="donorEmail" name="donorEmail" required>
                    </div>

                    <div class="form-group">
                        <label for="donorPhone">Phone Number</label>
                        <input type="tel" id="donorPhone" name="donorPhone" pattern="[0-9]{10}" placeholder="9876543210">
                    </div>

                    <!-- Hidden payment method field - static value -->
                    <input type="hidden" name="paymentMethod" value="direct">

                    <div class="form-group">
                        <label for="message">Leave a Message (Optional)</label>
                        <textarea id="message" name="message" rows="3" placeholder="Your message of support..."></textarea>
                    </div>

                    <div class="form-group checkbox-group">
                        <input type="checkbox" id="anonymous" name="anonymous" value="true">
                        <label for="anonymous">Make this donation anonymous</label>
                    </div>

                    <div class="form-group checkbox-group terms-group">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms">I agree to the <a href="${pageContext.request.contextPath}/terms" target="_blank">Terms & Conditions</a></label>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="donate-btn">
                            <i class="fas fa-heart"></i> Donate Now
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>
</div>

<jsp:include page="/WEB-INF/components/footer.jsp" />

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Handle suggested amounts
        const amountButtons = document.querySelectorAll('.amount-btn');
        const amountInput = document.getElementById('amount');

        amountButtons.forEach(button => {
            button.addEventListener('click', function() {
                const amount = this.getAttribute('data-amount');
                amountInput.value = amount;

                // Remove active class from all buttons
                amountButtons.forEach(btn => btn.classList.remove('active'));
                // Add active class to clicked button
                this.classList.add('active');
            });
        });

        // Form validation
        const donationForm = document.getElementById('donationForm');
        if (donationForm) {
            donationForm.addEventListener('submit', function(event) {
                const amount = amountInput.value;
                if (amount < 10) {
                    event.preventDefault();
                    alert('Please enter a donation amount of at least 10 NPR.');
                    amountInput.focus();
                }
            });
        }
    });
</script>
</body>
</html>