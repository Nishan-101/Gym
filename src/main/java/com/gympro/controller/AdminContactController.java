package com.gympro.controller;

import com.gympro.service.ContactService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Controller for the Admin Inquiries page.
 * Shows all contact messages submitted via the public contact form.
 * Admin can only view and mark messages as read — no editing.
 */
@WebServlet("/admin/contact")
public class AdminContactController extends HttpServlet {

    private final ContactService contactService = new ContactService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("inquiries", contactService.getAllInquiries());
        } catch (Exception e) {
            req.setAttribute("error", "Failed to load inquiries: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/contact.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String idStr  = req.getParameter("inquiryId");

        if ("markRead".equals(action) && idStr != null) {
            try {
                contactService.markAsRead(Integer.parseInt(idStr));
                req.setAttribute("success", "Inquiry marked as read.");
            } catch (Exception e) {
                req.setAttribute("error", "Could not update inquiry: " + e.getMessage());
            }
        }
        doGet(req, resp);
    }
}
