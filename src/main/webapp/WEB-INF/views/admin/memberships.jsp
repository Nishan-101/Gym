<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="Memberships" scope="request"/>
<c:set var="pageCSS"    value="admin-memberships" scope="request"/>
<c:set var="activePage" value="memberships" scope="request"/>

<%@ include file="/WEB-INF/views/shared/adminHeader.jsp" %>

<div class="page-header">
    <div>
        <h1><i class="fa-solid fa-credit-card"></i> Memberships</h1>
        <p>Manage plans and member subscriptions.</p>
    </div>

    <div class="page-actions">
        <button class="btn btn-secondary" onclick="openModal('addPlanModal')">
            <i class="fa-solid fa-plus"></i> Add Plan
        </button>

        <button class="btn btn-primary" onclick="openModal('assignModal')">
            <i class="fa-solid fa-clipboard-list"></i> Assign Membership
        </button>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty param.success}">
    <div class="alert alert-success">
        <i class="fa-solid fa-circle-check"></i> Operation completed successfully.
    </div>
</c:if>

<!-- Plans -->
<h2 class="section-title">
    <i class="fa-solid fa-layer-group"></i> Membership Plans
</h2>

<div class="plan-cards">

    <c:forEach var="plan" items="${plans}">
        <div class="plan-card ${not plan.active ? 'inactive' : ''}">

            <h3><i class="fa-solid fa-tag"></i> ${plan.planName}</h3>

            <div class="plan-price">
                <i class="fa-solid fa-indian-rupee-sign"></i>
                <fmt:formatNumber value="${plan.price}" pattern="#,##0"/>
            </div>

            <div class="plan-duration">
                <i class="fa-regular fa-calendar"></i> ${plan.durationMonths} month(s)
            </div>

            <p class="plan-desc">${plan.description}</p>

            <div class="plan-actions">
                <form action="${pageContext.request.contextPath}/admin/memberships" method="post"
                      onsubmit="return confirm('Delete plan ${plan.planName}?')">

                    <input type="hidden" name="action" value="deletePlan">
                    <input type="hidden" name="planId" value="${plan.planId}">

                    <button class="btn btn-danger btn-sm">
                        <i class="fa-solid fa-trash"></i> Delete
                    </button>

                </form>
            </div>

            <c:if test="${not plan.active}">
                <span class="badge badge-secondary">
                    <i class="fa-solid fa-ban"></i> Inactive
                </span>
            </c:if>

        </div>
    </c:forEach>

</div>

<!-- Membership Table -->
<div class="card">

    <div class="card-header">
        <h2><i class="fa-solid fa-users"></i> Member Subscriptions</h2>
    </div>

    <div class="card-body">

        <c:choose>

            <c:when test="${empty memberships}">
                <p class="no-data">
                    <i class="fa-solid fa-circle-info"></i> No memberships assigned yet.
                </p>
            </c:when>

            <c:otherwise>

                <div class="table-wrap">
                    <table>

                        <thead>
                        <tr>
                            <th>Member</th>
                            <th>Plan</th>
                            <th>Start</th>
                            <th>End</th>
                            <th>Amount</th>
                            <th>Payment</th>
                            <th>Actions</th>
                        </tr>
                        </thead>

                        <tbody>

                        <c:forEach var="m" items="${memberships}">
                            <tr>

                                <td><i class="fa-solid fa-user"></i> ${m.userName}</td>

                                <td><i class="fa-solid fa-box"></i> ${m.planName}</td>

                                <td>
                                    <i class="fa-regular fa-calendar"></i>
                                    <fmt:formatDate value="${m.startDate}" pattern="dd MMM yyyy"/>
                                </td>

                                <td>
                                    <i class="fa-regular fa-calendar-check"></i>
                                    <fmt:formatDate value="${m.endDate}" pattern="dd MMM yyyy"/>
                                </td>

                                <td>
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    <fmt:formatNumber value="${not empty m.amountPaid ? m.amountPaid : m.planPrice}" pattern="#,##0"/>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${m.paymentStatus eq 'paid'}">
                                            <span class="status paid">
                                                <i class="fa-solid fa-circle-check"></i> Paid
                                            </span>
                                        </c:when>

                                        <c:when test="${m.paymentStatus eq 'pending'}">
                                            <span class="status pending">
                                                <i class="fa-solid fa-clock"></i> Pending
                                            </span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="status overdue">
                                                <i class="fa-solid fa-triangle-exclamation"></i> Overdue
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:if test="${m.paymentStatus ne 'paid'}">
                                        <form action="${pageContext.request.contextPath}/admin/memberships"
                                              method="post">

                                            <input type="hidden" name="action" value="updatePayment">
                                            <input type="hidden" name="membershipId" value="${m.membershipId}">
                                            <input type="hidden" name="paymentStatus" value="paid">

                                            <button class="btn btn-success btn-sm">
                                                <i class="fa-solid fa-check"></i> Mark Paid
                                            </button>

                                        </form>
                                    </c:if>
                                </td>

                            </tr>
                        </c:forEach>

                        </tbody>

                    </table>
                </div>

            </c:otherwise>

        </c:choose>

    </div>
</div>

<!-- Add Plan Modal -->
<div class="modal-overlay" id="addPlanModal">
    <div class="modal-box">

        <div class="modal-header">
            <h3><i class="fa-solid fa-plus"></i> Add Membership Plan</h3>
            <button class="modal-close" onclick="closeModal('addPlanModal')">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/memberships" method="post">

            <input type="hidden" name="action" value="addPlan">

            <label>Plan Name *</label>
            <input type="text" name="planName" class="form-control" required>

            <label>Duration *</label>
            <input type="number" name="durationMonths" class="form-control" required>

            <label>Price *</label>
            <input type="number" name="price" class="form-control" required>

            <label>Description</label>
            <textarea name="description" class="form-control"></textarea>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addPlanModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-check"></i> Add Plan
                </button>
            </div>

        </form>

    </div>
</div>

<!-- Assign Modal -->
<div class="modal-overlay" id="assignModal">
    <div class="modal-box">

        <div class="modal-header">
            <h3><i class="fa-solid fa-clipboard-list"></i> Assign Membership</h3>
            <button class="modal-close" onclick="closeModal('assignModal')">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/memberships" method="post">

            <input type="hidden" name="action" value="assign">

            <label>Member *</label>
            <select name="userId" class="form-control" required>
                <option value="">Select Member</option>
                <c:forEach var="m" items="${members}">
                    <c:if test="${m.status eq 'approved'}">
                        <option value="${m.userId}">${m.fullName}</option>
                    </c:if>
                </c:forEach>
            </select>

            <label>Plan *</label>
            <select name="planId" class="form-control" required>
                <option value="">Select Plan</option>
                <c:forEach var="plan" items="${plans}">
                    <c:if test="${plan.active}">
                        <option value="${plan.planId}">
                            ${plan.planName}
                        </option>
                    </c:if>
                </c:forEach>
            </select>

            <label>Start Date *</label>
            <input type="date" name="startDate" class="form-control" required>

            <label>Payment Status</label>
            <select name="paymentStatus" class="form-control">
                <option value="paid">Paid</option>
                <option value="pending">Pending</option>
            </select>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeModal('assignModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-paper-plane"></i> Assign
                </button>
            </div>

        </form>

    </div>
</div>

<%@ include file="/WEB-INF/views/shared/adminFooter.jsp" %>
