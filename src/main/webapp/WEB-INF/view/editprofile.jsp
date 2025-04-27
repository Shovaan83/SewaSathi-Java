<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get user from session
    User user = (User) session.getAttribute("user");
    if (user == null) {
        // User not logged in, redirect to LoginServlet
        response.sendRedirect(request.getContextPath() + "/LoginServlet");
        return;
    }

    // Get the first letter of the user's name for the avatar
    String firstLetter = "";
    if (user.getFull_name() != null && !user.getFull_name().isEmpty()) {
        firstLetter = user.getFull_name().substring(0, 1).toUpperCase();
    } else {
        firstLetter = user.getEmail().substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Your Profile | <%= user.getFull_name() %></title>
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
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .back-link {
            margin-bottom: 1.5rem;
        }
        
        .back-link a {
            color: var(--primary-color);
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            font-weight: 500;
            transition: var(--transition);
        }
        
        .back-link a:hover {
            color: var(--secondary-color);
        }
        
        .back-link i {
            margin-right: 0.5rem;
        }
        
        .profile-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: var(--border-radius);
            padding: 2rem;
            text-align: center;
            color: white;
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }
        
        .profile-image {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            overflow: hidden;
            margin: 0 auto 1rem;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }
        
        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: 500;
            margin: 0 auto 1rem;
            border: 3px solid rgba(255, 255, 255, 0.3);
        }
        
        .profile-name {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .profile-username {
            opacity: 0.8;
            font-size: 1rem;
        }
        
        .form-container {
            background-color: white;
            border-radius: var(--border-radius);
            padding: 2rem;
            box-shadow: var(--box-shadow);
            margin-bottom: 2rem;
        }
        
        .form-section {
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #eee;
        }
        
        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .form-section-title {
            font-size: 1.2rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--dark-color);
        }
        
        .form-help {
            margin-top: 0.5rem;
            font-size: 0.85rem;
            color: var(--gray-color);
        }
        
        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-family: inherit;
            font-size: 1rem;
            transition: var(--transition);
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.1);
        }
        
        .form-group input:disabled {
            background-color: #f5f5f5;
            cursor: not-allowed;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
        }
        
        .button-primary {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: var(--border-radius);
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            font-family: inherit;
            font-size: 1rem;
        }
        
        .button-primary:hover {
            background-color: var(--secondary-color);
        }
        
        .button-secondary {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background-color: #f8f9fa;
            color: var(--dark-color);
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-weight: 500;
            text-decoration: none;
            cursor: pointer;
            transition: var(--transition);
            font-family: inherit;
            font-size: 1rem;
        }
        
        .button-secondary:hover {
            background-color: #e9ecef;
        }
        
        .file-upload {
            border: 2px dashed #ddd;
            padding: 2rem;
            text-align: center;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: var(--transition);
            position: relative;
        }
        
        .file-upload:hover {
            border-color: var(--primary-color);
        }
        
        .file-upload input[type="file"] {
            position: absolute;
            width: 100%;
            height: 100%;
            top: 0;
            left: 0;
            opacity: 0;
            cursor: pointer;
        }
        
        .current-image {
            margin-bottom: 1.5rem;
        }
        
        .current-image p {
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        
        .current-image img {
            max-width: 150px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }
        
        .image-preview {
            margin-bottom: 1.5rem;
        }
        
        .image-preview p {
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        
        .image-preview img {
            max-width: 150px;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
        }
        
        .alert {
            padding: 1rem;
            border-radius: var(--border-radius);
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        
        .alert-error {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(220, 53, 69, 0.2);
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/navbar.jsp" />

<div class="container">
    <div class="back-link">
        <a href="${pageContext.request.contextPath}/UserProfileServlet">
            <i class="fas fa-arrow-left"></i> Back to Profile
        </a>
    </div>

    <div class="profile-header">
        <% if (user.getProfile_picture_url() != null && !user.getProfile_picture_url().isEmpty()) { %>
        <div class="profile-image">
            <img src="<%= user.getProfile_picture_url() %>" alt="Profile Picture">
        </div>
        <% } else { %>
        <div class="avatar">
            <%= firstLetter %>
        </div>
        <% } %>

        <h1 class="profile-name">Edit Your Profile</h1>
        <p class="profile-username">Update your information to help others know you better</p>
    </div>

    <!-- Display error message if present -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">
        <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="form-container">
        <form action="${pageContext.request.contextPath}/UpdateProfileServlet" method="post" class="form" enctype="multipart/form-data">
            
            <div class="form-section">
                <div class="form-section-title">
                    <i class="fas fa-user-circle"></i> Account Information
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" value="<%= user.getEmail() %>" disabled>
                    <p class="form-help">Email address cannot be changed</p>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">
                    <i class="fas fa-id-card"></i> Personal Information
                </div>

                <div class="form-group">
                    <label for="full_name">Full Name*</label>
                    <input type="text" id="full_name" name="full_name" value="<%= user.getFull_name() != null ? user.getFull_name() : "" %>" required>
                    <p class="form-help">This name will be displayed on your profile and campaigns</p>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">
                    <i class="fas fa-address-book"></i> Contact Information
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" value="" placeholder="e.g., 9876543210">
                    <p class="form-help">For account recovery and campaign updates</p>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" value="" placeholder="e.g., Kathmandu, Nepal">
                    <p class="form-help">This helps us tailor local campaigns to you</p>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">
                    <i class="fas fa-camera"></i> Profile Picture
                </div>

                <% if (user.getProfile_picture_url() != null && !user.getProfile_picture_url().isEmpty()) { %>
                <div class="current-image">
                    <p>Current Profile Picture:</p>
                    <img src="<%= user.getProfile_picture_url() %>" alt="Current Profile Picture">
                </div>
                <% } %>

                <!-- New Image Preview -->
                <div id="imagePreview" class="image-preview" style="display: none;">
                    <p>New Profile Picture Preview:</p>
                    <img id="previewImg" src="#" alt="New Profile Picture Preview">
                </div>

                <div class="form-group">
                    <label for="profile_picture">Upload New Profile Picture</label>
                    <div class="file-upload">
                        <input type="file" id="profile_picture" name="profile_picture" accept="image/*" onchange="previewImage(this)">
                        <i class="fas fa-cloud-upload-alt" style="font-size: 2.5rem; color: var(--primary-color); margin-bottom: 1rem;"></i>
                        <p>Click to select a file or drag and drop</p>
                        <p class="form-help">Recommended size: 300x300 pixels. Max size: 5MB.</p>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">
                    <i class="fas fa-lock"></i> Confirm Changes
                </div>

                <div class="form-group">
                    <label for="password">Enter Password to Save Changes*</label>
                    <input type="password" id="password" name="password" required>
                    <p class="form-help">Your current password is required to save changes</p>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="button-primary">
                    <i class="fas fa-save"></i> Save Changes
                </button>
                <a href="${pageContext.request.contextPath}/UserProfileServlet" class="button-secondary">
                    <i class="fas fa-times"></i> Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/components/footer.jsp" />

<script>
    function previewImage(input) {
        const preview = document.getElementById('imagePreview');
        const previewImg = document.getElementById('previewImg');

        if (input.files && input.files[0]) {
            const reader = new FileReader();

            reader.onload = function(e) {
                previewImg.src = e.target.result;
                preview.style.display = 'block';
            }

            reader.readAsDataURL(input.files[0]);
        } else {
            previewImg.src = '#';
            preview.style.display = 'none';
        }
    }
</script>
</body>
</html>
