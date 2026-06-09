package com.gympro.dao;

import com.gympro.model.Trainer;
import com.gympro.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for trainers table.
 */
public class TrainerDAO {

    public int insert(Trainer t) throws SQLException {
        String sql = "INSERT INTO trainers (full_name,email,phone,specialization,experience_years,bio,schedule) VALUES (?,?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, t.getFullName());
            ps.setString(2, t.getEmail());
            ps.setString(3, t.getPhone());
            ps.setString(4, t.getSpecialization());
            ps.setInt(5, t.getExperienceYears());
            ps.setString(6, t.getBio());
            ps.setString(7, t.getSchedule());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally { DBConnection.close(conn); }
    }

    public Trainer findById(int id) throws SQLException {
        String sql = "SELECT * FROM trainers WHERE trainer_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? map(rs) : null;
        } finally { DBConnection.close(conn); }
    }

    public List<Trainer> findAll() throws SQLException {
        List<Trainer> list = new ArrayList<>();
        String sql = "SELECT * FROM trainers ORDER BY created_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    public List<Trainer> findActive() throws SQLException {
        List<Trainer> list = new ArrayList<>();
        String sql = "SELECT * FROM trainers WHERE is_active=1 ORDER BY full_name ASC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    public boolean update(Trainer t) throws SQLException {
        String sql = "UPDATE trainers SET full_name=?,email=?,phone=?,specialization=?,experience_years=?,bio=?,schedule=?,is_active=? WHERE trainer_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, t.getFullName());
            ps.setString(2, t.getEmail());
            ps.setString(3, t.getPhone());
            ps.setString(4, t.getSpecialization());
            ps.setInt(5, t.getExperienceYears());
            ps.setString(6, t.getBio());
            ps.setString(7, t.getSchedule());
            ps.setBoolean(8, t.isActive());
            ps.setInt(9, t.getTrainerId());
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM trainers WHERE trainer_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM trainers WHERE email=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            return ps.executeQuery().next();
        } finally { DBConnection.close(conn); }
    }

    public int countActive() throws SQLException {
        String sql = "SELECT COUNT(*) FROM trainers WHERE is_active=1";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally { DBConnection.close(conn); }
    }

    private Trainer map(ResultSet rs) throws SQLException {
        Trainer t = new Trainer();
        t.setTrainerId(rs.getInt("trainer_id"));
        t.setFullName(rs.getString("full_name"));
        t.setEmail(rs.getString("email"));
        t.setPhone(rs.getString("phone"));
        t.setSpecialization(rs.getString("specialization"));
        t.setExperienceYears(rs.getInt("experience_years"));
        t.setBio(rs.getString("bio"));
        t.setSchedule(rs.getString("schedule"));
        t.setActive(rs.getBoolean("is_active"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        return t;
    }
}
