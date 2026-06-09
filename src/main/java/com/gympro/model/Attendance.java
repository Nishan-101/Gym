package com.gympro.model;

import java.sql.Date;

/**
 * Model class representing an attendance record.
 */
public class Attendance {
    private int attendanceId;
    private int userId;
    private int classId;
    private Date attendedDate;
    private String status;

    // Joined fields
    private String className;
    private String userName;

    public Attendance() {}

    public int getAttendanceId()                       { return attendanceId; }
    public void setAttendanceId(int attendanceId)      { this.attendanceId = attendanceId; }

    public int getUserId()               { return userId; }
    public void setUserId(int userId)    { this.userId = userId; }

    public int getClassId()                  { return classId; }
    public void setClassId(int classId)      { this.classId = classId; }

    public Date getAttendedDate()                     { return attendedDate; }
    public void setAttendedDate(Date attendedDate)    { this.attendedDate = attendedDate; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public String getClassName()                    { return className; }
    public void setClassName(String className)      { this.className = className; }

    public String getUserName()                  { return userName; }
    public void setUserName(String userName)     { this.userName = userName; }
}
