package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.*;
import util.CloudinaryUtil;

import java.io.IOException;
import java.sql.Connection;
import java.util.Map;

@WebServlet(name = "UpdateCampaignImageServlet", value = {"/UpdateCampaignImageServlet", "/update-campaign-image"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1 MB
    maxFileSize = 1024 * 1024 * 10,     // 10 MB
    maxRequestSize = 1024 * 1024 * 50   // 50 MB
)
public class UpdateCampaignImageServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"User not authenticated\"}");
            return;
        }
        
        // Get campaign ID from request
        String campaignIdStr = request.getParameter("campaignId");
        if (campaignIdStr == null || campaignIdStr.trim().isEmpty()) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Campaign ID is required\"}");
            return;
        }
        
        int campaignId;
        try {
            campaignId = Integer.parseInt(campaignIdStr);
        } catch (NumberFormatException e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid campaign ID\"}");
            return;
        }
        
        // Get image file
        Part filePart = request.getPart("campaignImage");
        if (filePart == null || filePart.getSize() == 0) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"No image file provided\"}");
            return;
        }
        
        try (Connection conn = DatabaseConnection.getConnection()) {
            CampaignDAO campaignDAO = new CampaignDAO(conn);
            Campaign campaign = campaignDAO.getCampaignById(campaignId);
            
            // Check if campaign exists
            if (campaign == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Campaign not found\"}");
                return;
            }
            
            // Check if user is owner or admin
            if (campaign.getCreated_by() != currentUser.getUser_id() && currentUser.getRole_id() != 1) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Not authorized to update this campaign\"}");
                return;
            }
            
            // Store old image public ID for cleanup
            String oldImagePublicId = campaign.getCampaign_image_public_id();
            
            // Upload new image to Cloudinary
            Map uploadResult = CloudinaryUtil.uploadImage(filePart);
            if (uploadResult == null) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to upload image\"}");
                return;
            }
            
            // Get new image URL and public ID
            String newImageUrl = (String) uploadResult.get("secure_url");
            String newImagePublicId = (String) uploadResult.get("public_id");
            
            // Update campaign image in database
            boolean updateSuccess = campaignDAO.updateCampaignImage(campaignId, newImageUrl, newImagePublicId);
            
            if (updateSuccess) {
                // Delete old image if it's not the default
                if (oldImagePublicId != null && !oldImagePublicId.equals("default-campaign")) {
                    CloudinaryUtil.deleteImage(oldImagePublicId);
                }
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Campaign image updated successfully\", \"imageUrl\": \"" + newImageUrl + "\"}");
            } else {
                // If database update fails, delete the uploaded image
                CloudinaryUtil.deleteImage(newImagePublicId);
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to update campaign image\"}");
            }
            
        } catch (Exception e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
        }
    }
}