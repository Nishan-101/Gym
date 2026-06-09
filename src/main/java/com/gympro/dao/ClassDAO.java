package com.gympro.dao;

import com.gympro.model.GymClass;
import com.gympro.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for classes table.
 */
public class ClassDAO {

    public int insert(GymClass c) throws SQLException {
        String sql = "INSERT INTO classes (class_name,trainer_id,schedule_datetime,duration_minutes,capacity,description) VALUES (?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, c.getClassName());
            ps.setInt(2, c.getTrainerId());
            ps.setTimestamp(3, c.getScheduleDatetime());
            ps.setInt(4, c.getDurationMinutes());
            ps.setInt(5, c.getCapacity());
            ps.setString(6, c.getDescription());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally { DBConnection.close(conn); }
    }

    public GymClass findById(int id) throws SQLException {
        String sql = "SELECT c.*,t.full_name AS trainer_name FROM classes c " +
                     "JOIN trainers t ON c.trainer_id=t.trainer_id WHERE c.class_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? map(rs) : null;
        } finally { DBConnection.close(conn); }
    }

    public List<GymClass> findAll() throws SQLException {
        List<GymClass> list = new ArrayList<>();
        String sql = "SELECT c.*,t.full_name AS trainer_name FROM classes c " +
                     "JOIN trainers t ON c.trainer_id=t.trainer_id ORDER BY c.schedule_datetime ASC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    public List<GymClass> findUpcoming() throws SQLException {
        List<GymClass> list = new ArrayList<>();
        String sql = "SELECT c.*,t.full_name AS trainer_name FROM classes c " +
                     "JOIN trainers t ON c.trainer_id=t.trainer_id " +
                     "WHERE c.schedule_datetime >= NOW() AND c.is_active=1 ORDER BY c.schedule_datetime ASC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    public boolean update(GymClass c) throws SQLException {
        String sql = "UPDATE classes SET class_name=?,trainer_id=?,schedule_datetime=?,duration_minutes=?,capacity=?,description=?,is_active=? WHERE class_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, c.getClassName());
            ps.setInt(2, c.getTrainerId());
            ps.setTimestamp(3, c.getScheduleDatetime());
            ps.setInt(4, c.getDurationMinutes());
            ps.setInt(5, c.getCapacity());
            ps.setString(6, c.getDescription());
            ps.setBoolean(7, c.isActive());
            ps.setInt(8, c.getClassId());
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM classes WHERE class_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    public int countUpcoming() throws SQLException {
        String sql = "SELECT COUNT(*) FROM classes WHERE is_active=1 AND schedule_datetime>=NOW()";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally { DBConnection.close(conn); }
    }

    /** Atomically increment enrolled_count (used inside transaction). */
    public void incrementEnrolled(Connection conn, int classId) throws SQLException {
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE classes SET enrolled_count=enrolled_count+1 WHERE class_id=?");
        ps.setInt(1, classId);
        ps.executeUpdate();
    }

    /** Atomically decrement enrolled_count (used inside transaction). */
    public void decrementEnrolled(Connection conn, int classId) throws SQLException {
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE classes SET enrolled_count=GREATEST(enrolled_count-1,0) WHERE class_id=?");
        ps.setInt(1, classId);
        ps.executeUpdate();
    }

    private GymClass map(ResultSet rs) throws SQLException {
        GymClass c = new GymClass();
        c.setClassId(rs.getInt("class_id"));
        c.setClassName(rs.getString("class_name"));
        c.setTrainerId(rs.getInt("trainer_id"));
        c.setScheduleDatetime(rs.getTimestamp("schedule_datetime"));
        c.setDurationMinutes(rs.getInt("duration_minutes"));
        c.setCapacity(rs.getInt("capacity"));
        c.setEnrolledCount(rs.getInt("enrolled_count"));
        c.setDescription(rs.getString("description"));
        c.setActive(rs.getBoolean("is_active"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        c.setTrainerName(rs.getString("trainer_name"));
        return c;
    }
}
