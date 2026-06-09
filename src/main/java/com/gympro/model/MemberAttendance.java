package com.gympro.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * Model class for member gym attendance (check-in) records.
 */
public class MemberAttendance {

    private int attendanceId;
    private int userId;
    private Date attendanceDate;
    private Time checkInTime;
    private String note;
    private String status;        // pending | verified | rejected
    private Integer verifiedBy;
    private Timestamp verifiedAt;
    private Timestamp createdAt;

    // Joined fields
    private String userName;
    private String userEmail;
    private String verifierName;

    public MemberAttendance() {}

    public int getAttendanceId()                       { return attendanceId; }
    public void setAttendanceId(int attendanceId)      { this.attendanceId = attendanceId; }

    public int getUserId()               { return userId; }
    public void setUserId(int userId)    { this.userId = userId; }

    public Date getAttendanceDate()                       { return attendanceDate; }
    public void setAttendanceDate(Date attendanceDate)    { this.attendanceDate = attendanceDate; }

    public Time getCheckInTime()                       { return checkInTime; }
    public void setCheckInTime(Time checkInTime)       { this.checkInTime = checkInTime; }

    public String getNote()                { return note; }
    public void setNote(String note)       { this.note = note; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public Integer getVerifiedBy()                       { return verifiedBy; }
    public void setVerifiedBy(Integer verifiedBy)        { this.verifiedBy = verifiedBy; }

    public Timestamp getVerifiedAt()                     { return verifiedAt; }
    public void setVerifiedAt(Timestamp verifiedAt)      { this.verifiedAt = verifiedAt; }

    public Timestamp getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)       { this.createdAt = createdAt; }

    public String getUserName()                  { return userName; }
    public void setUserName(String userName)     { this.userName = userName; }

    public String getUserEmail()                   { return userEmail; }
    public void setUserEmail(String userEmail)     { this.userEmail = userEmail; }

    public String getVerifierName()                       { return verifierName; }
    public void setVerifierName(String verifierName)      { this.verifierName = verifierName; }
}