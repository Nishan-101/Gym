<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Admin'} — GymPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${not empty pageCSS ? pageCSS : 'admin-dashboard'}.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
</head>
<body>

<!-- Navbar -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="navbar-brand">Gym<span>Pro</span> <small style="font-size:0.6rem;color:#888;font-weight:400;">Admin</small></a>
    <button class="navbar-toggle" onclick="toggleNav()" aria-label="Menu">
        <span></span><span></span><span></span>
    </button>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/" class="nav-link">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/logout" class="nav-link btn btn-danger btn-sm" style="margin-left:0.5rem;">
            <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout</a></li>
    </ul>
</nav>

<!-- Layout Wrapper -->
<div class="layout">
    <!-- Sidebar -->
    <aside class="sidebar" id="sidebar">
        <div class="sidebar-title">Navigation</div>
        <a href="${pageContext.request.contextPath}/admin/dashboard"   class="${activePage eq 'dashboard'   ? 'active' : ''}"><span class="icon"><i class="fa-solid fa-chart-line"></i></span> Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin/users"       class="${activePage eq 'users'       ? 'active' : ''}"><span class="icon"><i class="fa-solid fa-users"></i></span> Members</a>
        <a href="${pageContext.request.contextPath}/admin/trainers"    class="${activePage eq 'trainers'    ? 'active' : ''}"><span class="icon"><i class="fa-solid fa-dumbbell"></i></span> Trainers</a>
        <a href="${pageContext.request.contextPath}/admin/classes"     class="${activePage eq 'classes'     ? 'active' : ''}"><span class="icon"><i class="fa-solid fa-calendar-days"></i></span> Classes</a>
        <a href="${pageContext.request.contextPath}/admin/memberships" class="${activePage eq 'memberships' ? 'active' : ''}"><span class="icon"><i class="fa-solid fa-credit-card"></i></span> Memberships</a>
        <a href="${pageContext.request.contextPath}/admin/attendance"  class="${activePage eq 'attendance'  ? 'active' : ''}"><span class="icon"><i class="fa-solid fa-clipboard-check"></i></span> Verify Attendance</a>
        <div class="sidebar-title" style="margin-top:1rem;">System</div>
        <a href="${pageContext.request.contextPath}/admin/reports"     class="${activePage eq 'reports'     ? 'active' : ''}"><span class="icon"><i class="fa-solid fa-chart-bar"></i></span> Reports</a>
        <a href="${pageContext.request.contextPath}/admin/contact"      class="${activePage eq 'contact'     ? 'active' : ''}"><span class="icon"><i class="fa-solid fa-envelope"></i></span> Inquiries</a>
        <a href="${pageContext.request.contextPath}/logout"><span class="icon"><i class="fa-solid fa-key"></i></span> Logout</a>
    </aside>

    <!-- Main Content starts here — closed in adminFooter.jsp -->
    <main class="main-content">
