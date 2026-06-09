<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="Manage Members"  scope="request"/>
<c:set var="pageCSS"    value="admin-users"     scope="request"/>
<c:set var="activePage" value="users"           scope="request"/>

<%@ include file="/WEB-INF/views/shared/adminHeader.jsp" %>

<div class="page-header">
    <div>
        <h1><i class="fa-solid fa-users"></i> Manage Members</h1>
        <p>Approve, view, and manage member accounts.</p>
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

<!-- Pending Members -->
<div class="card">

    <div class="card-header">
        <h2>
            <i class="fa-solid fa-hourglass-half"></i> Pending Registrations

            <c:if test="${not empty pendingUsers}">
                <span class="badge badge-danger">${pendingUsers.size()}</span>
            </c:if>
        </h2>
    </div>

    <div class="card-body">

        <c:choose>

            <c:when test="${empty pendingUsers}">
                <p class="no-data">
                    <i class="fa-solid fa-circle-info"></i> No pending registrations.
                </p>
            </c:when>

            <c:otherwise>

                <div class="table-wrap">

                    <table>

                        <thead>
                            <tr>
                                <th>Member</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>DOB</th>
                                <th>Gender</th>
                                <th>Registered</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="u" items="${pendingUsers}">

                                <tr>

                                    <td>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                ${u.fullName.charAt(0)}
                                            </div>

                                            <strong>${u.fullName}</strong>
                                        </div>
                                    </td>

                                    <td>${u.email}</td>

                                    <td>${u.phone}</td>

                                    <td>
                                        <fmt:formatDate value="${u.dateOfBirth}" pattern="dd MMM yyyy"/>
                                    </td>

                                    <td>${u.gender}</td>

                                    <td>
                                        <fmt:formatDate value="${u.createdAt}" pattern="dd MMM yyyy"/>
                                    </td>

                                    <td>

                                        <div class="action-btns">

                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post">

                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <input type="hidden" name="action" value="approve">

                                                <button class="btn btn-success btn-sm action-text-btn">
                                                    <i class="fa-solid fa-check"></i>
                                                    Approve
                                                </button>

                                            </form>

                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post"
                                                  onsubmit="return confirm('Reject this registration?')">

                                                <input type="hidden" name="userId" value="${u.userId}">
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

<!-- All Members -->
<div class="card">

    <div class="card-header">
        <h2>
            <i class="fa-solid fa-user-group"></i> All Members
        </h2>
    </div>

    <div class="card-body">

        <c:choose>

            <c:when test="${empty members}">
                <p class="no-data">
                    <i class="fa-solid fa-circle-info"></i> No members found.
                </p>
            </c:when>

            <c:otherwise>

                <div class="table-wrap">

                    <table>

                        <thead>
                            <tr>
                                <th>Member</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Gender</th>
                                <th>Status</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="u" items="${members}">

                                <tr>

                                    <td>
                                        <div class="user-info">

                                            <div class="user-avatar">
                                                ${u.fullName.charAt(0)}
                                            </div>

                                            <strong>${u.fullName}</strong>

                                        </div>
                                    </td>

                                    <td>${u.email}</td>

                                    <td>${u.phone}</td>

                                    <td>${u.gender}</td>

                                    <td>

                                        <c:choose>

                                            <c:when test="${u.status eq 'approved'}">
                                                <span class="badge badge-success">
                                                    <i class="fa-solid fa-circle-check"></i> Approved
                                                </span>
                                            </c:when>

                                            <c:when test="${u.status eq 'pending'}">
                                                <span class="badge badge-warning">
                                                    <i class="fa-solid fa-clock"></i> Pending
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="badge badge-danger">
                                                    <i class="fa-solid fa-circle-xmark"></i> Rejected
                                                </span>
                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                    <td>
                                        <fmt:formatDate value="${u.createdAt}" pattern="dd MMM yyyy"/>
                                    </td>

                                    <td>

                                        <div class="action-btns">

                                            <form action="${pageContext.request.contextPath}/admin/users"
                                                  method="post"
                                                  onsubmit="return confirm('Delete member ${u.fullName}? This cannot be undone.')">

                                                <input type="hidden" name="userId" value="${u.userId}">
                                                <input type="hidden" name="action" value="delete">

                                                <button class="btn btn-danger btn-sm icon-btn">
                                                    <i class="fa-solid fa-trash"></i>
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

<%@ include file="/WEB-INF/views/shared/adminFooter.jsp" %>
