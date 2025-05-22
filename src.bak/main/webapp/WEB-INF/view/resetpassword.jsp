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
    <title>Reset Password | <%= user.getFull_name() %></title>
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
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .back-link {
            margin-bottom: 1.5rem;
        }
        
        .back-link a {
            color: var(--primary-color);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            font-weight: 500;
            transition: var(--transition);
        }
        
        .back-link a:hover {
            color: var(--secondary-color);
        }
        
        .back-link i {
            margin-right: 0.5rem;
        }
        
        .profile-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: var(--border-radius);
            padding: 2rem;
            text-align: center;
            color: white;
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }
        
        .profile-image {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            overflow: hidden;
            margin: 0 auto 1rem;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }
        
        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .avatar {
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
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .profile-username {
            opacity: 0.8;
            font-size: 1rem;
        }
        
        .form {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            box-shadow: var(--box-shadow);
            margin-bottom: 2rem;
        }
        
        .form-section {
            margin-bottom: 1.5rem;
        }
        
        .form-section-title {
            font-size: 1.2rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #eee;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark-color);
        }
        
        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-family: inherit;
            font-size: 1rem;
            transition: var(--transition);
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
        }
        
        .form-help {
            margin-top: 0.5rem;
            font-size: 0.85rem;
            color: var(--gray-color);
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            border-radius: var(--border-radius);
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-family: inherit;
            font-size: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
        }
        
        .btn-secondary {
            background-color: #f8f9fa;
            color: var(--dark-color);
            border: 1px solid #ddd;
        }
        
        .btn-secondary:hover {
            background-color: #e9ecef;
        }
        
        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        
        .alert-error {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(220, 53, 69, 0.2);
        }
        
        .password-guidelines {
            background-color: #f8f9fa;
            border-radius: var(--border-radius);
            padding: 1.5rem;
            border-left: 4px solid var(--primary-color);
        }
        
        .password-guidelines h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }
        
        .password-guidelines ul {
            padding-left: 1.5rem;
        }
        
        .password-guidelines li {
            margin-bottom: 0.5rem;
            color: var(--gray-color);
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<div class="container">
    <div class="back-link">
        <a href="${pageContext.request.contextPath}/UserProfileServlet">
            <i class="fas fa-arrow-left"></i> Back to Profile
        </a>
    </div>

    <div class="profile-header">
        <% if (user.getProfile_picture_url() != null && !user.getProfile_picture_url().isEmpty()) { %>
        <div class="profile-image">
            <img src="<%= user.getProfile_picture_url() %>" alt="Profile Picture">
        </div>
        <% } else { %>
        <div class="avatar">
            <%= firstLetter %>
        </div>
        <% } %>

        <h1 class="profile-name">Reset Password</h1>
        <p class="profile-username">@<%= user.getEmail() %></p>
    </div>

    <!-- Display error message if present -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="post" class="form">
        
        <div class="form-section">
            <div class="form-section-title">Change Your Password</div>

            <div class="form-group">
                <label for="currentPassword">Current Password*</label>
                <input type="password" id="currentPassword" name="currentPassword" required>
                <p class="form-help">Enter your current password for verification</p>
            </div>

            <div class="form-group">
                <label for="newPassword">New Password*</label>
                <input type="password" id="newPassword" name="newPassword" required>
                <p class="form-help">Choose a strong password with at least 8 characters</p>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm New Password*</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
                <p class="form-help">Re-enter your new password to confirm</p>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">
                <i class="fas fa-key"></i> Update Password
            </button>
            <a href="${pageContext.request.contextPath}/UserProfileServlet" class="btn btn-secondary">
                <i class="fas fa-times"></i> Cancel
            </a>
        </div>
    </form>

    <div class="password-guidelines">
        <h3><i class="fas fa-shield-alt"></i> Password Guidelines</h3>
        <ul>
            <li>Use at least 8 characters</li>
            <li>Include uppercase and lowercase letters</li>
            <li>Include at least one number</li>
            <li>Include at least one special character</li>
            <li>Avoid using easily guessable information</li>
        </ul>
    </div>
</div>

<jsp:include page="/WEB-INF/components/footer.jsp" />
</body>
</html>
