<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="My Memberships"   scope="request"/>
<c:set var="pageCSS"    value="member-dashboard" scope="request"/>
<c:set var="activePage" value="memberships"      scope="request"/>

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

    .membership-wrapper{
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

    .plans-grid{
        display:grid;
        grid-template-columns:repeat(auto-fit,minmax(240px,1fr));
        gap:1.2rem;
    }

    .plan-card{
        background:#fff;
        border-radius:16px;
        padding:1.5rem;
        border-top:4px solid #ef4444;
        box-shadow:0 4px 12px rgba(0,0,0,0.05);
        transition:.3s ease;
        text-align:center;
    }

    .plan-card:hover{
        transform:translateY(-4px);
        box-shadow:0 8px 18px rgba(0,0,0,0.1);
    }

    .plan-icon{
        width:60px;
        height:60px;
        margin:0 auto 1rem;
        border-radius:50%;
        background:#fee2e2;
        display:flex;
        align-items:center;
        justify-content:center;
        font-size:1.4rem;
        color:#ef4444;
    }

    .plan-name{
        font-size:1.15rem;
        font-weight:700;
        margin-bottom:.6rem;
        color:#111827;
    }

    .plan-price{
        font-size:2rem;
        font-weight:900;
        color:#ef4444;
        margin-bottom:.5rem;
    }

    .plan-duration{
        color:#6b7280;
        font-size:.9rem;
        margin-bottom:.8rem;
    }

    .plan-description{
        color:#4b5563;
        font-size:.9rem;
        line-height:1.5;
    }

    .info-box{
        margin-top:1.2rem;
        background:#f9fafb;
        border-radius:12px;
        padding:1rem;
        display:flex;
        align-items:flex-start;
        gap:.7rem;
        color:#4b5563;
        font-size:.9rem;
    }

    .info-box i{
        color:#ef4444;
        margin-top:.15rem;
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

    .badge{
        padding:.45rem .8rem;
        border-radius:999px;
        font-size:.8rem;
        font-weight:600;
        display:inline-flex;
        align-items:center;
        gap:.35rem;
    }

    .badge-success{
        background:#dcfce7;
        color:#15803d;
    }

    .badge-warning{
        background:#fef3c7;
        color:#d97706;
    }

    .badge-danger{
        background:#fee2e2;
        color:#dc2626;
    }

    .no-data{
        text-align:center;
        padding:2rem;
        color:#6b7280;
    }

</style>

<div class="page-header">

    <div>

        <h1>
            <i class="fa-solid fa-credit-card"></i>
            My Memberships
        </h1>

        <p>
            Your membership history and current plan.
        </p>

    </div>

</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="membership-wrapper">

    <!-- Available Plans -->
    <div class="card">

        <div class="card-header">

            <h2>
                <i class="fa-solid fa-layer-group"></i>
                Available Plans
            </h2>

        </div>

        <div class="card-body">

            <div class="plans-grid">

                <c:forEach var="plan" items="${plans}">

                    <div class="plan-card">

                        <div class="plan-icon">
                            <i class="fa-solid fa-dumbbell"></i>
                        </div>

                        <div class="plan-name">
                            ${plan.planName}
                        </div>

                        <div class="plan-price">
                            Rs.
                            <fmt:formatNumber value="${plan.price}" pattern="#,##0"/>
                        </div>

                        <div class="plan-duration">
                            <i class="fa-solid fa-calendar"></i>
                            ${plan.durationMonths} month(s)
                        </div>

                        <div class="plan-description">
                            ${plan.description}
                        </div>

                    </div>

                </c:forEach>

            </div>

            <div class="info-box">

                <i class="fa-solid fa-circle-info"></i>

                <span>
                    To purchase a plan, contact an admin or visit the front desk.
                </span>

            </div>

        </div>

    </div>

    <!-- Membership History -->
    <div class="card">

        <div class="card-header">

            <h2>
                <i class="fa-solid fa-clock-rotate-left"></i>
                My Membership History
            </h2>

        </div>

        <div class="card-body">

            <c:choose>

                <c:when test="${empty memberships}">

                    <p class="no-data">
                        No membership records found. Contact admin to get started.
                    </p>

                </c:when>

                <c:otherwise>

                    <div class="table-wrap">

                        <table>

                            <thead>

                                <tr>
                                    <th>Plan</th>
                                    <th>Start Date</th>
                                    <th>End Date</th>
                                    <th>Amount</th>
                                    <th>Payment</th>
                                </tr>

                            </thead>

                            <tbody>

                                <c:forEach var="m" items="${memberships}">

                                    <tr>

                                        <td>
                                            <strong>${m.planName}</strong>
                                        </td>

                                        <td>
                                            <fmt:formatDate value="${m.startDate}" pattern="dd MMM yyyy"/>
                                        </td>

                                        <td>
                                            <fmt:formatDate value="${m.endDate}" pattern="dd MMM yyyy"/>
                                        </td>

                                        <td>
                                            Rs.
                                            <fmt:formatNumber
                                                value="${not empty m.amountPaid ? m.amountPaid : m.planPrice}"
                                                pattern="#,##0"/>
                                        </td>

                                        <td>

                                            <c:choose>

                                                <c:when test="${m.paymentStatus eq 'paid'}">

                                                    <span class="badge badge-success">
                                                        <i class="fa-solid fa-check"></i>
                                                        Paid
                                                    </span>

                                                </c:when>

                                                <c:when test="${m.paymentStatus eq 'pending'}">

                                                    <span class="badge badge-warning">
                                                        <i class="fa-solid fa-clock"></i>
                                                        Pending
                                                    </span>

                                                </c:when>

                                                <c:otherwise>

                                                    <span class="badge badge-danger">
                                                        <i class="fa-solid fa-triangle-exclamation"></i>
                                                        Overdue
                                                    </span>

                                                </c:otherwise>

                                            </c:choose>

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
