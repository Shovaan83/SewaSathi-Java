<%--
  Created by IntelliJ IDEA.
  User: koira
  Date: 4/1/2025
  Time: 3:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get user from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        // User not logged in, redirect to LoginServlet
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    // Get the first letter of the user's name for the avatar
    String firstLetter = "";
    if (user.getFullName() != null && !user.getFullName().isEmpty()) {
        firstLetter = user.getFullName().substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Backer Profile | <%= user.getFullName() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        :root {
            --primary: #2f80ed;
            --primary-dark: #1a73e8;
            --secondary: #34ca96;
            --text-dark: #333;
            --text-light: #666;
            --background: #f8f9fa;
            --danger: #e74c3c;
            --success: #27ae60;
            --warning: #f39c12;
            --light-gray: #e9ecef;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--background);
            color: var(--text-dark);
        }
        
        .crowdfund-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: white;
            padding: 15px 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
        }
        
        .logo span {
            color: var(--secondary);
        }
        
        .top-nav-links a {
            margin-left: 20px;
            text-decoration: none;
            color: var(--text-dark);
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .top-nav-links a:hover {
            color: var(--primary);
        }
        
        .profile-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border-radius: 10px;
            padding: 40px 20px;
            text-align: center;
            margin-bottom: 30px;
            position: relative;
        }
        
        .campaign-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: var(--text-light);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .profile-sections {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }
        
        .profile-section, .sidebar-section {
            background-color: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 1.2rem;
            margin-top: 0;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--light-gray);
            color: var(--primary);
        }
        
        .profile-detail {
            display: flex;
            margin-bottom: 15px;
            align-items: flex-start;
        }
        
        .detail-label {
            width: 140px;
            font-weight: 500;
            color: var(--text-light);
            flex-shrink: 0;
        }
        
        .detail-value {
            flex-grow: 1;
        }
        
        .button-primary {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        
        .button-primary:hover {
            background-color: var(--primary-dark);
        }
        
        .button-secondary {
            background-color: white;
            color: var(--primary);
            border: 1px solid var(--primary);
            padding: 12px 24px;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
            margin-bottom: 10px;
        }
        
        .button-secondary:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .button-danger {
            background-color: white;
            color: var(--danger);
            border: 1px solid var(--danger);
            padding: 12px 24px;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .button-danger:hover {
            background-color: var(--danger);
            color: white;
        }
        
        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            margin-bottom: 20px;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        
        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: var(--secondary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 500;
            margin-bottom: 20px;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            position: relative;
        }
        
        .close {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 1.5rem;
            cursor: pointer;
        }
        
        .modal-title {
            margin-top: 0;
            margin-bottom: 20px;
            color: var(--text-dark);
            font-size: 1.4rem;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--light-gray);
            border-radius: 5px;
            font-size: 1rem;
        }
        
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 30px;
        }
        
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background-color: rgba(39, 174, 96, 0.1);
            color: var(--success);
            border: 1px solid var(--success);
        }
        
        .alert-error {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger);
            border: 1px solid var(--danger);
        }
        
        .fund-progress {
            background-color: var(--light-gray);
            height: 8px;
            border-radius: 4px;
            margin-top: 20px;
            overflow: hidden;
        }
        
        .progress-bar {
            height: 100%;
            background-color: var(--secondary);
            width: 78%; /* Example value */
        }
        
        .project-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
            transition: transform 0.3s;
        }
        
        .project-card:hover {
            transform: translateY(-5px);
        }
        
        .project-image {
            height: 160px;
            overflow: hidden;
        }
        
        .project-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .project-info {
            padding: 20px;
        }
        
        .project-info h3 {
            margin-top: 0;
            font-size: 1.1rem;
        }
        
        .project-info p {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.7rem;
            font-weight: 500;
            margin-right: 5px;
        }
        
        .badge-primary {
            background-color: rgba(47, 128, 237, 0.1);
            color: var(--primary);
        }
        
        .badge-success {
            background-color: rgba(52, 202, 150, 0.1);
            color: var(--secondary);
        }
    </style>
</head>
<body>

<div class="crowdfund-container">
    <div class="top-nav">
        <div class="logo">Sewa<span>Sathi</span></div>
        <div class="top-nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home"></i> Dashboard</a>
            <a href="#"><i class="fas fa-compass"></i> Discover</a>
            <a href="#"><i class="fas fa-lightbulb"></i> Start a Campaign</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <!-- Display success message if present -->
    <% if (request.getParameter("success") != null) { %>
    <div class="alert alert-success">
        <%= request.getParameter("success") %>
    </div>
    <% } %>

    <!-- Display error message if present -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="profile-header">
        <% if (user.getProfilePicture() != null && user.getProfilePicture().length > 0) { %>
        <div class="profile-image">
            <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(user.getProfilePicture()) %>" alt="Profile Picture">
        </div>
        <% } else { %>
        <div class="avatar">
            <%= firstLetter %>
        </div>
        <% } %>

        <h1><%= user.getFullName() %></h1>
        <p>@<%= user.getUsername() %></p>
    </div>

    <div class="campaign-stats">
        <div class="stat-card">
            <div class="stat-value">3</div>
            <div class="stat-label">Projects Backed</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">₹15,000</div>
            <div class="stat-label">Total Contributions</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">1</div>
            <div class="stat-label">Campaigns Created</div>
        </div>
    </div>

    <div class="profile-sections">
        <div>
            <div class="profile-section">
                <h2 class="section-title">Your Campaign</h2>
                <div class="project-card">
                    <div class="project-image">
                        <img src="https://images.unsplash.com/photo-1593113598332-cd288d649433?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80" alt="Campaign Image">
                    </div>
                    <div class="project-info">
                        <span class="badge badge-success">Active</span>
                        <h3>Community Garden Initiative</h3>
                        <p>Creating sustainable community gardens in urban neighborhoods</p>
                        <div class="fund-progress">
                            <div class="progress-bar"></div>
                        </div>
                        <p><strong>₹45,000</strong> raised of ₹60,000 goal</p>
                    </div>
                </div>
                
                <h2 class="section-title">Recently Backed</h2>
                <div class="project-card">
                    <div class="project-image">
                        <img src="https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80" alt="Project Image">
                    </div>
                    <div class="project-info">
                        <span class="badge badge-primary">Technology</span>
                        <h3>Eco-Friendly Solar Charger</h3>
                        <p>Portable solar charger for all your devices</p>
                        <div class="fund-progress">
                            <div class="progress-bar" style="width: 65%"></div>
                        </div>
                        <p><strong>₹32,500</strong> raised of ₹50,000 goal</p>
                    </div>
                </div>
            </div>
        </div>
        
        <div>
            <div class="sidebar-section">
                <h2 class="section-title">Account Information</h2>
                
                <div class="profile-detail">
                    <div class="detail-label">Username</div>
                    <div class="detail-value"><%= user.getUsername() %></div>
                </div>
                
                <div class="profile-detail">
                    <div class="detail-label">Email</div>
                    <div class="detail-value"><%= user.getEmail() %></div>
                </div>
                
                <div class="profile-detail">
                    <div class="detail-label">Full Name</div>
                    <div class="detail-value"><%= user.getFullName() != null ? user.getFullName() : "Not provided" %></div>
                </div>
                
                <div class="profile-detail">
                    <div class="detail-label">Phone</div>
                    <div class="detail-value"><%= user.getPhone() != null && !user.getPhone().isEmpty() ? user.getPhone() : "Not provided" %></div>
                </div>
                
                <div class="profile-detail">
                    <div class="detail-label">Address</div>
                    <div class="detail-value"><%= user.getAddress() != null && !user.getAddress().isEmpty() ? user.getAddress() : "Not provided" %></div>
                </div>
                
                <a href="${pageContext.request.contextPath}/UpdateProfileServlet" class="button-primary">Edit Profile</a>
                <a href="${pageContext.request.contextPath}/ResetPasswordServlet" class="button-secondary">Change Password</a>
                <button id="deleteAccountBtn" class="button-danger">Delete Account</button>
            </div>
        </div>
    </div>
</div>

<!-- Delete Account Modal -->
<div id="deleteAccountModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h2 class="modal-title">Verify Password</h2>
        <p>Please enter your password to proceed to account deletion.</p>

        <form id="passwordForm" action="${pageContext.request.contextPath}/DeleteAccountServlet" method="get" class="form">
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <div class="modal-actions">
                <button type="button" class="button-secondary" id="cancelDelete">Cancel</button>
                <button type="submit" class="button-danger">Continue</button>
            </div>
        </form>
    </div>
</div>

<script>
    // Get the modal
    const modal = document.getElementById("deleteAccountModal");

    // Get the button that opens the modal
    const btn = document.getElementById("deleteAccountBtn");

    // Get the <span> element that closes the modal
    const span = document.getElementsByClassName("close")[0];

    // Get the cancel button
    const cancelBtn = document.getElementById("cancelDelete");

    // When the user clicks the button, open the modal
    btn.onclick = function() {
        modal.style.display = "block";
    }

    // When the user clicks on <span> (x), close the modal
    span.onclick = function() {
        modal.style.display = "none";
    }

    // When the user clicks on cancel, close the modal
    cancelBtn.onclick = function() {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>
