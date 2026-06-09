package com.gympro.controller;

import com.gympro.model.User;
import com.gympro.service.UserService;
import com.gympro.util.ValidationUtil;
import com.gympro.util.DateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 * Controller for member profile viewing and editing.
 */
@WebServlet("/member/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB
    maxFileSize       = 5 * 1024 * 1024,    // 5 MB
    maxRequestSize    = 10 * 1024 * 1024    // 10 MB
)
public class MemberProfileController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/member/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);
        User sessionUser = (User) session.getAttribute("loggedUser");

        try {
            if ("updateProfile".equals(action)) {
                String fullName = ValidationUtil.safeTrim(req.getParameter("fullName"));
                String phone    = ValidationUtil.safeTrim(req.getParameter("phone"));
                String gender   = req.getParameter("gender");
                String address  = ValidationUtil.safeTrim(req.getParameter("address"));
                String dob      = req.getParameter("dateOfBirth");

                if (!ValidationUtil.isValidName(fullName)) {
                    req.setAttribute("error", "Name must contain letters only.");
                    doGet(req, resp); return;
                }
                if (!ValidationUtil.isValidPhone(phone)) {
                    req.setAttribute("error", "Phone must be 10 digits.");
                    doGet(req, resp); return;
                }

                sessionUser.setFullName(fullName);
                sessionUser.setPhone(phone);
                sessionUser.setGender(gender);
                sessionUser.setAddress(address);
                sessionUser.setDateOfBirth(DateUtil.parseDate(dob));

                if (userService.updateProfile(sessionUser)) {
                    session.setAttribute("loggedUser", userService.getUserById(sessionUser.getUserId()));
                    req.setAttribute("success", "Profile updated successfully.");
                } else {
                    req.setAttribute("error", "Profile update failed.");
                }

            } else if ("changePassword".equals(action)) {
                String currentPwd = req.getParameter("currentPassword");
                String newPwd     = req.getParameter("newPassword");
                String confirmPwd = req.getParameter("confirmPassword");

                if (!com.gympro.util.PasswordUtil.verifyPassword(currentPwd, sessionUser.getPassword())) {
                    req.setAttribute("error", "Current password is incorrect.");
                    doGet(req, resp); return;
                }
                if (!ValidationUtil.isValidPassword(newPwd)) {
                    req.setAttribute("error", "New password does not meet complexity requirements.");
                    doGet(req, resp); return;
                }
                if (!newPwd.equals(confirmPwd)) {
                    req.setAttribute("error", "Passwords do not match.");
                    doGet(req, resp); return;
                }
                if (userService.changePassword(sessionUser.getUserId(), newPwd)) {
                    session.setAttribute("loggedUser", userService.getUserById(sessionUser.getUserId()));
                    req.setAttribute("success", "Password changed successfully.");
                } else {
                    req.setAttribute("error", "Password change failed.");
                }

            } else if ("updatePhoto".equals(action)) {
                Part filePart = req.getPart("profilePhoto");
                if (filePart == null || filePart.getSize() == 0) {
                    req.setAttribute("error", "Please choose an image to upload.");
                    doGet(req, resp); return;
                }

                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    req.setAttribute("error", "Only image files are allowed (JPG, PNG, GIF).");
                    doGet(req, resp); return;
                }

                String original = filePart.getSubmittedFileName();
                String ext = "";
                if (original != null) {
                    int dot = original.lastIndexOf('.');
                    if (dot >= 0) ext = original.substring(dot).toLowerCase();
                }

                String fileName = "user_" + sessionUser.getUserId() + "_" + System.currentTimeMillis() + ext;

                String uploadDir = getServletContext().getRealPath("/uploads/profile");
                Path uploadPath = Paths.get(uploadDir);
                if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);

                Path target = uploadPath.resolve(fileName);
                try (var in = filePart.getInputStream()) {
                    Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
                }

                if (userService.updateProfilePhoto(sessionUser.getUserId(), fileName)) {
                    session.setAttribute("loggedUser", userService.getUserById(sessionUser.getUserId()));
                    req.setAttribute("success", "Profile photo updated successfully.");
                } else {
                    req.setAttribute("error", "Failed to update profile photo.");
                }
            }
        } catch (Exception e) {
            req.setAttribute("error", "System error: " + e.getMessage());
        }
        doGet(req, resp);
    }
}