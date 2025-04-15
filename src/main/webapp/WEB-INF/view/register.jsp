<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join Sewa Sathi | Crowdfunding Platform</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/validation.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css">
</head>
<body>
<div class="page-wrapper">
    <div class="register-container">
        <!-- Left Side - Branding Area -->
        <div class="register-sidebar">
            <div class="sidebar-content">
                <div class="logo-area">
                    <div class="logo-circle">SS</div>
                    <h1>Sewa Sathi</h1>
                </div>
                <div class="tagline">Fund Dreams, Build Community</div>
                <p>Join our network of changemakers creating impact through collective action.</p>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">12K+</div>
                        <div class="stat-label">Backers</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">₹12M</div>
                        <div class="stat-label">Funded</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">7500+</div>
                        <div class="stat-label">Projects</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Side - Form Area -->
        <div class="register-form-wrapper">
            <div class="form-header">
                <h2>Create Your Account</h2>
                <p>Start your journey with us today</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/RegisterServlet" method="post" enctype="multipart/form-data">
                <div class="form-modules">
                    <!-- Module 1: Account Information -->
                    <div class="form-module">
                        <div class="module-header">
                            <div class="module-icon">👤</div>
                            <h3>Account Details</h3>
                        </div>
                        <div class="module-content">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="username">Username*</label>
                                    <input type="text" id="username" name="username" placeholder="Choose username" required>
                                </div>
                                <div class="form-group">
                                    <label for="email">Email*</label>
                                    <input type="email" id="email" name="email" placeholder="email@example.com" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="password">Password*</label>
                                    <input type="password" id="password" name="password" placeholder="Create password" required>
                                </div>
                                <div class="form-group">
                                    <label for="confirmPassword">Confirm Password*</label>
                                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm password" required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Module 2: Personal Information -->
                    <div class="form-module">
                        <div class="module-header">
                            <div class="module-icon">📋</div>
                            <h3>Personal Information</h3>
                        </div>
                        <div class="module-content">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="fullName">Full Name*</label>
                                    <input type="text" id="fullName" name="fullName" placeholder="Your name" required>
                                </div>
                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input type="tel" id="phone" name="phone" placeholder="Your phone">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="address">Address</label>
                                    <input type="text" id="address" name="address" placeholder="Your address">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-footer">
                    <div class="checkbox-container">
                        <input type="checkbox" id="termsConditions" name="termsConditions" required>
                        <label for="termsConditions">I agree to the <a href="#">Terms</a> & <a href="#">Privacy Policy</a></label>
                    </div>
                    <button type="submit" class="btn-register">Create Account</button>
                </div>
            </form>

            <div class="login-link">
                Already have an account? <a href="${pageContext.request.contextPath}/LoginServlet">Log in</a>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/validation.js"></script>
</body>
</html>