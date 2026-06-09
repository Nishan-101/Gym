package com.gympro.dao;

import com.gympro.model.MemberAttendance;
import com.gympro.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for member gym attendance check-ins.
 */
public class MemberAttendanceDAO {

    /** Insert today's attendance for a member. Returns true on success. */
    public boolean insert(int userId, String note) throws SQLException {
        String sql = "INSERT INTO member_attendance (user_id, attendance_date, check_in_time, note, status) " +
                     "VALUES (?, CURDATE(), CURTIME(), ?, 'pending')";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, note);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Check if a user has already marked attendance today. */
    public boolean hasMarkedToday(int userId) throws SQLException {
        String sql = "SELECT 1 FROM member_attendance WHERE user_id = ? AND attendance_date = CURDATE()";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeQuery().next();
        } finally { DBConnection.close(conn); }
    }

    /** Get today's attendance record for a user (or null). */
    public MemberAttendance findToday(int userId) throws SQLException {
        String sql = "SELECT * FROM member_attendance WHERE user_id = ? AND attendance_date = CURDATE()";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapBase(rs) : null;
        } finally { DBConnection.close(conn); }
    }

    /** Attendance history for a member (most recent first). */
    public List<MemberAttendance> findByUser(int userId) throws SQLException {
        List<MemberAttendance> list = new ArrayList<>();
        String sql = "SELECT a.*, v.full_name AS verifier_name FROM member_attendance a " +
                     "LEFT JOIN users v ON a.verified_by = v.user_id " +
                     "WHERE a.user_id = ? ORDER BY a.attendance_date DESC, a.check_in_time DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapWithVerifier(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    /** All pending attendance records (for admin verification). */
    public List<MemberAttendance> findPending() throws SQLException {
        List<MemberAttendance> list = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name AS user_name, u.email AS user_email " +
                     "FROM member_attendance a " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "WHERE a.status = 'pending' " +
                     "ORDER BY a.attendance_date DESC, a.check_in_time DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapWithUser(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    /** All attendance records (for admin overview). */
    public List<MemberAttendance> findAll() throws SQLException {
        List<MemberAttendance> list = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name AS user_name, u.email AS user_email, " +
                     "       v.full_name AS verifier_name " +
                     "FROM member_attendance a " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "LEFT JOIN users v ON a.verified_by = v.user_id " +
                     "ORDER BY a.attendance_date DESC, a.check_in_time DESC LIMIT 200";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapFull(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    /** Admin verifies or rejects an attendance record. */
    public boolean updateStatus(int attendanceId, String status, int verifiedBy) throws SQLException {
        String sql = "UPDATE member_attendance SET status = ?, verified_by = ?, verified_at = NOW() " +
                     "WHERE attendance_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, verifiedBy);
            ps.setInt(3, attendanceId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Count by status (for dashboards). */
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM member_attendance WHERE status = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally { DBConnection.close(conn); }
    }

    // ---------- mappers ----------

    private MemberAttendance mapBase(ResultSet rs) throws SQLException {
        MemberAttendance a = new MemberAttendance();
        a.setAttendanceId(rs.getInt("attendance_id"));
        a.setUserId(rs.getInt("user_id"));
        a.setAttendanceDate(rs.getDate("attendance_date"));
        a.setCheckInTime(rs.getTime("check_in_time"));
        a.setNote(rs.getString("note"));
        a.setStatus(rs.getString("status"));
        int vb = rs.getInt("verified_by");
        a.setVerifiedBy(rs.wasNull() ? null : vb);
        a.setVerifiedAt(rs.getTimestamp("verified_at"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        return a;
    }

    private MemberAttendance mapWithVerifier(ResultSet rs) throws SQLException {
        MemberAttendance a = mapBase(rs);
        a.setVerifierName(rs.getString("verifier_name"));
        return a;
    }

    private MemberAttendance mapWithUser(ResultSet rs) throws SQLException {
        MemberAttendance a = mapBase(rs);
        a.setUserName(rs.getString("user_name"));
        a.setUserEmail(rs.getString("user_email"));
        return a;
    }

    private MemberAttendance mapFull(ResultSet rs) throws SQLException {
        MemberAttendance a = mapBase(rs);
        a.setUserName(rs.getString("user_name"));
        a.setUserEmail(rs.getString("user_email"));
        a.setVerifierName(rs.getString("verifier_name"));
        return a;
    }
}