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
    <title>Sign In | SewaSathi</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #ff6b6b;
            --primary-dark: #ff5252;
            --text-color: #333333;
            --text-light: #757575;
            --background-color: #ffffff;
            --border-color: #e0e0e0;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            color: var(--text-color);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-image: linear-gradient(rgba(255, 107, 107, 0.3), rgba(255, 107, 107, 0.3));
            background-color: #f5f5f5;
            padding: 20px;
        }
        
        .auth-card {
            background-color: var(--background-color);
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
            padding: 40px;
            text-align: center;
        }
        
        .logo {
            margin-bottom: 24px;
        }
        
        .logo img {
            height: 60px;
        }
        
        h1 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 16px;
            color: var(--text-color);
        }
        
        .subtitle {
            font-size: 16px;
            color: var(--text-light);
            margin-bottom: 32px;
        }
        
        .input-field {
            background-color: #f5f5f5;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 15px;
            width: 100%;
            margin-bottom: 16px;
            font-size: 16px;
            font-family: inherit;
            color: var(--text-color);
            transition: border-color 0.3s;
        }
        
        .input-field:focus {
            outline: none;
            border-color: var(--primary-color);
        }
        
        .forgot-password {
            display: block;
            text-align: right;
            color: var(--primary-color);
            text-decoration: none;
            font-size: 14px;
            margin-bottom: 24px;
        }
        
        .forgot-password:hover {
            text-decoration: underline;
        }
        
        .auth-btn {
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 50px;
            padding: 15px;
            width: 100%;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-bottom: 20px;
        }
        
        .auth-btn:hover {
            background-color: var(--primary-dark);
        }
        
        .switch-auth {
            font-size: 14px;
            color: var(--text-light);
        }
        
        .switch-auth a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
        }
        
        .switch-auth a:hover {
            text-decoration: underline;
        }
        
        .terms-text {
            font-size: 12px;
            color: var(--text-light);
            margin-top: 24px;
            line-height: 1.5;
        }
        
        .terms-text a {
            color: var(--primary-color);
            text-decoration: none;
        }
        
        .terms-text a:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            margin-bottom: 20px;
        }
        
        .remember-me input[type="checkbox"] {
            margin-right: 8px;
            accent-color: var(--primary-color);
            width: 16px;
            height: 16px;
        }
        
        .remember-me label {
            font-size: 14px;
            color: var(--text-light);
            cursor: pointer;
        }
        
        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="auth-card">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="SewaSathi" onerror="this.src='${pageContext.request.contextPath}/assets/images/logo.png';this.onerror='';">
        </div>
        
        <h1>Sign In</h1>
        <p class="subtitle">Do you have an account? <a href="${pageContext.request.contextPath}/RegisterServlet">Sign Up</a></p>
        
        <!-- Display alerts if there are any messages -->
        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("success") %>
        </div>
        <% } %>
        
        <% if (request.getAttribute("registrationSuccess") != null) { %>
        <div class="alert alert-success">
            <%= request.getAttribute("registrationSuccess") %>
        </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <input type="email" name="email" class="input-field" placeholder="Email or phone number" required>
            <input type="password" name="password" class="input-field" placeholder="Password" required>
            
            <div class="form-footer">
                <div class="remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe">Remember me</label>
                </div>
                <a href="#" class="forgot-password">Forget your password?</a>
            </div>
            
            <button type="submit" class="auth-btn">Sign In</button>
        </form>
        
        <p class="terms-text">
            By clicking the Sign In button below, you agree to the SewaSathi 
            <a href="#">Terms of Service</a> and acknowledge the 
            <a href="#">Privacy Notice</a>.
        </p>
    </div>
</body>
</html>