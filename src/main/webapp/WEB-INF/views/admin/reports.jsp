<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%-- Page setup --%>
<c:set var="pageTitle"  value="Reports & Analytics" scope="request"/>
<c:set var="pageCSS"    value="admin-reports" scope="request"/>
<c:set var="activePage" value="reports" scope="request"/>

<%@ include file="/WEB-INF/views/shared/adminHeader.jsp" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<div class="page-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
    <div>
        <h1><i class="fa-solid fa-chart-line"></i> Reports & Analytics</h1>
        <p>System-wide performance overview</p>
    </div>
    <button id="downloadPdfBtn" style="padding: 10px 20px; background-color: #1e293b; color: white; border: none; border-radius: 6px; font-weight: bold; cursor: pointer; font-size: 14px; transition: background 0.2s; display: inline-flex; align-items: center; gap: 8px;">
        <i class="fa-solid fa-file-arrow-down"></i> Save Report as PDF
    </button>
</div>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div id="pdfReportContainer" style="padding: 15px; background-color: #f8fafc; border-radius: 8px;">

    <div class="kpi-row">

        <div class="kpi-box">
            <div class="kpi-num"><i class="fa-solid fa-users"></i> ${totalMembers}</div>
            <div class="kpi-lbl">Active Members</div>
        </div>

        <div class="kpi-box green">
            <div class="kpi-num"><i class="fa-solid fa-user-tie"></i> ${totalTrainers}</div>
            <div class="kpi-lbl">Trainers</div>
        </div>

        <div class="kpi-box blue">
            <div class="kpi-num"><i class="fa-solid fa-dumbbell"></i> ${totalClasses}</div>
            <div class="kpi-lbl">Classes</div>
        </div>

        <div class="kpi-box orange">
            <div class="kpi-num">
                <i class="fa-solid fa-indian-rupee-sign"></i>
                <fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/>
            </div>
            <div class="kpi-lbl">Total Revenue</div>
        </div>

        <div class="kpi-box" style="border-bottom-color:var(--danger);">
            <div class="kpi-num" style="color:var(--danger);">
                <i class="fa-solid fa-triangle-exclamation"></i> ${pendingPayments}
            </div>
            <div class="kpi-lbl">Pending Payments</div>
        </div>

    </div>

    <div class="report-grid">

        <div class="card">
            <div class="card-header">
                <h2><i class="fa-solid fa-coins"></i> Revenue by Plan</h2>
            </div>

            <div class="card-body">

                <c:choose>
                    <c:when test="${empty revenueByPlan}">
                        <p class="no-data">No revenue data available yet.</p>
                    </c:when>

                    <c:otherwise>

                        <%-- calculate max value for bar scaling --%>
                        <c:set var="maxRev" value="1"/>
                        <c:forEach var="r" items="${revenueByPlan}">
                            <c:if test="${r.revenue > maxRev}">
                                <c:set var="maxRev" value="${r.revenue}"/>
                            </c:if>
                        </c:forEach>

                        <div class="chart-bar-wrap">

                            <c:forEach var="r" items="${revenueByPlan}">
                                <div class="chart-bar-row">

                                    <span class="chart-bar-label" title="${r.planName}">
                                        ${r.planName}
                                    </span>

                                    <div class="chart-bar-track">
                                        <div class="chart-bar-fill green"
                                             style="width:${maxRev > 0 ? (r.revenue * 100 / maxRev) : 0}%">
                                        </div>
                                    </div>

                                    <span class="chart-bar-value">
                                        <fmt:formatNumber value="${r.revenue}" pattern="#,##0"/>
                                    </span>

                                </div>
                            </c:forEach>

                        </div>

                    </c:otherwise>
                </c:choose>

            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h2><i class="fa-solid fa-dumbbell"></i> Class Popularity</h2>
            </div>

            <div class="card-body">

                <c:choose>
                    <c:when test="${empty classPop}">
                        <p class="no-data">No class enrollment data available yet.</p>
                    </c:when>

                    <c:otherwise>

                        <%-- find max enrollment for scaling --%>
                        <c:set var="maxEnroll" value="1"/>
                        <c:forEach var="c" items="${classPop}">
                            <c:if test="${c.enrolledCount > maxEnroll}">
                                <c:set var="maxEnroll" value="${c.enrolledCount}"/>
                            </c:if>
                        </c:forEach>

                        <div class="chart-bar-wrap">

                            <c:forEach var="c" items="${classPop}">
                                <div class="chart-bar-row">

                                    <span class="chart-bar-label" title="${c.className}">
                                        ${c.className}
                                    </span>

                                    <div class="chart-bar-track">
                                        <div class="chart-bar-fill blue"
                                             style="width:${maxEnroll > 0 ? (c.enrolledCount * 100 / maxEnroll) : 0}%">
                                        </div>
                                    </div>

                                    <span class="chart-bar-value">
                                        ${c.enrolledCount}/${c.capacity}
                                    </span>

                                </div>
                            </c:forEach>

                        </div>

                    </c:otherwise>
                </c:choose>

            </div>
        </div>

    </div>

</div> <script>
    document.getElementById('downloadPdfBtn').addEventListener('click', function () {
        const { jsPDF } = window.jspdf;
        const element = document.getElementById('pdfReportContainer');
        
        // Provide immediate visual status feedback to user using matching new icon
        this.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Generating PDF...';
        this.disabled = true;

        const options = {
            scale: 2, // Retains pristine quality for dynamic elements
            useCORS: true,
            logging: false
        };

        html2canvas(element, options).then((canvas) => {
            const imgData = canvas.toDataURL('image/png');
            const pdf = new jsPDF('p', 'mm', 'a4');
            const imgWidth = 210; // Document width bounds (A4)
            const pageHeight = 295; // Document height bounds (A4)
            const imgHeight = (canvas.height * imgWidth) / canvas.width;
            let heightLeft = imgHeight;
            let position = 0;

            // Generate first page layout frame
            pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
            heightLeft -= pageHeight;

            // Check if page overflow occurs, append additional layout cards cleanly
            while (heightLeft >= 0) {
                position = heightLeft - imgHeight;
                pdf.addPage();
                pdf.addImage(imgData, 'PNG', 0, position, imgWidth, imgHeight);
                heightLeft -= pageHeight;
            }

            // Deliver file directly to browser context downloads directory
            pdf.save('Gym_Performance_Analytics.pdf');

            // Restore action button UI state with download icon
            document.getElementById('downloadPdfBtn').innerHTML = '<i class="fa-solid fa-file-arrow-down"></i> Save Report as PDF';
            document.getElementById('downloadPdfBtn').disabled = false;
        }).catch((err) => {
            console.error("PDF engine failure:", err);
            document.getElementById('downloadPdfBtn').innerHTML = '<i class="fa-solid fa-triangle-exclamation"></i> Error Generating';
            document.getElementById('downloadPdfBtn').disabled = false;
        });
    });
</script>

<%@ include file="/WEB-INF/views/shared/adminFooter.jsp" %>
