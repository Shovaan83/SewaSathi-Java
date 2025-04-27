<%@ page import="model.User, java.util.List, model.Campaign" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - SewaSathi</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #ff6b6b;
            --secondary-color: #ff8e8e;
            --dark-color: #2d3748;
            --light-color: #f8f9fa;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --gray-color: #6c757d;
            --border-radius: 0.5rem;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            width: 100%;
            padding-right: 15px;
            padding-left: 15px;
            margin-right: auto;
            margin-left: auto;
            max-width: 1200px;
        }
        
        .header {
            background-color: #fff;
            box-shadow: var(--box-shadow);
            padding: 1rem 0;
            margin-bottom: 2rem;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            text-decoration: none;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }
        
        .username {
            font-weight: 600;
        }
        
        .dashboard {
            display: grid;
            grid-template-columns: 250px 1fr;
            gap: 2rem;
        }
        
        .sidebar {
            background-color: #fff;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
        }
        
        .sidebar-menu {
            list-style: none;
        }
        
        .sidebar-menu li {
            margin-bottom: 0.5rem;
        }
        
        .sidebar-menu a {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            color: var(--dark-color);
            text-decoration: none;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }
        
        .sidebar-menu a:hover, .sidebar-menu a.active {
            background-color: var(--primary-color);
            color: white;
        }
        
        .sidebar-menu i {
            width: 20px;
            text-align: center;
        }
        
        .main-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }
        
        .card {
            background-color: #fff;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
            height: 100%;
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #eee;
        }
        
        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .card-icon {
            font-size: 1.5rem;
            color: var(--primary-color);
        }
        
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .stat-card {
            background-color: #fff;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1rem;
            text-align: center;
            transition: var(--transition);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-label {
            font-size: 0.875rem;
            color: var(--gray-color);
        }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        th {
            font-weight: 600;
            color: var(--dark-color);
        }
        
        tbody tr:hover {
            background-color: #f9f9f9;
        }
        
        .user-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .user-row .avatar {
            width: 30px;
            height: 30px;
            font-size: 0.75rem;
        }
        
        .badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .badge-success {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .badge-warning {
            background-color: rgba(255, 193, 7, 0.1);
            color: var(--warning-color);
        }
        
        .badge-danger {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }
        
        .btn {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: var(--border-radius);
            font-weight: 500;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            border: none;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
        }
        
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        
        .actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .empty-state {
            text-align: center;
            padding: 2rem 0;
            color: var(--gray-color);
        }
        
        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        @media (max-width: 992px) {
            .dashboard {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                margin-bottom: 1.5rem;
            }
            
            .sidebar-menu {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
            }
            
            .sidebar-menu li {
                margin-bottom: 0;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="container header-content">
            <a href="${pageContext.request.contextPath}/" class="logo">
                <i class="fas fa-hands-helping"></i> SewaSathi Admin
            </a>
            <div class="user-info">
                <div class="avatar">
                    ${firstLetterOfName}
                </div>
                <span class="username">${user.full_name}</span>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-sm btn-primary">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
    </header>
    
    <div class="container">
        <div class="dashboard">
            <aside class="sidebar">
                <ul class="sidebar-menu">
                    <li>
                        <a href="${pageContext.request.contextPath}/AdminDashboardServlet" class="active">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/AdminUsersServlet">
                            <i class="fas fa-users"></i> Users
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/AdminCampaignsServlet">
                            <i class="fas fa-hand-holding-heart"></i> Campaigns
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/AdminDonationsServlet">
                            <i class="fas fa-donate"></i> Donations
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/">
                            <i class="fas fa-home"></i> Back to Site
                        </a>
                    </li>
                </ul>
            </aside>
            
            <main>
                <div class="stat-grid">
                    <div class="stat-card">
                        <div class="stat-value">${totalUsers}</div>
                        <div class="stat-label">Total Users</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">${totalCampaigns}</div>
                        <div class="stat-label">Active Campaigns</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">
                            <c:if test="${recentCampaigns != null && not empty recentCampaigns}">
                                ${recentCampaigns.size()}
                            </c:if>
                            <c:if test="${recentCampaigns == null || empty recentCampaigns}">
                                0
                            </c:if>
                        </div>
                        <div class="stat-label">Recent Campaigns</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-value">
                            <c:if test="${not empty adminCount}">
                                ${adminCount}
                            </c:if>
                            <c:if test="${empty adminCount}">
                                1
                            </c:if>
                        </div>
                        <div class="stat-label">Admin Users</div>
                    </div>
                </div>
                
                <div class="main-content">
                    <!-- Recent Users -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">Recent Users</h2>
                            <i class="fas fa-users card-icon"></i>
                        </div>
                        <div class="card-body">
                            <c:if test="${allUsers != null && not empty allUsers}">
                                <div class="table-responsive">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>User</th>
                                                <th>Email</th>
                                                <th>Role</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="user" items="${allUsers}" varStatus="loop">
                                                <c:if test="${loop.index < 5}">
                                                    <tr>
                                                        <td>
                                                            <div class="user-row">
                                                                <div class="avatar">
                                                                    <c:choose>
                                                                        <c:when test="${user.full_name != null && not empty user.full_name}">
                                                                            ${fn:substring(user.full_name, 0, 1)}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${fn:substring(user.email, 0, 1)}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <span>${user.full_name}</span>
                                                            </div>
                                                        </td>
                                                        <td>${user.email}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${user.isAdmin()}">
                                                                    <span class="badge badge-success">Admin</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge badge-warning">User</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="actions">
                                                                <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=toggleAdmin&userId=${user.user_id}" class="btn btn-sm btn-primary">
                                                                    <i class="fas fa-user-shield"></i>
                                                                </a>
                                                                <c:if test="${user.user_id != sessionScope.user.user_id}">
                                                                    <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=delete&userId=${user.user_id}" 
                                                                       class="btn btn-sm btn-primary" style="background-color: var(--danger-color);"
                                                                       onclick="return confirm('Are you sure you want to delete this user?')">
                                                                        <i class="fas fa-trash"></i>
                                                                    </a>
                                                                </c:if>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div style="margin-top: 1rem; text-align: right;">
                                    <a href="${pageContext.request.contextPath}/AdminUsersServlet" class="btn btn-primary">View All Users</a>
                                </div>
                            </c:if>
                            <c:if test="${allUsers == null || empty allUsers}">
                                <div class="empty-state">
                                    <i class="fas fa-users"></i>
                                    <p>No users found</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Recent Campaigns -->
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">Recent Campaigns</h2>
                            <i class="fas fa-hand-holding-heart card-icon"></i>
                        </div>
                        <div class="card-body">
                            <c:if test="${recentCampaigns != null && not empty recentCampaigns}">
                                <div class="table-responsive">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Campaign</th>
                                                <th>Goal</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="campaign" items="${recentCampaigns}">
                                                <tr>
                                                    <td>${campaign.title}</td>
                                                    <td>Rs. ${campaign.goalAmount}</td>
                                                    <td>
                                                        <span class="badge badge-success">Active</span>
                                                    </td>
                                                    <td>
                                                        <div class="actions">
                                                            <a href="${pageContext.request.contextPath}/CampaignDetailsServlet?id=${campaign.campaignId}" class="btn btn-sm btn-primary">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div style="margin-top: 1rem; text-align: right;">
                                    <a href="${pageContext.request.contextPath}/AdminCampaignsServlet" class="btn btn-primary">View All Campaigns</a>
                                </div>
                            </c:if>
                            <c:if test="${recentCampaigns == null || empty recentCampaigns}">
                                <div class="empty-state">
                                    <i class="fas fa-hand-holding-heart"></i>
                                    <p>No campaigns found</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>
</body>
</html> 