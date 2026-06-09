package com.gympro.dao;

import com.gympro.model.MemberMembership;
import com.gympro.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for member_memberships table.
 */
public class MemberMembershipDAO {

    public boolean insert(MemberMembership m) throws SQLException {
        String sql = "INSERT INTO member_memberships (user_id,plan_id,start_date,end_date,payment_status,payment_date,amount_paid) VALUES (?,?,?,?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, m.getUserId());
            ps.setInt(2, m.getPlanId());
            ps.setDate(3, m.getStartDate());
            ps.setDate(4, m.getEndDate());
            ps.setString(5, m.getPaymentStatus());
            ps.setDate(6, m.getPaymentDate());
            ps.setBigDecimal(7, m.getAmountPaid());
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Fetch all memberships joined with user and plan names. */
    public List<MemberMembership> findAll() throws SQLException {
        List<MemberMembership> list = new ArrayList<>();
        String sql = "SELECT mm.*, u.full_name AS user_name, mp.plan_name, mp.price AS plan_price " +
                     "FROM member_memberships mm " +
                     "JOIN users u  ON mm.user_id = u.user_id " +
                     "JOIN membership_plans mp ON mm.plan_id = mp.plan_id " +
                     "ORDER BY mm.created_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    /** Fetch memberships for a specific member. */
    public List<MemberMembership> findByUser(int userId) throws SQLException {
        List<MemberMembership> list = new ArrayList<>();
        String sql = "SELECT mm.*, u.full_name AS user_name, mp.plan_name, mp.price AS plan_price " +
                     "FROM member_memberships mm " +
                     "JOIN users u  ON mm.user_id = u.user_id " +
                     "JOIN membership_plans mp ON mm.plan_id = mp.plan_id " +
                     "WHERE mm.user_id = ? ORDER BY mm.start_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    public boolean updatePaymentStatus(int membershipId, String status, Date paymentDate) throws SQLException {
        String sql = "UPDATE member_memberships SET payment_status=?, payment_date=? WHERE membership_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setDate(2, paymentDate);
            ps.setInt(3, membershipId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    /** Sum of all paid amounts. */
    public BigDecimal totalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(amount_paid),0) FROM member_memberships WHERE payment_status='paid'";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        } finally { DBConnection.close(conn); }
    }

    private MemberMembership map(ResultSet rs) throws SQLException {
        MemberMembership m = new MemberMembership();
        m.setMembershipId(rs.getInt("membership_id"));
        m.setUserId(rs.getInt("user_id"));
        m.setPlanId(rs.getInt("plan_id"));
        m.setStartDate(rs.getDate("start_date"));
        m.setEndDate(rs.getDate("end_date"));
        m.setPaymentStatus(rs.getString("payment_status"));
        m.setPaymentDate(rs.getDate("payment_date"));
        m.setAmountPaid(rs.getBigDecimal("amount_paid"));
        m.setCreatedAt(rs.getTimestamp("created_at"));
        m.setUserName(rs.getString("user_name"));
        m.setPlanName(rs.getString("plan_name"));
        m.setPlanPrice(rs.getBigDecimal("plan_price"));
        return m;
    }
}
