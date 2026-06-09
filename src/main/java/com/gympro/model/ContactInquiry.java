package com.gympro.model;

import java.sql.Timestamp;

/**
 * Model class for contact form inquiries.
 */
public class ContactInquiry {
    private int inquiryId;
    private String name;
    private String email;
    private String subject;
    private String message;
    private Timestamp submittedAt;
    private boolean isRead;

    public ContactInquiry() {}

    public int getInquiryId()                    { return inquiryId; }
    public void setInquiryId(int inquiryId)      { this.inquiryId = inquiryId; }

    public String getName()              { return name; }
    public void setName(String name)     { this.name = name; }

    public String getEmail()                { return email; }
    public void setEmail(String email)      { this.email = email; }

    public String getSubject()                  { return subject; }
    public void setSubject(String subject)      { this.subject = subject; }

    public String getMessage()                  { return message; }
    public void setMessage(String message)      { this.message = message; }

    public Timestamp getSubmittedAt()                     { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt)     { this.submittedAt = submittedAt; }

    public boolean isRead()                { return isRead; }
    public void setRead(boolean isRead)    { this.isRead = isRead; }
}
