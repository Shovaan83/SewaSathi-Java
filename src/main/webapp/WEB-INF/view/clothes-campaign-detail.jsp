<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${campaign.title} - SewaSathi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/campaign-detail.css">
    <style>
        .clothes-campaign-header {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('${pageContext.request.contextPath}/assets/images/clothes-banner.jpg');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 4rem 2rem;
            text-align: center;
        }

        .clothes-campaign-header h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .clothes-campaign-header p {
            font-size: 1.2rem;
            max-width: 800px;
            margin: 0 auto;
        }

        .clothes-campaign-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .clothes-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .clothes-info-card {
            background: white;
            border-radius: 10px;
            padding: 2rem;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .clothes-info-card h3 {
            color: #2c3e50;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .clothes-info-card i {
            color: #e74c3c;
        }

        .clothes-info-card ul {
            list-style: none;
            padding: 0;
        }

        .clothes-info-card li {
            margin-bottom: 0.5rem;
            padding-left: 1.5rem;
            position: relative;
        }

        .clothes-info-card li:before {
            content: "•";
            color: #e74c3c;
            position: absolute;
            left: 0;
        }

        .donation-success {
            background: #d4edda;
            color: #155724;
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .donation-success i {
            font-size: 1.5rem;
        }

        .donate-clothes-btn {
            background: #e74c3c;
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 5px;
            font-size: 1.1rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: background-color 0.3s;
        }

        .donate-clothes-btn:hover {
            background: #c0392b;
        }

        .campaign-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin: 2rem 0;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .stat-card h4 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .stat-card p {
            font-size: 1.5rem;
            color: #e74c3c;
            font-weight: bold;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<div class="clothes-campaign-header">
    <h1>${campaign.title}</h1>
    <p>${campaign.description}</p>
</div>

<div class="clothes-campaign-content">
    <c:if test="${not empty successMessage}">
        <div class="donation-success">
            <i class="fas fa-check-circle"></i>
            <p>${successMessage}</p>
        </div>
    </c:if>

    <div class="campaign-stats">
        <div class="stat-card">
            <h4>Total Donations</h4>
            <p>${totalDonations}</p>
        </div>
        <div class="stat-card">
            <h4>Campaign Status</h4>
            <p>${campaign.status}</p>
        </div>
        <div class="stat-card">
            <h4>Days Left</h4>
            <p>${daysLeft}</p>
        </div>
    </div>

    <div class="clothes-info-grid">
        <div class="clothes-info-card">
            <h3><i class="fas fa-tshirt"></i> What to Donate</h3>
            <ul>
                <li>Clean, gently used clothing</li>
                <li>All sizes of clothes (children, women, men)</li>
                <li>Seasonal clothing (winter jackets, raincoats)</li>
                <li>Shoes and accessories</li>
                <li>New undergarments (with tags)</li>
            </ul>
        </div>

        <div class="clothes-info-card">
            <h3><i class="fas fa-hand-holding-heart"></i> How It Helps</h3>
            <ul>
                <li>Provides clothing to those in need</li>
                <li>Supports disaster relief efforts</li>
                <li>Helps low-income families</li>
                <li>Assists children's homes</li>
                <li>Supports rural communities</li>
            </ul>
        </div>

        <div class="clothes-info-card">
            <h3><i class="fas fa-truck"></i> Pickup Information</h3>
            <ul>
                <li>Free pickup service available</li>
                <li>Flexible pickup times</li>
                <li>Convenient scheduling</li>
                <li>Nationwide coverage</li>
                <li>Professional handling</li>
            </ul>
        </div>
    </div>

    <div style="text-align: center; margin-top: 2rem;">
        <a href="${pageContext.request.contextPath}/clothes-donate?campaignId=${campaign.campaign_id}" class="donate-clothes-btn">
            <i class="fas fa-tshirt"></i> Donate Clothes Now
        </a>
    </div>
</div>

<jsp:include page="/WEB-INF/components/footer.jsp" />
</body>
</html> 