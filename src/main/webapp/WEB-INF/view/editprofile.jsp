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
    if (user.getFullName() != null && !user.getFullName().isEmpty()) {
        firstLetter = user.getFullName().substring(0, 1).toUpperCase();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Your Profile | <%= user.getFullName() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        :root {
            --primary: #2f80ed;
            --primary-dark: #1a73e8;
            --secondary: #34ca96;
            --text-dark: #333;
            --text-light: #666;
            --background: #f8f9fa;
            --danger: #e74c3c;
            --success: #27ae60;
            --warning: #f39c12;
            --light-gray: #e9ecef;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--background);
            color: var(--text-dark);
        }
        
        .crowdfund-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .top-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: white;
            padding: 15px 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            border-radius: 10px;
            margin-bottom: 30px;
        }
        
        .logo {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary);
        }
        
        .logo span {
            color: var(--secondary);
        }
        
        .top-nav-links a {
            margin-left: 20px;
            text-decoration: none;
            color: var(--text-dark);
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .top-nav-links a:hover {
            color: var(--primary);
        }
        
        .profile-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border-radius: 10px;
            padding: 40px 20px;
            text-align: center;
            margin-bottom: 30px;
        }
        
        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            margin-bottom: 20px;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        
        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: var(--secondary);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 500;
            margin-bottom: 20px;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        
        .form-container {
            background-color: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }
        
        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--light-gray);
        }
        
        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .form-section-title {
            font-size: 1.2rem;
            color: var(--primary);
            margin-bottom: 20px;
            font-weight: 500;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--text-dark);
        }
        
        .form-help {
            font-size: 0.85rem;
            color: var(--text-light);
            margin-top: 5px;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--light-gray);
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
        }
        
        .form-group input:disabled {
            background-color: var(--light-gray);
            cursor: not-allowed;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-start;
            margin-top: 30px;
        }
        
        .button-primary {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 12px 24px;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }
        
        .button-primary:hover {
            background-color: var(--primary-dark);
        }
        
        .button-secondary {
            background-color: white;
            color: var(--primary);
            border: 1px solid var(--primary);
            padding: 12px 24px;
            font-size: 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        
        .button-secondary:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .file-upload {
            border: 2px dashed var(--light-gray);
            padding: 20px;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            transition: border-color 0.3s;
            position: relative;
        }
        
        .file-upload:hover {
            border-color: var(--primary);
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
            margin-bottom: 20px;
        }
        
        .current-image img {
            max-width: 150px;
            border-radius: 5px;
            display: block;
            margin-top: 10px;
        }
        
        .image-preview {
            display: none;
            margin-bottom: 20px;
        }
        
        .image-preview img {
            max-width: 150px;
            border-radius: 5px;
        }
        
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .alert-error {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger);
            border: 1px solid var(--danger);
        }
        
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
        }
        
        .back-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            display: flex;
            align-items: center;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="crowdfund-container">
    <div class="top-nav">
        <div class="logo">Sewa<span>Sathi</span></div>
        <div class="top-nav-links">
            <a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home"></i> Dashboard</a>
            <a href="#"><i class="fas fa-compass"></i> Discover</a>
            <a href="#"><i class="fas fa-lightbulb"></i> Start a Campaign</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <div class="back-link">
        <a href="${pageContext.request.contextPath}/UserProfileServlet"><i class="fas fa-arrow-left"></i> Back to Profile</a>
    </div>

    <div class="profile-header">
        <% if (user.getProfilePicture() != null && user.getProfilePicture().length > 0) { %>
        <div class="profile-image">
            <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(user.getProfilePicture()) %>" alt="Profile Picture">
        </div>
        <% } else { %>
        <div class="avatar">
            <%= firstLetter %>
        </div>
        <% } %>

        <h1>Edit Your Profile</h1>
        <p>Update your information to help backers know you better</p>
    </div>

    <!-- Display error message if present -->
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">
        <%= request.getAttribute("error") %>
    </div>
    <% } %>

    <div class="form-container">
        <form action="${pageContext.request.contextPath}/UpdateProfileServlet" method="post" class="form" enctype="multipart/form-data">
            <div class="form-section">
                <div class="form-section-title">Account Information</div>

                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" value="<%= user.getUsername() %>" disabled>
                    <p class="form-help">Username cannot be changed</p>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" value="<%= user.getEmail() %>" disabled>
                    <p class="form-help">Email address cannot be changed</p>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">Personal Information</div>

                <div class="form-group">
                    <label for="fullName">Full Name*</label>
                    <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required>
                    <p class="form-help">This name will be displayed on your profile and campaigns</p>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">Contact Information</div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                    <p class="form-help">For account recovery and campaign updates</p>
                </div>

                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" value="<%= user.getAddress() != null ? user.getAddress() : "" %>">
                    <p class="form-help">This helps us tailor local campaigns to you</p>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">Profile Picture</div>

                <% if (user.getProfilePicture() != null && user.getProfilePicture().length > 0) { %>
                <div class="current-image">
                    <p>Current Profile Picture:</p>
                    <img src="data:image/jpeg;base64,<%= java.util.Base64.getEncoder().encodeToString(user.getProfilePicture()) %>" alt="Current Profile Picture">
                </div>
                <% } %>

                <!-- New Image Preview -->
                <div id="imagePreview" class="image-preview">
                    <p>New Profile Picture Preview:</p>
                    <img id="previewImg" src="#" alt="New Profile Picture Preview">
                </div>

                <div class="form-group">
                    <label for="profilePicture">Upload New Profile Picture</label>
                    <div class="file-upload">
                        <input type="file" id="profilePicture" name="profilePicture" accept="image/*" onchange="previewImage(this)">
                        <i class="fas fa-cloud-upload-alt" style="font-size: 2rem; color: var(--primary); margin-bottom: 10px;"></i>
                        <p>Click to select a file or drag and drop</p>
                        <p class="form-help">Recommended size: 300x300 pixels. Max size: 5MB.</p>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">Confirm Changes</div>

                <div class="form-group">
                    <label for="password">Enter Password to Save Changes*</label>
                    <input type="password" id="password" name="password" required>
                    <p class="form-help">Your current password is required to save changes</p>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="button-primary">Save Changes</button>
                <a href="${pageContext.request.contextPath}/UserProfileServlet" class="button-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

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
