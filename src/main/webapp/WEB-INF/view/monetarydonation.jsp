<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make a Donation - SewaSathi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/monetary-donation.css">
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<div class="donation-container">
    <div class="donation-header">
        <h1>Make a Donation</h1>
        <p>Your generosity makes a difference in someone's life</p>
    </div>

    <div class="donation-content">
        <div class="campaign-details">
            <div class="campaign-image">
                <img src="${pageContext.request.contextPath}/assets/images/default-campaign.jpg" alt="Education for Children">
            </div>
            <div class="campaign-info">
                <h2>Education for Children</h2>
                <p class="campaign-creator">By John Doe</p>
                <div class="progress-container">
                    <div class="progress-bar">
                        <div class="progress" style="width:65%"></div>
                    </div>
                    <div class="progress-stats">
                        <span class="raised">NPR 65,000</span>
                        <span class="goal">of NPR 100,000</span>
                        <span class="percentage">65%</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="donation-form-container">
            <form action="${pageContext.request.contextPath}/processDonation" method="post" class="donation-form" id="donationForm">
                <input type="hidden" name="campaignId" value="1">

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

                <div class="form-group">
                    <label for="paymentMethod">Payment Method</label>
                    <div class="payment-methods">
                        <div class="payment-option">
                            <input type="radio" id="khalti" name="paymentMethod" value="khalti" checked>
                            <label for="khalti" class="payment-label">
                                <img src="${pageContext.request.contextPath}/assets/images/khalti-logo.png" alt="Khalti" onerror="this.src='https://via.placeholder.com/80x40?text=Khalti'">
                                <span>Khalti</span>
                            </label>
                        </div>
                        <div class="payment-option">
                            <input type="radio" id="esewa" name="paymentMethod" value="esewa">
                            <label for="esewa" class="payment-label">
                                <img src="${pageContext.request.contextPath}/assets/images/esewa-logo.png" alt="eSewa" onerror="this.src='https://via.placeholder.com/80x40?text=eSewa'">
                                <span>eSewa</span>
                            </label>
                        </div>
                        <div class="payment-option">
                            <input type="radio" id="connectips" name="paymentMethod" value="connectips">
                            <label for="connectips" class="payment-label">
                                <img src="${pageContext.request.contextPath}/assets/images/connectips-logo.png" alt="ConnectIPS" onerror="this.src='https://via.placeholder.com/80x40?text=ConnectIPS'">
                                <span>ConnectIPS</span>
                            </label>
                        </div>
                    </div>
                </div>

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
        donationForm.addEventListener('submit', function(event) {
            const amount = amountInput.value;
            if (amount < 10) {
                event.preventDefault();
                alert('Please enter a donation amount of at least 10 NPR.');
                amountInput.focus();
            }
        });
    });
</script>
</body>
</html>