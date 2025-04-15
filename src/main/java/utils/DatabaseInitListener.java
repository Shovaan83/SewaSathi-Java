package utils;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class DatabaseInitListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application starting - initializing database...");
        DatabaseSetup.initializeDatabase();
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup operations if needed
        System.out.println("Application shutting down");
    }
} 