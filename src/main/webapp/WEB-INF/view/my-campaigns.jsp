<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Campaigns - SewaSathi</title>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem;
        }
        
        .page-title {
            text-align: center;
            color: var(--dark-color);
            margin: 2rem 0;
        }
        
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
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
        
        .alert-success {
            background-color: #d4edda;
            color: var(--success-color);
            border: 1px solid #c3e6cb;
        }
        
        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 2rem;
            transition: transform 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .campaign-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
        }
        
        .campaign-card-img {
            height: 200px;
            width: 100%;
            object-fit: cover;
            border-bottom: 1px solid #eee;
        }
        
        .campaign-card-body {
            padding: 1.5rem;
        }
        
        .campaign-card-title {
            font-size: 1.25rem;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }
        
        .campaign-card-description {
            color: #666;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .campaign-card-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .campaign-progress {
            height: 10px;
            background-color: #e9ecef;
            border-radius: 5px;
            margin-bottom: 0.75rem;
            overflow: hidden;
        }
        
        .campaign-progress-bar {
            height: 100%;
            border-radius: 5px;
            background-color: var(--primary-color);
        }
        
        .campaign-stats {
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
            color: #666;
        }
        
        .campaign-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 1.5rem;
            align-items: center;
        }
        
        .status-badge {
            display: inline-block;
            padding: 0.3rem 0.75rem;
            border-radius: 50px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: var(--warning-color);
        }
        
        .status-active {
            background-color: #d4edda;
            color: var(--success-color);
        }
        
        .status-rejected {
            background-color: #f8d7da;
            color: var(--danger-color);
        }
        
        .status-completed {
            background-color: #e2e3e5;
            color: #495057;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
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
        
        @media (max-width: 768px) {
            .campaign-grid {
                grid-template-columns: 1fr;
            }
            
            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Include the navbar -->
    <c:set var="requestURI" value="${pageContext.request.requestURI}" />
    <jsp:include page="/WEB-INF/components/navbar.jsp" />

    <div class="container">
        <div class="page-header">
            <h1 class="page-title">My Campaigns</h1>
            <a href="${pageContext.request.contextPath}/create-campaign" class="btn btn-primary">
                <i class="fas fa-plus-circle"></i> Create New Campaign
            </a>
        </div>
        
        <!-- Display error message if any -->
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger">
                ${sessionScope.error}
                <c:remove var="error" scope="session" />
            </div>
        </c:if>
        
        <!-- Display success message if any -->
        <c:if test="${not empty sessionScope.success}">
            <div class="alert alert-success">
                ${sessionScope.success}
                <c:remove var="success" scope="session" />
            </div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty campaigns}">
                <!-- Empty state if no campaigns -->
                <div class="empty-state">
                    <div class="empty-state-icon">
                        <i class="fas fa-bullhorn"></i>
                    </div>
                    <div class="empty-state-message">
                        You haven't created any campaigns yet.
                    </div>
                    <a href="${pageContext.request.contextPath}/create-campaign" class="btn btn-primary">
                        Create Your First Campaign
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Display campaigns in a grid -->
                <div class="campaign-grid">
                    <c:forEach var="campaign" items="${campaigns}">
                        <div class="card">
                            <c:choose>
                                <c:when test="${not empty campaign.campaign_image_url}">
                                    <img src="${campaign.campaign_image_url}" alt="${campaign.title}" class="campaign-card-img">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/img/default-campaign.jpg" alt="${campaign.title}" class="campaign-card-img">
                                </c:otherwise>
                            </c:choose>
                            
                            <div class="campaign-card-body">
                                <h3 class="campaign-card-title">${campaign.title}</h3>
                                
                                <div class="campaign-card-meta">
                                    <span><i class="far fa-calendar-alt"></i> Deadline: <fmt:formatDate value="${campaign.deadline}" pattern="MMM dd, yyyy" /></span>
                                    <span class="status-badge status-${campaign.status}">${campaign.status}</span>
                                </div>
                                
                                <p class="campaign-card-description">${campaign.description}</p>
                                
                                <div class="campaign-progress">
                                    <div class="campaign-progress-bar" style="width: ${campaign.progressPercentage}%"></div>
                                </div>
                                
                                <div class="campaign-stats">
                                    <span><strong><fmt:formatNumber value="${campaign.collectedAmount}" type="currency" currencySymbol="NPR " /></strong> raised</span>
                                    <span><strong><fmt:formatNumber value="${campaign.goal_amount}" type="currency" currencySymbol="NPR " /></strong> goal</span>
                                    <span><strong>${campaign.progressPercentage}%</strong> funded</span>
                                </div>
                                
                                <div class="campaign-actions">
                                    <a href="${pageContext.request.contextPath}/campaign?id=${campaign.campaign_id}" class="btn btn-secondary">View Details</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html> 
