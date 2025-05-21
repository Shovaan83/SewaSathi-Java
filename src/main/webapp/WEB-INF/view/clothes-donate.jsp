<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Donate Clothes - ${campaign.title}</title>
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom styles -->
    <style>
        :root {
            --primary-color: #ff6b6b;
            --secondary-color: #339af0;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
            --danger-color: #e74c3c;
            --success-color: #2ecc71;
            --warning-color: #f39c12;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 1rem;
        }
        
        .page-title {
            font-size: 2rem;
            text-align: center;
            margin-bottom: 1rem;
            color: var(--dark-color);
        }
        
        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 2rem;
        }
        
        .campaign-info {
            background-color: #fff;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .campaign-title {
            font-size: 1.5rem;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
        }
        
        .campaign-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1rem;
            font-size: 0.9rem;
            color: #666;
        }
        
        .form-card {
            background-color: #fff;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }
        
        .form-control {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        
        .btn {
            display: inline-block;
            padding: 0.8rem 1.5rem;
            border: none;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #ff5252;
        }
        
        .btn-secondary {
            background-color: #e9ecef;
            color: #495057;
        }
        
        .btn-secondary:hover {
            background-color: #dee2e6;
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 2rem;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1.5rem;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: var(--danger-color);
            border: 1px solid #f5c6cb;
        }
        
        .clothes-type-options {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .clothes-option {
            display: flex;
            align-items: center;
        }
        
        .clothes-option input {
            margin-right: 0.5rem;
        }
        
        .required-label::after {
            content: " *";
            color: var(--danger-color);
        }
        
        @media (max-width: 768px) {
            .clothes-type-options {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
                gap: 1rem;
            }
            
            .btn {
                width: 100%;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <!-- Include the navbar -->
    <c:set var="requestURI" value="${pageContext.request.requestURI}" />
    <jsp:include page="/WEB-INF/components/navbar.jsp" />

    <div class="container">
        <h1 class="page-title">Donate Clothes</h1>
        <p class="subtitle">Thank you for choosing to donate clothes to help others in need.</p>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>
        
        <div class="campaign-info">
            <h2 class="campaign-title">${campaign.title}</h2>
            <div class="campaign-meta">
                <div><strong>Organizer:</strong> ${campaign.creatorName}</div>
                <div><strong>Deadline:</strong> <fmt:formatDate value="${campaign.deadline}" pattern="MMMM dd, yyyy" /></div>
            </div>
            <p>${campaign.description}</p>
        </div>
        
        <div class="form-card">
            <form action="${pageContext.request.contextPath}/clothes-donate" method="post">
                <input type="hidden" name="campaignId" value="${campaign.campaign_id}">
                
                <div class="form-group">
                    <label for="clothesType" class="required-label">Clothes Type</label>
                    <div class="clothes-type-options">
                        <div class="clothes-option">
                            <input type="radio" id="shirts" name="clothesType" value="shirts">
                            <label for="shirts">Shirts/T-shirts</label>
                        </div>
                        <div class="clothes-option">
                            <input type="radio" id="pants" name="clothesType" value="pants">
                            <label for="pants">Pants/Trousers</label>
                        </div>
                        <div class="clothes-option">
                            <input type="radio" id="dresses" name="clothesType" value="dresses">
                            <label for="dresses">Dresses</label>
                        </div>
                        <div class="clothes-option">
                            <input type="radio" id="coats" name="clothesType" value="coats">
                            <label for="coats">Coats/Jackets</label>
                        </div>
                        <div class="clothes-option">
                            <input type="radio" id="shoes" name="clothesType" value="shoes">
                            <label for="shoes">Shoes</label>
                        </div>
                        <div class="clothes-option">
                            <input type="radio" id="other" name="clothesType" value="other">
                            <label for="other">Other</label>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="quantity" class="required-label">Quantity</label>
                    <input type="number" id="quantity" name="quantity" class="form-control" min="1" required>
                </div>
                
                <div class="form-group">
                    <label for="size" class="required-label">Size</label>
                    <select id="size" name="size" class="form-control" required>
                        <option value="" disabled selected>Select a size</option>
                        <option value="XS">Extra Small (XS)</option>
                        <option value="S">Small (S)</option>
                        <option value="M">Medium (M)</option>
                        <option value="L">Large (L)</option>
                        <option value="XL">Extra Large (XL)</option>
                        <option value="XXL">Double Extra Large (XXL)</option>
                        <option value="XXXL">Triple Extra Large (XXXL)</option>
                        <option value="Kids">Kids</option>
                        <option value="Various">Various Sizes</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="condition" class="required-label">Condition</label>
                    <select id="condition" name="condition" class="form-control" required>
                        <option value="" disabled selected>Select condition</option>
                        <option value="New">New (with tags)</option>
                        <option value="Like-new">Like New</option>
                        <option value="Good">Good</option>
                        <option value="Fair">Fair</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="pickupAddress" class="required-label">Pickup Address</label>
                    <textarea id="pickupAddress" name="pickupAddress" class="form-control" rows="3" required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="pickupDate" class="required-label">Preferred Pickup Date</label>
                    <input type="date" id="pickupDate" name="pickupDate" class="form-control" required>
                </div>
                
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/campaign?id=${campaign.campaign_id}" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Submit Donation</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Set minimum date for pickup to tomorrow
        const pickupDateInput = document.getElementById('pickupDate');
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        
        // Format date as YYYY-MM-DD
        const formatDate = (date) => {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        };
        
        pickupDateInput.min = formatDate(tomorrow);
    </script>
</body>
</html> 
