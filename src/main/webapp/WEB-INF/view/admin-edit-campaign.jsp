<%@ page import="model.User, model.Campaign, model.Category, java.util.List, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Campaign - SewaSathi Admin</title>
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
            margin-bottom: 1.5rem;
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
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

        .form-group {
            margin-bottom: 1.25rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .form-control {
            display: block;
            width: 100%;
            padding: 0.75rem;
            font-size: 1rem;
            border: 1px solid #ced4da;
            border-radius: var(--border-radius);
            background-color: #fff;
            transition: border-color 0.15s ease-in-out;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(255, 107, 107, 0.25);
        }

        .form-section {
            margin-bottom: 2rem;
        }

        .form-section-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--dark-color);
        }

        .alert {
            padding: 0.75rem 1.25rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            border-radius: var(--border-radius);
        }

        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }

        .btn {
            display: inline-block;
            font-weight: 500;
            color: #212529;
            text-align: center;
            vertical-align: middle;
            cursor: pointer;
            background-color: transparent;
            border: 1px solid transparent;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            line-height: 1.5;
            border-radius: var(--border-radius);
            transition: var(--transition);
        }

        .btn-primary {
            color: #fff;
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: #ff5252;
            border-color: #ff5252;
        }

        .btn-outline-secondary {
            color: var(--gray-color);
            border-color: var(--gray-color);
        }

        .btn-outline-secondary:hover {
            color: #fff;
            background-color: var(--gray-color);
            border-color: var(--gray-color);
        }

        .btn-group {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        .campaign-image-preview {
            width: 100%;
            max-width: 300px;
            border-radius: var(--border-radius);
            margin-bottom: 1rem;
        }

        #description {
            min-height: 150px;
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
                    <h1>Edit Campaign</h1>
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
            <!-- Display error message if any -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    ${error}
                </div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Edit Campaign: ${campaign.title}</h2>
                    <i class="fas fa-edit card-icon"></i>
                </div>

                <form action="${pageContext.request.contextPath}/admin/edit-campaign" method="post">
                    <!-- Hidden fields -->
                    <input type="hidden" name="campaign_id" value="${campaign.campaign_id}">

                    <div class="form-section">
                        <div class="form-section-title">Campaign Information</div>

                        <div class="form-group">
                            <label for="title">Title</label>
                            <input type="text" id="title" name="title" class="form-control" value="${campaign.title}" required>
                        </div>

                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" required>${campaign.description}</textarea>
                        </div>

                        <div class="form-group">
                            <label for="goal_amount">Goal Amount (Rs.)</label>
                            <input type="number" id="goal_amount" name="goal_amount" class="form-control" value="${campaign.goal_amount}" min="1" step="0.01" required>
                        </div>

                        <div class="form-group">
                            <label for="deadline">Deadline</label>
                            <% 
                                Campaign campaign = (Campaign)request.getAttribute("campaign");
                                String formattedDeadline = "";
                                if(campaign != null && campaign.getDeadline() != null) {
                                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                                    formattedDeadline = dateFormat.format(campaign.getDeadline());
                                }
                            %>
                            <input type="date" id="deadline" name="deadline" class="form-control" value="<%= formattedDeadline %>" required>
                        </div>

                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status" class="form-control" required>
                                <option value="pending" ${campaign.status == 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="active" ${campaign.status == 'active' ? 'selected' : ''}>Active</option>
                                <option value="rejected" ${campaign.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                                <option value="completed" ${campaign.status == 'completed' ? 'selected' : ''}>Completed</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="donation_type">Donation Type</label>
                            <select id="donation_type" name="donation_type" class="form-control" required>
                                <option value="monetary" ${campaign.donation_type == 'monetary' ? 'selected' : ''}>Monetary</option>
                                <option value="clothes" ${campaign.donation_type == 'clothes' ? 'selected' : ''}>Clothes</option>
                                <option value="both" ${campaign.donation_type == 'both' ? 'selected' : ''}>Both</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title">Campaign Image</div>

                        <c:if test="${not empty campaign.campaign_image_url}">
                            <img src="${campaign.campaign_image_url}" alt="${campaign.title}" class="campaign-image-preview">
                        </c:if>
                        <p>To change the campaign image, please use the campaign detail page.</p>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title">Creator Information</div>
                        <p><strong>Created by:</strong> ${campaign.creatorName}</p>
                    </div>

                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">Update Campaign</button>
                        <a href="${pageContext.request.contextPath}/admin/campaigns" class="btn btn-outline-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html> 
