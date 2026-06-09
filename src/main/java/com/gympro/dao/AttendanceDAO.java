package com.gympro.dao;

import com.gympro.model.Attendance;
import com.gympro.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for attendance table.
 */
public class AttendanceDAO {

    /** Upsert an attendance record for today. */
    public boolean upsert(int userId, int classId, String status) throws SQLException {
        String sql = "INSERT INTO attendance (user_id,class_id,attended_date,status) VALUES (?,?,CURDATE(),?) " +
                     "ON DUPLICATE KEY UPDATE status=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, classId);
            ps.setString(3, status);
            ps.setString(4, status);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Attendance history for a member. */
    public List<Attendance> findByUser(int userId) throws SQLException {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*,c.class_name FROM attendance a " +
                     "JOIN classes c ON a.class_id=c.class_id " +
                     "WHERE a.user_id=? ORDER BY a.attended_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapWithClass(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    /** Attendance records for a class. */
    public List<Attendance> findByClass(int classId) throws SQLException {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT a.*,u.full_name AS user_name FROM attendance a " +
                     "JOIN users u ON a.user_id=u.user_id " +
                     "WHERE a.class_id=? ORDER BY a.attended_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, classId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapWithUser(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    private Attendance mapWithClass(ResultSet rs) throws SQLException {
        Attendance a = base(rs);
        a.setClassName(rs.getString("class_name"));
        return a;
    }

    private Attendance mapWithUser(ResultSet rs) throws SQLException {
        Attendance a = base(rs);
        a.setUserName(rs.getString("user_name"));
        return a;
    }

    private Attendance base(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setAttendanceId(rs.getInt("attendance_id"));
        a.setUserId(rs.getInt("user_id"));
        a.setClassId(rs.getInt("class_id"));
        a.setAttendedDate(rs.getDate("attended_date"));
        a.setStatus(rs.getString("status"));
        return a;
    }
}
