<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Get the context path
    String contextPath = request.getContextPath();
    
    // Get user from session
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = user != null;

    // Get the first letter of the user's name for the avatar - only if user is logged in
    String firstLetter = "";
    if (isLoggedIn && user.getFull_name() != null && !user.getFull_name().isEmpty()) {
        firstLetter = user.getFull_name().substring(0, 1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SewaSathi - Help Through Crowdfunding</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="<%= contextPath %>/assets/css/styles.css">
    <style>
        :root {
            --primary: #ff6b6b;
            --primary-dark: #ff5252;
            --primary-light: #ffa5a5;
            --secondary: #339af0;
            --text-dark: #212529;
            --text-light: #6c757d;
            --background: #ffffff;
            --gray-light: #f8f9fa;
            --gray-medium: #e9ecef;
            --border-color: #dee2e6;
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
        
        /* Remove hover-based dropdown display */
        /* .user-dropdown:hover .dropdown-menu {
            display: block;
        } */
        
        /* Add this class via JavaScript */
        .show-dropdown {
            display: block !important;
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

        /* Hero Section */
        .hero {
            height: 80vh;
            background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('https://images.unsplash.com/photo-1593113598332-cd288d649433?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            color: white;
            padding: 2rem;
        }

        .hero-subtitle {
            font-size: 1.5rem;
            font-weight: 400;
            margin-bottom: 1rem;
            opacity: 0.9;
        }

        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 2rem;
            max-width: 800px;
        }

        .hero .btn {
            padding: 0.8rem 2rem;
            font-size: 1.1rem;
        }

        /* Initiatives Section */
        .initiatives {
            padding: 4rem 0;
        }

        .section-title {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 2.5rem;
            text-align: center;
        }

        .initiatives-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(270px, 1fr));
            gap: 2rem;
        }

        .initiative-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            height: 100%;
        }

        .initiative-card:hover {
            transform: translateY(-5px);
        }

        .initiative-img {
            height: 200px;
            width: 100%;
            object-fit: cover;
        }

        .initiative-info {
            padding: 1.5rem;
        }

        .initiative-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
        }

        .initiative-description {
            font-size: 0.9rem;
            color: var(--text-light);
            margin-bottom: 1rem;
        }

        .donate-link {
            color: var(--primary);
            font-weight: 500;
            font-size: 0.9rem;
            display: inline-block;
        }

        /* Featured Topics */
        .featured-topics {
            padding: 4rem 0;
            background-color: var(--gray-light);
        }

        .topic-card {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .topic-title {
            font-size: 1.2rem;
            padding: 1.25rem;
            background-color: var(--gray-medium);
            font-weight: 600;
        }

        .topic-featured {
            display: inline-block;
            background-color: var(--primary-light);
            color: var(--primary-dark);
            font-size: 0.7rem;
            padding: 0.2rem 0.5rem;
            border-radius: 50px;
            margin-left: 0.5rem;
            font-weight: 500;
        }

        .topic-img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }

        .topic-info {
            padding: 1.5rem;
        }

        .learn-more {
            color: var(--primary);
            font-weight: 500;
            display: inline-block;
            margin-top: 1rem;
        }

        /* Fundraise For Anyone */
        .fundraise-options {
            padding: 4rem 0;
            background-image: linear-gradient(to right, var(--primary-light), var(--primary));
            color: white;
        }

        .fundraise-heading {
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 3rem;
            text-align: center;
        }

        .option-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .option-card {
            background-color: white;
            border-radius: 10px;
            padding: 2rem;
            color: var(--text-dark);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            height: 100%;
        }

        .option-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .option-description {
            color: var(--text-light);
            margin-bottom: 1rem;
        }

        .info-icon {
            font-size: 1.2rem;
            color: var(--text-light);
            float: right;
        }

        /* How It Works */
        .how-it-works {
            padding: 4rem 0;
            background-color: var(--gray-light);
        }

        .how-container {
            max-width: 800px;
            margin: 0 auto;
            text-align: center;
        }

        .how-title {
            font-size: 2.25rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .how-description {
            margin-bottom: 2rem;
            color: var(--text-light);
            font-size: 1.1rem;
        }

        /* Footer */
        footer {
            background-color: var(--text-dark);
            color: white;
            padding: 4rem 0 2rem;
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
            
            .hero-title {
                font-size: 2rem;
            }
            
            .hero-subtitle {
                font-size: 1.2rem;
            }
        }

        @media (max-width: 576px) {
            .nav-link {
                display: none;
            }
            
            .hero {
                height: 70vh;
            }

            .option-cards {
                grid-template-columns: 1fr;
            }
            
            .footer-bottom {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }
        }
    </style>
</head>
<body>
    <!-- Include the common navbar component -->
    <jsp:include page="/WEB-INF/components/navbar.jsp" />

    <!-- Hero Section -->
    <section class="hero">
        <h2 class="hero-subtitle">Help through SewaSathi</h2>
        <h1 class="hero-title">Your small help can put smile in their face.</h1>
        <% if (isLoggedIn) { %>
        <a href="${pageContext.request.contextPath}/CreateCampaignServlet" class="btn btn-primary">Start a Fund</a>
        <% } else { %>
        <a href="${pageContext.request.contextPath}/LoginServlet" class="btn btn-primary">Start a Fund</a>
        <% } %>
    </section>

    <!-- Initiatives Section -->
    <section class="initiatives">
        <div class="container">
            <h2 class="section-title">Find and support the initiatives that matter most to you</h2>
            <div class="initiatives-grid">
                <div class="initiative-card">
                    <img src="${pageContext.request.contextPath}/assets/images/flood.jpg" alt="Kathmandu Flood" class="initiative-img" onerror="this.src='https://images.unsplash.com/photo-1578894381163-e72c17f2d45f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';">
                    <div class="initiative-info">
                        <h3 class="initiative-title">Helpline for Kathmandu Flood</h3>
                        <p class="initiative-description">Support families affected by recent flooding in Kathmandu Valley</p>
                        <a href="#" class="donate-link">Donate now →</a>
                    </div>
                </div>
                
                <div class="initiative-card">
                    <img src="${pageContext.request.contextPath}/assets/images/cancer.webp" alt="Fight against Cancer" class="initiative-img" onerror="this.src='https://images.unsplash.com/photo-1579154392429-0e6b4e850ad2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';">
                    <div class="initiative-info">
                        <h3 class="initiative-title">Help patients to fight against Cancer</h3>
                        <p class="initiative-description">Fund treatment and support for cancer patients in Nepal</p>
                        <a href="#" class="donate-link">Donate now →</a>
                    </div>
                </div>
                
                <div class="initiative-card">
                    <img src="${pageContext.request.contextPath}/assets/images/education.jpg" alt="Child Education" class="initiative-img" onerror="this.src='https://images.unsplash.com/photo-1541339907198-e08756dedf3f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';">
                    <div class="initiative-info">
                        <h3 class="initiative-title">Fund for Child Education</h3>
                        <p class="initiative-description">Help provide education to underprivileged children</p>
                        <a href="#" class="donate-link">Donate now →</a>
                    </div>
                </div>
                
                <div class="initiative-card">
                    <img src="${pageContext.request.contextPath}/assets/images/landslide.jpg" alt="Landslide Relief" class="initiative-img" onerror="this.src='https://images.unsplash.com/photo-1533460004989-cef01064af7e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';">
                    <div class="initiative-info">
                        <h3 class="initiative-title">Helpline for Landslide</h3>
                        <p class="initiative-description">Support communities affected by landslides in rural Nepal</p>
                        <a href="#" class="donate-link">Donate now →</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Topics -->
    <section class="featured-topics">
        <div class="container">
            <h2 class="section-title">Featured topics</h2>
            
            <div class="topic-card">
                <div class="topic-title">
                    Fundraise for Kathmandu Flood <span class="topic-featured">Featured</span>
                </div>
                <img src="${pageContext.request.contextPath}/assets/images/flood-feature.jpg" alt="Kathmandu Flood" class="topic-img" onerror="this.src='https://images.unsplash.com/photo-1547683905-f686c993aae5?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80';">
                <div class="topic-info">
                    <p>Help rebuild communities affected by devastating floods in Kathmandu Valley. Your contributions will provide emergency shelter, food, clean water, and long-term recovery support.</p>
                    <a href="#" class="learn-more">Learn More →</a>
                </div>
            </div>
            
            <div class="option-cards">
                <div class="initiative-card">
                    <img src="${pageContext.request.contextPath}/assets/images/cancer.webp" alt="Fight Cancer" class="initiative-img" onerror="this.src='https://images.unsplash.com/photo-1579154341098-e4e158cc8992?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';">
                    <div class="initiative-info">
                        <h3 class="initiative-title">Fundraise for patients to fight against Cancer</h3>
                        <p class="initiative-description">Support cancer treatment for those who cannot afford it</p>
                        <a href="#" class="learn-more">Learn More →</a>
                    </div>
                </div>
                
                <div class="initiative-card">
                    <img src="${pageContext.request.contextPath}/assets/images/landslide.jpg" alt="Landslide Relief" class="initiative-img" onerror="this.src='https://images.unsplash.com/photo-1547683895-3c82f4caf54a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';">
                    <div class="initiative-info">
                        <h3 class="initiative-title">Fundraise for Landslide</h3>
                        <p class="initiative-description">Help communities recover from destructive landslides</p>
                        <a href="#" class="learn-more">Learn More →</a>
                    </div>
                </div>
                
                <div class="initiative-card">
                    <img src="${pageContext.request.contextPath}/assets/images/education-feature.jpg" alt="Child Education" class="initiative-img" onerror="this.src='https://images.unsplash.com/photo-1594608661623-aa0bd3a69d98?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';">
                    <div class="initiative-info">
                        <h3 class="initiative-title">Fundraise for Children's Education</h3>
                        <p class="initiative-description">Support educational opportunities for disadvantaged children</p>
                        <a href="#" class="learn-more">Learn More →</a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Fundraise For Anyone -->
    <section class="fundraise-options">
        <div class="container">
            <h2 class="fundraise-heading">Fundraise for anyone</h2>
            
            <div class="option-cards">
                <div class="option-card">
                    <i class="fas fa-info-circle info-icon"></i>
                    <h3 class="option-title">Yourself</h3>
                    <p class="option-description">Funds are delivered to your bank account for your own use</p>
                </div>
                
                <div class="option-card">
                    <i class="fas fa-info-circle info-icon"></i>
                    <h3 class="option-title">Charity</h3>
                    <p class="option-description">Funds are delivered to your chosen nonprofit for you</p>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="how-it-works" id="how-it-works">
        <div class="container how-container">
            <h2 class="how-title">How SewaSathi Works</h2>
            <p class="how-description">SewaSathi is a platform that connects people in need with individuals who want to help. Our simple and secure platform makes it easy to raise funds and donate to causes that matter to you.</p>
            <% if (isLoggedIn) { %>
            <a href="${pageContext.request.contextPath}/CreateCampaignServlet" class="btn btn-primary">Start a Fund</a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/LoginServlet" class="btn btn-primary">Start a Fund</a>
            <% } %>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div>
                    <div class="footer-logo-text">Sewa<span>Sathi</span></div>
                    <p class="footer-about">SewaSathi connects donors with causes that matter, helping communities across Nepal recover, rebuild, and thrive.</p>
                </div>
                
                <div>
                    <h3 class="footer-title">Quick links</h3>
                    <div class="footer-links">
                        <a href="#how-it-works">How SewaSathi works</a>
                        <a href="#">Generate Charity</a>
                        <% if (isLoggedIn) { %>
                        <a href="${pageContext.request.contextPath}/CreateCampaignServlet">Start a fund</a>
                        <% } else { %>
                        <a href="${pageContext.request.contextPath}/LoginServlet">Start a fund</a>
                        <% } %>
                    </div>
                </div>
                
                <div>
                    <h3 class="footer-title">Contact Us</h3>
                    <div class="contact-info">
                        <i class="fas fa-map-marker-alt"></i>
                        <p>Sinamangal Kathmandu, Nepal</p>
                    </div>
                    <div class="contact-info">
                        <i class="fas fa-phone-alt"></i>
                        <p>+977 9861452719</p>
                    </div>
                    <div class="contact-info">
                        <i class="fas fa-envelope"></i>
                        <p>sewasathi@gmail.com</p>
                    </div>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>© 2024 www.sewasathi.com | Hosting Partner Cloud977</p>
                <div class="social-icons">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-youtube"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Add JavaScript for dropdown menu -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const dropdownToggle = document.getElementById('userDropdownToggle');
            const dropdownMenu = document.getElementById('userDropdownMenu');
            
            if (dropdownToggle && dropdownMenu) {
                // Toggle menu when clicking on the user avatar
                dropdownToggle.addEventListener('click', function(e) {
                    e.stopPropagation();
                    dropdownMenu.classList.toggle('show-dropdown');
                });
                
                // Close dropdown when clicking elsewhere on the page
                document.addEventListener('click', function(e) {
                    if (!dropdownToggle.contains(e.target) && !dropdownMenu.contains(e.target)) {
                        dropdownMenu.classList.remove('show-dropdown');
                    }
                });
                
                // Prevent dropdown from closing when clicking inside it
                dropdownMenu.addEventListener('click', function(e) {
                    e.stopPropagation();
                });
            }
        });
    </script>
</body>
</html>
