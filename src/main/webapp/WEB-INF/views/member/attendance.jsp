<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="My Attendance"    scope="request"/>
<c:set var="pageCSS"    value="member-dashboard" scope="request"/>
<c:set var="activePage" value="attendance"       scope="request"/>

<%@ include file="/WEB-INF/views/shared/memberHeader.jsp" %>

<!-- Font Awesome -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>

    .page-header{
        margin-bottom:1.8rem;
    }

    .page-header h1{
        display:flex;
        align-items:center;
        gap:.7rem;
        font-size:2rem;
        margin-bottom:.4rem;
    }

    .page-header p{
        color:#6b7280;
        font-size:1rem;
    }

    .attendance-wrapper{
        display:grid;
        grid-template-columns:1fr;
        gap:1.5rem;
    }

    .card{
        background:#fff;
        border-radius:18px;
        box-shadow:0 4px 14px rgba(0,0,0,0.06);
        overflow:hidden;
        border:none;
    }

    .card-header{
        padding:1.2rem 1.5rem;
        border-bottom:1px solid #f1f1f1;
        background:#fff;
    }

    .card-header h2{
        display:flex;
        align-items:center;
        gap:.6rem;
        font-size:1.3rem;
        color:#111827;
    }

    .card-body{
        padding:1.5rem;
    }

    .attendance-status{
        display:flex;
        align-items:center;
        gap:.7rem;
        margin-bottom:1rem;
        font-size:1rem;
    }

    .attendance-status i{
        color:#ef4444;
    }

    .form-group{
        margin-bottom:1rem;
    }

    .form-group label{
        display:block;
        margin-bottom:.5rem;
        font-weight:600;
        color:#374151;
    }

    .form-control{
        width:100%;
        padding:.9rem 1rem;
        border:1px solid #d1d5db;
        border-radius:10px;
        font-size:.95rem;
        outline:none;
        transition:.3s;
    }

    .form-control:focus{
        border-color:#ef4444;
        box-shadow:0 0 0 3px rgba(239,68,68,0.12);
    }

    .btn{
        border:none;
        border-radius:10px;
        padding:.85rem 1.2rem;
        font-weight:600;
        cursor:pointer;
        transition:.3s;
    }

    .btn i{
        margin-right:.45rem;
    }

    .btn-primary{
        background:#ef4444;
        color:#fff;
    }

    .btn-primary:hover{
        background:#dc2626;
    }

    .badge{
        padding:.45rem .8rem;
        border-radius:999px;
        font-size:.8rem;
        font-weight:600;
    }

    .badge-success{
        background:#dcfce7;
        color:#15803d;
    }

    .badge-danger{
        background:#fee2e2;
        color:#dc2626;
    }

    .badge-warning{
        background:#fef3c7;
        color:#d97706;
    }

    .table-wrap{
        width:100%;
        overflow-x:auto;
    }

    table{
        width:100%;
        border-collapse:collapse;
    }

    thead{
        background:#f9fafb;
    }

    th{
        text-align:left;
        padding:1rem;
        font-size:.9rem;
        color:#374151;
        font-weight:700;
    }

    td{
        padding:1rem;
        border-top:1px solid #f3f4f6;
        color:#4b5563;
        font-size:.95rem;
    }

    tr:hover{
        background:#fafafa;
    }

    .no-data{
        text-align:center;
        padding:2rem;
        color:#6b7280;
    }

    .helper-text{
        margin-top:.8rem;
        color:#6b7280;
        font-size:.88rem;
    }

</style>

<div class="page-header">

    <div>

        <h1>
            <i class="fa-solid fa-calendar-check"></i>
            My Attendance
        </h1>

        <p>
            Mark your daily gym attendance and view your history.
        </p>

    </div>

</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>

<div class="attendance-wrapper">

    <!-- Today's Attendance -->
    <div class="card">

        <div class="card-header">

            <h2>
                <i class="fa-solid fa-user-check"></i>
                Today's Attendance
            </h2>

        </div>

        <div class="card-body">

            <c:choose>

                <c:when test="${markedToday}">

                    <div class="attendance-status">

                        <i class="fa-solid fa-clock"></i>

                        <span>
                            You marked attendance today at
                            <strong>
                                <fmt:formatDate value="${today.checkInTime}" pattern="hh:mm a"/>
                            </strong>
                        </span>

                    </div>

                    <p style="margin-bottom:1rem;">

                        Status:

                        <c:choose>

                            <c:when test="${today.status eq 'verified'}">
                                <span class="badge badge-success">
                                    Verified by Admin
                                </span>
                            </c:when>

                            <c:when test="${today.status eq 'rejected'}">
                                <span class="badge badge-danger">
                                    Rejected by Admin
                                </span>
                            </c:when>

                            <c:otherwise>
                                <span class="badge badge-warning">
                                    Pending Admin Verification
                                </span>
                            </c:otherwise>

                        </c:choose>

                    </p>

                    <c:if test="${not empty today.note}">

                        <div class="attendance-status">

                            <i class="fa-solid fa-note-sticky"></i>

                            <span>
                                <em>${today.note}</em>
                            </span>

                        </div>

                    </c:if>

                </c:when>

                <c:otherwise>

                    <form action="${pageContext.request.contextPath}/member/attendance" method="post">

                        <div class="form-group">

                            <label>
                                <i class="fa-solid fa-pen"></i>
                                Note (optional)
                            </label>

                            <input type="text"
                                   name="note"
                                   class="form-control"
                                   maxlength="255"
                                   placeholder="E.g. Morning workout, leg day, etc.">

                        </div>

                        <button type="submit" class="btn btn-primary">

                            <i class="fa-solid fa-check"></i>
                            Mark My Attendance

                        </button>

                    </form>

                    <p class="helper-text">
                        Your attendance will be sent to the admin for verification.
                    </p>

                </c:otherwise>

            </c:choose>

        </div>

    </div>

    <!-- Attendance History -->
    <div class="card">

        <div class="card-header">

            <h2>
                <i class="fa-solid fa-clock-rotate-left"></i>
                Attendance History
            </h2>

        </div>

        <div class="card-body">

            <c:choose>

                <c:when test="${empty history}">

                    <p class="no-data">
                        No attendance records yet.
                    </p>

                </c:when>

                <c:otherwise>

                    <div class="table-wrap">

                        <table>

                            <thead>

                                <tr>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Note</th>
                                    <th>Status</th>
                                    <th>Verified By</th>
                                </tr>

                            </thead>

                            <tbody>

                                <c:forEach var="a" items="${history}">

                                    <tr>

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
                                                        Verified
                                                    </span>
                                                </c:when>

                                                <c:when test="${a.status eq 'rejected'}">
                                                    <span class="badge badge-danger">
                                                        Rejected
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="badge badge-warning">
                                                        Pending
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

</div>

<%@ include file="/WEB-INF/views/shared/memberFooter.jsp" %>
