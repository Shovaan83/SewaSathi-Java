<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | SewaSathi</title>
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
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="auth-card">
        <div class="logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="SewaSathi" onerror="this.src='${pageContext.request.contextPath}/assets/images/logo.png';this.onerror='';">
        </div>
        
        <h1>Create an account</h1>
        <p class="subtitle">Already have an account? <a href="${pageContext.request.contextPath}/LoginServlet">Sign In</a></p>
        
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" enctype="multipart/form-data">
            <input type="text" name="full_name" id="full_name" class="input-field" placeholder="Full name" required>
            <input type="email" name="email" id="email" class="input-field" placeholder="Email" required>
            <input type="password" name="password" id="password" class="input-field" placeholder="Password" required>
            <input type="password" name="confirmPassword" id="confirmPassword" class="input-field" placeholder="Confirm password" required>
            
            <!-- Role selection (only shown in admin view) - hidden by default -->
            <select id="role_id" name="role_id" class="input-field hidden">
                <c:forEach var="role" items="${roles}">
                    <option value="${role.role_id}">${role.role_name}</option>
                </c:forEach>
            </select>
            
            <button type="submit" class="auth-btn">Sign Up</button>
        </form>
        
        <p class="terms-text">
            By clicking the Sign In button below, you agree to the SewaSathi 
            <a href="#">Terms of Service</a> and acknowledge the 
            <a href="#">Privacy Notice</a>.
        </p>
    </div>
    
    <script>
        // Form validation script
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');
            
            form.addEventListener('submit', function(event) {
                if (password.value !== confirmPassword.value) {
                    event.preventDefault();
                    alert('Passwords do not match!');
                }
            });
        });
    </script>
</body>
</html>