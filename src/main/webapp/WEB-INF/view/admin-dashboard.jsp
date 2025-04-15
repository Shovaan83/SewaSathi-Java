<%@ page import="model.User, java.util.List, java.util.Base64" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | Sewa Sathi</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --accent-color: #e74c3c;
            --bg-color: #f5f7fa;
            --text-color: #333;
            --border-color: #ddd;
            --success-color: #27ae60;
            --warning-color: #f39c12;
            --error-color: #c0392b;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        
        .header h1 {
            color: var(--primary-color);
            margin: 0;
        }
        
        .nav-links {
            display: flex;
            gap: 1rem;
        }
        
        .nav-links a {
            color: var(--primary-color);
            text-decoration: none;
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        
        .nav-links a:hover {
            background-color: rgba(0, 0, 0, 0.05);
        }
        
        .nav-links a.active {
            background-color: var(--primary-color);
            color: white;
        }
        
        .message {
            padding: 1rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .users-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        
        .users-table th, .users-table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        
        .users-table th {
            background-color: var(--primary-color);
            color: white;
            font-weight: 500;
        }
        
        .users-table tr:last-child td {
            border-bottom: none;
        }
        
        .users-table tr:hover {
            background-color: rgba(0, 0, 0, 0.02);
        }
        
        .user-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .user-actions a, .user-actions button {
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.85rem;
            cursor: pointer;
            border: none;
            background-color: var(--primary-color);
            color: white;
        }
        
        .user-actions a.delete, .user-actions button.delete {
            background-color: var(--error-color);
        }
        
        .user-actions a.role, .user-actions button.role {
            background-color: var(--warning-color);
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
            font-weight: 500;
            font-size: 1.2rem;
        }
        
        .admin-badge {
            background-color: var(--primary-color);
            color: white;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-size: 0.85rem;
            display: inline-block;
        }
        
        .profile-pic {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        .dashboard-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background-color: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .stat-card h3 {
            margin-top: 0;
            color: var(--primary-color);
            font-size: 1rem;
            font-weight: 500;
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--accent-color);
            margin-bottom: 0.5rem;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .users-table {
                display: block;
                overflow-x: auto;
            }
            
            .dashboard-stats {
                grid-template-columns: 1fr;
            }
            
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <header class="header">
        <h1>Admin Dashboard</h1>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/UserProfileServlet">My Profile</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
        </div>
    </header>
    
    <% if (request.getAttribute("message") != null) { %>
    <div class="message">
        <%= request.getAttribute("message") %>
    </div>
    <% } %>
    
    <%
        List<User> users = (List<User>) request.getAttribute("users");
        int totalUsers = users.size();
        int adminUsers = 0;
        int regularUsers = 0;
        
        for (User u : users) {
            if (u.isAdmin()) {
                adminUsers++;
            } else {
                regularUsers++;
            }
        }
    %>
    
    <div class="dashboard-stats">
        <div class="stat-card">
            <h3>Total Users</h3>
            <div class="stat-value"><%= totalUsers %></div>
        </div>
        <div class="stat-card">
            <h3>Administrators</h3>
            <div class="stat-value"><%= adminUsers %></div>
        </div>
        <div class="stat-card">
            <h3>Regular Users</h3>
            <div class="stat-value"><%= regularUsers %></div>
        </div>
    </div>
    
    <h2>User Management</h2>
    <table class="users-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Profile</th>
                <th>Username</th>
                <th>Email</th>
                <th>Full Name</th>
                <th>Role</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <% 
                User currentUser = (User) session.getAttribute("user");
                for (User user : users) {
                    String profilePic = "";
                    String firstLetter = "";
                    
                    if (user.getFullName() != null && !user.getFullName().isEmpty()) {
                        firstLetter = user.getFullName().substring(0, 1).toUpperCase();
                    } else if (user.getUsername() != null && !user.getUsername().isEmpty()) {
                        firstLetter = user.getUsername().substring(0, 1).toUpperCase();
                    }
            %>
            <tr>
                <td><%= user.getId() %></td>
                <td>
                    <% if (user.getProfilePicture() != null && user.getProfilePicture().length > 0) { %>
                        <img src="data:image/jpeg;base64,<%= Base64.getEncoder().encodeToString(user.getProfilePicture()) %>" alt="Profile Picture" class="profile-pic">
                    <% } else { %>
                        <div class="avatar"><%= firstLetter %></div>
                    <% } %>
                </td>
                <td><%= user.getUsername() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getFullName() != null ? user.getFullName() : "-" %></td>
                <td>
                    <% if (user.isAdmin()) { %>
                        <span class="admin-badge">Admin</span>
                    <% } else { %>
                        Regular
                    <% } %>
                </td>
                <td>
                    <div class="user-actions">
                        <% if (user.getId() != currentUser.getId()) { %>
                            <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=toggleAdmin&userId=<%= user.getId() %>" class="role">
                                <%= user.isAdmin() ? "Remove Admin" : "Make Admin" %>
                            </a>
                            <a href="${pageContext.request.contextPath}/AdminDashboardServlet?action=delete&userId=<%= user.getId() %>" class="delete" 
                               onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                        <% } else { %>
                            <span>Current User</span>
                        <% } %>
                    </div>
                </td>
            </tr>
            <% } %>
        </tbody>
    </table>
</div>
</body>
</html> 