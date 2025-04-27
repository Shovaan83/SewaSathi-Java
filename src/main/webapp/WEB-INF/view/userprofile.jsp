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
    if (user.getFull_name() != null && !user.getFull_name().isEmpty()) {
        firstLetter = user.getFull_name().substring(0, 1).toUpperCase();
    } else {
        firstLetter = user.getEmail().substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile | <%= user.getFull_name() %></title>
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
            color: var(--text-dark);
            line-height: 1.6;
            background-color: var(--gray-light);
        }

        a {
            text-decoration: none;
            color: inherit;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }

        /* Header & Navigation */
        header {
            background-color: var(--background);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            position: sticky;
            top: 0;
            z-index: 100;
            padding: 1rem 0;
        }

        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo-text {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary);
        }

        .logo-text span {
            color: var(--text-dark);
        }

        .search-container {
            display: flex;
            align-items: center;
            border: 1px solid var(--border-color);
            border-radius: 50px;
            padding: 0.5rem 1rem;
            width: 300px;
        }

        .search-container input {
            border: none;
            outline: none;
            width: 100%;
            font-size: 0.9rem;
            margin-left: 0.5rem;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .nav-link {
            font-size: 0.95rem;
            font-weight: 500;
            color: var(--text-dark);
            transition: color 0.3s ease;
        }

        .nav-link:hover {
            color: var(--primary);
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 500;
            font-size: 1rem;
            margin-right: 10px;
        }

        .user-dropdown {
            position: relative;
            display: inline-block;
        }

        .user-trigger {
            display: flex;
            align-items: center;
            cursor: pointer;
            padding: 5px;
            border-radius: 50px;
            transition: background-color 0.3s;
        }

        .user-trigger:hover {
            background-color: var(--gray-light);
        }

        .user-trigger i {
            margin-left: 5px;
            font-size: 0.8rem;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            right: 0;
            background-color: white;
            min-width: 180px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            z-index: 1000;
            display: none;
            padding: 10px 0;
            margin-top: 10px;
        }

        .dropdown-menu a {
            display: block;
            padding: 10px 20px;
            font-size: 0.9rem;
            transition: background-color 0.3s;
        }

        .dropdown-menu a:hover {
            background-color: var(--gray-light);
        }

        .dropdown-divider {
            height: 1px;
            background-color: var(--gray-medium);
            margin: 5px 0;
        }

        .user-dropdown:hover .dropdown-menu {
            display: none;
        }

        .dropdown-menu.show {
            display: block;
        }

        .btn {
            padding: 0.6rem 1.2rem;
            border-radius: 50px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.95rem;
            display: inline-block;
            text-align: center;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            border: 1px solid var(--primary);
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
            border-color: var(--primary-dark);
        }

        .btn-outline {
            background-color: transparent;
            color: var(--text-dark);
            border: 1px solid var(--border-color);
        }

        .btn-outline:hover {
            background-color: var(--gray-light);
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
            border: 1px solid #dc3545;
        }

        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }

        /* Profile Page Styles */
        .profile-container {
            max-width: 1000px;
            margin: 2rem auto;
            background-color: var(--background);
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .profile-header {
            background-color: var(--primary-light);
            padding: 2rem;
            color: var(--text-dark);
            position: relative;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: var(--primary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 3rem;
            margin: 0 auto 1rem;
            border: 5px solid white;
        }

        .profile-name {
            font-size: 2rem;
            font-weight: 700;
            text-align: center;
            margin-bottom: 0.5rem;
        }

        .profile-username {
            font-size: 1.1rem;
            color: var(--text-light);
            text-align: center;
            margin-bottom: 1rem;
        }

        .profile-stats {
            display: flex;
            justify-content: center;
            gap: 2rem;
            margin-top: 1.5rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-dark);
        }

        .stat-label {
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .profile-content {
            padding: 2rem;
        }

        .section-heading {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--text-dark);
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.5rem;
        }

        .account-info {
            margin-bottom: 2rem;
        }

        .info-item {
            display: flex;
            margin-bottom: 1rem;
        }

        .info-label {
            width: 140px;
            font-weight: 500;
            color: var(--text-light);
        }

        .info-value {
            color: var(--text-dark);
        }

        .profile-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        /* Modal Styles */
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal {
            background-color: white;
            border-radius: 10px;
            max-width: 500px;
            width: 100%;
            padding: 2rem;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            margin-bottom: 1.5rem;
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--text-dark);
        }

        .modal-body {
            margin-bottom: 1.5rem;
            color: var(--text-light);
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
        }

        /* Footer */
        footer {
            background-color: var(--text-dark);
            color: white;
            padding: 4rem 0 2rem;
            margin-top: 4rem;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .footer-logo-text {
            font-size: 1.8rem;
            font-weight: 700;
            color: white;
            margin-bottom: 1rem;
        }

        .footer-logo-text span {
            color: var(--primary);
        }

        .footer-about {
            color: #adb5bd;
            font-size: 0.9rem;
            max-width: 300px;
            line-height: 1.6;
        }

        .footer-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        .footer-links a {
            display: block;
            color: #adb5bd;
            margin-bottom: 0.8rem;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .footer-links a:hover {
            color: white;
        }

        .contact-info {
            display: flex;
            align-items: flex-start;
            margin-bottom: 1rem;
            color: #adb5bd;
            font-size: 0.9rem;
        }

        .contact-info i {
            margin-right: 0.8rem;
            margin-top: 0.3rem;
        }

        .footer-bottom {
            border-top: 1px solid #495057;
            padding-top: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.8rem;
            color: #adb5bd;
        }

        .social-icons {
            display: flex;
            gap: 1rem;
        }

        .social-icons a {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background-color: #343a40;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background-color 0.3s ease;
        }

        .social-icons a:hover {
            background-color: var(--primary);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .search-container {
                display: none;
            }

            .nav-links {
                gap: 1rem;
            }

            .profile-stats {
                flex-direction: column;
                gap: 1rem;
            }

            .profile-actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
                text-align: center;
            }
        }

        @media (max-width: 576px) {
            .nav-link {
                display: none;
            }

            .profile-header {
                padding: 1.5rem;
            }

            .profile-avatar {
                width: 100px;
                height: 100px;
                font-size: 2.5rem;
            }

            .profile-name {
                font-size: 1.5rem;
            }

            .footer-bottom {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
        }

        /* Profile styles updated to match project theme */
        .profile-section {
            padding: 2rem 0;
        }
        
        .profile-container {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
        }
        
        .profile-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 3rem 2rem;
            text-align: center;
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: 500;
            margin: 0 auto 1rem;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }
        
        .profile-name {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .profile-username {
            opacity: 0.8;
            font-size: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .profile-stats {
            display: flex;
            justify-content: center;
            gap: 2rem;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .stat-label {
            font-size: 0.85rem;
            opacity: 0.8;
        }
        
        .profile-content {
            padding: 2rem;
        }
        
        .section-heading {
            font-size: 1.25rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            font-weight: 600;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #eee;
        }
        
        .info-item {
            display: flex;
            margin-bottom: 1rem;
        }
        
        .info-label {
            width: 120px;
            font-weight: 500;
            color: var(--dark-color);
        }
        
        .info-value {
            flex: 1;
            color: var(--gray-color);
        }
        
        .profile-actions {
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 500;
            text-align: center;
            cursor: pointer;
            transition: var(--transition);
            font-family: inherit;
            font-size: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
            border: none;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
        }
        
        .btn-outline {
            background-color: transparent;
            color: var(--dark-color);
            border: 1px solid #ddd;
        }
        
        .btn-outline:hover {
            background-color: #f8f9fa;
        }
        
        .btn-danger {
            background-color: transparent;
            color: var(--danger-color);
            border: 1px solid var(--danger-color);
        }
        
        .btn-danger:hover {
            background-color: var(--danger-color);
            color: white;
        }
        
        /* Modal styles */
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        .modal {
            background-color: white;
            border-radius: var(--border-radius);
            width: 90%;
            max-width: 500px;
            box-shadow: var(--box-shadow);
            overflow: hidden;
        }
        
        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid #eee;
        }
        
        .modal-title {
            margin: 0;
            color: var(--dark-color);
        }
        
        .modal-body {
            padding: 1.5rem;
            color: var(--gray-color);
        }
        
        .modal-footer {
            padding: 1.5rem;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
        }
        
        @media (max-width: 768px) {
            .profile-stats {
                flex-direction: column;
                gap: 1rem;
            }
            
            .profile-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<!-- Profile Section -->
<section class="profile-section">
    <div class="container">
        <div class="profile-container">
            <div class="profile-header">
                <div class="profile-avatar">
                    <%= firstLetter %>
                </div>
                <h1 class="profile-name"><%= user.getFull_name() != null ? user.getFull_name() : "No Name Set" %></h1>
                <p class="profile-username">@<%= user.getEmail() %></p>

                <div class="profile-stats">
                    <div class="stat-item">
                        <div class="stat-value">12</div>
                        <div class="stat-label">Projects Backed</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">32</div>
                        <div class="stat-label">Following</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-value">Rs 25,000</div>
                        <div class="stat-label">Total Contribution</div>
                    </div>
                </div>
            </div>

            <div class="profile-content">
                <div class="account-info">
                    <h2 class="section-heading">Account Information</h2>
                    <div class="info-item">
                        <div class="info-label">Full Name:</div>
                        <div class="info-value"><%= user.getFull_name() != null ? user.getFull_name() : "Not set" %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Username:</div>
                        <div class="info-value"><%= user.getEmail() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Email:</div>
                        <div class="info-value"><%= user.getEmail() %></div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Member Since:</div>
                        <div class="info-value">March 18, 2024</div>
                    </div>
                </div>

                <div class="profile-actions">
                    <a href="${pageContext.request.contextPath}/UpdateProfileServlet" class="btn btn-primary">
                        <i class="fas fa-edit"></i> Edit Profile
                    </a>
                    <a href="${pageContext.request.contextPath}/ResetPasswordServlet" class="btn btn-outline">
                        <i class="fas fa-key"></i> Change Password
                    </a>
                    <button id="deleteAccountBtn" class="btn btn-danger">
                        <i class="fas fa-trash-alt"></i> Delete Account
                    </button>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Delete Account Modal -->
<div id="deleteAccountModal" class="modal-backdrop">
    <div class="modal">
        <div class="modal-header">
            <h3 class="modal-title">Delete Account</h3>
        </div>
        <div class="modal-body">
            <p>Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.</p>
        </div>
        <div class="modal-footer">
            <button id="cancelDeleteBtn" class="btn btn-outline">Cancel</button>
            <a href="${pageContext.request.contextPath}/DeleteAccountServlet" class="btn btn-danger">Delete Account</a>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/components/footer.jsp" />

<script>
    // Delete Account Modal
    const deleteAccountBtn = document.getElementById('deleteAccountBtn');
    const deleteAccountModal = document.getElementById('deleteAccountModal');
    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');

    deleteAccountBtn.addEventListener('click', function() {
        deleteAccountModal.style.display = 'flex';
    });

    cancelDeleteBtn.addEventListener('click', function() {
        deleteAccountModal.style.display = 'none';
    });

    deleteAccountModal.addEventListener('click', function(e) {
        if (e.target === deleteAccountModal) {
            deleteAccountModal.style.display = 'none';
        }
    });

    // User Dropdown Toggle
    const userTrigger = document.querySelector('.user-trigger');
    const dropdownMenu = document.querySelector('.dropdown-menu');

    // Toggle dropdown on user avatar click
    userTrigger.addEventListener('click', function(e) {
        e.stopPropagation();
        dropdownMenu.classList.toggle('show');
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!userTrigger.contains(e.target) && !dropdownMenu.contains(e.target)) {
            dropdownMenu.classList.remove('show');
        }
    });
</script>
</body>
</html>
