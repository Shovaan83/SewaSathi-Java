package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet that handles monetary donation requests
 */
@WebServlet(urlPatterns = {"/monetary-donation", "/donation.do"})
public class MonetaryDonationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Simply forward to the monetary donation JSP page which has mock data
        request.getRequestDispatcher("/WEB-INF/view/monetarydonation.jsp").forward(request, response);
    }
}