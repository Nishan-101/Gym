package com.gympro.controller;

import com.gympro.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Admin controller for managing members: listing, approving, rejecting, deleting.
 */
@WebServlet("/admin/users")
public class AdminUserController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("members",      userService.getUsersByRole("member"));
            req.setAttribute("pendingUsers", userService.getPendingUsers());
        } catch (Exception e) {
            req.setAttribute("error", "Error loading users: " + e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        String userIdStr = req.getParameter("userId");

        try {
            int userId = Integer.parseInt(userIdStr);
            switch (action) {
                case "approve":
                    userService.updateUserStatus(userId, "approved");
                    req.setAttribute("success", "Member approved successfully.");
                    break;
                case "reject":
                    userService.updateUserStatus(userId, "rejected");
                    req.setAttribute("success", "Member registration rejected.");
                    break;
                case "delete":
                    userService.deleteUser(userId);
                    req.setAttribute("success", "Member deleted.");
                    break;
                default:
                    req.setAttribute("error", "Unknown action.");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
        }
        doGet(req, resp);
    }
}
