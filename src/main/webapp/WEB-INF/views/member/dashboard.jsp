<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="My Dashboard"     scope="request"/>
<c:set var="pageCSS"    value="member-dashboard" scope="request"/>
<c:set var="activePage" value="dashboard"        scope="request"/>

<%@ include file="/WEB-INF/views/shared/memberHeader.jsp" %>

<!-- Font Awesome -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<div class="page-header">

    <div>

        <h1>
            <i class="fa-solid fa-wave-square"></i>
            Welcome, ${sessionScope.loggedUser.fullName}!
        </h1>

        <p>Your fitness overview for today.</p>

    </div>

</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<!-- Membership Status -->

<c:choose>

    <c:when test="${not empty memberships}">

        <c:set var="latest" value="${memberships[0]}"/>

        <div class="membership-status-card">

            <div class="membership-top">

                <div>

                    <h3>
                        <i class="fa-solid fa-id-card"></i>
                        Current Membership
                    </h3>

                    <div class="plan-name">
                        ${latest.planName}
                    </div>

                </div>

                <div class="membership-icon">
                    <i class="fa-solid fa-crown"></i>
                </div>

            </div>

            <div class="expiry">

                <i class="fa-solid fa-calendar-days"></i>

                Valid:
                <fmt:formatDate value="${latest.startDate}" pattern="dd MMM yyyy"/>
                &nbsp;&rarr;&nbsp;
                <fmt:formatDate value="${latest.endDate}" pattern="dd MMM yyyy"/>

            </div>

            <div class="expiry payment-status">

                <i class="fa-solid fa-wallet"></i>

                Payment:
                <strong>${latest.paymentStatus}</strong>

            </div>

        </div>

    </c:when>

    <c:otherwise>

        <div class="no-membership">

            <div class="empty-icon">
                <i class="fa-solid fa-dumbbell"></i>
            </div>

            <strong>No Active Membership</strong>

            <p>
                Contact the admin to get a membership plan assigned.
            </p>

        </div>

    </c:otherwise>

</c:choose>

<!-- Stats Row -->

<div class="stats-grid">

    <div class="stat-card">

        <div class="stat-icon">
            <i class="fa-solid fa-calendar-check"></i>
        </div>

        <div class="stat-info">

            <div class="value">
                ${enrollments.size()}
            </div>

            <div class="label">
                Enrolled Classes
            </div>

        </div>

    </div>

    <div class="stat-card green">

        <div class="stat-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>

        <div class="stat-info">

            <div class="value">
                ${attendance.size()}
            </div>

            <div class="label">
                Sessions Attended
            </div>

        </div>

    </div>

    <div class="stat-card blue">

        <div class="stat-icon">
            <i class="fa-solid fa-clock"></i>
        </div>

        <div class="stat-info">

            <div class="value">
                ${upcomingClasses.size()}
            </div>

            <div class="label">
                Upcoming Classes
            </div>

        </div>

    </div>

</div>

<!-- My Enrollments -->

<div class="card">

    <div class="card-header">

        <h2>
            <i class="fa-solid fa-calendar-days"></i>
            My Class Enrollments
        </h2>

        <a href="${pageContext.request.contextPath}/member/classes"
           class="btn btn-primary btn-sm">

            <i class="fa-solid fa-plus"></i>
            Browse Classes

        </a>

    </div>

    <div class="card-body">

        <c:choose>

            <c:when test="${empty enrollments}">

                <p class="no-data">

                    <i class="fa-regular fa-folder-open"></i>

                    You have not enrolled in any classes yet.

                </p>

            </c:when>

            <c:otherwise>

                <c:forEach var="e" items="${enrollments}">

                    <div class="class-enrollment-card">

                        <div>

                            <div class="ce-name">

                                <i class="fa-solid fa-dumbbell"></i>

                                ${e.className}

                            </div>

                            <div class="ce-meta">

                                <span>
                                    <i class="fa-solid fa-user"></i>
                                    ${e.trainerName}
                                </span>

                                <span>
                                    <i class="fa-solid fa-clock"></i>
                                    <fmt:formatDate value="${e.scheduleDatetime}"
                                                    pattern="dd MMM yyyy, HH:mm"/>
                                </span>

                                <span>
                                    <i class="fa-solid fa-stopwatch"></i>
                                    ${e.durationMinutes} min
                                </span>

                            </div>

                        </div>

                        <div>

                            <span class="badge badge-${e.status eq 'enrolled' ? 'success' : 'secondary'}">

                                <i class="fa-solid fa-circle-check"></i>

                                ${e.status}

                            </span>

                        </div>

                    </div>

                </c:forEach>

            </c:otherwise>

        </c:choose>

    </div>

</div>

<%@ include file="/WEB-INF/views/shared/memberFooter.jsp" %>
