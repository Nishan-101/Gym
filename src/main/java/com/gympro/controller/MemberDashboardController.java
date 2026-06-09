package com.gympro.controller;

import com.gympro.model.User;
import com.gympro.service.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Controller for the Member Dashboard.
 */
@WebServlet("/member/dashboard")
public class MemberDashboardController extends HttpServlet {

    private final MembershipService membershipService = new MembershipService();
    private final ClassService      classService      = new ClassService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        try {
            req.setAttribute("memberships",    membershipService.getMembershipsByUser(user.getUserId()));
            req.setAttribute("enrollments",    classService.getEnrollmentsByUser(user.getUserId()));
            req.setAttribute("attendance",     classService.getAttendanceByUser(user.getUserId()));
            req.setAttribute("upcomingClasses",classService.getUpcomingClasses());
        } catch (Exception e) {
            req.setAttribute("error", "Error loading dashboard: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/member/dashboard.jsp").forward(req, resp);
    }
}
