<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Manage Classes" scope="request"/>
<c:set var="pageCSS" value="admin-classes" scope="request"/>
<c:set var="activePage" value="classes" scope="request"/>

<%@ include file="/WEB-INF/views/shared/adminHeader.jsp" %>

<style>
    .attendance-row {
        display: none;
    }
    .attendance-row.open {
        display: table-row;
    }
    .attendance-panel {
        padding: 0;
        background: var(--color-bg-soft, #f8f9fa);
    }
    .attendance-inner {
        padding: 1rem 1.5rem;
        border-top: 1px solid var(--color-border, #e5e7eb);
    }
    .attendance-inner h4 {
        margin: 0 0 0.75rem;
        font-size: 0.875rem;
        font-weight: 600;
        color: var(--color-text-muted, #6b7280);
        text-transform: uppercase;
        letter-spacing: 0.05em;
    }
    .attendance-inner table {
        width: 100%;
        font-size: 0.875rem;
        border-collapse: collapse;
    }
    .attendance-inner table th {
        text-align: left;
        padding: 0.4rem 0.75rem;
        color: var(--color-text-muted, #6b7280);
        font-weight: 500;
        border-bottom: 1px solid var(--color-border, #e5e7eb);
    }
    .attendance-inner table td {
        padding: 0.5rem 0.75rem;
        border-bottom: 1px solid var(--color-border-light, #f3f4f6);
    }
    .no-records {
        font-size: 0.85rem;
        color: var(--color-text-muted, #9ca3af);
        font-style: italic;
    }
    .btn-attendance-toggle {
        background: none;
        border: none;
        cursor: pointer;
        padding: 0.25rem 0.4rem;
        border-radius: 4px;
        transition: background 0.15s;
    }
    .btn-attendance-toggle:hover {
        background: var(--color-bg-hover, #e5e7eb);
    }
    .btn-attendance-toggle i {
        transition: transform 0.2s ease;
    }
    .btn-attendance-toggle.active i {
        transform: rotate(180deg);
    }
</style>

<div class="page-header">
    <div>
        <h1><i class="fa-solid fa-calendar-days"></i> Manage Classes</h1>
        <p>Schedule and manage gym classes.</p>
    </div>

    <button class="btn btn-primary" onclick="openModal('classModal')">
        <i class="fa-solid fa-plus"></i> Schedule Class
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

<!-- CLASSES TABLE -->
<div class="card">

    <div class="card-header">
        <h2>
            <i class="fa-solid fa-dumbbell"></i>
            All Classes
        </h2>
    </div>

    <div class="card-body">

        <c:choose>

            <c:when test="${empty classes}">
                <p class="no-data">
                    <i class="fa-solid fa-circle-info"></i>
                    No classes found.
                </p>
            </c:when>

            <c:otherwise>

                <div class="table-wrap">

                    <table class="class-schedule-table">

                        <thead>
                            <tr>
                                <th>Class</th>
                                <th>Trainer</th>
                                <th>Date &amp; Time</th>
                                <th>Duration</th>
                                <th>Capacity</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="cls" items="${classes}">

                                <c:set var="fillPct"
                                       value="${cls.capacity > 0 ? (cls.enrolledCount * 100 / cls.capacity) : 0}"/>

                                <!-- MAIN CLASS ROW -->
                                <tr id="row-${cls.classId}">

                                    <td>
                                        <div class="schedule-name">${cls.className}</div>
                                        <div class="schedule-time">${cls.description}</div>
                                    </td>

                                    <td>${cls.trainerName}</td>

                                    <td>
                                        <fmt:formatDate
                                                value="${cls.scheduleDatetime}"
                                                pattern="dd MMM yyyy HH:mm"/>
                                    </td>

                                    <td>
                                        <i class="fa-regular fa-clock"></i>
                                        ${cls.durationMinutes} min
                                    </td>

                                    <td>
                                        <div>${cls.enrolledCount} / ${cls.capacity}</div>
                                        <div class="capacity-bar">
                                            <div class="capacity-fill ${fillPct >= 100 ? 'full' : fillPct >= 75 ? 'warn' : ''}"
                                                 style="width:${fillPct > 100 ? 100 : fillPct}%">
                                            </div>
                                        </div>
                                        <div class="capacity-text">${cls.availableSpots} spots left</div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${cls.active}">
                                                <span class="badge badge-success">
                                                    <i class="fa-solid fa-circle-check"></i>
                                                    Active
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-secondary">
                                                    <i class="fa-solid fa-circle-xmark"></i>
                                                    Inactive
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <div class="action-btns">

                                            <!-- EDIT -->
                                            <a href="${pageContext.request.contextPath}/admin/classes?editId=${cls.classId}"
                                               class="btn btn-info btn-sm"
                                               title="Edit">
                                                <i class="fa-solid fa-pen"></i>
                                            </a>

                                            <!-- ATTENDANCE TOGGLE (inline, no page reload) -->
                                            <button class="btn btn-secondary btn-sm"
                                                    title="View Attendance"
                                                    onclick="toggleAttendance('${cls.classId}', this)">
                                                <i class="fa-solid fa-clipboard-list"></i>
                                            </button>

                                            <!-- DELETE -->
                                            <form action="${pageContext.request.contextPath}/admin/classes"
                                                  method="post"
                                                  onsubmit="return confirm('Delete class ${cls.className}?')">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="classId" value="${cls.classId}">
                                                <button class="btn btn-danger btn-sm" title="Delete">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </form>

                                        </div>
                                    </td>

                                </tr>

                                <!-- INLINE ATTENDANCE ROW (hidden by default) -->
                                <tr class="attendance-row" id="att-row-${cls.classId}">
                                    <td colspan="7" class="attendance-panel">
                                        <div class="attendance-inner">

                                            <h4>
                                                <i class="fa-solid fa-clipboard-list"></i>
                                                Attendance — ${cls.className}
                                            </h4>

                                            <%-- Attendance is only populated when viewClass matches this class --%>
                                            <c:choose>

                                                <c:when test="${not empty viewClass and viewClass.classId eq cls.classId}">

                                                    <c:choose>

                                                        <c:when test="${empty attendanceList}">
                                                            <p class="no-records">
                                                                <i class="fa-solid fa-circle-info"></i>
                                                                No attendance records for this class.
                                                            </p>
                                                        </c:when>

                                                        <c:otherwise>
                                                            <table>
                                                                <thead>
                                                                    <tr>
                                                                        <th>Member</th>
                                                                        <th>Date</th>
                                                                        <th>Status</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:forEach var="att" items="${attendanceList}">
                                                                        <tr>
                                                                            <td>${att.userName}</td>
                                                                            <td>
                                                                                <fmt:formatDate
                                                                                        value="${att.attendedDate}"
                                                                                        pattern="dd MMM yyyy"/>
                                                                            </td>
                                                                            <td>
                                                                                <c:choose>
                                                                                    <c:when test="${att.status eq 'present'}">
                                                                                        <span class="badge badge-success">
                                                                                            <i class="fa-solid fa-check"></i>
                                                                                            Present
                                                                                        </span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="badge badge-danger">
                                                                                            <i class="fa-solid fa-xmark"></i>
                                                                                            Absent
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </td>
                                                                        </tr>
                                                                    </c:forEach>
                                                                </tbody>
                                                            </table>
                                                        </c:otherwise>

                                                    </c:choose>

                                                </c:when>

                                                <c:otherwise>
                                                    <%-- Placeholder: data loads via AJAX or on page if not pre-fetched --%>
                                                    <p class="no-records" id="att-placeholder-${cls.classId}">
                                                        <i class="fa-solid fa-spinner fa-spin"></i>
                                                        Loading attendance…
                                                    </p>
                                                </c:otherwise>

                                            </c:choose>

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

<!--  FOR ADD + EDIT -->
<div class="modal-overlay ${not empty editClass ? 'open' : ''}"
     id="classModal">

    <div class="modal-box">

        <div class="modal-header">
            <h3>
                <i class="fa-solid fa-calendar-plus"></i>
                <c:choose>
                    <c:when test="${not empty editClass}">Edit Class</c:when>
                    <c:otherwise>Schedule New Class</c:otherwise>
                </c:choose>
            </h3>
            <button class="modal-close" onclick="closeModal('classModal')">&times;</button>
        </div>

        <form action="${pageContext.request.contextPath}/admin/classes" method="post">

            <input type="hidden" name="action" value="${not empty editClass ? 'update' : 'add'}">

            <c:if test="${not empty editClass}">
                <input type="hidden" name="classId" value="${editClass.classId}">
            </c:if>

            <!-- ROW 1 -->
            <div class="form-row">
                <div class="form-group">
                    <label>Class Name *</label>
                    <input type="text"
                           name="className"
                           class="form-control"
                           value="${not empty editClass ? editClass.className : ''}"
                           required>
                </div>
                <div class="form-group">
                    <label>Trainer *</label>
                    <select name="trainerId" class="form-control" required>
                        <option value="">-- Select Trainer --</option>
                        <c:forEach var="tr" items="${trainers}">
                            <option value="${tr.trainerId}"
                                    ${not empty editClass && tr.trainerId == editClass.trainerId ? 'selected' : ''}>
                                ${tr.fullName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <!-- ROW 2 -->
            <div class="form-row">
                <div class="form-group">
                    <label>Date &amp; Time *</label>
                    <input type="datetime-local"
                           name="scheduleDatetime"
                           class="form-control"
                           value="<c:if test='${not empty editClass}'><fmt:formatDate value='${editClass.scheduleDatetime}' pattern='yyyy-MM-dd&apos;T&apos;HH:mm'/></c:if>"
                           required>
                </div>
                <div class="form-group">
                    <label>Duration (minutes)</label>
                    <input type="number"
                           name="durationMinutes"
                           class="form-control"
                           value="${not empty editClass ? editClass.durationMinutes : 60}"
                           min="15"
                           max="240">
                </div>
            </div>

            <!-- ROW 3 -->
            <div class="form-row">
                <div class="form-group">
                    <label>Capacity</label>
                    <input type="number"
                           name="capacity"
                           class="form-control"
                           value="${not empty editClass ? editClass.capacity : 20}"
                           min="1"
                           max="200">
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <input type="text"
                           name="description"
                           class="form-control"
                           value="${not empty editClass ? editClass.description : ''}">
                </div>
            </div>

            <!-- STATUS — EDIT ONLY -->
            <c:if test="${not empty editClass}">
                <div class="form-group">
                    <label>Status</label>
                    <select name="isActive" class="form-control">
                        <option value="1" ${editClass.active ? 'selected' : ''}>Active</option>
                        <option value="0" ${not editClass.active ? 'selected' : ''}>Inactive</option>
                    </select>
                </div>
            </c:if>

            <!-- BUTTONS -->
            <div class="modal-actions">
                <button type="button" class="btn btn-secondary" onclick="closeModal('classModal')">Cancel</button>
                <button type="submit" class="btn btn-primary">
                    <c:choose>
                        <c:when test="${not empty editClass}">
                            <i class="fa-solid fa-floppy-disk"></i> Save Changes
                        </c:when>
                        <c:otherwise>
                            <i class="fa-solid fa-calendar-check"></i> Schedule Class
                        </c:otherwise>
                    </c:choose>
                </button>
            </div>

        </form>

    </div>

</div>

<script>
    var openAttendanceId = null;

    function toggleAttendance(classId, btn) {
        var attRow = document.getElementById('att-row-' + classId);
        var isOpen = attRow.classList.contains('open');

        /* Closing  any currently open attendance panel */
        if (openAttendanceId && openAttendanceId !== classId) {
            var prevRow = document.getElementById('att-row-' + openAttendanceId);
            var prevBtn = document.querySelector('[data-att-id="' + openAttendanceId + '"]');
            if (prevRow) prevRow.classList.remove('open');
            if (prevBtn) prevBtn.classList.remove('active');
        }

        if (isOpen) {
            attRow.classList.remove('open');
            btn.classList.remove('active');
            openAttendanceId = null;
        } else {
            attRow.classList.add('open');
            btn.classList.add('active');
            btn.setAttribute('data-att-id', classId);
            openAttendanceId = classId;

            /* If placeholder is still showing, fetch attendance via AJAX */
            var placeholder = document.getElementById('att-placeholder-' + classId);
            if (placeholder) {
                fetchAttendance(classId, placeholder);
            }
        }
    }

    function fetchAttendance(classId, placeholder) {
        var url = '${pageContext.request.contextPath}/admin/classes?viewAttendance=' + classId + '&ajax=true';

        fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
            .then(function(res) {
                if (!res.ok) throw new Error('Network error');
                return res.json();
            })
            .then(function(data) {
                renderAttendance(classId, data, placeholder);
            })
            .catch(function() {
                placeholder.innerHTML =
                    '<i class="fa-solid fa-triangle-exclamation"></i> Could not load attendance. ' +
                    '<a href="${pageContext.request.contextPath}/admin/classes?viewAttendance=' + classId + '">Reload page</a>';
            });
    }

    function renderAttendance(classId, records, placeholder) {
        if (!records || records.length === 0) {
            placeholder.innerHTML =
                '<i class="fa-solid fa-circle-info"></i> No attendance records for this class.';
            return;
        }

        var html = '<table><thead><tr><th>Member</th><th>Date</th><th>Status</th></tr></thead><tbody>';
        records.forEach(function(r) {
            var badge = r.status === 'present'
                ? '<span class="badge badge-success"><i class="fa-solid fa-check"></i> Present</span>'
                : '<span class="badge badge-danger"><i class="fa-solid fa-xmark"></i> Absent</span>';
            html += '<tr><td>' + escHtml(r.userName) + '</td><td>' + escHtml(r.attendedDate) + '</td><td>' + badge + '</td></tr>';
        });
        html += '</tbody></table>';

        placeholder.outerHTML = html;
    }

    function escHtml(str) {
        if (!str) return '';
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    /* Auto-open attendance panel if the server pre-loaded viewClass data */
    <c:if test="${not empty viewClass}">
    (function() {
        var btn = document.querySelector('.btn[onclick*="toggleAttendance(\'${viewClass.classId}\'"]');
        /* Simpler: directly open the row since data is already rendered */
        var attRow = document.getElementById('att-row-${viewClass.classId}');
        if (attRow) {
            attRow.classList.add('open');
            openAttendanceId = '${viewClass.classId}';
        }
        attRow.scrollIntoView({ behavior: 'smooth', block: 'center' });
    })();
    </c:if>
</script>

<%@ include file="/WEB-INF/views/shared/adminFooter.jsp" %>
