package util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

public class CloudinaryUtil {
    private static Cloudinary cloudinary;
    
    static {
        // Initialize Cloudinary with the provided credentials
        cloudinary = new Cloudinary(ObjectUtils.asMap(
            "cloud_name", "dtnxy4t7e",
            "api_key", "649417366995584",
            "api_secret", "JNemu1yUOFB5Nb7MgXaCb2cH-M4"
        ));
    }
    
    public static Map uploadImage(Part filePart) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        try (InputStream fileInputStream = filePart.getInputStream()) {
            // Upload the image to Cloudinary
            Map uploadResult = cloudinary.uploader().upload(
                fileInputStream.readAllBytes(),
                ObjectUtils.asMap(
                    "folder", "sewasathi",
                    "use_filename", true,
                    "unique_filename", true
                )
            );
            
            return uploadResult;
        }
    }
    
    public static boolean deleteImage(String publicId) {
        if (publicId == null || publicId.isEmpty()) {
            return false;
        }
        
        try {
            // Delete the image from Cloudinary
            Map result = cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
            return "ok".equals(result.get("result"));
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
} 