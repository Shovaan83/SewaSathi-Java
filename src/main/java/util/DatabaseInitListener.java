package util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import model.DatabaseConnection;

/**
 * Database initialization listener that runs when the application starts
 */
@WebListener
public class DatabaseInitListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Initialize database when application starts
        DatabaseSetup.initialize();
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Close the connection pool when the application shuts down
        DatabaseConnection.closePool();
    }
} 