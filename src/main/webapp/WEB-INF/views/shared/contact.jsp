<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle"  value="Contact Us — GymPro" scope="request"/>
<c:set var="pageCSS"    value="public"               scope="request"/>
<c:set var="activePage" value="contact"              scope="request"/>
<%@ include file="/WEB-INF/views/shared/publicHeader.jsp" %>

<%-- Font Awesome --%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"/>

<style>
    /* Full-black footer area on contact page */
    html, body { background: #1a1a1a; }

    /* Two equal-size cards side by side */
    .contact-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 2rem;
        align-items: stretch;
    }

    /* Style info box to match the card on the right */
    .contact-info-box {
        background: #fff;
        border: 1px solid #e5e5e5;
        border-radius: 12px;
        padding: 1.75rem 2rem;
        box-shadow: 0 2px 10px rgba(0,0,0,0.04);
        height: 100%;
        box-sizing: border-box;
    }

    .contact-info-box h3 {
        margin: 0 0 1.25rem;
        padding-bottom: 1rem;
        border-bottom: 1px solid #eee;
        font-size: 1.25rem;
        font-weight: 700;
    }

    /* Stretch the form card to fill the row too */
    .contact-grid .card {
        height: 100%;
        box-sizing: border-box;
        margin-bottom: 0;
    }

    /* Each contact item */
    .ci-item {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.5rem 0;
    }

    .ci-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
        width: 1.5rem;
        height: 1.5rem;
        font-size: 1rem;
        line-height: 1;
        color: var(--primary);
    }

    /* Inner sub-section ("Why Contact Us?") */
    .ci-subheading {
        margin-top: 1.25rem;
        padding-top: 1.25rem;
        border-top: 1px solid #eee;
        font-weight: 700;
        color: #333;
        margin-bottom: 0.5rem;
    }

    /* Stack columns on mobile */
    @media (max-width: 768px) {
        .contact-grid { grid-template-columns: 1fr; }
    }
</style>

<%-- Page hero --%>
<div style="background:var(--dark);color:#fff;padding:3rem 2rem;text-align:center;">
    <h1 style="font-size:2.5rem;font-weight:900;">Contact <span style="color:var(--primary);">Us</span></h1>
    <p style="color:#aaa;margin-top:.5rem;">We'd love to hear from you. Send us a message below.</p>
</div>

<section class="section">
    <div class="section-inner">
        <c:if test="${not empty error}">  <div class="alert alert-danger">${error}</div>   </c:if>
        <c:if test="${not empty success}"><div class="alert alert-success">${success}</div></c:if>

        <div class="contact-grid">

            <%-- Info Box --%>
            <div class="contact-info-box">
                <h3>Get in Touch</h3>
                <div class="ci-item"><span class="ci-icon"><i class="fa-solid fa-location-dot"></i></span><span>Thamel, Kathmandu, Nepal</span></div>
                <div class="ci-item"><span class="ci-icon"><i class="fa-solid fa-phone"></i></span><span>+977-9800000000</span></div>
                <div class="ci-item"><span class="ci-icon"><i class="fa-solid fa-envelope"></i></span><span>info@gympro.com</span></div>
                <div class="ci-item"><span class="ci-icon"><i class="fa-regular fa-clock"></i></span><span>Mon–Sat: 5:30 AM – 9:00 PM</span></div>

                <div class="ci-subheading">Why Contact Us?</div>
                <div class="ci-item"><span class="ci-icon"><i class="fa-solid fa-circle-info"></i></span><span>Membership inquiries</span></div>
                <div class="ci-item"><span class="ci-icon"><i class="fa-solid fa-circle-info"></i></span><span>Class scheduling questions</span></div>
                <div class="ci-item"><span class="ci-icon"><i class="fa-solid fa-circle-info"></i></span><span>Personal training packages</span></div>
                <div class="ci-item"><span class="ci-icon"><i class="fa-solid fa-circle-info"></i></span><span>General feedback</span></div>
            </div>

            <%-- Contact Form --%>
            <div class="card">
                <div class="card-header"><h2>Send a Message</h2></div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/contact" method="post" novalidate>
                        <div class="form-row">
                            <div class="form-group">
                                <label>Your Name *</label>
                                <input type="text" name="name" class="form-control"
                                       placeholder="Full Name" required
                                       value="${not empty param.name ? param.name : ''}">
                            </div>
                            <div class="form-group">
                                <label>Email Address *</label>
                                <input type="email" name="email" class="form-control"
                                       placeholder="mail@example.com" required
                                       value="${not empty param.email ? param.email : ''}">
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Subject *</label>
                            <input type="text" name="subject" class="form-control"
                                   placeholder="What is this about?" required
                                   value="${not empty param.subject ? param.subject : ''}">
                        </div>
                        <div class="form-group">
                            <label>Message *</label>
                            <textarea name="message" class="form-control"
                                      placeholder="Write your message here..." required
                                      style="min-height:130px;">${not empty param.message ? param.message : ''}</textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Send Message &#x2192;</button>
                    </form>
                </div>
            </div>

        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/shared/publicFooter.jsp" %>
