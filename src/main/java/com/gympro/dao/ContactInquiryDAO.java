package com.gympro.dao;

import com.gympro.model.ContactInquiry;
import com.gympro.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for contact_inquiries table.
 */
public class ContactInquiryDAO {
// Save a new contact inquiry into the database
    public boolean insert(ContactInquiry ci) throws SQLException {
        String sql = "INSERT INTO contact_inquiries (name,email,subject,message) VALUES (?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, ci.getName());
            ps.setString(2, ci.getEmail());
            ps.setString(3, ci.getSubject());
            ps.setString(4, ci.getMessage());
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }
// Get all contact inquiries from database (latest first)
    public List<ContactInquiry> findAll() throws SQLException {
        List<ContactInquiry> list = new ArrayList<>();
        String sql = "SELECT * FROM contact_inquiries ORDER BY submitted_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }
// To mark a specific inquiry as read
    public boolean markRead(int id) throws SQLException {
        String sql = "UPDATE contact_inquiries SET is_read=1 WHERE inquiry_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }
// Convert database row into ContactInquiry object
    private ContactInquiry map(ResultSet rs) throws SQLException {
        ContactInquiry ci = new ContactInquiry();
        ci.setInquiryId(rs.getInt("inquiry_id"));
        ci.setName(rs.getString("name"));
        ci.setEmail(rs.getString("email"));
        ci.setSubject(rs.getString("subject"));
        ci.setMessage(rs.getString("message"));
        ci.setSubmittedAt(rs.getTimestamp("submitted_at"));
        ci.setRead(rs.getBoolean("is_read"));
        return ci;
    }
}
