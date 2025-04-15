
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
    <title>Reset Password | <%= user.getFullName() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .password-guidelines {
            margin-top: var(--spacing-xl);
            padding: var(--spacing-md);
            background-color: var(--background);
            border-left: 3px solid var(--primary-color);
        }

        .password-guidelines h3 {
            font-family: var(--font-serif);
            color: var(--primary-color);
            margin-bottom: var(--spacing-sm);
            font-size: 1.1rem;
        }

        .password-guidelines ul {
            padding-left: var(--spacing-md);
        }

        .password-guidelines li {
            margin-bottom: var(--spacing-xs);
            color: var(--light-text);
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="container profile-container">
    <div class="profile-header">
        <div class="back-link">
            <a href="${pageContext.request.contextPath}/UserProfileServlet" class="subtle-link">&larr; Back to Profile</a>
        </div>

        <% if (user.getProfilePicture() != null && user.getProfilePicture().length > 0) { %>
        <div class="profile-image large">
            <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(user.getProfilePicture()) %>" alt="Profile Picture" class="profile-pic">
        </div>
        <% } else { %>
        <div class="avatar large">
            <%= firstLetter %>
        </div>
        <% } %>

        <h1 class="profile-name">Reset Password</h1>
        <p class="profile-username">@<%= user.getUsername() %></p>
    </div>

    <!-- Display error message if present -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <form action="${pageContext.request.contextPath}/ResetPasswordServlet" method="post" class="form">
        <div class="form-section">
            <div class="form-section-title">Password Reset</div>

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
            <button type="submit" class="btn btn-primary">Reset Password</button>
            <a href="${pageContext.request.contextPath}/UserProfileServlet" class="btn btn-secondary">Cancel</a>
        </div>
    </form>

    <div class="password-guidelines">
        <h3>Password Guidelines</h3>
        <ul>
            <li>Use at least 8 characters</li>
            <li>Include uppercase and lowercase letters</li>
            <li>Include at least one number</li>
            <li>Include at least one special character</li>
            <li>Avoid using easily guessable information</li>
        </ul>
    </div>
</div>

</body>
</html>
