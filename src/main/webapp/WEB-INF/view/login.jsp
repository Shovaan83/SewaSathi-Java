<%--
  Created by IntelliJ IDEA.
  User: koira
  Date: 4/1/2025
  Time: 3:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | SewaSathi Crowdfunding</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>

<div class="page-container">
    <div class="login-wrapper">
        <div class="brand-panel">
            <div class="brand-content">
                <h1 class="brand-logo">SewaSathi</h1>
                <p class="brand-tagline">Funding dreams, supporting communities</p>
                <div class="impact-stats">
                    <div class="stat">
                        <span class="stat-number">7,500+</span>
                        <span class="stat-label">Projects Funded</span>
                    </div>
                    <div class="stat">
                        <span class="stat-number">₹120M+</span>
                        <span class="stat-label">Raised</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="login-panel">
            <div class="login-header">
                <h2 class="login-title">Welcome Back</h2>
                <p class="login-subtitle">Sign in to continue to your account</p>
            </div>

            <div class="notification-area">
                <!-- Display success message if present -->
                <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success">
                    <span class="alert-icon">✓</span>
                    <span class="alert-message"><%= request.getAttribute("success") %></span>
                </div>
                <% } %>
                <!-- Display registration success message if present -->
                <% if (request.getAttribute("registrationSuccess") != null) { %>
                <div class="alert alert-success">
                    <span class="alert-icon">✓</span>
                    <span class="alert-message"><%= request.getAttribute("registrationSuccess") %></span>
                </div>
                <% } %>
                <!-- Display error message if present -->
                <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <span class="alert-icon">!</span>
                    <span class="alert-message"><%= request.getAttribute("error") %></span>
                </div>
                <% } %>
            </div>

            <div class="login-form-wrapper">
                <form action="${pageContext.request.contextPath}/LoginServlet" method="post" class="login-form">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-container">
                            <span class="input-icon user-icon"></span>
                            <input type="text" id="username" name="username" placeholder="Enter your username" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-container">
                            <span class="input-icon password-icon"></span>
                            <input type="password" id="password" name="password" placeholder="Enter your password" required>
                        </div>
                    </div>

                    <div class="form-actions">
                        <div class="remember-me-group">
                            <label class="remember-me-label">
                                <input type="checkbox" id="rememberMe" name="rememberMe">
                                <span class="checkmark"></span>
                                <span class="remember-text">Remember me</span>
                            </label>
                        </div>
                        <a href="#" class="forgot-password">Forgot password?</a>
                    </div>

                    <button type="submit" class="btn btn-primary">Sign In</button>
                </form>
            </div>

            <div class="form-footer">
                <p>Don't have an account? <a href="${pageContext.request.contextPath}/RegisterServlet" class="register-link">Create Account</a></p>
            </div>
        </div>
    </div>
</div>

</body>
</html>