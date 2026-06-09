package com.gympro.controller;

import com.gympro.model.Trainer;
import com.gympro.service.TrainerService;
import com.gympro.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Admin controller for Trainer CRUD operations.
 */
@WebServlet("/admin/trainers")
public class AdminTrainerController extends HttpServlet {

    private final TrainerService trainerService = new TrainerService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("trainers", trainerService.getAllTrainers());
            String editId = req.getParameter("editId");
            if (editId != null) {
                req.setAttribute("editTrainer", trainerService.getTrainerById(Integer.parseInt(editId)));
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error loading trainers: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/trainers.jsp").forward(req, resp);
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
                default: resp.sendRedirect(req.getContextPath() + "/admin/trainers");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        Trainer t = buildTrainer(req);
        String error = validateTrainer(t, req);
        if (error != null) {
            req.setAttribute("error", error);
            doGet(req, resp); return;
        }
        if (trainerService.emailExists(t.getEmail())) {
            req.setAttribute("error", "A trainer with this email already exists.");
            doGet(req, resp); return;
        }
        if (trainerService.addTrainer(t)) {
            resp.sendRedirect(req.getContextPath() + "/admin/trainers?success=added");
        } else {
            req.setAttribute("error", "Failed to add trainer."); doGet(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        Trainer t = buildTrainer(req);
        t.setTrainerId(Integer.parseInt(req.getParameter("trainerId")));
        t.setActive("1".equals(req.getParameter("isActive")));
        String error = validateTrainer(t, req);
        if (error != null) {
            req.setAttribute("error", error); doGet(req, resp); return;
        }
        if (trainerService.updateTrainer(t)) {
            resp.sendRedirect(req.getContextPath() + "/admin/trainers?success=updated");
        } else {
            req.setAttribute("error", "Failed to update trainer."); doGet(req, resp);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws Exception {
        int id = Integer.parseInt(req.getParameter("trainerId"));
        if (trainerService.deleteTrainer(id)) {
            resp.sendRedirect(req.getContextPath() + "/admin/trainers?success=deleted");
        } else {
            req.setAttribute("error", "Failed to delete trainer."); doGet(req, resp);
        }
    }

    private Trainer buildTrainer(HttpServletRequest req) {
        Trainer t = new Trainer();
        t.setFullName(ValidationUtil.safeTrim(req.getParameter("fullName")));
        t.setEmail(ValidationUtil.safeTrim(req.getParameter("email")));
        t.setPhone(ValidationUtil.safeTrim(req.getParameter("phone")));
        t.setSpecialization(ValidationUtil.safeTrim(req.getParameter("specialization")));
        String exp = req.getParameter("experienceYears");
        t.setExperienceYears(exp != null && !exp.isEmpty() ? Integer.parseInt(exp) : 0);
        t.setBio(ValidationUtil.safeTrim(req.getParameter("bio")));
        t.setSchedule(ValidationUtil.safeTrim(req.getParameter("schedule")));
        t.setActive(true);
        return t;
    }

    private String validateTrainer(Trainer t, HttpServletRequest req) {
        if (!ValidationUtil.isValidName(t.getFullName()))   return "Trainer name must contain letters only.";
        if (!ValidationUtil.isValidEmail(t.getEmail()))     return "Please enter a valid email.";
        if (!ValidationUtil.isValidPhone(t.getPhone()))     return "Phone must be 10 digits.";
        if (!ValidationUtil.isNotEmpty(t.getSpecialization())) return "Specialization is required.";
        return null;
    }
}
