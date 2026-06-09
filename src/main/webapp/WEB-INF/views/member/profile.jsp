<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle"  value="My Profile"      scope="request"/>
<c:set var="pageCSS"    value="member-profile"  scope="request"/>
<c:set var="activePage" value="profile"         scope="request"/>

<%@ include file="/WEB-INF/views/shared/memberHeader.jsp" %>

<c:set var="user" value="${sessionScope.loggedUser}"/>

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

<div class="profile-container">

    <!-- Profile Header -->
    <div class="profile-header">

        <c:choose>
            <c:when test="${not empty user.profilePhoto}">
                <img src="${pageContext.request.contextPath}/uploads/profile/${user.profilePhoto}" alt="Profile">
            </c:when>
            <c:otherwise>
                <div class="profile-avatar-lg">
                    ${user.fullName.charAt(0)}
                </div>
            </c:otherwise>
        </c:choose>

        <div>
            <div class="ph-name">${user.fullName}</div>

            <div class="ph-email">
                <i class="fa-solid fa-envelope"></i>
                ${user.email}
            </div>

            <div class="ph-role">
                <span class="badge badge-info">
                    <i class="fa-solid fa-user"></i> Member
                </span>

                <span class="badge badge-success">
                    <i class="fa-solid fa-circle-check"></i> ${user.status}
                </span>
            </div>
        </div>

    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <!-- Tabs -->
    <div class="profile-tabs">
        <button class="profile-tab active" onclick="showTab('editTab',this)">
            <i class="fa-solid fa-user-pen"></i> Edit Profile
        </button>

        <button class="profile-tab" onclick="showTab('pwdTab',this)">
            <i class="fa-solid fa-lock"></i> Change Password
        </button>
    </div>

    <!-- Edit Tab -->
    <div id="editTab" class="profile-section active">

        <!-- Photo Upload -->
        <div class="card mb-2">
            <div class="card-header">
                <h2><i class="fa-solid fa-camera"></i> Profile Photo</h2>
            </div>

            <div class="card-body">
                <form action="${pageContext.request.contextPath}/member/profile"
                      method="post" enctype="multipart/form-data">

                    <input type="hidden" name="action" value="updatePhoto"/>

                    <div class="upload-box">

                        <c:choose>
                            <c:when test="${not empty user.profilePhoto}">
                                <img src="${pageContext.request.contextPath}/uploads/profile/${user.profilePhoto}"
                                     style="width:110px;height:110px;border-radius:50%;object-fit:cover;">
                            </c:when>
                            <c:otherwise>
                                <div class="profile-avatar-lg" style="width:110px;height:110px;">
                                    ${user.fullName.charAt(0)}
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="upload-content">
                            <label><i class="fa-solid fa-upload"></i> Upload New Photo</label>

                            <input type="file"
                                   name="profilePhoto"
                                   accept="image/*"
                                   class="form-control"
                                   required>

                            <small class="helper-text">
                                Max 5 MB. JPG, PNG, GIF only.
                            </small>

                            <button type="submit" class="btn btn-primary mt-1">
                                <i class="fa-solid fa-cloud-arrow-up"></i>
                                Upload Photo
                            </button>
                        </div>

                    </div>

                </form>
            </div>
        </div>

        <!-- Profile Form -->
        <div class="card">

            <div class="card-header">
                <h2><i class="fa-solid fa-user-gear"></i> Edit Profile</h2>
            </div>

            <div class="card-body">

                <form action="${pageContext.request.contextPath}/member/profile"
                      method="post">

                    <input type="hidden" name="action" value="updateProfile"/>

                    <div class="form-row">

                        <div class="form-group">
                            <label>Full Name *</label>
                            <input type="text" name="fullName"
                                   value="${user.fullName}"
                                   class="form-control" required/>
                        </div>

                        <div class="form-group">
                            <label>Phone *</label>
                            <input type="text" name="phone"
                                   value="${user.phone}"
                                   class="form-control" required/>
                        </div>

                    </div>

                    <div class="form-row">

                        <div class="form-group">
                            <label>Date of Birth</label>
                            <input type="date" name="dateOfBirth"
                                   class="form-control"
                                   value="<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd'/>"/>
                        </div>

                        <div class="form-group">
                            <label>Gender</label>
                            <select name="gender" class="form-control">
                                <option value="Male" ${user.gender eq 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${user.gender eq 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${user.gender eq 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>

                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" value="${user.email}" class="form-control" disabled/>
                    </div>

                    <div class="form-group">
                        <label>Address</label>
                        <textarea name="address" class="form-control">${user.address}</textarea>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-floppy-disk"></i>
                        Save Changes
                    </button>

                </form>

            </div>

        </div>

    </div>

    <!-- Password Tab -->
    <div id="pwdTab" class="profile-section">

        <div class="card">

            <div class="card-header">
                <h2><i class="fa-solid fa-lock"></i> Change Password</h2>
            </div>

            <div class="card-body">

                <form action="${pageContext.request.contextPath}/member/profile"
                      method="post" style="max-width:500px;">

                    <input type="hidden" name="action" value="changePassword"/>

                    <div class="form-group">
                        <label>Current Password *</label>
                        <input type="password" name="currentPassword"
                               class="form-control" required/>
                    </div>

                    <div class="form-group">
                        <label>New Password *</label>
                        <input type="password" name="newPassword"
                               class="form-control" required/>
                    </div>

                    <div class="form-group">
                        <label>Confirm Password *</label>
                        <input type="password" name="confirmPassword"
                               class="form-control" required/>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-lock"></i>
                        Change Password
                    </button>

                </form>

            </div>

        </div>

    </div>

</div>

<script>
function showTab(tabId, btn){
    document.querySelectorAll('.profile-section').forEach(s => s.classList.remove('active'));
    document.querySelectorAll('.profile-tab').forEach(t => t.classList.remove('active'));

    document.getElementById(tabId).classList.add('active');
    btn.classList.add('active');
}
</script>

<%@ include file="/WEB-INF/views/shared/memberFooter.jsp" %>
