package com.gympro.model;

import java.sql.Timestamp;

/**
 * Model class representing a gym trainer.
 */
public class Trainer {
    private int trainerId;
    private String fullName;
    private String email;
    private String phone;
    private String specialization;
    private int experienceYears;
    private String bio;
    private String schedule;
    private boolean isActive;
    private Timestamp createdAt;

    public Trainer() {}

    public int getTrainerId()                    { return trainerId; }
    public void setTrainerId(int trainerId)      { this.trainerId = trainerId; }

    public String getFullName()                   { return fullName; }
    public void setFullName(String fullName)      { this.fullName = fullName; }

    public String getEmail()                { return email; }
    public void setEmail(String email)      { this.email = email; }

    public String getPhone()                { return phone; }
    public void setPhone(String phone)      { this.phone = phone; }

    public String getSpecialization()                        { return specialization; }
    public void setSpecialization(String specialization)     { this.specialization = specialization; }

    public int getExperienceYears()                        { return experienceYears; }
    public void setExperienceYears(int experienceYears)    { this.experienceYears = experienceYears; }

    public String getBio()             { return bio; }
    public void setBio(String bio)     { this.bio = bio; }

    public String getSchedule()                  { return schedule; }
    public void setSchedule(String schedule)     { this.schedule = schedule; }

    public boolean isActive()                  { return isActive; }
    public void setActive(boolean isActive)    { this.isActive = isActive; }

    public Timestamp getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)       { this.createdAt = createdAt; }
}
