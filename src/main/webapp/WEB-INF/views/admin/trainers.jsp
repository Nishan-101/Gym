<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="Manage Trainers" scope="request"/>
<c:set var="pageCSS"    value="admin-trainers"  scope="request"/>
<c:set var="activePage" value="trainers"        scope="request"/>

<%@ include file="/WEB-INF/views/shared/adminHeader.jsp" %>

<div class="page-header">
    <div>
        <h1><i class="fa-solid fa-dumbbell"></i> Manage Trainers</h1>
        <p>Add, edit and manage gym trainers.</p>
    </div>
    <button class="btn btn-primary" onclick="openModal('addTrainerModal')">
        <i class="fa-solid fa-plus"></i> Add Trainer
    </button>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty param.success}">
    <div class="alert alert-success">
        <i class="fa-solid fa-circle-check"></i> Operation completed successfully.
    </div>
</c:if>

<!-- Trainer Cards -->
<c:choose>

    <c:when test="${empty trainers}">
        <p class="no-data">
            <i class="fa-solid fa-circle-info"></i> No trainers found. Add your first trainer.
        </p>
    </c:when>

    <c:otherwise>

        <div class="trainer-grid-admin">

            <c:forEach var="t" items="${trainers}">

                <div class="trainer-card-admin ${not t.active ? 'plan-inactive' : ''}">

                    <c:if test="${not t.active}">
                        <span class="badge badge-secondary inactive-badge">
                            <i class="fa-solid fa-ban"></i> Inactive
                        </span>
                    </c:if>

                    <div class="tc-avatar">
                        <i class="fa-solid fa-user"></i>
                    </div>

                    <h3>${t.fullName}</h3>

                    <div class="tc-spec">
                        <i class="fa-solid fa-star"></i> ${t.specialization}
                    </div>

                    <div class="tc-detail">
                        <i class="fa-solid fa-phone"></i> ${t.phone}
                    </div>

                    <div class="tc-detail">
                        <i class="fa-solid fa-envelope"></i> ${t.email}
                    </div>

                    <div class="tc-detail">
                        <i class="fa-regular fa-clock"></i> ${t.schedule}
                    </div>

                    <div class="tc-detail">
                        <i class="fa-solid fa-trophy"></i> ${t.experienceYears} yrs experience
                    </div>

                    <div class="tc-actions">

                        <a href="${pageContext.request.contextPath}/admin/trainers?editId=${t.trainerId}"
                           class="btn btn-info btn-sm">
                            <i class="fa-solid fa-pen"></i> Edit
                        </a>

                        <form action="${pageContext.request.contextPath}/admin/trainers"
                              method="post"
                              onsubmit="return confirm('Delete trainer ${t.fullName}?')">

                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="trainerId" value="${t.trainerId}">

                            <button class="btn btn-danger btn-sm">
                                <i class="fa-solid fa-trash"></i>
                            </button>

                        </form>

                    </div>

                </div>

            </c:forEach>

        </div>

    </c:otherwise>

</c:choose>

<!-- ADD MODAL -->
<div class="modal-overlay" id="addTrainerModal">

    <div class="modal-box">

        <div class="modal-header">
            <h3><i class="fa-solid fa-plus"></i> Add Trainer</h3>
            <button class="modal-close" onclick="closeModal('addTrainerModal')">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/trainers" method="post">

            <input type="hidden" name="action" value="add">

            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-user"></i> Full Name *</label>
                    <input type="text" name="fullName" class="form-control" required>
                </div>

                <div class="form-group">
                    <label><i class="fa-solid fa-star"></i> Specialization *</label>
                    <input type="text" name="specialization" class="form-control" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-envelope"></i> Email *</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="form-group">
                    <label><i class="fa-solid fa-phone"></i> Phone *</label>
                    <input type="text" name="phone" class="form-control" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-medal"></i> Experience</label>
                    <input type="number" name="experienceYears" class="form-control">
                </div>

                <div class="form-group">
                    <label><i class="fa-regular fa-clock"></i> Schedule</label>
                    <input type="text" name="schedule" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label><i class="fa-solid fa-align-left"></i> Bio</label>
                <textarea name="bio" class="form-control"></textarea>
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeModal('addTrainerModal')">
                    Cancel
                </button>

                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-check"></i> Save Trainer
                </button>
            </div>

        </form>

    </div>

</div>

<!-- EDIT MODAL -->
<c:if test="${not empty editTrainer}">

<div class="modal-overlay open" id="editTrainerModal">

    <div class="modal-box">

        <div class="modal-header">
            <h3><i class="fa-solid fa-pen"></i> Edit Trainer</h3>
            <a href="${pageContext.request.contextPath}/admin/trainers" class="modal-close">&times;</a>
        </div>

        <form action="${pageContext.request.contextPath}/admin/trainers" method="post">

            <input type="hidden" name="action" value="update">
            <input type="hidden" name="trainerId" value="${editTrainer.trainerId}">

            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-user"></i> Full Name *</label>
                    <input type="text" name="fullName" value="${editTrainer.fullName}" class="form-control">
                </div>

                <div class="form-group">
                    <label><i class="fa-solid fa-star"></i> Specialization *</label>
                    <input type="text" name="specialization" value="${editTrainer.specialization}" class="form-control">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-envelope"></i> Email *</label>
                    <input type="email" name="email" value="${editTrainer.email}" class="form-control">
                </div>

                <div class="form-group">
                    <label><i class="fa-solid fa-phone"></i> Phone *</label>
                    <input type="text" name="phone" value="${editTrainer.phone}" class="form-control">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-medal"></i> Experience</label>
                    <input type="number" name="experienceYears" value="${editTrainer.experienceYears}" class="form-control">
                </div>

                <div class="form-group">
                    <label><i class="fa-regular fa-clock"></i> Schedule</label>
                    <input type="text" name="schedule" value="${editTrainer.schedule}" class="form-control">
                </div>
            </div>

            <div class="form-group">
                <label><i class="fa-solid fa-align-left"></i> Bio</label>
                <textarea name="bio" class="form-control">${editTrainer.bio}</textarea>
            </div>

            <div class="form-group">
                <label><i class="fa-solid fa-toggle-on"></i> Status</label>
                <select name="isActive" class="form-control">
                    <option value="1" ${editTrainer.active ? 'selected' : ''}>Active</option>
                    <option value="0" ${not editTrainer.active ? 'selected' : ''}>Inactive</option>
                </select>
            </div>

            <div class="modal-actions">
                <a href="${pageContext.request.contextPath}/admin/trainers" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">
                    <i class="fa-solid fa-floppy-disk"></i> Save Changes
                </button>
            </div>

        </form>

    </div>

</div>

</c:if>

<%@ include file="/WEB-INF/views/shared/adminFooter.jsp" %>
