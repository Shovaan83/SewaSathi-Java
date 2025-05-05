<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="admin-sidebar">
    <div class="admin-sidebar-header">
        <h3>Admin Panel</h3>
    </div>
    
    <div class="admin-sidebar-menu">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="admin-sidebar-item ${requestURI.endsWith('/admin/dashboard') ? 'active' : ''}">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="admin-sidebar-item ${requestURI.endsWith('/admin/users') ? 'active' : ''}">
            <i class="fas fa-users"></i> Users Management
        </a>
        <a href="${pageContext.request.contextPath}/admin/campaigns" class="admin-sidebar-item ${requestURI.endsWith('/admin/campaigns') ? 'active' : ''}">
            <i class="fas fa-bullhorn"></i> Campaigns Management
        </a>
        <a href="${pageContext.request.contextPath}/admin/donations" class="admin-sidebar-item ${requestURI.endsWith('/admin/donations') ? 'active' : ''}">
            <i class="fas fa-hand-holding-heart"></i> Donations Management
        </a>
        <div class="sidebar-divider"></div>
        <a href="${pageContext.request.contextPath}/" class="admin-sidebar-item">
            <i class="fas fa-home"></i> Back to Website
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="admin-sidebar-item">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>
</div>

<style>
.admin-sidebar {
    width: 250px;
    background-color: #2c3e50;
    color: #fff;
    height: 100vh;
    position: fixed;
    left: 0;
    top: 0;
    overflow-y: auto;
}

.admin-sidebar-header {
    padding: 20px;
    text-align: center;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.admin-sidebar-menu {
    padding: 20px 0;
}

.admin-sidebar-item {
    display: block;
    padding: 12px 20px;
    color: #ecf0f1;
    text-decoration: none;
    transition: all 0.3s;
    position: relative;
}

.admin-sidebar-item:hover {
    background-color: rgba(255, 255, 255, 0.1);
    color: #fff;
    padding-left: 25px;
}

.admin-sidebar-item.active {
    background-color: #3498db;
    color: #fff;
}

.admin-sidebar-item i {
    margin-right: 10px;
    width: 20px;
    text-align: center;
}

.sidebar-divider {
    height: 1px;
    background-color: rgba(255, 255, 255, 0.1);
    margin: 15px 20px;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .admin-sidebar {
        width: 70px;
        overflow: visible;
    }
    
    .admin-sidebar-header h3 {
        display: none;
    }
    
    .admin-sidebar-item span {
        display: none;
    }
    
    .admin-sidebar-item i {
        margin-right: 0;
        font-size: 1.2rem;
    }
    
    .admin-sidebar-item {
        text-align: center;
        padding: 15px 0;
    }
    
    .admin-sidebar-item:hover {
        padding-left: 0;
    }
}
</style>

<script>
    // Get current path to highlight active menu item
    document.addEventListener("DOMContentLoaded", function() {
        const currentPath = window.location.pathname;
        const sidebarItems = document.querySelectorAll('.admin-sidebar-item');
        
        sidebarItems.forEach(item => {
            if (item.getAttribute('href') === currentPath) {
                item.classList.add('active');
            }
        });
    });
</script> 