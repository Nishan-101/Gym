package com.gympro.controller;

import com.gympro.service.MembershipService;
import com.gympro.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Admin controller for managing membership plans and member memberships.
 */
@WebServlet("/admin/memberships")
public class AdminMembershipController extends HttpServlet {

    private final MembershipService membershipService = new MembershipService();
    private final UserService       userService       = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("plans",       membershipService.getAllPlans());
            req.setAttribute("memberships", membershipService.getAllMemberships());
            req.setAttribute("members",     userService.getUsersByRole("member"));
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/memberships.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try {
            switch (action) {
                case "addPlan":
                    handleAddPlan(req, resp); break;
                case "deletePlan":
                    membershipService.deletePlan(Integer.parseInt(req.getParameter("planId")));
                    resp.sendRedirect(req.getContextPath() + "/admin/memberships?success=planDeleted"); break;
                case "assign":
                    handleAssign(req, resp); break;
                case "updatePayment":
                    membershipService.updatePaymentStatus(
                        Integer.parseInt(req.getParameter("membershipId")),
                        req.getParameter("paymentStatus"));
                    resp.sendRedirect(req.getContextPath() + "/admin/memberships?success=paymentUpdated"); break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/memberships");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private void handleAddPlan(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        com.gympro.model.MembershipPlan plan = new com.gympro.model.MembershipPlan();
        plan.setPlanName(req.getParameter("planName"));
        plan.setDurationMonths(Integer.parseInt(req.getParameter("durationMonths")));
        plan.setPrice(new java.math.BigDecimal(req.getParameter("price")));
        plan.setDescription(req.getParameter("description"));
        if (membershipService.addPlan(plan)) {
            resp.sendRedirect(req.getContextPath() + "/admin/memberships?success=planAdded");
        } else {
            req.setAttribute("error", "Failed to add plan."); doGet(req, resp);
        }
    }

    private void handleAssign(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int userId = Integer.parseInt(req.getParameter("userId"));
        int planId = Integer.parseInt(req.getParameter("planId"));
        String startDate = req.getParameter("startDate");
        String paymentStatus = req.getParameter("paymentStatus");
        if (membershipService.assignMembership(userId, planId, startDate, paymentStatus)) {
            resp.sendRedirect(req.getContextPath() + "/admin/memberships?success=assigned");
        } else {
            req.setAttribute("error", "Failed to assign membership."); doGet(req, resp);
        }
    }
}
