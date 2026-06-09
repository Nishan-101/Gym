package com.gympro.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model class representing a member's active or past membership.
 */
public class MemberMembership {
    private int membershipId;
    private int userId;
    private int planId;
    private Date startDate;
    private Date endDate;
    private String paymentStatus;
    private Date paymentDate;
    private BigDecimal amountPaid;
    private Timestamp createdAt;

    // Joined fields for display
    private String userName;
    private String planName;
    private BigDecimal planPrice;

    public MemberMembership() {}

    public int getMembershipId()                       { return membershipId; }
    public void setMembershipId(int membershipId)      { this.membershipId = membershipId; }

    public int getUserId()               { return userId; }
    public void setUserId(int userId)    { this.userId = userId; }

    public int getPlanId()               { return planId; }
    public void setPlanId(int planId)    { this.planId = planId; }

    public Date getStartDate()                  { return startDate; }
    public void setStartDate(Date startDate)    { this.startDate = startDate; }

    public Date getEndDate()                { return endDate; }
    public void setEndDate(Date endDate)    { this.endDate = endDate; }

    public String getPaymentStatus()                       { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus)     { this.paymentStatus = paymentStatus; }

    public Date getPaymentDate()                    { return paymentDate; }
    public void setPaymentDate(Date paymentDate)    { this.paymentDate = paymentDate; }

    public BigDecimal getAmountPaid()                     { return amountPaid; }
    public void setAmountPaid(BigDecimal amountPaid)      { this.amountPaid = amountPaid; }

    public Timestamp getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)       { this.createdAt = createdAt; }

    public String getUserName()                  { return userName; }
    public void setUserName(String userName)     { this.userName = userName; }

    public String getPlanName()                  { return planName; }
    public void setPlanName(String planName)     { this.planName = planName; }

    public BigDecimal getPlanPrice()                  { return planPrice; }
    public void setPlanPrice(BigDecimal planPrice)    { this.planPrice = planPrice; }
}
