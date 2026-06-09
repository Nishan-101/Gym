package com.gympro.service;

import com.gympro.dao.AttendanceDAO;
import com.gympro.dao.ClassDAO;
import com.gympro.dao.EnrollmentDAO;
import com.gympro.model.Attendance;
import com.gympro.model.ClassEnrollment;
import com.gympro.model.GymClass;
import com.gympro.util.DBConnection;

import java.sql.Connection;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.SQLException;
import java.util.List;

/**
 * Service layer for Classes, Enrollment, and Attendance.
 */
public class ClassService {

    private final ClassDAO      classDAO      = new ClassDAO();
    private final EnrollmentDAO enrollmentDAO = new EnrollmentDAO();
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    // ── Classes ──────────────────────────────────────────────────────────────
    public List<GymClass> getAllClasses()           throws SQLException { return classDAO.findAll(); }
    public List<GymClass> getUpcomingClasses()      throws SQLException { return classDAO.findUpcoming(); }
    public GymClass       getClassById(int id)      throws SQLException { return classDAO.findById(id); }
    public boolean        addClass(GymClass c)      throws SQLException { return classDAO.insert(c) > 0; }
    public boolean        updateClass(GymClass c)   throws SQLException { return classDAO.update(c); }
    public boolean        deleteClass(int id)       throws SQLException { return classDAO.delete(id); }
    public int            getTotalClasses()         throws SQLException { return classDAO.countUpcoming(); }

    // ── Enrollments ──────────────────────────────────────────────────────────
    /**
     * Enroll a member in a class within a single transaction.
     * Checks capacity and duplicate enrollment atomically.
     */
    public boolean enrollMember(int userId, int classId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if (!enrollmentDAO.hasCapacity(conn, classId)) {
                conn.rollback();
                return false;
            }
            enrollmentDAO.insert(conn, userId, classId);
            classDAO.incrementEnrolled(conn, classId);
            conn.commit();
            return true;
        } catch (SQLIntegrityConstraintViolationException e) {
            if (conn != null) conn.rollback();
            return false; // Already enrolled
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); DBConnection.close(conn); }
        }
    }

    /**
     * Cancel a member's enrollment within a single transaction.
     */
    public boolean cancelEnrollment(int userId, int classId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            int deleted = enrollmentDAO.delete(conn, userId, classId);
            if (deleted > 0) classDAO.decrementEnrolled(conn, classId);
            conn.commit();
            return deleted > 0;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw e;
        } finally {
            if (conn != null) { conn.setAutoCommit(true); DBConnection.close(conn); }
        }
    }

    public boolean           isEnrolled(int userId, int classId) throws SQLException { return enrollmentDAO.isEnrolled(userId, classId); }
    public List<ClassEnrollment> getEnrollmentsByUser(int userId) throws SQLException { return enrollmentDAO.findByUser(userId); }

    // ── Attendance ───────────────────────────────────────────────────────────
    public boolean          markAttendance(int userId, int classId, String status) throws SQLException { return attendanceDAO.upsert(userId, classId, status); }
    public List<Attendance> getAttendanceByUser(int userId)                        throws SQLException { return attendanceDAO.findByUser(userId); }
    public List<Attendance> getAttendanceByClass(int classId)                      throws SQLException { return attendanceDAO.findByClass(classId); }
}
