<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — GymPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
<style>
.auth-wrapper{
    background-image: url('${pageContext.request.contextPath}/images/gymhero.png') !important;
    background-size: cover !important;
    background-position: center !important;
    background-repeat: no-repeat !important;
}
</style>
</head>

<body>
<div class="auth-wrapper">
    <div class="auth-box">
        <div class="auth-logo">Gym<span>Pro</span></div>
        <p class="auth-subtitle">Sign in to your account</p>

        <c:if test="${param.msg eq 'registered'}">
            <div class="alert alert-success">&#10003; Registration submitted! Please wait for admin approval.</div>
        </c:if>
        <c:if test="${param.msg eq 'loggedout'}">
            <div class="alert alert-info">You have been logged out successfully.</div>
        </c:if>
        <c:if test="${param.error eq 'session'}">
            <div class="alert alert-warning">&#9888; Your session expired. Please login again.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="you@example.com" required
                       value="${not empty param.email ? param.email : ''}">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" class="form-control"
                       placeholder="Your password" required>
            </div>
            <button type="submit" class="btn btn-primary full-width mt-2">Sign In &rarr;</button>
        </form>

        <div class="auth-footer-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
        </div>
        <div class="auth-footer-link mt-1">
            <a href="${pageContext.request.contextPath}/" style="color:var(--gray);">&#8592; Back to Home</a>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
