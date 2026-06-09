<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle"  value="Inquiries"     scope="request"/>
<c:set var="pageCSS"    value="admin-users"   scope="request"/>
<c:set var="activePage" value="contact"       scope="request"/>
<%@ include file="/WEB-INF/views/shared/adminHeader.jsp" %>

<style>
    .inquiry-table td { vertical-align: top; }
    .inquiry-message {
        max-width: 340px;
        white-space: pre-wrap;
        word-break: break-word;
        color: #444;
        font-size: 0.88rem;
        line-height: 1.5;
    }
    .badge-unread {
        background: var(--primary);
        color: #fff;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 0.72rem;
        font-weight: 700;
        letter-spacing: 0.5px;
    }
    .badge-read {
        background: #e5e5e5;
        color: #888;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 0.72rem;
        font-weight: 600;
    }
    .row-unread { background: #fff8f8; }
    .subject-cell { font-weight: 600; color: #222; }
</style>

<div class="page-header">
    <div>
        <h1><i class="fa-solid fa-envelope-open-text"></i> Member Inquiries</h1>
        <p>Messages sent by members and visitors via the Contact page. Read-only.</p>
    </div>
</div>

<c:if test="${not empty error}">  <div class="alert alert-danger">${error}</div>   </c:if>
<c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>

<div class="card">
    <div class="card-header">
        <h2>
            <i class="fa-solid fa-inbox"></i> All Inquiries
            <c:set var="unreadCount" value="0"/>
            <c:forEach var="inq" items="${inquiries}">
                <c:if test="${!inq.read}">
                    <c:set var="unreadCount" value="${unreadCount + 1}"/>
                </c:if>
            </c:forEach>
            <c:if test="${unreadCount > 0}">
                <span class="badge badge-danger">${unreadCount} new</span>
            </c:if>
        </h2>
    </div>
    <div class="card-body">
        <c:choose>
            <c:when test="${empty inquiries}">
                <p class="no-data"><i class="fa-solid fa-inbox"></i> No inquiries yet.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrap inquiry-table">
                    <table>
                        <thead>
                            <tr>
                                <th>Status</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Subject</th>
                                <th>Message</th>
                                <th>Received</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="inq" items="${inquiries}">
                            <tr class="${!inq.read ? 'row-unread' : ''}">
                                <td>
                                    <c:choose>
                                        <c:when test="${!inq.read}">
                                            <span class="badge-unread"><i class="fa-solid fa-circle" style="font-size:0.5rem;vertical-align:middle;"></i> New</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-read">Read</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="user-info">
                                        <div class="user-avatar">${inq.name.charAt(0)}</div>
                                        <strong>${inq.name}</strong>
                                    </div>
                                </td>
                                <td><a href="mailto:${inq.email}" style="color:var(--primary);">${inq.email}</a></td>
                                <td class="subject-cell">${inq.subject}</td>
                                <td><div class="inquiry-message">${inq.message}</div></td>
                                <td style="white-space:nowrap;">
                                    <fmt:formatDate value="${inq.submittedAt}" pattern="dd MMM yyyy"/><br>
                                    <small style="color:#888;"><fmt:formatDate value="${inq.submittedAt}" pattern="hh:mm a"/></small>
                                </td>
                                <td>
                                    <c:if test="${!inq.read}">
                                        <form action="${pageContext.request.contextPath}/admin/contact" method="post">
                                            <input type="hidden" name="action"    value="markRead">
                                            <input type="hidden" name="inquiryId" value="${inq.inquiryId}">
                                            <button class="btn btn-secondary btn-sm">
                                                <i class="fa-solid fa-check-double"></i> Mark Read
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${inq.read}">
                                        <span style="color:#bbb;font-size:0.82rem;">—</span>
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

<%@ include file="/WEB-INF/views/shared/adminFooter.jsp" %>
