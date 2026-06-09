package com.gympro.dao;

import com.gympro.model.MembershipPlan;
import com.gympro.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for membership_plans table.
 */
public class MembershipPlanDAO {

    public int insert(MembershipPlan plan) throws SQLException {
        String sql = "INSERT INTO membership_plans (plan_name, duration_months, price, description) VALUES (?,?,?,?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, plan.getPlanName());
            ps.setInt(2, plan.getDurationMonths());
            ps.setBigDecimal(3, plan.getPrice());
            ps.setString(4, plan.getDescription());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally { DBConnection.close(conn); }
    }

    public MembershipPlan findById(int planId) throws SQLException {
        String sql = "SELECT * FROM membership_plans WHERE plan_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, planId);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? map(rs) : null;
        } finally { DBConnection.close(conn); }
    }

    public List<MembershipPlan> findAll() throws SQLException {
        List<MembershipPlan> list = new ArrayList<>();
        String sql = "SELECT * FROM membership_plans ORDER BY duration_months ASC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    public List<MembershipPlan> findActive() throws SQLException {
        List<MembershipPlan> list = new ArrayList<>();
        String sql = "SELECT * FROM membership_plans WHERE is_active=1 ORDER BY duration_months ASC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            ResultSet rs = conn.prepareStatement(sql).executeQuery();
            while (rs.next()) list.add(map(rs));
        } finally { DBConnection.close(conn); }
        return list;
    }

    public boolean update(MembershipPlan plan) throws SQLException {
        String sql = "UPDATE membership_plans SET plan_name=?,duration_months=?,price=?,description=?,is_active=? WHERE plan_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, plan.getPlanName());
            ps.setInt(2, plan.getDurationMonths());
            ps.setBigDecimal(3, plan.getPrice());
            ps.setString(4, plan.getDescription());
            ps.setBoolean(5, plan.isActive());
            ps.setInt(6, plan.getPlanId());
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    public boolean delete(int planId) throws SQLException {
        String sql = "DELETE FROM membership_plans WHERE plan_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, planId);
            return ps.executeUpdate() > 0;
        } finally { DBConnection.close(conn); }
    }

    private MembershipPlan map(ResultSet rs) throws SQLException {
        MembershipPlan p = new MembershipPlan();
        p.setPlanId(rs.getInt("plan_id"));
        p.setPlanName(rs.getString("plan_name"));
        p.setDurationMonths(rs.getInt("duration_months"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setDescription(rs.getString("description"));
        p.setActive(rs.getBoolean("is_active"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}
