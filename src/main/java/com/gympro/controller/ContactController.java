package com.gympro.controller;

import com.gympro.model.ContactInquiry;
import com.gympro.service.ContactService;
import com.gympro.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Controller for the public Contact page and inquiry submission.
 */
@WebServlet("/contact")
public class ContactController extends HttpServlet {

    private final ContactService contactService = new ContactService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/shared/contact.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name    = ValidationUtil.safeTrim(req.getParameter("name"));
        String email   = ValidationUtil.safeTrim(req.getParameter("email"));
        String subject = ValidationUtil.safeTrim(req.getParameter("subject"));
        String message = ValidationUtil.safeTrim(req.getParameter("message"));

        if (!ValidationUtil.isValidName(name)) {
            req.setAttribute("error", "Please enter a valid name (letters only)."); doGet(req, resp); return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("error", "Please enter a valid email address."); doGet(req, resp); return;
        }
        if (!ValidationUtil.isNotEmpty(subject)) {
            req.setAttribute("error", "Subject is required."); doGet(req, resp); return;
        }
        if (!ValidationUtil.isNotEmpty(message)) {
            req.setAttribute("error", "Message is required."); doGet(req, resp); return;
        }

        try {
            ContactInquiry ci = new ContactInquiry();
            ci.setName(name); ci.setEmail(email);
            ci.setSubject(subject); ci.setMessage(message);
            if (contactService.saveInquiry(ci)) {
                req.setAttribute("success", "Thank you! Your inquiry has been submitted.");
            } else {
                req.setAttribute("error", "Failed to submit inquiry.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "System error: " + e.getMessage());
        }
        doGet(req, resp);
    }
}
