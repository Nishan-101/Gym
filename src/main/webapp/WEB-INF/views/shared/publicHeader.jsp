<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%-- Public-facing pages header (landing, about, contact) --%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'GymPro'}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${not empty pageCSS ? pageCSS : 'public'}.css">
</head>
<body>
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand">Gym<span>Pro</span></a>
    <button class="navbar-toggle" onclick="toggleNav()" aria-label="Menu">
        <span></span><span></span><span></span>
    </button>
    <ul class="navbar-nav">
        <li><a href="${pageContext.request.contextPath}/"        class="${activePage eq 'home'    ? 'active' : ''}">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/about"   class="${activePage eq 'about'   ? 'active' : ''}">About</a></li>
        <li><a href="${pageContext.request.contextPath}/contact" class="${activePage eq 'contact' ? 'active' : ''}">Contact</a></li>
        <li><a href="${pageContext.request.contextPath}/login"   class="btn btn-outline btn-sm">Login</a></li>
        <li><a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Join Now</a></li>
    </ul>
</nav>
