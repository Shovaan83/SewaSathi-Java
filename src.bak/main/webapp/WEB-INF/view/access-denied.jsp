<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - SewaSathi</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #ff6b6b;
            --primary-dark: #ff5252;
            --text-color: #333333;
            --white: #ffffff;
            --gray-light: #f5f5f5;
            --font-family: 'Inter', sans-serif;
        }
        
        body {
            font-family: var(--font-family);
            margin: 0;
            padding: 0;
            background-color: var(--gray-light);
            color: var(--text-color);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        .content {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 2rem;
            text-align: center;
        }
        
        .error-icon {
            font-size: 5rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
        }
        
        h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary-dark);
        }
        
        p {
            font-size: 1.1rem;
            max-width: 600px;
            margin: 0 auto 1.5rem;
            line-height: 1.6;
        }
        
        .btn {
            display: inline-block;
            background-color: var(--primary-color);
            color: var(--white);
            padding: 0.8rem 1.5rem;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 500;
            transition: background-color 0.3s;
            margin: 0.5rem;
            border: none;
            cursor: pointer;
        }
        
        .btn:hover {
            background-color: var(--primary-dark);
        }
        
        .btn-outline {
            background-color: transparent;
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
        }
        
        .btn-outline:hover {
            background-color: var(--primary-color);
            color: var(--white);
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<div class="content">
    <div class="error-icon">
        <i class="fas fa-lock"></i>
    </div>
    
    <h1>Access Denied</h1>
    
    <p>Sorry, you don't have permission to access this page. This area may be restricted to users with specific roles or privileges.</p>
    
    <div class="actions">
        <a href="${pageContext.request.contextPath}/" class="btn">Return to Home</a>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Sign In</a>
    </div>
</div>

<jsp:include page="/WEB-INF/components/footer.jsp" />
</body>
</html> 