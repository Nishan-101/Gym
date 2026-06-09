package com.gympro.controller;

import com.gympro.model.User;
import com.gympro.service.MemberAttendanceService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
  Admin controller for verifying member attendance.
 */
@WebServlet("/admin/attendance")
public class AdminAttendanceController extends HttpServlet {

    private final MemberAttendanceService service = new MemberAttendanceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("pending", service.getPending());
            req.setAttribute("all",     service.getAll());
        } catch (Exception e) {
            req.setAttribute("error", "Error loading attendance: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/attendance.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User admin = (User) session.getAttribute("loggedUser");

        String action = req.getParameter("action");
        String idStr  = req.getParameter("attendanceId");

        try {
            int attendanceId = Integer.parseInt(idStr);
            if ("verify".equals(action)) {
                if (service.verify(attendanceId, admin.getUserId())) {
                    req.setAttribute("success", "Attendance verified.");
                } else {
                    req.setAttribute("error", "Failed to verify attendance.");
                }
            } else if ("reject".equals(action)) {
                if (service.reject(attendanceId, admin.getUserId())) {
                    req.setAttribute("success", "Attendance rejected.");
                } else {
                    req.setAttribute("error", "Failed to reject attendance.");
                }
            } else {
                req.setAttribute("error", "Unknown action.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
        }
        doGet(req, resp);
    }
}