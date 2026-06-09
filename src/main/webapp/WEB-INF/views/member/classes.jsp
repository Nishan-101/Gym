<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="Browse Classes" scope="request"/>
<c:set var="pageCSS"    value="member-classes" scope="request"/>
<c:set var="activePage" value="classes"        scope="request"/>

<%@ include file="/WEB-INF/views/shared/memberHeader.jsp" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
    .classes-grid .class-tile h3 {
        color: #111827 !important;
        font-weight: 700;
    }

    .ct-trainer, .ct-meta, .ct-meta div, .ct-meta i, .ct-trainer i {
        color: #374151 !important;
    }

    .enrolled-indicator {
        background-color: #e5e7eb !important;
        color: #1f2937 !important;
        font-weight: 600;
        border-radius: 4px;
        padding: 2px 8px;
        font-size: 0.75rem;
    }
</style>

<div class="page-header">
    <div>
        <h1>
            <i class="fa-solid fa-calendar-days"></i>
            Browse Classes
        </h1>
        <p>View upcoming classes and enroll in your favorite sessions.</p>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>

<c:choose>

    <c:when test="${empty upcomingClasses}">
        <p class="no-data">
            No upcoming classes scheduled. Check back later.
        </p>
    </c:when>

    <c:otherwise>

        <div class="classes-grid">

            <c:forEach var="cls" items="${upcomingClasses}">

                <c:set var="isEnrolled" value="false"/>

                <c:forEach var="e" items="${myEnrollments}">
                    <c:if test="${e.classId eq cls.classId and e.status eq 'enrolled'}">
                        <c:set var="isEnrolled" value="true"/>
                    </c:if>
                </c:forEach>

                <div class="class-tile">

                    <div>

                        <h3>
                            ${cls.className}

                            <c:if test="${isEnrolled}">
                                <span class="enrolled-indicator">Enrolled</span>
                            </c:if>
                        </h3>

                        <div class="ct-trainer">
                            <i class="fa-solid fa-dumbbell"></i>
                            ${cls.trainerName}
                        </div>

                        <div class="ct-meta">
                            <div>
                                <i class="fa-solid fa-calendar"></i>
                                <fmt:formatDate value="${cls.scheduleDatetime}" pattern="dd MMM yyyy"/>
                            </div>

                            <div>
                                <i class="fa-solid fa-clock"></i>
                                <fmt:formatDate value="${cls.scheduleDatetime}" pattern="HH:mm"/>
                                &nbsp;|&nbsp;
                                ${cls.durationMinutes} min
                            </div>

                            <c:if test="${not empty cls.description}">
                                <div>
                                    <i class="fa-solid fa-circle-info"></i>
                                    ${cls.description}
                                </div>
                            </c:if>
                        </div>

                        <div style="margin-top:1rem;">
                            <c:choose>
                                <c:when test="${cls.availableSpots <= 0}">
                                    <span class="spots-badge spots-full">FULL</span>
                                </c:when>

                                <c:when test="${cls.availableSpots <= 3}">
                                    <span class="spots-badge spots-low">
                                        ${cls.availableSpots} spots left
                                    </span>
                                </c:when>

                                <c:otherwise>
                                    <span class="spots-badge spots-ok">
                                        ${cls.availableSpots} spots available
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>

                    <div class="ct-actions">

                        <c:choose>

                            <c:when test="${isEnrolled}">
                                <form action="${pageContext.request.contextPath}/member/classes" method="post">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="classId" value="${cls.classId}">
                                    <button class="btn btn-secondary btn-sm">Cancel</button>
                                </form>
                            </c:when>

                            <c:when test="${cls.availableSpots <= 0}">
                                <button class="btn btn-secondary btn-sm" disabled>Class Full</button>
                            </c:when>

                            <c:otherwise>
                                <form action="${pageContext.request.contextPath}/member/classes" method="post">
                                    <input type="hidden" name="action" value="enroll">
                                    <input type="hidden" name="classId" value="${cls.classId}">
                                    <button class="btn btn-primary btn-sm">Enroll</button>
                                </form>
                            </c:otherwise>

                        </c:choose>

                    </div>

                </div>

            </c:forEach>

        </div>

    </c:otherwise>

</c:choose>

<%@ include file="/WEB-INF/views/shared/memberFooter.jsp" %>
