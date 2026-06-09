package com.gympro.controller;

import com.gympro.model.User;
import com.gympro.service.MembershipService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Controller for member to view their own membership history.
 */
@WebServlet("/member/memberships")
public class MemberMembershipController extends HttpServlet {

    private final MembershipService membershipService = new MembershipService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        try {
            req.setAttribute("memberships", membershipService.getMembershipsByUser(user.getUserId()));
            req.setAttribute("plans",       membershipService.getActivePlans());
        } catch (Exception e) {
            req.setAttribute("error", "Error loading memberships: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/member/memberships.jsp").forward(req, resp);
    }
}
