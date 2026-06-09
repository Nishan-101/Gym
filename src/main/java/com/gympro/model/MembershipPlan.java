package com.gympro.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Model class representing a membership plan offered by the gym.
 */
public class MembershipPlan {
    private int planId;
    private String planName;
    private int durationMonths;
    private BigDecimal price;
    private String description;
    private boolean isActive;
    private Timestamp createdAt;

    public MembershipPlan() {}

    public MembershipPlan(int planId, String planName, int durationMonths,
                          BigDecimal price, String description, boolean isActive, Timestamp createdAt) {
        this.planId = planId;
        this.planName = planName;
        this.durationMonths = durationMonths;
        this.price = price;
        this.description = description;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    public int getPlanId()                   { return planId; }
    public void setPlanId(int planId)        { this.planId = planId; }

    public String getPlanName()                    { return planName; }
    public void setPlanName(String planName)       { this.planName = planName; }

    public int getDurationMonths()                      { return durationMonths; }
    public void setDurationMonths(int durationMonths)   { this.durationMonths = durationMonths; }

    public BigDecimal getPrice()                  { return price; }
    public void setPrice(BigDecimal price)        { this.price = price; }

    public String getDescription()                      { return description; }
    public void setDescription(String description)      { this.description = description; }

    public boolean isActive()                  { return isActive; }
    public void setActive(boolean isActive)    { this.isActive = isActive; }

    public Timestamp getCreatedAt()                     { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)       { this.createdAt = createdAt; }
}
