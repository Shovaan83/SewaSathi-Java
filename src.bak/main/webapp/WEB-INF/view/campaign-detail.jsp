<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${campaign.title}" default="Campaign Details"/> - SewaSathi</title>
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Cloudinary upload script -->
    <script src="${pageContext.request.contextPath}/assets/js/cloudinary-upload.js"></script>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem;
        }
        
        .campaign-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .campaign-title {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }
        
        .campaign-category {
            display: inline-block;
            background-color: #e9ecef;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.85rem;
            color: #495057;
            margin-bottom: 1rem;
        }
        
        .campaign-meta {
            display: flex;
            justify-content: center;
            gap: 2rem;
            flex-wrap: wrap;
            margin-bottom: 1.5rem;
            color: #666;
            font-size: 0.9rem;
        }
        
        .campaign-meta-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .campaign-meta-item i {
            color: var(--primary-color);
        }
        
        .campaign-main {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }
        
        .campaign-content {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }
        
        .campaign-image-container {
            position: relative;
            margin-bottom: 2rem;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .campaign-image {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
            display: block;
        }
        
        .edit-image-btn {
            position: absolute;
            bottom: 15px;
            right: 15px;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            border: none;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            font-size: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
            opacity: 0.7;
        }
        
        .edit-image-btn:hover {
            opacity: 1;
            transform: scale(1.1);
        }
        
        .campaign-description {
            white-space: pre-line;
            font-size: 1.05rem;
            margin-bottom: 2rem;
        }
        
        .campaign-section-title {
            font-size: 1.5rem;
            color: var(--dark-color);
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #eee;
        }
        
        .campaign-sidebar {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }
        
        .sidebar-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
        }
        
        .donation-stats {
            margin-bottom: 1.5rem;
        }
        
        .donation-amount {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }
        
        .donation-goal {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .progress-container {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            margin-bottom: 0.75rem;
            overflow: hidden;
        }
        
        .progress-bar {
            height: 100%;
            background-color: var(--primary-color);
            border-radius: 5px;
        }
        
        .donation-details {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
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
            margin-bottom: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #ff5252;
        }
        
        .btn-secondary {
            background-color: var(--secondary-color);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #228be6;
        }
        
        .btn-block {
            display: block;
            width: 100%;
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
        
        .campaign-creator {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .creator-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: 600;
            font-size: 1.25rem;
        }
        
        .creator-info {
            flex: 1;
        }
        
        .creator-name {
            font-weight: 600;
            margin-bottom: 0.25rem;
        }
        
        .creator-title {
            font-size: 0.85rem;
            color: #666;
        }
        
        .badges {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .badge {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .badge-pending {
            background-color: #fff3cd;
            color: var(--warning-color);
        }
        
        .badge-active {
            background-color: #d4edda;
            color: var(--success-color);
        }
        
        .badge-rejected {
            background-color: #f8d7da;
            color: var(--danger-color);
        }
        
        .share-options {
            display: flex;
            gap: 0.75rem;
            margin-top: 1rem;
        }
        
        .share-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
            font-size: 1.25rem;
            transition: all 0.3s;
        }
        
        .share-facebook {
            background-color: #3b5998;
        }
        
        .share-twitter {
            background-color: #1da1f2;
        }
        
        .share-whatsapp {
            background-color: #25d366;
        }
        
        .share-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
        }
        
        @media (max-width: 992px) {
            .campaign-main {
                grid-template-columns: 1fr;
            }
            
            .campaign-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <!-- Include the navbar -->
    <c:set var="requestURI" value="${pageContext.request.requestURI}" />
    <jsp:include page="/WEB-INF/components/navbar.jsp" />

    <div class="container">
        <c:choose>
            <c:when test="${not empty error}">
                <div class="alert alert-danger">
                    ${error}
                </div>
                <div style="text-align: center; margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/campaigns" class="btn btn-primary">View All Campaigns</a>
                </div>
            </c:when>
            <c:when test="${empty campaign}">
                <div class="alert alert-info">
                    Campaign not found or has been removed.
                </div>
                <div style="text-align: center; margin-top: 2rem;">
                    <a href="${pageContext.request.contextPath}/campaigns" class="btn btn-primary">View All Campaigns</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="campaign-header">
                    <h1 class="campaign-title">${campaign.title}</h1>
                    
                    <span class="campaign-category">
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
                    
                    <div class="campaign-meta">
                        <div class="campaign-meta-item">
                            <i class="far fa-calendar-alt"></i>
                            <span>Deadline: <fmt:formatDate value="${campaign.deadline}" pattern="MMMM dd, yyyy" /></span>
                        </div>
                        
                        <div class="campaign-meta-item">
                            <i class="fas fa-user"></i>
                            <span>Created by: ${campaign.creatorName}</span>
                        </div>
                        
                        <div class="campaign-meta-item">
                            <i class="fas fa-tag"></i>
                            <span class="badge 
                                <c:choose>
                                    <c:when test="${campaign.status == 'active'}">badge-active</c:when>
                                    <c:when test="${campaign.status == 'pending'}">badge-pending</c:when>
                                    <c:when test="${campaign.status == 'rejected'}">badge-rejected</c:when>
                                    <c:otherwise>badge-pending</c:otherwise>
                                </c:choose>
                            ">
                                ${campaign.status}
                            </span>
                        </div>
                        
                        <div class="campaign-meta-item">
                            <i class="fas fa-hand-holding-heart"></i>
                            <span>Donation Type: 
                                <strong>
                                    <c:choose>
                                        <c:when test="${campaign.donation_type == 'monetary'}">Monetary</c:when>
                                        <c:when test="${campaign.donation_type == 'clothes'}">Clothes</c:when>
                                        <c:otherwise>Monetary</c:otherwise>
                                    </c:choose>
                                </strong>
                            </span>
                        </div>
                    </div>
                </div>
                
                <div class="campaign-main">
                    <div class="campaign-content">
                        <div class="campaign-image-container">
                            <c:choose>
                                <c:when test="${not empty campaign.campaign_image_url}">
                                    <img class="campaign-image" src="${campaign.campaign_image_url}" alt="${campaign.title}">
                                </c:when>
                                <c:otherwise>
                                    <img class="campaign-image" src="${pageContext.request.contextPath}/assets/img/default-campaign.jpg" alt="${campaign.title}">
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Show edit button only if user is campaign creator or admin -->
                            <c:if test="${not empty user && (user.user_id == campaign.created_by || user.role_id == 1)}">
                                <button type="button" class="edit-image-btn" onclick="updateCampaignImage(${campaign.campaign_id})" title="Change image">
                                    <i class="fas fa-camera"></i>
                                </button>
                            </c:if>
                        </div>
                        
                        <h2 class="campaign-section-title">About this campaign</h2>
                        <div class="campaign-description">
                            ${campaign.description}
                        </div>
                    </div>
                    
                    <div class="campaign-sidebar">
                        <div class="sidebar-card">
                            <div class="donation-stats">
                                <div class="donation-amount">
                                    <fmt:formatNumber value="${campaign.collectedAmount}" type="currency" currencySymbol="NPR " />
                                </div>
                                
                                <div class="donation-goal">
                                    raised of <fmt:formatNumber value="${campaign.goal_amount}" type="currency" currencySymbol="NPR " /> goal
                                </div>
                                
                                <div class="progress-container">
                                    <div class="progress-bar" style="width: ${campaign.progressPercentage}%"></div>
                                </div>
                                
                                <div class="donation-details">
                                    <span>${campaign.progressPercentage}% Funded</span>
                                    <span>
                                        <c:choose>
                                            <c:when test="${campaign.deadline != null}">
                                                <jsp:useBean id="now" class="java.util.Date" />
                                                <c:set var="daysLeft" value="${(campaign.deadline.time - now.time) / (1000 * 60 * 60 * 24)}" />
                                                <fmt:formatNumber value="${daysLeft}" pattern="0" var="daysLeftFormatted" />
                                                <c:choose>
                                                    <c:when test="${daysLeftFormatted <= 0}">Campaign ended</c:when>
                                                    <c:otherwise>${daysLeftFormatted} days left</c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>No deadline</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            
                            <c:choose>
                                <c:when test="${campaign.status == 'active'}">
                                    <c:choose>
                                        <c:when test="${campaign.donation_type == 'clothes'}">
                                            <a href="${pageContext.request.contextPath}/clothes-donate?campaignId=${campaign.campaign_id}" class="btn btn-primary btn-block">
                                                <i class="fas fa-tshirt"></i> Donate Clothes
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/donate?campaignId=${campaign.campaign_id}" class="btn btn-primary btn-block">
                                                <i class="fas fa-heart"></i> Donate Now
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-info">
                                        This campaign is currently ${campaign.status} and not accepting donations.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="share-options">
                                <a href="https://www.facebook.com/sharer/sharer.php?u=${pageContext.request.requestURL}?id=${campaign.campaign_id}" target="_blank" class="share-btn share-facebook">
                                    <i class="fab fa-facebook-f"></i>
                                </a>
                                <a href="https://twitter.com/intent/tweet?text=Support this campaign: ${campaign.title}&url=${pageContext.request.requestURL}?id=${campaign.campaign_id}" target="_blank" class="share-btn share-twitter">
                                    <i class="fab fa-twitter"></i>
                                </a>
                                <a href="https://wa.me/?text=Support this campaign: ${campaign.title} ${pageContext.request.requestURL}?id=${campaign.campaign_id}" target="_blank" class="share-btn share-whatsapp">
                                    <i class="fab fa-whatsapp"></i>
                                </a>
                            </div>
                        </div>
                        
                        <div class="sidebar-card">
                            <h3 class="campaign-section-title">Campaign Creator</h3>
                            <div class="campaign-creator">
                                <div class="creator-avatar">
                                    ${campaign.creatorName.charAt(0)}
                                </div>
                                <div class="creator-info">
                                    <div class="creator-name">${campaign.creatorName}</div>
                                    <div class="creator-title">Campaign Organizer</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html> 
