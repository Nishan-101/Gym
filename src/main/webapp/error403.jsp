<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>403 Forbidden — GymPro</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div style="min-height:100vh;display:flex;align-items:center;justify-content:center;background:var(--light);">
<div style="text-align:center;padding:3rem;">
    <div style="font-size:5rem;">&#x1F6AB;</div>
    <h1 style="font-size:3rem;font-weight:900;color:var(--primary);">403</h1>
    <h2 style="margin-bottom:1rem;">Access Denied</h2>
    <p style="color:var(--gray);margin-bottom:1.5rem;">You do not have permission to access this page.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go Home</a>
    <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary" style="margin-left:.5rem;">Login</a>
</div></div></body></html>
