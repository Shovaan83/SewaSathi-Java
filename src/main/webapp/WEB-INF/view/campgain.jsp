<%--
  Created by IntelliJ IDEA.
  User: Shovan
  Date: 21/04/2025
  Time: 9:50 am
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campaigns | SewaSathi</title>
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem 1rem;
        }
        
        .page-title {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-color);
            margin-bottom: 1.5rem;
            text-align: center;
        }
        
        .campaigns-wrapper {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }
        
        .campaign-card {
            background-color: #fff;
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--box-shadow);
            transition: var(--transition);
        }
        
        .campaign-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }
        
        .campaign-image {
            height: 200px;
            overflow: hidden;
        }
        
        .campaign-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .campaign-card:hover .campaign-image img {
            transform: scale(1.05);
        }
        
        .campaign-details {
            padding: 1.5rem;
        }
        
        .campaign-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }
        
        .campaign-description {
            color: var(--gray-color);
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .campaign-progress {
            height: 8px;
            background-color: #e9ecef;
            border-radius: 4px;
            margin-bottom: 0.5rem;
            overflow: hidden;
        }
        
        .progress-bar {
            height: 100%;
            background-color: var(--primary-color);
        }
        
        .campaign-stats {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
        
        .campaign-stats .amount {
            font-weight: 600;
        }
        
        .campaign-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .days-left {
            color: var(--gray-color);
            font-size: 0.9rem;
        }
        
        .btn {
            display: inline-block;
            padding: 0.5rem 1rem;
            background-color: var(--primary-color);
            color: white;
            border-radius: var(--border-radius);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }
        
        .btn:hover {
            background-color: var(--secondary-color);
        }
        
        .empty-message {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--gray-color);
        }
        
        .empty-message i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
        }
        
        @media (max-width: 768px) {
            .campaigns-wrapper {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/components/navbar.jsp" />
    
    <div class="container">
        <h1 class="page-title">Active Campaigns</h1>
        
        <div class="campaigns-wrapper">
            <!-- Campaign 1 -->
            <div class="campaign-card">
                <div class="campaign-image">
                    <img src="https://images.unsplash.com/photo-1593113598332-cd288d649433?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80" alt="Community Garden Initiative">
                </div>
                <div class="campaign-details">
                    <h2 class="campaign-title">Community Garden Initiative</h2>
                    <p class="campaign-description">Creating sustainable community gardens in urban neighborhoods to improve food security and build community connections.</p>
                    <div class="campaign-progress">
                        <div class="progress-bar" style="width: 75%"></div>
                    </div>
                    <div class="campaign-stats">
                        <div class="raised">
                            <span class="amount">₹45,000</span> raised
                        </div>
                        <div class="goal">
                            of <span class="amount">₹60,000</span>
                        </div>
                    </div>
                    <div class="campaign-footer">
                        <div class="days-left">
                            <i class="far fa-clock"></i> 15 days left
                        </div>
                        <a href="#" class="btn">Donate Now</a>
                    </div>
                </div>
            </div>
            
            <!-- Campaign 2 -->
            <div class="campaign-card">
                <div class="campaign-image">
                    <img src="https://images.unsplash.com/photo-1519389950473-47ba0277781c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80" alt="Eco-Friendly Solar Charger">
                </div>
                <div class="campaign-details">
                    <h2 class="campaign-title">Eco-Friendly Solar Charger</h2>
                    <p class="campaign-description">Portable solar charger for all your devices. Help us bring sustainable technology to everyone.</p>
                    <div class="campaign-progress">
                        <div class="progress-bar" style="width: 65%"></div>
                    </div>
                    <div class="campaign-stats">
                        <div class="raised">
                            <span class="amount">₹32,500</span> raised
                        </div>
                        <div class="goal">
                            of <span class="amount">₹50,000</span>
                        </div>
                    </div>
                    <div class="campaign-footer">
                        <div class="days-left">
                            <i class="far fa-clock"></i> 20 days left
                        </div>
                        <a href="#" class="btn">Donate Now</a>
                    </div>
                </div>
            </div>
            
            <!-- Campaign 3 -->
            <div class="campaign-card">
                <div class="campaign-image">
                    <img src="https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80" alt="Education for All">
                </div>
                <div class="campaign-details">
                    <h2 class="campaign-title">Education for All</h2>
                    <p class="campaign-description">Supporting education for underprivileged children. Your donation can help us provide books, supplies, and learning opportunities.</p>
                    <div class="campaign-progress">
                        <div class="progress-bar" style="width: 40%"></div>
                    </div>
                    <div class="campaign-stats">
                        <div class="raised">
                            <span class="amount">₹20,000</span> raised
                        </div>
                        <div class="goal">
                            of <span class="amount">₹50,000</span>
                        </div>
                    </div>
                    <div class="campaign-footer">
                        <div class="days-left">
                            <i class="far fa-clock"></i> 30 days left
                        </div>
                        <a href="#" class="btn">Donate Now</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/components/footer.jsp" />
</body>
</html>
