package com.gympro.model;

import java.sql.Timestamp;

/**
 * Model class representing a gym class/session.
 */
public class GymClass {
    private int classId;
    private String className;
    private int trainerId;
    private Timestamp scheduleDatetime;
    private int durationMinutes;
    private int capacity;
    private int enrolledCount;
    private String description;
    private boolean isActive;
    private Timestamp createdAt;

    // Joined field
    private String trainerName;

    public GymClass() {}

    public int getClassId()                  { return classId; }
    public void setClassId(int classId)      { this.classId = classId; }

    public String getClassName()                    { return className; }
    public void setClassName(String className)      { this.className = className; }

    public int getTrainerId()                    { return trainerId; }
    public void setTrainerId(int trainerId)      { this.trainerId = trainerId; }

    public Timestamp getScheduleDatetime()                          { return scheduleDatetime; }
    public void setScheduleDatetime(Timestamp scheduleDatetime)     { this.scheduleDatetime = scheduleDatetime; }

    public int getDurationMinutes()                        { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes)    { this.durationMinutes = durationMinutes; }

    public int getCapacity()                  { return capacity; }
    public void setCapacity(int capacity)     { this.capacity = capacity; }

    public int getEnrolledCount()                      { return enrolledCount; }
    public void setEnrolledCount(int enrolledCount)    { this.enrolledCount = enrolledCount; }

    public String getDescription()                      { return description; }
    public void setDescription(String description)      { this.description = description; }

    public boolean isActive()                  { return isActive; }
    public void setActive(boolean isActive)    { this.isActive = isActive; }

    public Timestamp getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)       { this.createdAt = createdAt; }

    public String getTrainerName()                    { return trainerName; }
    public void setTrainerName(String trainerName)    { this.trainerName = trainerName; }

    /** Returns available spots in the class */
    public int getAvailableSpots() {
        return capacity - enrolledCount;
    }
}
