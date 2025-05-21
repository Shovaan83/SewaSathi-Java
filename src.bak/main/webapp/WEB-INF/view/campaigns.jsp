<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaigns - SewaSathi</title>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem;
        }
        
        .page-header {
            text-align: center;
            margin: 2rem 0;
        }
        
        .page-title {
            font-size: 2.5rem;
            color: var(--dark-color);
            margin-bottom: 0.5rem;
        }
        
        .subtitle {
            color: #666;
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .campaigns-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }
        
        .campaign-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s;
        }
        
        .campaign-card:hover {
            transform: translateY(-5px);
        }
        
        .campaign-image {
            height: 200px;
            width: 100%;
            object-fit: cover;
        }
        
        .campaign-content {
            padding: 1.5rem;
        }
        
        .campaign-title {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }
        
        .campaign-meta {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            color: #666;
            font-size: 0.85rem;
        }
        
        .campaign-description {
            color: #555;
            margin-bottom: 1.25rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .campaign-progress {
            height: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            margin-bottom: 0.75rem;
            overflow: hidden;
        }
        
        .progress-bar {
            height: 100%;
            background-color: var(--primary-color);
            border-radius: 4px;
        }
        
        .campaign-stats {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1.25rem;
            font-size: 0.85rem;
            color: #666;
        }
        
        .campaign-actions {
            display: flex;
            justify-content: space-between;
        }
        
        .btn {
            display: inline-block;
            padding: 0.6rem 1.2rem;
            font-size: 0.9rem;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: #fff;
        }
        
        .btn-primary:hover {
            background-color: #ff5252;
        }
        
        .btn-outline {
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            background-color: transparent;
        }
        
        .btn-outline:hover {
            background-color: var(--primary-color);
            color: #fff;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: var(--danger-color);
            border: 1px solid #f5c6cb;
        }
        
        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            margin: 2rem 0;
        }
        
        .empty-state-icon {
            font-size: 3rem;
            color: #ddd;
            margin-bottom: 1rem;
        }
        
        .empty-state-message {
            font-size: 1.25rem;
            color: #666;
            margin-bottom: 2rem;
        }
        
        .filters {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .filter-group {
            display: flex;
            gap: 0.5rem;
        }
        
        .filter-btn {
            padding: 0.5rem 1rem;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 30px;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .filter-btn:hover,
        .filter-btn.active {
            background-color: var(--primary-color);
            color: #fff;
            border-color: var(--primary-color);
        }
        
        .search-container {
            position: relative;
            flex: 1;
            max-width: 400px;
        }
        
        .search-input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 3rem;
            border: 1px solid #ddd;
            border-radius: 30px;
            font-size: 0.9rem;
            transition: border-color 0.3s;
        }
        
        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        
        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
        }
        
        @media (max-width: 768px) {
            .campaigns-grid {
                grid-template-columns: 1fr;
            }
            
            .filters {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-container {
                max-width: 100%;
            }
        }
        
        .campaign-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            z-index: 2;
        }
        
        .donation-type-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.7rem;
            font-weight: bold;
            z-index: 2;
        }
        
        .monetary-badge {
            background-color: #339af0;
            color: white;
        }
        
        .clothes-badge {
            background-color: #e67e22;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Include the navbar -->
    <c:set var="requestURI" value="${pageContext.request.requestURI}" />
    <jsp:include page="/WEB-INF/components/navbar.jsp" />

    <div class="container">
        <header class="page-header">
            <h1 class="page-title">Active Campaigns</h1>
            <p class="subtitle">Discover campaigns that need your support and make a difference today.</p>
        </header>
        
        <div class="filters">
            <div class="filter-group">
                <button class="filter-btn active">All</button>
                <button class="filter-btn">Medical</button>
                <button class="filter-btn">Education</button>
                <button class="filter-btn">Disaster Relief</button>
                <button class="filter-btn">Animal Welfare</button>
            </div>
            
            <div class="search-container">
                <i class="fas fa-search search-icon"></i>
                <form action="${pageContext.request.contextPath}/search" method="get">
                    <input type="text" class="search-input" name="query" placeholder="Search campaigns...">
                </form>
            </div>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty campaigns}">
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fas fa-search"></i>
                    </div>
                    <div class="empty-state-message">
                        No active campaigns found at the moment.
                    </div>
                    <c:if test="${not empty sessionScope.user && sessionScope.user.role_id != 1}">
                        <a href="${pageContext.request.contextPath}/create-campaign" class="btn btn-primary">
                            Create a Campaign
                        </a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="campaigns-grid">
                    <c:forEach var="campaign" items="${campaigns}">
                        <div class="campaign-card">
                            <c:choose>
                                <c:when test="${not empty campaign.campaign_image_url}">
                                    <img src="${campaign.campaign_image_url}" alt="${campaign.title}" class="campaign-image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/img/default-campaign.jpg" alt="${campaign.title}" class="campaign-image">
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Donation Type Badge -->
                            <div class="donation-type-badge ${campaign.donation_type == 'clothes' ? 'clothes-badge' : 'monetary-badge'}">
                                <c:choose>
                                    <c:when test="${campaign.donation_type == 'clothes'}">
                                        <i class="fas fa-tshirt"></i> Clothes
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-dollar-sign"></i> Money
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="campaign-content">
                                <h3 class="campaign-title">${campaign.title}</h3>
                                
                                <div class="campaign-meta">
                                    <span>by ${campaign.creatorName}</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${campaign.category_id == 1}">Medical</c:when>
                                            <c:when test="${campaign.category_id == 2}">Education</c:when>
                                            <c:when test="${campaign.category_id == 3}">Disaster Relief</c:when>
                                            <c:when test="${campaign.category_id == 4}">Animal Welfare</c:when>
                                            <c:when test="${campaign.category_id == 5}">Environment</c:when>
                                            <c:when test="${campaign.category_id == 6}">Community Development</c:when>
                                            <c:when test="${campaign.category_id == 7}">Art & Culture</c:when>
                                            <c:otherwise>Other</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                
                                <p class="campaign-description">${campaign.description}</p>
                                
                                <div class="campaign-progress">
                                    <div class="progress-bar" style="width: ${campaign.progressPercentage}%"></div>
                                </div>
                                
                                <div class="campaign-stats">
                                    <span><strong><fmt:formatNumber value="${campaign.collectedAmount}" type="currency" currencySymbol="NPR " /></strong> raised</span>
                                    <span><strong>${campaign.progressPercentage}%</strong> of <fmt:formatNumber value="${campaign.goal_amount}" type="currency" currencySymbol="NPR " /></span>
                                </div>
                                
                                <div class="campaign-actions">
                                    <a href="${pageContext.request.contextPath}/campaign?id=${campaign.campaign_id}" class="btn btn-outline">View Details</a>
                                    <a href="${pageContext.request.contextPath}/donate?campaignId=${campaign.campaign_id}" class="btn btn-primary">Donate</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <script>
        // Filter button functionality
        document.addEventListener('DOMContentLoaded', function() {
            const filterButtons = document.querySelectorAll('.filter-btn');
            
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    // Remove active class from all buttons
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    // TODO: Implement actual filtering logic
                    // For now, this is just a UI demo
                });
            });
        });
    </script>
</body>
</html> 
