<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.util.List, model.CartItem" %>
<%
    // MEMBER 3: Check if a user session exists
    String userName = (String) session.getAttribute("user");

    // MEMBER 3: Get last order info (set in CheckoutServlet)
    List<CartItem> orderItems = (List<CartItem>) session.getAttribute("orderItems");
    String orderUser = (String) session.getAttribute("orderUser");
    Double orderTotal = (Double) session.getAttribute("orderTotal");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kuih To You - Home</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        /* GLOBAL STYLES */
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background-color: #f9f9f9; overflow-x: hidden; }

        /* HEADER */
        header {
            background-color: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; display: flex;
            justify-content: space-between; align-items: center; padding: 15px 20px;
        }
        .logo { font-size: 24px; font-weight: bold; color: #2e7d32; text-decoration: none; }

        /* NAVIGATION & ACTIONS */
        .nav-actions { display: flex; gap: 15px; align-items: center; }
        .nav-actions a, .nav-actions span { text-decoration: none; color: #333; font-weight: 600; font-size: 14px; }

        .btn-pill { padding: 10px 25px; border-radius: 50px; text-decoration: none;
            font-weight: bold; font-size: 13px; transition: 0.3s; cursor: pointer; border: none; }
        .btn-primary { background-color: #c62828; color: white; }
        .btn-secondary { background-color: white; border: 2px solid #c62828; color: #c62828; }
        .btn-admin { border: 1px solid #555; color: #555; padding: 8px 15px; font-size: 12px; }
        .user-greeting { color: #2e7d32 !important; font-weight: bold; }

        /* --- ENTRANCE ANIMATIONS --- */
        .reveal { opacity: 0; transform: translateY(40px); transition: all 0.8s cubic-bezier(0.165, 0.84, 0.44, 1); }
        .reveal.active { opacity: 1; transform: translateY(0); }

        /* HERO SECTION */
        .hero-section { background-color: #e8f5e9; padding: 60px 20px; text-align: center; }
        .hero-card { max-width: 1100px; margin: 0 auto; background-color: white; border-radius: 20px;
            overflow: hidden; display: flex; box-shadow: 0 10px 20px rgba(0,0,0,0.1); transition: transform 0.5s ease; }
        .hero-card:hover { transform: scale(1.01); }
        .hero-text { flex: 1; padding: 50px; display: flex; flex-direction: column;
            justify-content: center; align-items: flex-start; text-align: left; }
        .hero-text h1 { font-size: 42px; color: #2e7d32; margin: 0 0 15px 0; }
        .hero-text p { font-size: 18px; color: #555; margin-bottom: 25px; }

        /* FIXED: Hero image using context path for reliability */
        .hero-image {
            flex: 1;
            background-image: url('${pageContext.request.contextPath}/KuihMuihImage/hero.jpg');
            background-size: cover;
            background-position: center;
            min-height: 400px;
            transition: transform 0.8s ease;
        }
        .hero-card:hover .hero-image { transform: scale(1.05); }

        /* FEATURED MENU */
        .featured-menu { padding: 80px 20px; max-width: 1200px; margin: 0 auto; text-align: center; }
        .section-title { font-size: 32px; color: #2e7d32; margin-bottom: 40px; }
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(350px, 1fr)); gap: 40px; padding: 0 20px; }
        .kuih-card { background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 5px 20px rgba(0,0,0,0.05); transition: all 0.4s ease; text-align: center; padding-bottom: 20px; }
        .kuih-card:hover { transform: translateY(-12px); box-shadow: 0 20px 40px rgba(0,0,0,0.12); }
        .kuih-card .img-container { width: 100%; height: 350px; overflow: hidden; }
        .kuih-card img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }
        .kuih-card:hover img { transform: scale(1.1); }
        .kuih-card h3 { margin: 25px 0; color: #2e7d32; font-size: 24px; font-weight:700; }

        footer { text-align: center; padding: 40px 20px; color: #777; font-size: 13px; }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Kuih To You</a>
        <div class="nav-actions">
            <a href="menu.jsp">Menu</a>
            <a href="admin_login.html" class="btn-pill btn-admin">Admin</a>

            <%-- DYNAMIC AUTH BUTTONS --%>
            <% if (userName != null) { %>
                <span class="user-greeting">Hi, <%= userName %>!</span>
                <a href="LogoutServlet" style="color: #c62828; margin-left:10px; font-weight: bold;">Logout</a>
            <% } else { %>
                <a href="login.html">Sign In</a>
                <a href="signup.html" class="btn-pill btn-secondary">Sign Up</a>
            <% } %>
        </div>
    </div>
</header>

<section class="hero-section">
    <div class="hero-card reveal">
        <div class="hero-text">
            <span style="color: #ff9800; font-weight:bold; letter-spacing:1px; font-size: 12px;">LIMITED TIME</span>
            <h1>The Taste of Tradition</h1>
            <p>Fresh Malaysian kuih made with authentic recipes and delivered straight to your door.</p>
            <a href="menu.jsp" class="btn-pill btn-primary" style="padding: 15px 30px; font-size: 16px;">Order Now</a>
        </div>
        <div class="hero-image"></div>
    </div>
</section>

<section class="featured-menu">
    <h2 class="section-title reveal">Explore Our Traditional Kuih</h2>
    <div id="featured-grid" class="menu-grid">
        <p>Loading our fresh favorites...</p>
    </div>
    <div style="margin-top: 50px;" class="reveal">
        <a href="menu.jsp" class="btn-pill btn-secondary" style="padding: 12px 40px;">View Full Menu</a>
    </div>
</section>

<footer>
    &copy; 2026 Kuih To You. CAT201 Project.
</footer>

<script>
    // Define context path for JS usage
    const contextPath = "${pageContext.request.contextPath}";

    // 1. SCROLL REVEAL LOGIC
    const observerOptions = { threshold: 0.15 };
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
            }
        });
    }, observerOptions);

    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));

    // 2. DYNAMIC MENU LOADING
    document.addEventListener("DOMContentLoaded", function() {
        fetch('./GetProducts')
            .then(response => response.json())
            .then(data => {
                const grid = document.getElementById('featured-grid');
                grid.innerHTML = '';

                data.slice(0, 3).forEach(kuih => {
                    const imgFile = (kuih.image && kuih.image.trim() !== "") ? kuih.image : 'default.jpg';

                    // FIXED: Use the absolute context path for the image source
                    const imagePath = contextPath + "/KuihMuihImage/" + imgFile;
                    const fallbackPath = contextPath + "/KuihMuihImage/default.jpg";

                    const card = `
                        <div class="kuih-card reveal">
                            <div class="img-container">
                                <img src="${'${imagePath}'}" alt="${'${kuih.name}'}" onerror="this.src='${'${fallbackPath}'}'">
                            </div>
                            <h3>${'${kuih.name}'}</h3>
                        </div>`;
                    grid.insertAdjacentHTML('beforeend', card);
                });

                document.querySelectorAll('#featured-grid .reveal').forEach(el => observer.observe(el));
            })
            .catch(error => {
                console.error('Error loading favorites:', error);
                document.getElementById('featured-grid').innerHTML = '<p>Fresh favorites arriving soon!</p>';
            });

        // 3. ORDER CONFIRMATION POPUP
        const urlParams = new URLSearchParams(window.location.search);

        <% if (orderItems != null) { %>
        if (urlParams.get('status') === 'order_success') {

            let orderSummary = '';
            <% for (CartItem item : orderItems) { %>
                orderSummary += "<%= item.getKuih().getName() %> x <%= item.getQuantity() %> <br>";
            <% } %>
            orderSummary += "<hr><b>Total: RM <%= String.format("%.2f", orderTotal) %></b>";

            Swal.fire({
                title: "Thank You, <%= (orderUser != null) ? orderUser : "Customer" %>!",
                html: orderSummary + '<br><br>Your order has been successfully placed.',
                icon: 'success',
                confirmButtonColor: '#2e7d32'
            });

            <%
                session.removeAttribute("orderItems");
                session.removeAttribute("orderUser");
                session.removeAttribute("orderTotal");
            %>

            window.history.replaceState({}, document.title, window.location.pathname);
        }
        <% } %>
    });
</script>

</body>
</html>