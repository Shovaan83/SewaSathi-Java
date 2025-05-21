<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donate Clothes - SewaSathi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/clothes-donation.css">
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<div class="clothes-donation-container">
    <div class="donation-header">
        <h1>Donate Clothes</h1>
        <p>Your donated clothes can provide warmth and dignity to those in need</p>
    </div>

    <div class="donation-content">
        <div class="donation-info">
            <div class="info-card">
                <div class="info-icon">
                    <i class="fas fa-tshirt"></i>
                </div>
                <div class="info-text">
                    <h3>What to Donate</h3>
                    <ul>
                        <li>Clean, gently used clothing</li>
                        <li>All sizes of clothes (children, women, men)</li>
                        <li>Seasonal clothing (winter jackets, raincoats)</li>
                        <li>Shoes and accessories</li>
                        <li>New undergarments (with tags)</li>
                    </ul>
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
                    <h3>Pickup & Drop-off</h3>
                    <p>We offer two convenient options:</p>
                    <ul>
                        <li>Schedule a pickup from your location</li>
                        <li>Drop off at one of our collection centers</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="donation-form-container">
            <form action="${pageContext.request.contextPath}/clothesdonation" method="post" class="donation-form" id="clothesDonationForm">
                <div class="form-group">
                    <label for="donorName">Your Name</label>
                    <input type="text" id="donorName" name="donorName"
                           value="${sessionScope.user != null ? sessionScope.user.fullName : ''}"
                           required>
                </div>

                <div class="form-group">
                    <label for="donorEmail">Email Address</label>
                    <input type="email" id="donorEmail" name="donorEmail"
                           value="${sessionScope.user != null ? sessionScope.user.email : ''}"
                           required>
                </div>

                <div class="form-group">
                    <label for="donorPhone">Phone Number</label>
                    <input type="tel" id="donorPhone" name="donorPhone"
                           value="${sessionScope.user != null ? sessionScope.user.phone : ''}"
                           pattern="[0-9]{10}" placeholder="9876543210" required>
                </div>

                <div class="form-group">
                    <label for="donationMethod">Donation Method</label>
                    <div class="radio-group">
                        <div class="radio-option">
                            <input type="radio" id="pickup" name="donationMethod" value="pickup" checked>
                            <label for="pickup" class="radio-label">
                                <i class="fas fa-truck"></i>
                                <span>Schedule Pickup</span>
                            </label>
                        </div>
                        <div class="radio-option">
                            <input type="radio" id="dropoff" name="donationMethod" value="dropoff">
                            <label for="dropoff" class="radio-label">
                                <i class="fas fa-building"></i>
                                <span>Drop-off</span>
                            </label>
                        </div>
                    </div>
                </div>

                <div id="pickupDetails" class="conditional-section">
                    <div class="form-group">
                        <label for="pickupAddress">Pickup Address</label>
                        <input type="text" id="pickupAddress" name="pickupAddress" placeholder="Street address">
                    </div>

                    <div class="form-group">
                        <label for="pickupCity">City</label>
                        <input type="text" id="pickupCity" name="pickupCity" placeholder="City">
                    </div>

                    <div class="form-row">
                        <div class="form-group half">
                            <label for="pickupDate">Preferred Date</label>
                            <input type="date" id="pickupDate" name="pickupDate" min="">
                        </div>
                        <div class="form-group half">
                            <label for="pickupTime">Preferred Time</label>
                            <select id="pickupTime" name="pickupTime">
                                <option value="morning">Morning (9AM - 12PM)</option>
                                <option value="afternoon">Afternoon (12PM - 3PM)</option>
                                <option value="evening">Evening (3PM - 6PM)</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div id="dropoffDetails" class="conditional-section hidden">
                    <div class="form-group">
                        <label for="dropoffCenter">Select Drop-off Center</label>
                        <select id="dropoffCenter" name="dropoffCenter">
                            <option value="center1">SewaSathi Main Office - Kathmandu</option>
                            <option value="center2">Community Center - Lalitpur</option>
                            <option value="center3">Helping Hands - Bhaktapur</option>
                            <option value="center4">Care Center - Pokhara</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dropoffDate">Planned Drop-off Date</label>
                        <input type="date" id="dropoffDate" name="dropoffDate" min="">
                    </div>
                </div>

                <div class="form-group">
                    <label>What are you donating?</label>
                    <div class="checkbox-grid">
                        <div class="checkbox-item">
                            <input type="checkbox" id="mens" name="clothesTypes" value="mens">
                            <label for="mens">Men's Clothing</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="womens" name="clothesTypes" value="womens">
                            <label for="womens">Women's Clothing</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="children" name="clothesTypes" value="children">
                            <label for="children">Children's Clothing</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="winter" name="clothesTypes" value="winter">
                            <label for="winter">Winter Wear</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="shoes" name="clothesTypes" value="shoes">
                            <label for="shoes">Shoes</label>
                        </div>
                        <div class="checkbox-item">
                            <input type="checkbox" id="accessories" name="clothesTypes" value="accessories">
                            <label for="accessories">Accessories</label>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="clothesQuantity">Approximate Quantity</label>
                    <select id="clothesQuantity" name="clothesQuantity">
                        <option value="small">Small (1-5 items)</option>
                        <option value="medium" selected>Medium (6-15 items)</option>
                        <option value="large">Large (16-30 items)</option>
                        <option value="xlarge">Extra Large (30+ items)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="additionalInfo">Additional Information</label>
                    <textarea id="additionalInfo" name="additionalInfo" rows="3" placeholder="Any specific details about your donation..."></textarea>
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
        // Set minimum date for date inputs to today
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('pickupDate').min = today;
        document.getElementById('dropoffDate').min = today;

        // Toggle between pickup and dropoff sections
        const pickupRadio = document.getElementById('pickup');
        const dropoffRadio = document.getElementById('dropoff');
        const pickupDetails = document.getElementById('pickupDetails');
        const dropoffDetails = document.getElementById('dropoffDetails');

        pickupRadio.addEventListener('change', function() {
            if (this.checked) {
                pickupDetails.classList.remove('hidden');
                dropoffDetails.classList.add('hidden');
            }
        });

        dropoffRadio.addEventListener('change', function() {
            if (this.checked) {
                dropoffDetails.classList.remove('hidden');
                pickupDetails.classList.add('hidden');
            }
        });

        // Form validation
        const donationForm = document.getElementById('clothesDonationForm');
        donationForm.addEventListener('submit', function(event) {
            // Validate that at least one clothes type is selected
            const clothesTypes = document.querySelectorAll('input[name="clothesTypes"]:checked');
            if (clothesTypes.length === 0) {
                event.preventDefault();
                alert('Please select at least one type of clothing you are donating.');
            }

            // Validate pickup/dropoff details based on selected method
            if (pickupRadio.checked) {
                const address = document.getElementById('pickupAddress').value;
                const city = document.getElementById('pickupCity').value;
                const date = document.getElementById('pickupDate').value;

                if (!address || !city || !date) {
                    event.preventDefault();
                    alert('Please fill in all pickup details.');
                }
            } else if (dropoffRadio.checked) {
                const date = document.getElementById('dropoffDate').value;

                if (!date) {
                    event.preventDefault();
                    alert('Please select a planned drop-off date.');
                }
            }
        });
    });
</script>
</body>
</html>