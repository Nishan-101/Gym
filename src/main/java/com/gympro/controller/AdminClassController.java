package com.gympro.controller;

import com.gympro.model.GymClass;
import com.gympro.service.ClassService;
import com.gympro.service.TrainerService;
import com.gympro.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

/**
 * Admin controller for Class scheduling CRUD.
 */
@WebServlet("/admin/classes")
public class AdminClassController extends HttpServlet {

    private final ClassService   classService   = new ClassService();
    private final TrainerService trainerService = new TrainerService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("classes",  classService.getAllClasses());
            req.setAttribute("trainers", trainerService.getActiveTrainers());
            String editId = req.getParameter("editId");
            if (editId != null) {
                req.setAttribute("editClass", classService.getClassById(Integer.parseInt(editId)));
            }
            String viewId = req.getParameter("viewAttendance");
            if (viewId != null) {
                req.setAttribute("attendanceList", classService.getAttendanceByClass(Integer.parseInt(viewId)));
                req.setAttribute("viewClass", classService.getClassById(Integer.parseInt(viewId)));
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/classes.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            switch (action) {
                case "add":    handleAdd(req, resp);    break;
                case "update": handleUpdate(req, resp); break;
                case "delete": handleDelete(req, resp); break;
                case "markAttendance": handleAttendance(req, resp); break;
                default: resp.sendRedirect(req.getContextPath() + "/admin/classes");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        GymClass gc = buildClass(req);
        if (gc == null) {
            req.setAttribute("error", "Invalid datetime format."); doGet(req, resp); return;
        }
        if (!ValidationUtil.isNotEmpty(gc.getClassName())) {
            req.setAttribute("error", "Class name is required."); doGet(req, resp); return;
        }
        if (classService.addClass(gc)) {
            resp.sendRedirect(req.getContextPath() + "/admin/classes?success=added");
        } else {
            req.setAttribute("error", "Failed to add class."); doGet(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        GymClass gc = buildClass(req);
        if (gc == null) {
            req.setAttribute("error", "Invalid datetime format."); doGet(req, resp); return;
        }
        gc.setClassId(Integer.parseInt(req.getParameter("classId")));
        gc.setActive("1".equals(req.getParameter("isActive")));
        if (classService.updateClass(gc)) {
            resp.sendRedirect(req.getContextPath() + "/admin/classes?success=updated");
        } else {
            req.setAttribute("error", "Failed to update class."); doGet(req, resp);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int id = Integer.parseInt(req.getParameter("classId"));
        if (classService.deleteClass(id)) {
            resp.sendRedirect(req.getContextPath() + "/admin/classes?success=deleted");
        } else {
            req.setAttribute("error", "Failed to delete class."); doGet(req, resp);
        }
    }

    private void handleAttendance(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int userId  = Integer.parseInt(req.getParameter("userId"));
        int classId = Integer.parseInt(req.getParameter("classId"));
        String status = req.getParameter("status");
        classService.markAttendance(userId, classId, status);
        resp.sendRedirect(req.getContextPath() + "/admin/classes?viewAttendance=" + classId + "&success=attendance");
    }

    private GymClass buildClass(HttpServletRequest req) {
        GymClass gc = new GymClass();
        gc.setClassName(ValidationUtil.safeTrim(req.getParameter("className")));
        gc.setTrainerId(Integer.parseInt(req.getParameter("trainerId")));
        String dtStr = req.getParameter("scheduleDatetime");
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            java.util.Date d = sdf.parse(dtStr);
            gc.setScheduleDatetime(new Timestamp(d.getTime()));
        } catch (Exception e) { return null; }
        String dur = req.getParameter("durationMinutes");
        gc.setDurationMinutes(dur != null && !dur.isEmpty() ? Integer.parseInt(dur) : 60);
        String cap = req.getParameter("capacity");
        gc.setCapacity(cap != null && !cap.isEmpty() ? Integer.parseInt(cap) : 20);
        gc.setDescription(ValidationUtil.safeTrim(req.getParameter("description")));
        gc.setActive(true);
        return gc;
    }
}
