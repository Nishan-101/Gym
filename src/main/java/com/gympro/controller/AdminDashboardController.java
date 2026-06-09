package com.gympro.controller;

import com.gympro.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Controller for the Admin Dashboard (summary statistics).
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    private final UserService       userService       = new UserService();
    private final MembershipService membershipService = new MembershipService();
    private final TrainerService    trainerService    = new TrainerService();
    private final ClassService      classService      = new ClassService();
    private final ContactService    contactService    = new ContactService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalMembers",  userService.getTotalMembers());
            req.setAttribute("totalTrainers", trainerService.getTotalTrainers());
            req.setAttribute("totalClasses",  classService.getTotalClasses());
            req.setAttribute("totalRevenue",  membershipService.getTotalRevenue());
            req.setAttribute("pendingUsers",  userService.getPendingUsers());
            req.setAttribute("upcomingClasses", classService.getUpcomingClasses());
            req.setAttribute("allInquiries",  contactService.getAllInquiries());
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load dashboard: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
