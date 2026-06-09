<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><title>500 Server Error — GymPro</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body><div style="min-height:100vh;display:flex;align-items:center;justify-content:center;background:var(--light);">
<div style="text-align:center;padding:3rem;">
    <div style="font-size:5rem;">&#x26A0;</div>
    <h1 style="font-size:3rem;font-weight:900;color:var(--primary);">500</h1>
    <h2 style="margin-bottom:1rem;">Internal Server Error</h2>
    <p style="color:var(--gray);margin-bottom:1.5rem;">Something went wrong on our end. Please try again shortly.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Go Home</a>
</div></div></body></html>
