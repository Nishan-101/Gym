package com.gympro.controller;

import com.gympro.model.User;
import com.gympro.service.MemberAttendanceService;
import com.gympro.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Controller for members to mark and view their gym attendance.
 */
@WebServlet("/member/attendance")
public class MemberAttendanceController extends HttpServlet {

    private final MemberAttendanceService service = new MemberAttendanceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        try {
            req.setAttribute("history",     service.getByUser(user.getUserId()));
            req.setAttribute("today",       service.getToday(user.getUserId()));
            req.setAttribute("markedToday", service.hasMarkedToday(user.getUserId()));
        } catch (Exception e) {
            req.setAttribute("error", "Error loading attendance: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/member/attendance.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        String note = ValidationUtil.safeTrim(req.getParameter("note"));

        try {
            if (service.hasMarkedToday(user.getUserId())) {
                req.setAttribute("error", "You have already marked attendance for today.");
            } else if (service.markAttendance(user.getUserId(), note)) {
                req.setAttribute("success", "Attendance marked successfully. Waiting for admin verification.");
            } else {
                req.setAttribute("error", "Failed to mark attendance.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "System error: " + e.getMessage());
        }
        doGet(req, resp);
    }
}