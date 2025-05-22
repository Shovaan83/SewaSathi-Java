<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create a Campaign - SewaSathi</title>
    <!-- FontAwesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom styles -->
    <style>
        :root {
            --primary-color: #ff6b6b;
            --secondary-color: #339af0;
            --dark-color: #2c3e50;
            --light-color: #f8f9fa;
            --danger-color: #e74c3c;
            --success-color: #2ecc71;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 1rem;
        }
        
        .page-title {
            text-align: center;
            color: var(--dark-color);
            margin: 2rem 0;
        }
        
        .card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            color: var(--dark-color);
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            outline: none;
        }
        
        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }
        
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
            border-radius: 5px;
            transition: all 0.3s;
            border: none;
            font-size: 1rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #ff5252;
        }
        
        .btn-secondary {
            background-color: var(--secondary-color);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #228be6;
        }
        
        .btn-block {
            display: block;
            width: 100%;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 5px;
            margin-bottom: 1.5rem;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: var(--danger-color);
            border: 1px solid #f5c6cb;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: var(--success-color);
            border: 1px solid #c3e6cb;
        }
        
        .file-input-container {
            position: relative;
            margin-bottom: 1.5rem;
        }
        
        .file-input-label {
            display: block;
            background-color: #f8f9fa;
            border: 2px dashed #ddd;
            border-radius: 5px;
            padding: 2rem 1rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .file-input-label:hover {
            border-color: var(--primary-color);
        }
        
        .file-input {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }
        
        .file-input-icon {
            font-size: 2rem;
            color: #888;
            margin-bottom: 1rem;
        }
        
        .info-text {
            font-size: 0.9rem;
            color: #666;
            margin-top: 0.5rem;
        }
        
        .campaign-form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 2rem;
        }
        
        @media (max-width: 768px) {
            .campaign-form-actions {
                flex-direction: column;
                gap: 1rem;
            }
            
            .btn-block {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Include the navbar -->
    <c:set var="requestURI" value="${pageContext.request.requestURI}" />
    <jsp:include page="/WEB-INF/components/navbar.jsp" />

    <div class="container">
        <h1 class="page-title">Create a New Campaign</h1>
        
        <div class="card">
            <!-- Display error message if any -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    ${error}
                </div>
            </c:if>
            
            <!-- Display success message if any -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    ${success}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/create-campaign" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="title">Campaign Title *</label>
                    <input type="text" id="title" name="title" class="form-control" required>
                    <div class="info-text">Choose a clear, descriptive title that conveys the purpose of your campaign.</div>
                </div>
                
                <div class="form-group">
                    <label for="categoryId">Category *</label>
                    <select id="categoryId" name="categoryId" class="form-control" required>
                        <option value="" disabled selected>Select a category</option>
                        <option value="1">Medical</option>
                        <option value="2">Education</option>
                        <option value="3">Disaster Relief</option>
                        <option value="4">Animal Welfare</option>
                        <option value="5">Environment</option>
                        <option value="6">Community Development</option>
                        <option value="7">Art & Culture</option>
                        <option value="8">Other</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="description">Campaign Description *</label>
                    <textarea id="description" name="description" class="form-control" required></textarea>
                    <div class="info-text">Provide a detailed description of your campaign. Explain why you're raising funds, how the funds will be used, and who will benefit from the campaign.</div>
                </div>
                
                <div class="form-group">
                    <label for="goalAmount">Goal Amount (NPR) *</label>
                    <input type="number" id="goalAmount" name="goalAmount" class="form-control" min="1000" step="1000" required>
                    <div class="info-text">Set a realistic funding goal for your campaign. Minimum amount is NPR 1,000.</div>
                </div>
                
                <div class="form-group">
                    <label for="deadline">End Date *</label>
                    <input type="date" id="deadline" name="deadline" class="form-control" required>
                    <div class="info-text">Choose an end date for your campaign. Campaigns typically run for 30-60 days.</div>
                </div>
                
                <div class="form-group">
                    <label>Donation Type *</label>
                    <div style="display: flex; gap: 20px; margin-top: 10px;">
                        <div style="display: flex; align-items: center;">
                            <input type="radio" id="monetary" name="donationType" value="monetary" checked>
                            <label for="monetary" style="margin-left: 8px; margin-bottom: 0; font-weight: normal;">Monetary Donation</label>
                        </div>
                        <div style="display: flex; align-items: center;">
                            <input type="radio" id="clothes" name="donationType" value="clothes">
                            <label for="clothes" style="margin-left: 8px; margin-bottom: 0; font-weight: normal;">Clothes Donation</label>
                        </div>
                    </div>
                    <div class="info-text">Select the type of donations you want to receive for this campaign.</div>
                </div>
                
                <div class="file-input-container">
                    <label>Campaign Image</label>
                    <label for="campaignImage" class="file-input-label">
                        <div class="file-input-icon">
                            <i class="fas fa-cloud-upload-alt"></i>
                        </div>
                        <div>Drag & drop an image here or click to browse</div>
                        <div class="info-text">Recommended size: 1200x630 pixels, max 5MB (JPG, PNG)</div>
                    </label>
                    <input type="file" id="campaignImage" name="campaignImage" class="file-input" accept="image/*">
                </div>
                
                <div class="form-group">
                    <div class="info-text">
                        <strong>Note:</strong> Your campaign will be reviewed by our team before it becomes visible to the public. This process typically takes 24-48 hours.
                    </div>
                </div>
                
                <div class="campaign-form-actions">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary">Create Campaign</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        // Set minimum date for deadline to tomorrow
        const deadlineInput = document.getElementById('deadline');
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        
        // Format date as YYYY-MM-DD
        const formatDate = (date) => {
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            return `${year}-${month}-${day}`;
        };
        
        deadlineInput.min = formatDate(tomorrow);
        
        // Preview uploaded image
        const fileInput = document.getElementById('campaignImage');
        const fileLabel = document.querySelector('.file-input-label');
        
        fileInput.addEventListener('change', function() {
            if (this.files && this.files[0]) {
                const file = this.files[0];
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    fileLabel.innerHTML = `
                        <div class="file-input-icon">
                            <img src="${e.target.result}" alt="Preview" style="max-width: 100%; max-height: 200px; border-radius: 5px;">
                        </div>
                        <div>${file.name}</div>
                        <div class="info-text">Click to change image</div>
                    `;
                };
                
                reader.readAsDataURL(file);
            }
        });
    </script>
</body>
</html> 
