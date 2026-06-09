package com.gympro.service;

import com.gympro.dao.MemberAttendanceDAO;
import com.gympro.model.MemberAttendance;

import java.sql.SQLException;
import java.util.List;

/**
 Service layer for member attendance.
 */
public class MemberAttendanceService {

    private final MemberAttendanceDAO dao = new MemberAttendanceDAO();

    public boolean markAttendance(int userId, String note) throws SQLException {
        if (dao.hasMarkedToday(userId)) return false;
        return dao.insert(userId, note);
    }

    public boolean hasMarkedToday(int userId)        throws SQLException { return dao.hasMarkedToday(userId); }
    public MemberAttendance getToday(int userId)     throws SQLException { return dao.findToday(userId); }
    public List<MemberAttendance> getByUser(int uid) throws SQLException { return dao.findByUser(uid); }
    public List<MemberAttendance> getPending()       throws SQLException { return dao.findPending(); }
    public List<MemberAttendance> getAll()           throws SQLException { return dao.findAll(); }

    public boolean verify(int attendanceId, int adminId) throws SQLException {
        return dao.updateStatus(attendanceId, "verified", adminId);
    }

    public boolean reject(int attendanceId, int adminId) throws SQLException {
        return dao.updateStatus(attendanceId, "rejected", adminId);
    }

    public int countPending() throws SQLException { return dao.countByStatus("pending"); }
}