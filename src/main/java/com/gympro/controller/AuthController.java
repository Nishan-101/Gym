package com.gympro.controller;

import com.gympro.model.User;
import com.gympro.service.UserService;
import com.gympro.util.ValidationUtil;
import com.gympro.util.DateUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Controller handling login, logout, and registration actions.
 */
@WebServlet(urlPatterns = {"/login", "/logout", "/register"})
public class AuthController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.endsWith("/logout")) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login?msg=loggedout");
            return;
        }

        if (uri.endsWith("/register")) {
            req.getRequestDispatcher("/WEB-INF/views/shared/register.jsp").forward(req, resp);
            return;
        }

        // /login
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            User u = (User) session.getAttribute("loggedUser");
            redirectByRole(u, req, resp);
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/shared/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String uri = req.getRequestURI();

        if (uri.endsWith("/login")) {
            handleLogin(req, resp);
        } else if (uri.endsWith("/register")) {
            handleRegister(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = ValidationUtil.safeTrim(req.getParameter("email"));
        String password = req.getParameter("password");

        if (!ValidationUtil.isValidEmail(email) || !ValidationUtil.isNotEmpty(password)) {
            req.setAttribute("error", "Please enter a valid email and password.");
            req.getRequestDispatcher("/WEB-INF/views/shared/login.jsp").forward(req, resp);
            return;
        }

        try {
            User user = userService.login(email, password);
            if (user == null) {
                req.setAttribute("error", "Invalid credentials or account not approved.");
                req.getRequestDispatcher("/WEB-INF/views/shared/login.jsp").forward(req, resp);
                return;
            }
            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes
            redirectByRole(user, req, resp);
        } catch (Exception e) {
            req.setAttribute("error", "A system error occurred. Please try again.");
            req.getRequestDispatcher("/WEB-INF/views/shared/login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = ValidationUtil.safeTrim(req.getParameter("fullName"));
        String email    = ValidationUtil.safeTrim(req.getParameter("email"));
        String phone    = ValidationUtil.safeTrim(req.getParameter("phone"));
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String dob      = ValidationUtil.safeTrim(req.getParameter("dateOfBirth"));
        String gender   = ValidationUtil.safeTrim(req.getParameter("gender"));
        String address  = ValidationUtil.safeTrim(req.getParameter("address"));

        // Validation
        if (!ValidationUtil.isValidName(fullName)) {
            req.setAttribute("error", "Full name must contain letters only (2–100 characters).");
            forwardRegister(req, resp); return;
        }
        if (!ValidationUtil.isValidEmail(email)) {
            req.setAttribute("error", "Please enter a valid email address.");
            forwardRegister(req, resp); return;
        }
        if (!ValidationUtil.isValidPhone(phone)) {
            req.setAttribute("error", "Phone number must be exactly 10 digits.");
            forwardRegister(req, resp); return;
        }
        if (!ValidationUtil.isValidPassword(password)) {
            req.setAttribute("error", "Password must be at least 8 characters with uppercase, lowercase, number, and special character.");
            forwardRegister(req, resp); return;
        }
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            forwardRegister(req, resp); return;
        }
        if (DateUtil.parseDate(dob) == null) {
            req.setAttribute("error", "Please enter a valid date of birth.");
            forwardRegister(req, resp); return;
        }

        try {
            if (userService.emailExists(email)) {
                req.setAttribute("error", "An account with this email already exists.");
                forwardRegister(req, resp); return;
            }
            if (userService.phoneExists(phone)) {
                req.setAttribute("error", "An account with this phone number already exists.");
                forwardRegister(req, resp); return;
            }

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPassword(password);
            user.setDateOfBirth(DateUtil.parseDate(dob));
            user.setGender(gender);
            user.setAddress(address);

            int id = userService.registerUser(user);
            if (id > 0) {
                resp.sendRedirect(req.getContextPath() + "/login?msg=registered");
            } else {
                req.setAttribute("error", "Registration failed. Please try again.");
                forwardRegister(req, resp);
            }
        } catch (Exception e) {
            req.setAttribute("error", "A system error occurred: " + e.getMessage());
            forwardRegister(req, resp);
        }
    }

    private void redirectByRole(User user, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if ("admin".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/member/dashboard");
        }
    }

    private void forwardRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/shared/register.jsp").forward(req, resp);
    }
}
