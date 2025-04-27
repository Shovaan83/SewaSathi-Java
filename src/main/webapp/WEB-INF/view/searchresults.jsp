<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results | SewaSathi</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <jsp:include page="../components/navbar.jsp" />
    
    <div class="container my-5">
        <h2 class="mb-4">Search Results for "${searchQuery}"</h2>
        
        <c:if test="${empty searchResults}">
            <div class="alert alert-info">
                <p>No campaigns found matching your search criteria.</p>
                <p><a href="${pageContext.request.contextPath}/campaigns" class="btn btn-primary mt-2">View All Campaigns</a></p>
            </div>
        </c:if>
        
        <c:if test="${not empty searchResults}">
            <p>Found ${searchResults.size()} result(s).</p>
            
            <div class="row row-cols-1 row-cols-md-3 g-4">
                <c:forEach var="campaign" items="${searchResults}">
                    <div class="col">
                        <div class="card h-100 shadow-sm">
                            <c:if test="${not empty campaign.campaign_image_url}">
                                <img src="${campaign.campaign_image_url}" class="card-img-top" alt="${campaign.title}" style="height: 200px; object-fit: cover;">
                            </c:if>
                            <c:if test="${empty campaign.campaign_image_url}">
                                <div class="bg-light text-center py-5">
                                    <i class="fas fa-image fa-3x text-muted"></i>
                                </div>
                            </c:if>
                            <div class="card-body">
                                <h5 class="card-title">${campaign.title}</h5>
                                <p class="card-text">${campaign.description.length() > 100 ? campaign.description.substring(0, 100).concat('...') : campaign.description}</p>
                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="${pageContext.request.contextPath}/campaign?id=${campaign.campaign_id}" class="btn btn-primary">View Details</a>
                                    <small class="text-muted">Goal: NPR ${campaign.goal_amount}</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
    
    <jsp:include page="../components/footer.jsp" />
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 