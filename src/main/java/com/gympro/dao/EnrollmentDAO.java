package com.gympro.dao;

import com.gympro.model.ClassEnrollment;
import com.gympro.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for managing class enrollments.
 * Handles insert, delete, and query operations on the class_enrollments table.
 */
public class EnrollmentDAO {

    /**
     * Default constructor.
     */
    public EnrollmentDAO() {
    }

    /**
     * Inserts a new enrollment record for the given user and class.
     *
     * @param conn    active database connection
     * @param userId  the ID of the user enrolling
     * @param classId the ID of the class to enroll in
     * @throws SQLException if a database error occurs
     */
    public void insert(Connection conn, int userId, int classId) throws SQLException {
        String sql = "INSERT INTO class_enrollments (user_id, class_id) VALUES (?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, classId);
        ps.executeUpdate();
    }

    /**
     * Deletes an enrollment record matching the given user and class.
     *
     * @param conn    active database connection
     * @param userId  the ID of the user
     * @param classId the ID of the class
     * @return the number of rows affected
     * @throws SQLException if a database error occurs
     */
    public int delete(Connection conn, int userId, int classId) throws SQLException {
        String sql = "DELETE FROM class_enrollments WHERE user_id = ? AND class_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, classId);
        return ps.executeUpdate();
    }

    /**
     * Checks whether a class still has available capacity.
     * Uses a SELECT FOR UPDATE to prevent race conditions.
     *
     * @param conn    active database connection
     * @param classId the ID of the class to check
     * @return true if enrolled_count is less than capacity, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean hasCapacity(Connection conn, int classId) throws SQLException {
        String sql = "SELECT capacity, enrolled_count FROM classes WHERE class_id = ? FOR UPDATE";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, classId);
        ResultSet rs = ps.executeQuery();
        return rs.next() && rs.getInt("enrolled_count") < rs.getInt("capacity");
    }

    /**
     * Checks whether a user is currently enrolled in a specific class.
     *
     * @param userId  the ID of the user
     * @param classId the ID of the class
     * @return true if the user has an active 'enrolled' status, false otherwise
     * @throws SQLException if a database error occurs
     */
    public boolean isEnrolled(int userId, int classId) throws SQLException {
        String sql = "SELECT 1 FROM class_enrollments WHERE user_id = ? AND class_id = ? AND status = 'enrolled'";
        Connection conn = null;
        boolean isFound;

        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, classId);
            isFound = ps.executeQuery().next();
        } finally {
            DBConnection.close(conn);
        }

        return isFound;
    }

    /**
     * Retrieves all class enrollments for a specific user,
     * ordered by scheduled date ascending.
     *
     * @param userId the ID of the user
     * @return a list of ClassEnrollment objects with joined class and trainer details
     * @throws SQLException if a database error occurs
     */
    public List<ClassEnrollment> findByUser(int userId) throws SQLException {
        List<ClassEnrollment> enrollmentList = new ArrayList<>();

        String sql = "SELECT ce.*, c.class_name, c.schedule_datetime, c.duration_minutes, " +
                     "t.full_name AS trainer_name " +
                     "FROM class_enrollments ce " +
                     "JOIN classes c ON ce.class_id = c.class_id " +
                     "JOIN trainers t ON c.trainer_id = t.trainer_id " +
                     "WHERE ce.user_id = ? " +
                     "ORDER BY c.schedule_datetime ASC";

        Connection conn = null;

        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ClassEnrollment enrollment = new ClassEnrollment();
                enrollment.setEnrollmentId(rs.getInt("enrollment_id"));
                enrollment.setUserId(rs.getInt("user_id"));
                enrollment.setClassId(rs.getInt("class_id"));
                enrollment.setEnrolledDate(rs.getTimestamp("enrolled_date"));
                enrollment.setStatus(rs.getString("status"));
                enrollment.setClassName(rs.getString("class_name"));
                enrollment.setScheduleDatetime(rs.getTimestamp("schedule_datetime"));
                enrollment.setDurationMinutes(rs.getInt("duration_minutes"));
                enrollment.setTrainerName(rs.getString("trainer_name"));
                enrollmentList.add(enrollment);
            }

        } finally {
            DBConnection.close(conn);
        }

        return enrollmentList;
    }
}