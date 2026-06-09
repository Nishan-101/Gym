<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="Verify Attendance"  scope="request"/>
<c:set var="pageCSS"    value="admin-attendance"   scope="request"/>
<c:set var="activePage" value="attendance"         scope="request"/>

<%@ include file="/WEB-INF/views/shared/adminHeader.jsp" %>

<div class="page-header">
    <div>
        <h1><i class="fa-solid fa-calendar-check"></i> Verify Member Attendance</h1>
        <p>Approve or reject member attendance submissions.</p>
    </div>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty success}">
    <div class="alert alert-success">
        <i class="fa-solid fa-circle-check"></i> ${success}
    </div>
</c:if>

<!-- Pending Attendance -->
<div class="card">

    <div class="card-header">
        <h2>
            <i class="fa-solid fa-hourglass-half"></i> Pending Verifications

            <c:if test="${not empty pending}">
                <span class="badge badge-danger">${pending.size()}</span>
            </c:if>
        </h2>
    </div>

    <div class="card-body">

        <c:choose>

            <c:when test="${empty pending}">
                <p class="no-data">
                    <i class="fa-solid fa-circle-info"></i> No pending attendance to verify.
                </p>
            </c:when>

            <c:otherwise>

                <div class="table-wrap">

                    <table>

                        <thead>
                            <tr>
                                <th>Member</th>
                                <th>Email</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Note</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="a" items="${pending}">

                                <tr>

                                    <td>
                                        <div class="user-info">

                                            <div class="user-avatar">
                                                ${a.userName.charAt(0)}
                                            </div>

                                            <strong>${a.userName}</strong>

                                        </div>
                                    </td>

                                    <td>${a.userEmail}</td>

                                    <td>
                                        <fmt:formatDate value="${a.attendanceDate}" pattern="dd MMM yyyy"/>
                                    </td>

                                    <td>
                                        <fmt:formatDate value="${a.checkInTime}" pattern="hh:mm a"/>
                                    </td>

                                    <td>
                                        ${empty a.note ? '—' : a.note}
                                    </td>

                                    <td>

                                        <div class="action-btns">

                                            <form action="${pageContext.request.contextPath}/admin/attendance"
                                                  method="post">

                                                <input type="hidden" name="attendanceId" value="${a.attendanceId}">
                                                <input type="hidden" name="action" value="verify">

                                                <button class="btn btn-success btn-sm action-text-btn">
                                                    <i class="fa-solid fa-check"></i>
                                                    Verify
                                                </button>

                                            </form>

                                            <form action="${pageContext.request.contextPath}/admin/attendance"
                                                  method="post"
                                                  onsubmit="return confirm('Reject this attendance?')">

                                                <input type="hidden" name="attendanceId" value="${a.attendanceId}">
                                                <input type="hidden" name="action" value="reject">

                                                <button class="btn btn-danger btn-sm action-text-btn">
                                                    <i class="fa-solid fa-xmark"></i>
                                                    Reject
                                                </button>

                                            </form>

                                        </div>

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

<!-- All Attendance -->
<div class="card attendance-history-card">

    <div class="card-header">

        <h2>
            <i class="fa-solid fa-clipboard-list"></i> All Attendance Records

            <small class="history-note">
                (latest 200)
            </small>
        </h2>

    </div>

    <div class="card-body">

        <c:choose>

            <c:when test="${empty all}">
                <p class="no-data">
                    <i class="fa-solid fa-circle-info"></i> No attendance records yet.
                </p>
            </c:when>

            <c:otherwise>

                <div class="table-wrap">

                    <table>

                        <thead>
                            <tr>
                                <th>Member</th>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Note</th>
                                <th>Status</th>
                                <th>Verified By</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="a" items="${all}">

                                <tr>

                                    <td>${a.userName}</td>

                                    <td>
                                        <fmt:formatDate value="${a.attendanceDate}" pattern="dd MMM yyyy"/>
                                    </td>

                                    <td>
                                        <fmt:formatDate value="${a.checkInTime}" pattern="hh:mm a"/>
                                    </td>

                                    <td>
                                        ${empty a.note ? '—' : a.note}
                                    </td>

                                    <td>

                                        <c:choose>

                                            <c:when test="${a.status eq 'verified'}">
                                                <span class="badge badge-success">
                                                    <i class="fa-solid fa-circle-check"></i> Verified
                                                </span>
                                            </c:when>

                                            <c:when test="${a.status eq 'rejected'}">
                                                <span class="badge badge-danger">
                                                    <i class="fa-solid fa-circle-xmark"></i> Rejected
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-warning">
                                                    <i class="fa-solid fa-clock"></i> Pending
                                                </span>
                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                    <td>
                                        ${empty a.verifierName ? '—' : a.verifierName}
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

<%@ include file="/WEB-INF/views/shared/adminFooter.jsp" %>
