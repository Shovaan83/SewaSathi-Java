<%@ page import="model.User, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - SewaSathi Admin</title>
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
        
        .admin-content {
            margin-left: 250px;
            padding: 20px;
        }
        
        .container {
            width: 100%;
            padding-right: 15px;
            padding-left: 15px;
            margin-right: auto;
            margin-left: auto;
            max-width: 1200px;
        }
        
        .header {
            background-color: #fff;
            box-shadow: var(--box-shadow);
            padding: 1rem 0;
            margin-bottom: 2rem;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            text-decoration: none;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
        }
        
        .username {
            font-weight: 600;
        }
        
        .card {
            background-color: #fff;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.5rem;
            height: 100%;
            margin-bottom: 1.5rem;
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid #eee;
        }
        
        .card-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .card-icon {
            font-size: 1.5rem;
            color: var(--primary-color);
        }
        
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .stat-card {
            background-color: #fff;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1rem;
            text-align: center;
            transition: var(--transition);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .stat-label {
            font-size: 0.875rem;
            color: var(--gray-color);
        }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th, td {
            padding: 0.75rem;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        th {
            font-weight: 600;
            color: var(--dark-color);
        }
        
        tbody tr:hover {
            background-color: #f9f9f9;
        }
        
        .user-row {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .user-row .avatar {
            width: 30px;
            height: 30px;
            font-size: 0.75rem;
        }
        
        .badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .badge-success {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .badge-warning {
            background-color: rgba(255, 193, 7, 0.1);
            color: var(--warning-color);
        }
        
        .badge-danger {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }
        
        .btn {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            border-radius: var(--border-radius);
            font-weight: 500;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            border: none;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary-color);
        }
        
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        
        .actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .search-box {
            display: flex;
            margin-bottom: 1.5rem;
        }
        
        .search-box input {
            flex: 1;
            padding: 0.5rem 1rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius) 0 0 var(--border-radius);
            font-size: 1rem;
        }
        
        .search-box button {
            padding: 0.5rem 1rem;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 0 var(--border-radius) var(--border-radius) 0;
            cursor: pointer;
        }
        
        .alert {
            padding: 0.75rem 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            border-radius: var(--border-radius);
        }
        
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-top: 1.5rem;
        }
        
        .pagination a {
            display: inline-block;
            padding: 0.5rem 0.75rem;
            background-color: #fff;
            border: 1px solid #ddd;
            color: var(--primary-color);
            text-decoration: none;
            border-radius: var(--border-radius);
        }
        
        .pagination a.active, .pagination a:hover {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        
        @media (max-width: 768px) {
            .admin-content {
                margin-left: 70px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Admin Sidebar -->
    <jsp:include page="../components/admin-sidebar.jsp" />
    
    <div class="admin-content">
        <div class="header">
            <div class="container">
                <div class="header-content">
                    <h1>User Management</h1>
                    <div class="user-info">
                        <div class="avatar">
                            <%= request.getAttribute("firstLetterOfName") %>
                        </div>
                        <div class="username">${sessionScope.user.full_name}</div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="container">
            <!-- Display success/error message if any -->
            <c:if test="${not empty message}">
                <div class="alert alert-success">
                    ${message}
                </div>
            </c:if>
            
            <div class="stat-grid">
                <div class="stat-card">
                    <div class="stat-value">${totalUsers}</div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${adminCount}</div>
                    <div class="stat-label">Admins</div>
                </div>
            </div>
            
            <!-- Users list card -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">User Management</h2>
                    <i class="fas fa-users card-icon"></i>
                </div>
                
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Search users...">
                    <button onclick="searchUsers()"><i class="fas fa-search"></i></button>
                </div>
                
                <div class="table-responsive">
                    <table id="usersTable">
                        <thead>
                            <tr>
                                <th>User ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${allUsers}">
                                <tr>
                                    <td>${user.user_id}</td>
                                    <td>
                                        <div class="user-row">
                                            <div class="avatar">
                                                <c:choose>
                                                    <c:when test="${user.full_name != null && not empty user.full_name}">
                                                        ${fn:substring(user.full_name, 0, 1)}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:substring(user.email, 0, 1)}
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <span>${user.full_name}</span>
                                        </div>
                                    </td>
                                    <td>${user.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.isAdmin()}">
                                                <span class="badge badge-success">Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-warning">User</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/AdminUsersServlet?action=toggleAdmin&userId=${user.user_id}" 
                                               class="btn btn-sm btn-primary" title="${user.isAdmin() ? 'Remove admin rights' : 'Make admin'}">
                                                <i class="fas fa-user-shield"></i>
                                            </a>
                                            <c:if test="${user.user_id != sessionScope.user.user_id}">
                                                <a href="${pageContext.request.contextPath}/AdminUsersServlet?action=delete&userId=${user.user_id}" 
                                                   class="btn btn-sm btn-primary" style="background-color: var(--danger-color);" title="Delete user"
                                                   onclick="return confirm('Are you sure you want to delete this user?')">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination for large user lists -->
                <c:if test="${totalUsers > 20}">
                    <div class="pagination">
                        <a href="#">&laquo;</a>
                        <a href="#" class="active">1</a>
                        <a href="#">2</a>
                        <a href="#">3</a>
                        <a href="#">&raquo;</a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    
    <script>
        function searchUsers() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toUpperCase();
            const table = document.getElementById('usersTable');
            const tr = table.getElementsByTagName('tr');
            
            for (let i = 1; i < tr.length; i++) {
                let found = false;
                const td = tr[i].getElementsByTagName('td');
                
                for (let j = 0; j < td.length; j++) {
                    const txtValue = td[j].textContent || td[j].innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        found = true;
                        break;
                    }
                }
                
                tr[i].style.display = found ? '' : 'none';
            }
        }
        
        // Add event listener for the enter key in the search box
        document.getElementById('searchInput').addEventListener('keyup', function(event) {
            if (event.key === 'Enter') {
                searchUsers();
            }
        });
    </script>
</body>
</html> 
