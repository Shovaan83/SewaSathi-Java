<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Debug information - only visible in source -->
<!-- Current context path: ${pageContext.request.contextPath} -->

<style>
    .navbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 1rem 2rem;
        background-color: #fff;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        position: relative;
    }
    .navbar-logo {
        font-size: 1.5rem;
        font-weight: 700;
        color: #ff6b6b;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .navbar-logo img {
        height: 35px;
    }
    .navbar-menu {
        display: flex;
        gap: 1.5rem;
        align-items: center;
    }
    .navbar-link {
        text-decoration: none;
        color: #333;
        font-weight: 500;
        transition: color 0.3s;
        white-space: nowrap;
    }
    .navbar-link:hover {
        color: #ff6b6b;
    }
    .navbar-donate {
        background-color: #ff6b6b;
        color: white;
        padding: 0.5rem 1.2rem;
        border-radius: 50px;
        font-weight: 600;
        text-decoration: none;
        transition: background-color 0.3s;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        position: relative;
        white-space: nowrap;
    }
    .navbar-donate:hover {
        background-color: #ff5252;
    }
    .donate-menu {
        position: absolute;
        top: 100%;
        right: 0;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        padding: 0.5rem 0;
        min-width: 180px;
        z-index: 100;
        display: none;
        margin-top: 0.5rem;
    }
    .navbar-donate:hover .donate-menu {
        display: block;
    }
    .donate-menu-item {
        padding: 0.75rem 1rem;
        text-decoration: none;
        color: #333;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .donate-menu-item:hover {
        background-color: #f5f5f5;
    }
    .donate-menu-item i {
        color: #666;
        width: 20px;
    }
    .navbar-cta {
        display: flex;
        gap: 1rem;
        align-items: center;
    }
    .navbar-login, .navbar-register {
        text-decoration: none;
        padding: 0.5rem 1.2rem;
        border-radius: 50px;
        font-weight: 600;
        transition: all 0.3s;
        white-space: nowrap;
    }
    .navbar-login {
        color: #333;
        border: 1px solid #e1e1e1;
    }
    .navbar-login:hover {
        background-color: #f5f5f5;
    }
    .navbar-register {
        background-color: #ff6b6b;
        color: white;
    }
    .navbar-register:hover {
        background-color: #ff5252;
    }
    .navbar-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        background-color: #ff6b6b;
        color: white;
        display: flex;
        justify-content: center;
        align-items: center;
        font-weight: 600;
        cursor: pointer;
        overflow: hidden;
    }
    .navbar-avatar img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .navbar-user {
        position: relative;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }
    .user-menu {
        position: absolute;
        top: 100%;
        right: 0;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        padding: 0.5rem 0;
        min-width: 200px;
        z-index: 100;
        display: none;
        margin-top: 0.5rem;
    }
    .navbar-user:hover .user-menu {
        display: block;
    }
    .user-menu-item {
        padding: 0.75rem 1rem;
        text-decoration: none;
        color: #333;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    }
    .user-menu-item:hover {
        background-color: #f5f5f5;
    }
    .user-menu-item i {
        color: #666;
        width: 20px;
    }
    .search-container {
        position: relative;
        margin-left: auto;
        margin-right: 1.5rem;
    }
    .search-input {
        padding: 0.5rem 1rem 0.5rem 2.5rem;
        border: 1px solid #e1e1e1;
        border-radius: 50px;
        width: 200px;
        transition: width 0.3s, border-color 0.3s;
        font-family: inherit;
    }
    .search-input:focus {
        width: 250px;
        border-color: #ff6b6b;
        outline: none;
    }
    .search-icon {
        position: absolute;
        left: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        color: #666;
        font-size: 0.9rem;
    }
    .navbar-actions {
        display: flex;
        align-items: center;
    }
    .mobile-menu-toggle {
        display: none;
        background: none;
        border: none;
        font-size: 1.5rem;
        color: #333;
        cursor: pointer;
    }
    .start-fund-btn {
        background-color: #339af0;
        color: white;
        padding: 0.5rem 1.2rem;
        border-radius: 50px;
        font-weight: 600;
        text-decoration: none;
        transition: background-color 0.3s;
        white-space: nowrap;
    }
    .start-fund-btn:hover {
        background-color: #228be6;
    }

    @media (max-width: 1100px) {
        .search-input {
            width: 150px;
        }
        .search-input:focus {
            width: 200px;
        }
    }

    @media (max-width: 992px) {
        .navbar {
            padding: 1rem;
        }
        .navbar-menu {
            gap: 1rem;
        }
    }

    @media (max-width: 768px) {
        .navbar-menu, .search-container {
            display: none;
        }
        .mobile-menu-toggle {
            display: block;
        }
        .navbar-menu.active {
            display: flex;
            flex-direction: column;
            position: absolute;
            top: 70px;
            left: 0;
            right: 0;
            background: white;
            padding: 1rem;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 100;
            max-height: 80vh;
            overflow-y: auto;
        }
        .search-container.active {
            display: block;
            width: 100%;
            margin: 0.5rem 0;
        }
        .search-input, .search-input:focus {
            width: 100%;
        }
        .donate-menu {
            position: static;
            box-shadow: none;
            display: none;
            margin: 0.5rem 0 0.5rem 1rem;
        }
        .navbar-donate {
            width: 100%;
            justify-content: space-between;
        }
        .navbar-user {
            margin-top: 0.5rem;
        }
    }
</style>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="navbar-logo">
        <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="SewaSathi">
    </a>

    <button class="mobile-menu-toggle" id="mobile-menu-toggle">
        <i class="fas fa-bars"></i>
    </button>

    <div class="navbar-menu" id="navbar-menu">
        <a href="${pageContext.request.contextPath}/" class="navbar-link">Home</a>
        <a href="${pageContext.request.contextPath}/campaigns" class="navbar-link">Campaigns</a>
        <a href="${pageContext.request.contextPath}/about" class="navbar-link">About Us</a>
        <a href="${pageContext.request.contextPath}/contact" class="navbar-link">Contact</a>
        <c:if test="${not empty user && user.role_id != 1}">
            <a href="${pageContext.request.contextPath}/create-campaign" class="start-fund-btn">
                <i class="fas fa-plus-circle"></i> Start a Campaign
            </a>
        </c:if>
    </div>

    <div class="search-container" id="search-container">
        <i class="fas fa-search search-icon"></i>
        <form action="${pageContext.request.contextPath}/search" method="get">
            <input type="text" class="search-input" name="q" placeholder="Search campaigns...">
        </form>
    </div>

    <div class="navbar-actions">
        <!-- Donate button with dropdown -->
        <div class="navbar-donate" id="donate-dropdown">
            <span><i class="fas fa-heart"></i> Donate</span>
            <i class="fas fa-chevron-down"></i>

            <div class="donate-menu">
                <a href="${pageContext.request.contextPath}/clothes-donation" class="donate-menu-item">
                    <i class="fas fa-tshirt"></i> Clothes Donation
                </a>
                <a href="${pageContext.request.contextPath}/monetary-donation" class="donate-menu-item">
                    <i class="fas fa-money-bill-wave"></i> Monetary Donation
                </a>
            </div>
        </div>

        <c:choose>
            <c:when test="${sessionScope.user != null}">
                
                <div class="navbar-user" style="margin-left: 1rem;">
                    <div class="navbar-avatar">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user.profile_picture_url}">
                                <img src="${sessionScope.user.profile_picture_url}" alt="${sessionScope.user.full_name}">
                            </c:when>
                            <c:otherwise>
                                <c:set var="firstLetter" value="${fn:substring(sessionScope.user.full_name, 0, 1)}" />
                                ${not empty firstLetter ? firstLetter : fn:substring(sessionScope.user.email, 0, 1)}
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="user-menu">
                        <a href="${pageContext.request.contextPath}/profile" class="user-menu-item">
                            <i class="fas fa-user"></i> My Profile
                        </a>
                        <c:if test="${user.role_id != 1}">
                            <a href="${pageContext.request.contextPath}/create-campaign" class="user-menu-item">
                                <i class="fas fa-plus-circle"></i> Create Campaign
                            </a>
                            <a href="${pageContext.request.contextPath}/my-campaigns" class="user-menu-item">
                                <i class="fas fa-bullhorn"></i> My Campaigns
                            </a>
                        </c:if>
                        <div style="height: 1px; background-color: #e1e1e1; margin: 0.5rem 0;"></div>
                        <a href="${pageContext.request.contextPath}/logout" class="user-menu-item">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- User is not logged in -->
                <div class="navbar-cta">
                    <a href="${pageContext.request.contextPath}/LoginServlet" class="navbar-login">Login</a>
                    <a href="${pageContext.request.contextPath}/RegisterServlet" class="navbar-register">Sign Up</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const mobileMenuToggle = document.getElementById('mobile-menu-toggle');
        const navbarMenu = document.getElementById('navbar-menu');
        const searchContainer = document.getElementById('search-container');
        
        mobileMenuToggle.addEventListener('click', function() {
            navbarMenu.classList.toggle('active');
            searchContainer.classList.toggle('active');
        });
        
        // For mobile: show dropdown on click rather than hover
        if (window.innerWidth <= 768) {
            const donateDropdown = document.getElementById('donate-dropdown');
            const donateMenu = donateDropdown.querySelector('.donate-menu');
            
            donateDropdown.addEventListener('click', function(e) {
                e.preventDefault();
                if (donateMenu.style.display === 'block') {
                    donateMenu.style.display = 'none';
                } else {
                    donateMenu.style.display = 'block';
                }
            });
        }
    });
</script>