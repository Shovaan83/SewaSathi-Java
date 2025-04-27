package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet that handles clothes donation requests
 */
@WebServlet(urlPatterns = {"/clothes-donation", "/clothes-donation.do"})
public class ClothesDonationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward the request to the clothes donation JSP page
        request.getRequestDispatcher("/WEB-INF/view/clothesdonation.jsp").forward(request, response);
    }
}