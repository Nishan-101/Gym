<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.LocalDate" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Date-of-birth bounds: user must be at least 5 years old.
    int minAge = 3;
    int maxAge = 120;
    String maxDob = LocalDate.now().minusYears(minAge).toString();
    String minDob = LocalDate.now().minusYears(maxAge).toString();
    request.setAttribute("maxDob", maxDob);
    request.setAttribute("minDob", minDob);
    request.setAttribute("minAge", minAge);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register — GymPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-box register-box">
        <div class="auth-logo">Gym<span>Pro</span></div>
        <p class="auth-subtitle">Create your member account</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" novalidate>
            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName" class="form-control"
                           placeholder="Your Full Name" required
                           value="${not empty param.fullName ? param.fullName : ''}">
                </div>
                <div class="form-group">
                    <label for="dateOfBirth">Date of Birth *</label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control"
                           required
                           min="${minDob}"
                           max="${maxDob}"
                           data-min-age="${minAge}"
                           value="${not empty param.dateOfBirth ? param.dateOfBirth : ''}">
                    <div class="pwd-hint">You must be at least ${minAge} years old.</div>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email Address *</label>
                    <input type="email" id="email" name="email" class="form-control"
                           placeholder="you@example.com" required
                           value="${not empty param.email ? param.email : ''}">
                </div>
                <div class="form-group">
                    <label for="phone">Phone Number *</label>
                    <input type="text" id="phone" name="phone" class="form-control"
                           placeholder="10-digit number" maxlength="10" required
                           value="${not empty param.phone ? param.phone : ''}">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="gender">Gender *</label>
                    <select id="gender" name="gender" class="form-control" required>
                        <option value="">-- Select --</option>
                        <option value="Male"   ${param.gender eq 'Male'   ? 'selected' : ''}>Male</option>
                        <option value="Female" ${param.gender eq 'Female' ? 'selected' : ''}>Female</option>
                        <option value="Other"  ${param.gender eq 'Other'  ? 'selected' : ''}>Other</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="address">Address</label>
                <textarea id="address" name="address" class="form-control"
                          placeholder="Your full address">${not empty param.address ? param.address : ''}</textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="Strong password" required>
                    <div class="pwd-hint">Min 8 chars with uppercase, lowercase, number &amp; special character.</div>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                           placeholder="Repeat password" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary full-width mt-2">Create Account &rarr;</button>
        </form>

        <div class="auth-footer-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>

<script>
(function () {
    const form = document.querySelector('form[action$="/register"]');
    const dobInput = document.getElementById('dateOfBirth');
    if (!form || !dobInput) return;

    const minAge = parseInt(dobInput.getAttribute('data-min-age'), 10) || 5;

    form.addEventListener('submit', function (e) {
        const val = dobInput.value;
        if (!val) return; // 'required' handles empty

        const dob = new Date(val);
        if (isNaN(dob.getTime())) {
            e.preventDefault();
            alert('Please enter a valid date of birth.');
            dobInput.focus();
            return;
        }

        const today = new Date();
        today.setHours(0, 0, 0, 0);

        if (dob > today) {
            e.preventDefault();
            alert('Date of birth cannot be in the future.');
            dobInput.focus();
            return;
        }

   
       
    });
})();
</script>
</body>
</html>
