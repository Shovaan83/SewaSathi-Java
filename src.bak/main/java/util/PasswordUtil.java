package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for secure password handling
 */
public class PasswordUtil {
    private static final int SALT_LENGTH = 16;
    private static final String HASH_ALGORITHM = "SHA-256";
    private static final int ITERATIONS = 10000;

    /**
     * Hash a password using PBKDF2-like approach with SHA-256
     * 
     * @param password The plain text password to hash
     * @return A string representation of the hashed password with salt
     */
    public static String hashPassword(String password) {
        try {
            // Generate a random salt
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Hash the password
            MessageDigest digest = MessageDigest.getInstance(HASH_ALGORITHM);
            byte[] hash = getHash(password, salt, digest, ITERATIONS);
            
            // Convert to Base64 strings
            String saltStr = Base64.getEncoder().encodeToString(salt);
            String hashStr = Base64.getEncoder().encodeToString(hash);
            
            // Format: iterations:salt:hash
            return ITERATIONS + ":" + saltStr + ":" + hashStr;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Failed to hash password", e);
        }
    }
    
    /**
     * Verify a password against a stored hash
     * 
     * @param password The plain text password to check
     * @param storedHash The stored password hash
     * @return true if the password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash) {
        try {
            // Split the stored hash into components
            String[] parts = storedHash.split(":");
            if (parts.length != 3) {
                return false;
            }
            
            int iterations = Integer.parseInt(parts[0]);
            byte[] salt = Base64.getDecoder().decode(parts[1]);
            byte[] hash = Base64.getDecoder().decode(parts[2]);
            
            // Hash the input password with the same salt
            MessageDigest digest = MessageDigest.getInstance(HASH_ALGORITHM);
            byte[] testHash = getHash(password, salt, digest, iterations);
            
            // Compare the hashes in constant time
            int diff = hash.length ^ testHash.length;
            for (int i = 0; i < hash.length && i < testHash.length; i++) {
                diff |= hash[i] ^ testHash[i];
            }
            return diff == 0;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Generate hash using multiple iterations
     */
    private static byte[] getHash(String password, byte[] salt, MessageDigest digest, int iterations) {
        digest.reset();
        digest.update(salt);
        byte[] input = digest.digest(password.getBytes());
        
        for (int i = 0; i < iterations; i++) {
            digest.reset();
            input = digest.digest(input);
        }
        return input;
    }
} 