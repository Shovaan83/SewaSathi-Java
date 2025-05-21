/**
 * SewaSathi Cloudinary Image Upload Helper
 * 
 * This file contains functions to handle image uploads for campaigns
 */

function updateCampaignImage(campaignId) {
    // Create a hidden file input
    const fileInput = document.createElement('input');
    fileInput.type = 'file';
    fileInput.accept = 'image/*';
    fileInput.style.display = 'none';
    document.body.appendChild(fileInput);
    
    // Trigger the file selection dialog
    fileInput.click();
    
    // Handle file selection
    fileInput.addEventListener('change', function() {
        if (!fileInput.files || !fileInput.files[0]) {
            document.body.removeChild(fileInput);
            return;
        }
        
        // Create form data
        const formData = new FormData();
        formData.append('campaignId', campaignId);
        formData.append('image', fileInput.files[0]);
        
        // Show loading overlay
        const imageContainer = document.querySelector('.campaign-image-container');
        const overlay = document.createElement('div');
        overlay.className = 'upload-overlay';
        overlay.innerHTML = `
            <div class="spinner"></div>
            <div>Uploading image...</div>
        `;
        imageContainer.appendChild(overlay);
        
        // Send the image to the server
        fetch(`${contextPath}/update-campaign-image`, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Server error');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // Refresh the page to show the new image
                window.location.reload();
            } else {
                showNotification('Error: ' + (data.message || 'Failed to update image'), 'error');
                imageContainer.removeChild(overlay);
            }
        })
        .catch(error => {
            console.error('Error updating image:', error);
            showNotification('Error uploading image. Please try again.', 'error');
            imageContainer.removeChild(overlay);
        })
        .finally(() => {
            document.body.removeChild(fileInput);
        });
    });
}

function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.innerHTML = `
        <div class="notification-icon">
            <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        </div>
        <div class="notification-message">${message}</div>
    `;
    
    document.body.appendChild(notification);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 5000);
}

// Add styles when the document is loaded
document.addEventListener('DOMContentLoaded', function() {
    const style = document.createElement('style');
    style.textContent = `
        .notification {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.2);
            padding: 15px 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            z-index: 1000;
            transition: opacity 0.3s;
        }
        
        .notification.success .notification-icon {
            color: #2ecc71;
        }
        
        .notification.error .notification-icon {
            color: #e74c3c;
        }
        
        .notification-message {
            flex: 1;
        }
        
        .upload-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            border-radius: 5px;
        }

        .spinner {
            border: 4px solid rgba(255, 255, 255, 0.3);
            border-top: 4px solid white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin-bottom: 10px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .campaign-image-container {
            position: relative;
        }
    `;
    document.head.appendChild(style);
}); 