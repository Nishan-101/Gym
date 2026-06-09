package com.gympro.controller;

import com.gympro.service.ClassService;
import com.gympro.service.TrainerService;
import com.gympro.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Controller handling public static routes (Home and About).
 */
@WebServlet(urlPatterns = {"", "/about"}) 
public class AboutController extends HttpServlet {

    private final UserService userService = new UserService();
    private final TrainerService trainerService = new TrainerService();
    private final ClassService classService = new ClassService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        String servletPath = req.getServletPath();

        if ("/about".equals(servletPath)) {
            // Forward directly to the about page
            req.getRequestDispatcher("/about.jsp").forward(req, resp);
        } else {
            // Handling the homepage root URL
            try {
                // Fetch dynamic data using your exact service layer methods
                int members = userService.getTotalMembers(); 
                int trainers = trainerService.getTotalTrainers(); 
                int weeklyClasses = classService.getTotalClasses(); 
                double rating = 4.9; 

                // Inject the variables into the request scope
                req.setAttribute("memberCount", members);
                req.setAttribute("trainerCount", trainers);
                req.setAttribute("classCount", weeklyClasses);
                req.setAttribute("averageRating", rating);

            } catch (SQLException e) {
                // Log database errors to the IDE console for debugging
                e.printStackTrace();
                
                // Safe fallbacks to keep the page online if the database fails
                req.setAttribute("memberCount", 500);
                req.setAttribute("trainerCount", 10);
                req.setAttribute("classCount", 30);
                req.setAttribute("averageRating", 5.0);
            }

            // Forward to your homepage JSP file
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }
}