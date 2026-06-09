<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle"  value="About Us — GymPro" scope="request"/>
<c:set var="pageCSS"    value="public"             scope="request"/>
<c:set var="activePage" value="about"              scope="request"/>
<%@ include file="/WEB-INF/views/shared/publicHeader.jsp" %>

<!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<style>
    /*  image*/
    .about-img-box {
        width: 100%;
        aspect-ratio: 4 / 3;
        border-radius: 12px;
        overflow: hidden;
        background: #e8e8e8;
        flex-shrink: 0;
    }
    .about-img-box img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }

    /* Team grid  5-card layout  */
    .team-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 1.5rem;
        margin-top: 2rem;
    }

    .trainer-card {
        background: #fff;
        border: 1px solid #ebebeb;
        border-radius: 12px;
        padding: 1.75rem 1.25rem 1.5rem;
        text-align: center;
        box-shadow: 0 2px 10px rgba(0,0,0,.06);
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: .5rem;
        transition: box-shadow .2s;
    }
    .trainer-card:hover {
        box-shadow: 0 6px 22px rgba(0,0,0,.11);
    }

    .trainer-avatar {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    object-fit: cover;
    display: block;
    margin-bottom: .25rem;
    flex-shrink: 0;
    border: 3px solid #f3f4f6;
    background: #fff;
}


    .trainer-card h3 {
        font-size: 1rem;
        font-weight: 700;
        margin: 0;
        color: var(--dark, #111);
    }

    .trainer-role {
        color: var(--primary, #e63946);
        font-size: .82rem;
        font-weight: 600;
        margin: 0;
    }

    .trainer-exp {
        font-size: .8rem;
        color: var(--gray, #777);
        margin: 0;
        display: flex;
        align-items: center;
        gap: .35rem;
        justify-content: center;
    }
    .trainer-exp i {
        font-size: .75rem;
        opacity: .75;
    }
</style>

<div style="background:var(--dark);color:#fff;padding:3rem 2rem;text-align:center;">
    <h1 style="font-size:2.5rem;font-weight:900;">About <span style="color:var(--primary);">GymPro</span></h1>
    <p style="color:#aaa;margin-top:.5rem;max-width:550px;margin-inline:auto;">We are more than a gym we are a community built around your goals.</p>
</div>

<section class="section">
    <div class="section-inner">
        <div class="about-grid">
          
            <div class="about-img-box">
                <img src="${pageContext.request.contextPath}/images/gym.png"
                     alt="GymPro gym interior"
                  />
            </div>
            <div class="about-text">
                <h2>Our Story</h2>
                <p>GymPro was founded in 2018 with a simple mission: make professional fitness accessible to everyone in Kathmandu. What started as a small studio has grown into a full-featured fitness management platform.</p>
                <p>We believe that fitness is not a destination — it's a lifelong journey. Our team of dedicated trainers and state-of-the-art facilities are here to support every step of that journey.</p>
                <div class="about-values">
                    <div class="value-item"><h4><i class="fas fa-bullseye"></i> Focus</h4><p>Goal-oriented training for measurable results.</p></div>
                    <div class="value-item"><h4><i class="fas fa-handshake"></i> Community</h4><p>A welcoming space for all fitness levels.</p></div>
                    <div class="value-item"><h4><i class="fas fa-fist-raised"></i> Excellence</h4><p>World-class trainers and equipment.</p></div>
                    <div class="value-item"><h4><i class="fas fa-lightbulb"></i> Innovation</h4><p>Technology-driven fitness management.</p></div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="section" style="background:#fff;">
    <div class="section-inner">
        <h2 class="section-heading">Our Team</h2>
        <p class="section-sub">Expert trainers committed to your success.</p>
        <div class="team-grid">
    <div class="trainer-card">
        <img src="${pageContext.request.contextPath}/images/Nishan.png" alt="Nishan Bhusal" class="trainer-avatar" />
        <h3>Nishan Bhusal</h3>
        <p class="trainer-role">Strength &amp; Conditioning</p>
        <p class="trainer-exp"></i> 5 years experience. Certified personal trainer.</p>
    </div>

    <div class="trainer-card">
        <img src="${pageContext.request.contextPath}/images/Aayush.png" alt="Ayush Dhimal" class="trainer-avatar" />
        <h3>Aayush Dhimal</h3>
        <p class="trainer-role">Yoga &amp; Flexibility</p>
        <p class="trainer-exp"></i> 4 years experience. Mindfulness yoga specialist.</p>
    </div>

    <div class="trainer-card">
        <img src="${pageContext.request.contextPath}/images/Sachin.png" alt="Sachin Bashyal" class="trainer-avatar" />
        <h3>Sachin Bashyal</h3>
        <p class="trainer-role">Cardio &amp; HIIT</p>
        <p class="trainer-exp"></i> 6 years experience. High-energy HIIT expert.</p>
    </div>

    <div class="trainer-card">
        <img src="${pageContext.request.contextPath}/images/Kalsang.png" alt="Kalsang Sherpa" class="trainer-avatar" />
        <h3>Kalsang Sherpa</h3>
        <p class="trainer-role">Nutrition &amp; Wellness</p>
        <p class="trainer-exp"></i> 3 years experience. Certified nutrition coach.</p>
    </div>

    <div class="trainer-card">
        <img src="${pageContext.request.contextPath}/images/Naveen.png" alt="Naveen Subedi" class="trainer-avatar" />
        <h3>Naveen Subedi</h3>
        <p class="trainer-role">Boxing &amp; MMA</p>
        <p class="trainer-exp"></i> 7 years experience. Combat sports specialist.</p>
    </div>
</div>
        
        
    </div>
</section>

<%@ include file="/WEB-INF/views/shared/publicFooter.jsp" %>
