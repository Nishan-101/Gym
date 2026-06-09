package com.gympro.model;

import java.sql.Timestamp;

/**
 * Model class representing a member's enrollment in a class.
 */
public class ClassEnrollment {
    private int enrollmentId;
    private int userId;
    private int classId;
    private Timestamp enrolledDate;
    private String status;

    // Joined fields
    private String className;
    private String trainerName;
    private Timestamp scheduleDatetime;
    private int durationMinutes;

    public ClassEnrollment() {}

    public int getEnrollmentId()                       { return enrollmentId; }
    public void setEnrollmentId(int enrollmentId)      { this.enrollmentId = enrollmentId; }

    public int getUserId()               { return userId; }
    public void setUserId(int userId)    { this.userId = userId; }

    public int getClassId()                  { return classId; }
    public void setClassId(int classId)      { this.classId = classId; }

    public Timestamp getEnrolledDate()                      { return enrolledDate; }
    public void setEnrolledDate(Timestamp enrolledDate)     { this.enrolledDate = enrolledDate; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public String getClassName()                    { return className; }
    public void setClassName(String className)      { this.className = className; }

    public String getTrainerName()                    { return trainerName; }
    public void setTrainerName(String trainerName)    { this.trainerName = trainerName; }

    public Timestamp getScheduleDatetime()                          { return scheduleDatetime; }
    public void setScheduleDatetime(Timestamp scheduleDatetime)     { this.scheduleDatetime = scheduleDatetime; }

    public int getDurationMinutes()                        { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes)    { this.durationMinutes = durationMinutes; }
}
