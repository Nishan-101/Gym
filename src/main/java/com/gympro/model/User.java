package com.gympro.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model class representing a system user (admin or member).
 */
public class User {
    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private Date dateOfBirth;
    private String gender;
    private String address;
    private String role;
    private String status;
    private String profilePhoto;
    private Timestamp createdAt;

    public User() {}

    public User(int userId, String fullName, String email, String phone,
                String password, Date dateOfBirth, String gender,
                String address, String role, String status, Timestamp createdAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.address = address;
        this.role = role;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getUserId()               { return userId; }
    public void setUserId(int userId)    { this.userId = userId; }

    public String getFullName()                   { return fullName; }
    public void setFullName(String fullName)      { this.fullName = fullName; }

    public String getEmail()                { return email; }
    public void setEmail(String email)      { this.email = email; }

    public String getPhone()                { return phone; }
    public void setPhone(String phone)      { this.phone = phone; }

    public String getPassword()                    { return password; }
    public void setPassword(String password)       { this.password = password; }

    public Date getDateOfBirth()                       { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth)       { this.dateOfBirth = dateOfBirth; }

    public String getGender()                { return gender; }
    public void setGender(String gender)     { this.gender = gender; }

    public String getAddress()                  { return address; }
    public void setAddress(String address)      { this.address = address; }

    public String getRole()              { return role; }
    public void setRole(String role)     { this.role = role; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public String getProfilePhoto()                     { return profilePhoto; }
    public void setProfilePhoto(String profilePhoto)    { this.profilePhoto = profilePhoto; }

    public Timestamp getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)       { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", fullName='" + fullName + "', role='" + role + "', status='" + status + "'}";
    }
}