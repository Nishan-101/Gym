package com.gympro.controller;

import com.gympro.model.User;
import com.gympro.service.ClassService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Controller for member class browsing and enrollment.
 */
@WebServlet("/member/classes")
public class MemberClassController extends HttpServlet {

    private final ClassService classService = new ClassService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        try {
            req.setAttribute("upcomingClasses", classService.getUpcomingClasses());
            req.setAttribute("myEnrollments",   classService.getEnrollmentsByUser(user.getUserId()));
            req.setAttribute("myAttendance",    classService.getAttendanceByUser(user.getUserId()));
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/member/classes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        String action  = req.getParameter("action");
        int classId = Integer.parseInt(req.getParameter("classId"));

        try {
            if ("enroll".equals(action)) {
                boolean ok = classService.enrollMember(user.getUserId(), classId);
                req.setAttribute(ok ? "success" : "error", ok ? "Enrolled successfully!" : "Enrollment failed — class may be full or you are already enrolled.");
            } else if ("cancel".equals(action)) {
                boolean ok = classService.cancelEnrollment(user.getUserId(), classId);
                req.setAttribute(ok ? "success" : "error", ok ? "Enrollment cancelled." : "Could not cancel enrollment.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
        }
        doGet(req, resp);
    }
}
