package com.gympro.controller;

import com.gympro.dao.AttendanceDAO;
import com.gympro.dao.ClassDAO;
import com.gympro.dao.MemberMembershipDAO;
import com.gympro.dao.UserDAO;
import com.gympro.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.*;

/**
 * Controller for admin analytics/reports dashboard.
 * Generates: revenue summary, class popularity, attendance rates,
 * membership plan distribution, and member growth data.
 */
@WebServlet("/admin/reports")
public class AdminReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // ── 1. Revenue by plan ───────────────────────────────────────────
            List<Map<String, Object>> revenueByPlan = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT mp.plan_name, COUNT(*) AS total_sold, " +
                    "COALESCE(SUM(mm.amount_paid),0) AS revenue " +
                    "FROM member_memberships mm " +
                    "JOIN membership_plans mp ON mm.plan_id = mp.plan_id " +
                    "WHERE mm.payment_status = 'paid' " +
                    "GROUP BY mp.plan_id, mp.plan_name ORDER BY revenue DESC")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("planName",  rs.getString("plan_name"));
                    row.put("totalSold", rs.getInt("total_sold"));
                    row.put("revenue",   rs.getBigDecimal("revenue"));
                    revenueByPlan.add(row);
                }
            }

            // ── 2. Class popularity by enrollment count ──────────────────────
            List<Map<String, Object>> classPop = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT c.class_name, c.enrolled_count, c.capacity, " +
                    "t.full_name AS trainer_name " +
                    "FROM classes c JOIN trainers t ON c.trainer_id = t.trainer_id " +
                    "ORDER BY c.enrolled_count DESC LIMIT 10")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("className",    rs.getString("class_name"));
                    row.put("enrolledCount",rs.getInt("enrolled_count"));
                    row.put("capacity",     rs.getInt("capacity"));
                    row.put("trainerName",  rs.getString("trainer_name"));
                    classPop.add(row);
                }
            }

            // ── 3. Attendance summary per class ──────────────────────────────
            List<Map<String, Object>> attendanceSummary = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT c.class_name, " +
                    "SUM(CASE WHEN a.status='present' THEN 1 ELSE 0 END) AS present_count, " +
                    "SUM(CASE WHEN a.status='absent'  THEN 1 ELSE 0 END) AS absent_count, " +
                    "COUNT(*) AS total " +
                    "FROM attendance a JOIN classes c ON a.class_id = c.class_id " +
                    "GROUP BY c.class_id, c.class_name ORDER BY total DESC")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("className",    rs.getString("class_name"));
                    row.put("presentCount", rs.getInt("present_count"));
                    row.put("absentCount",  rs.getInt("absent_count"));
                    row.put("total",        rs.getInt("total"));
                    int total = rs.getInt("total");
                    row.put("attendanceRate",
                        total > 0 ? (rs.getInt("present_count") * 100 / total) : 0);
                    attendanceSummary.add(row);
                }
            }

            // ── 4. Member registration trend (last 6 months) ─────────────────
            List<Map<String, Object>> memberTrend = new ArrayList<>();
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT DATE_FORMAT(created_at, '%b %Y') AS month_label, " +
                    "COUNT(*) AS new_members " +
                    "FROM users WHERE role='member' " +
                    "AND created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " +
                    "GROUP BY YEAR(created_at), MONTH(created_at) " +
                    "ORDER BY YEAR(created_at), MONTH(created_at)")) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("month",      rs.getString("month_label"));
                    row.put("newMembers", rs.getInt("new_members"));
                    memberTrend.add(row);
                }
            }

            // ── 5. Summary totals ────────────────────────────────────────────
            int totalMembers = 0, totalTrainers = 0, totalClasses = 0;
            BigDecimal totalRevenue = BigDecimal.ZERO;

            try (ResultSet rs = conn.prepareStatement(
                    "SELECT " +
                    "(SELECT COUNT(*) FROM users WHERE role='member' AND status='approved') AS members, " +
                    "(SELECT COUNT(*) FROM trainers WHERE is_active=1) AS trainers, " +
                    "(SELECT COUNT(*) FROM classes WHERE is_active=1) AS classes, " +
                    "(SELECT COALESCE(SUM(amount_paid),0) FROM member_memberships WHERE payment_status='paid') AS revenue")
                    .executeQuery()) {
                if (rs.next()) {
                    totalMembers  = rs.getInt("members");
                    totalTrainers = rs.getInt("trainers");
                    totalClasses  = rs.getInt("classes");
                    totalRevenue  = rs.getBigDecimal("revenue");
                }
            }

            // ── 6. Pending payments count ────────────────────────────────────
            int pendingPayments = 0;
            try (ResultSet rs = conn.prepareStatement(
                    "SELECT COUNT(*) FROM member_memberships WHERE payment_status='pending'")
                    .executeQuery()) {
                if (rs.next()) pendingPayments = rs.getInt(1);
            }

            req.setAttribute("revenueByPlan",    revenueByPlan);
            req.setAttribute("classPop",         classPop);
            req.setAttribute("attendanceSummary",attendanceSummary);
            req.setAttribute("memberTrend",      memberTrend);
            req.setAttribute("totalMembers",     totalMembers);
            req.setAttribute("totalTrainers",    totalTrainers);
            req.setAttribute("totalClasses",     totalClasses);
            req.setAttribute("totalRevenue",     totalRevenue);
            req.setAttribute("pendingPayments",  pendingPayments);

        } catch (SQLException e) {
            req.setAttribute("error", "Failed to load reports: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(req, resp);
    }
}
