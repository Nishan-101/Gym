package com.gympro.service;

import com.gympro.dao.MemberMembershipDAO;
import com.gympro.dao.MembershipPlanDAO;
import com.gympro.model.MemberMembership;
import com.gympro.model.MembershipPlan;
import com.gympro.util.DateUtil;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

/**
 * Service layer for Membership Plans and Member Memberships.
 */
public class MembershipService {

    private final MembershipPlanDAO   planDAO       = new MembershipPlanDAO();
    private final MemberMembershipDAO membershipDAO = new MemberMembershipDAO();

    // ── Plans ────────────────────────────────────────────────────────────────
    public List<MembershipPlan> getAllPlans()      throws SQLException { return planDAO.findAll(); }
    public List<MembershipPlan> getActivePlans()   throws SQLException { return planDAO.findActive(); }
    public MembershipPlan       getPlanById(int id) throws SQLException { return planDAO.findById(id); }
    public boolean addPlan(MembershipPlan plan)    throws SQLException { return planDAO.insert(plan) > 0; }
    public boolean updatePlan(MembershipPlan plan) throws SQLException { return planDAO.update(plan); }
    public boolean deletePlan(int planId)          throws SQLException { return planDAO.delete(planId); }

    // ── Memberships ───────────────────────────────────────────────────────────
    /**
     * Assign a plan to a member. Calculates end_date automatically.
     */
    public boolean assignMembership(int userId, int planId, String startDateStr, String paymentStatus)
            throws SQLException {
        MembershipPlan plan = planDAO.findById(planId);
        if (plan == null) return false;

        Date startDate = DateUtil.parseDate(startDateStr);
        if (startDate == null) return false;
        Date endDate   = DateUtil.addMonths(startDate, plan.getDurationMonths());

        MemberMembership mm = new MemberMembership();
        mm.setUserId(userId);
        mm.setPlanId(planId);
        mm.setStartDate(startDate);
        mm.setEndDate(endDate);
        mm.setPaymentStatus(paymentStatus);
        if ("paid".equals(paymentStatus)) {
            mm.setPaymentDate(new Date(System.currentTimeMillis()));
            mm.setAmountPaid(plan.getPrice());
        }
        return membershipDAO.insert(mm);
    }

    public List<MemberMembership> getAllMemberships()         throws SQLException { return membershipDAO.findAll(); }
    public List<MemberMembership> getMembershipsByUser(int u) throws SQLException { return membershipDAO.findByUser(u); }
    public BigDecimal             getTotalRevenue()           throws SQLException { return membershipDAO.totalRevenue(); }

    public boolean updatePaymentStatus(int membershipId, String status) throws SQLException {
        Date payDate = "paid".equals(status) ? new Date(System.currentTimeMillis()) : null;
        return membershipDAO.updatePaymentStatus(membershipId, status, payDate);
    }
}
