<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<footer style="background:var(--dark);color:#aaa;padding:1.25rem 2rem;margin-top:2rem;">
    <div style="max-width:1100px;margin:0 auto;display:flex;flex-wrap:wrap;gap:1.5rem;justify-content:space-between;align-items:flex-start;">

        <!--  in Left side , Contact Info , Social Links -->
        <div>
            <div style="font-weight:700;color:#fff;margin-bottom:0.4rem;font-size:0.8rem;text-transform:uppercase;letter-spacing:.5px;">Contact</div>
            <div style="font-size:0.8rem;display:flex;flex-direction:column;gap:0.3rem;margin-bottom:0.8rem;">
                <span style="display:flex;align-items:center;gap:0.4rem;">
                    <i class="fa-solid fa-location-dot" style="color:var(--primary);width:12px;font-size:0.75rem;"></i> Thamel, Kathmandu, Nepal
                </span>
                <span style="display:flex;align-items:center;gap:0.4rem;">
                    <i class="fa-solid fa-phone" style="color:var(--primary);width:12px;font-size:0.75rem;"></i> +977-9800000000
                </span>
                <span style="display:flex;align-items:center;gap:0.4rem;">
                    <i class="fa-solid fa-envelope" style="color:var(--primary);width:12px;font-size:0.75rem;"></i> info@gympro.com
                </span>
                <span style="display:flex;align-items:center;gap:0.4rem;">
                    <i class="fa-regular fa-clock" style="color:var(--primary);width:12px;font-size:0.75rem;"></i> Mon&#x2013;Sat: 5:30 AM &#x2013; 9:00 PM
                </span>
            </div>
            <div style="display:flex;gap:0.6rem;align-items:center;">
                <a href="https://linkedin.com" target="_blank" title="LinkedIn"
                   style="color:#aaa;font-size:1rem;transition:color .2s;"
                   onmouseover="this.style.color='var(--primary)'" onmouseout="this.style.color='#aaa'">
                    <i class="fa-brands fa-linkedin"></i>
                </a>
                <a href="mailto:info@gympro.com" title="Email Us"
                   style="color:#aaa;font-size:1rem;transition:color .2s;"
                   onmouseover="this.style.color='var(--primary)'" onmouseout="this.style.color='#aaa'">
                    <i class="fa-solid fa-envelope"></i>
                </a>
                <a href="https://facebook.com" target="_blank" title="Facebook"
                   style="color:#aaa;font-size:1rem;transition:color .2s;"
                   onmouseover="this.style.color='var(--primary)'" onmouseout="this.style.color='#aaa'">
                    <i class="fa-brands fa-facebook"></i>
                </a>
                <a href="https://twitter.com" target="_blank" title="twitter"
                   style="color:#aaa;font-size:1rem;transition:color .2s;"
                   onmouseover="this.style.color='var(--primary)'" onmouseout="this.style.color='#aaa'">
                    <i class="fa-brands fa-twitter"></i>
                </a>
            </div>
        </div>

        <!-- Middle Quick Links -->
        <div>
            <div style="font-weight:700;color:#fff;margin-bottom:0.4rem;font-size:0.8rem;text-transform:uppercase;letter-spacing:.5px;">Quick Links</div>
            <div style="display:flex;flex-direction:column;gap:0.2rem;font-size:0.8rem;">
                <a href="${pageContext.request.contextPath}/"        style="color:#aaa;">Home</a>
                <a href="${pageContext.request.contextPath}/about"   style="color:#aaa;">About</a>
                <a href="${pageContext.request.contextPath}/contact" style="color:#aaa;">Contact</a>
                <a href="${pageContext.request.contextPath}/login"   style="color:#aaa;">Login</a>
            </div>
        </div>

        <!-- Right: Logo and  Short Description -->
        <div style="max-width:220px;">
            <div style="font-size:1.3rem;font-weight:900;color:#fff;margin-bottom:0.4rem;letter-spacing:-0.5px;">
                Gym<span style="color:var(--primary);">Pro</span>
            </div>
            <div style="font-size:0.78rem;line-height:1.6;color:#888;">
                Kathmandu's premier fitness destination state of the art equipment, certified trainers,
                and group classes for every level. Mon&#x2013;Sat, 5:30 AM – 9:00 PM.
            </div>
        </div>

    </div>

    <div style="text-align:center;margin-top:1rem;padding-top:0.75rem;border-top:1px solid #333;font-size:0.78rem;">
        &copy; 2025 <span style="color:var(--primary);">GymPro</span>. All rights reserved.
    </div>
</footer>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
