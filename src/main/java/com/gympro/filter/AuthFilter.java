package com.gympro.filter;

import com.gympro.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Authentication Filter
 * Checks user login and role access.
 */
@WebFilter(urlPatterns = {"/admin/*", "/member/*"})
public class AuthFilter implements Filter {

    // Role constants
    private static final String ROLE_ADMIN = "admin";
    private static final String ROLE_MEMBER = "member";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        // Convert request and response into HTTP objects
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        // Get current session
        HttpSession session = req.getSession(false);

        // Get logged-in user from session
        User loggedUser = null;

        if (session != null) {
            loggedUser = (User) session.getAttribute("loggedUser");
        }

        // Get current request URL
        String contextPath = req.getContextPath();
        String uri = req.getRequestURI();

        // If user is not logged in
        if (loggedUser == null) {

            if (session != null) {
                session.setAttribute(
                        "errorMessage",
                        "Please login to continue."
                );
            }

            resp.sendRedirect(contextPath + "/login");
            return;
        }

        // Admin access check
        if (uri.startsWith(contextPath + "/admin/")
                && !ROLE_ADMIN.equals(loggedUser.getRole())) {

            resp.sendRedirect(contextPath + "/error403.jsp");
            return;
        }

        // Member access check
        if (uri.startsWith(contextPath + "/member/")
                && !ROLE_MEMBER.equals(loggedUser.getRole())) {

            resp.sendRedirect(contextPath + "/error403.jsp");
            return;
        }

        // Continue request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
