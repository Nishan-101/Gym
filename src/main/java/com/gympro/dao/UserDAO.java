package com.gympro.dao;

import com.gympro.model.User;
import com.gympro.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User entity.
 * All direct SQL operations for the users table live here.
 */
public class UserDAO {

    /** Insert a new user. Returns generated user_id or -1 on failure. */
    public int insert(User user) throws SQLException {
        String sql = "INSERT INTO users (full_name, email, phone, password, date_of_birth, gender, address, role, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getPassword());
            ps.setDate(5, user.getDateOfBirth());
            ps.setString(6, user.getGender());
            ps.setString(7, user.getAddress());
            ps.setString(8, user.getRole() != null ? user.getRole() : "member");
            ps.setString(9, user.getStatus() != null ? user.getStatus() : "pending");
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally { DBConnection.close(conn); }
    }

    /** Find user by primary key. */
    public User findById(int userId) throws SQLException {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? map(rs) : null;
        } finally { DBConnection.close(conn); }
    }

    /** Find user by email (for login). */
    public User findByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? map(rs) : null;
        } finally { DBConnection.close(conn); }
    }

    /** Return all users with a given role. */
    public List<User> findByRole(String role) throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    /** Return all users with status = 'pending'. */
    public List<User> findPending() throws SQLException {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE status = 'pending' AND role = 'member' ORDER BY created_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    /** Update profile fields (excludes password, role, status). */
    public boolean updateProfile(User user) throws SQLException {
        String sql = "UPDATE users SET full_name=?, phone=?, gender=?, address=?, date_of_birth=? WHERE user_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getGender());
            ps.setString(4, user.getAddress());
            ps.setDate(5, user.getDateOfBirth());
            ps.setInt(6, user.getUserId());
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Update only the password hash. */
    public boolean updatePassword(int userId, String hashedPassword) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Update only the profile photo filename. */
    public boolean updateProfilePhoto(int userId, String fileName) throws SQLException {
        String sql = "UPDATE users SET profile_photo = ? WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, fileName);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Update only the status field. */
    public boolean updateStatus(int userId, String status) throws SQLException {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Hard-delete a user. */
    public boolean delete(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Check whether an email is already registered. */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE email = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            return ps.executeQuery().next();
        } finally { DBConnection.close(conn); }
    }

    /** Check whether a phone number is already registered. */
    public boolean phoneExists(String phone) throws SQLException {
        String sql = "SELECT 1 FROM users WHERE phone = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, phone);
            return ps.executeQuery().next();
        } finally { DBConnection.close(conn); }
    }

    /** Count of approved members. */
    public int countApprovedMembers() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role='member' AND status='approved'";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally { DBConnection.close(conn); }
    }

    /** Maps a ResultSet row to a User object. */
    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setPassword(rs.getString("password"));
        u.setDateOfBirth(rs.getDate("date_of_birth"));
        u.setGender(rs.getString("gender"));
        u.setAddress(rs.getString("address"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setProfilePhoto(rs.getString("profile_photo"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}