<%@ page contentType="text/html;charset=UTF-8" language="java" import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>
<%
    // 1. BACKEND LOGIC: Load data
    List<Kuih> allKuih = DataHandler.readFromFile(application);

    // 2. BEST SELLERS FILTER
    String[] bestSellerNames = {"Badak Berendam", "Kuih Bakar", "Kuih Keria", "Tepung Pelita", "Popia Big Mac"};

    // 3. CART COUNTER
    int totalCount = 0;
    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");
    if (currentCart != null) {
        for(CartItem item : currentCart) {
            totalCount += item.getQuantity();
        }
    }
    String userName = (String) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Kuih To You</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --clay-orange: #b97c5a;
            --clay-dark: #a06648;
            --parchment-bg: #f3ece0;
            --espresso: #4a2c2a;
            --warm-white: #fffcf7;
            --warm-shadow: rgba(74, 44, 42, 0.18);
        }

        body {
            margin: 0; font-family: 'Lora', serif; background-color: var(--parchment-bg);
            background-image: linear-gradient(rgba(243, 236, 224, 0.85), rgba(243, 236, 224, 0.85)),
            url('${pageContext.request.contextPath}/KuihMuihImage/batik_pattern.jpg');
            background-repeat: repeat; background-size: 380px; background-attachment: fixed;
            color: var(--espresso); overflow-x: hidden;
        }

        header {
            background-color: var(--clay-orange);
            box-shadow: 0 4px 15px rgba(74, 44, 42, 0.25);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; display: flex;
            justify-content: space-between; align-items: center; padding: 10px 25px;
        }

        /* --- LOGO STYLES UPDATED FOR NEW IMAGE --- */
        .logo-wrapper { display: flex; align-items: center; text-decoration: none; gap: 12px; }
        .logo-img {
            height: 40px;
            width: auto;
            border-radius: 10px;
            background: transparent;
            object-fit: contain;
        }
        .logo-text { font-family: 'Playfair Display', serif; font-size: 24px; font-weight: bold; color: white; text-transform: uppercase; letter-spacing: 1px; }

        .nav-actions { display: flex; gap: 20px; align-items: center; }
        .nav-actions a, .nav-actions span { text-decoration: none; color: white !important; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 1.5px; }

        .hero-banner {
            background-image: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), url('${pageContext.request.contextPath}/KuihMuihImage/hero_landscape.jpg');
            background-size: cover; background-position: center;
            height: 550px; display: flex; align-items: center; justify-content: center; text-align: center;
        }
        .hero-content { max-width: 800px; padding: 20px; color: white; display: flex; flex-direction: column; align-items: center; gap: 25px; }
        .hero-content h1 { font-family: 'Playfair Display', serif; font-size: 56px; margin: 0; letter-spacing: 2px; text-shadow: 0 2px 10px rgba(0,0,0,0.4); line-height: 1.2; }

        /* --- CAROUSEL --- */
        .featured-menu { padding: 80px 20px; max-width: 1300px; margin: 0 auto; text-align: center; }
        .carousel-container { position: relative; margin: 40px auto; padding: 0 60px; }
        .carousel-viewport { overflow: hidden; padding: 20px 0; }
        .carousel-track { display: flex; gap: 30px; transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1); will-change: transform; }

        .carousel-nav {
            position: absolute; top: 50%; transform: translateY(-50%);
            background: var(--clay-orange); color: white; border: none;
            width: 45px; height: 45px; border-radius: 50%; cursor: pointer;
            z-index: 10; font-size: 1.5rem; display: flex; align-items: center;
            justify-content: center; box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: 0.3s;
        }
        .carousel-nav:hover { background: var(--clay-dark); transform: translateY(-50%) scale(1.1); }
        .carousel-nav.prev { left: 0; }
        .carousel-nav.next { right: 0; }

        .kuih-card {
            background: var(--warm-white); border-radius: 20px; overflow: hidden;
            box-shadow: 0 10px 25px var(--warm-shadow); text-align: center;
            padding: 15px; padding-bottom: 25px; min-width: 320px; flex: 0 0 auto;
        }
        .kuih-card .img-container { width: 100%; height: 280px; overflow: hidden; border-radius: 12px; margin-bottom: 15px; }
        .kuih-card img { width: 100%; height: 100%; object-fit: cover; }
        .kuih-card h3 { font-family: 'Playfair Display', serif; font-size: 24px; color: var(--espresso); margin-bottom: 15px; }

        .btn-solid-pop {
            display: inline-block; background-color: var(--clay-orange); color: white !important;
            padding: 12px 30px; font-size: 14px; font-weight: bold; text-decoration: none;
            border-radius: 50px; letter-spacing: 1px; transition: 0.3s;
        }
        .btn-solid-pop:hover { background-color: var(--clay-dark); transform: scale(1.05); }

        footer { text-align: center; padding: 60px 20px; color: #777; font-size: 14px; border-top: 1px solid rgba(74, 44, 42, 0.1); }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="index.jsp" class="logo-wrapper">
            <img src="${pageContext.request.contextPath}/KuihMuihImage/kuihtoyoulogo.png" alt="Logo" class="logo-img">
        </a>
        <div class="nav-actions">
            <a href="all_menu.jsp">Menu</a>
            <% if (userName != null) { %>
            <span style="color:white; font-weight:bold; margin-left:10px;">Hi, <%= userName %>!</span>
            <a href="Logout" class="btn-pill" style="margin-left:10px;">Logout</a>
            <% } else { %>
            <a href="login.html" style="margin-left:10px;">Sign In</a>
            <a href="signup.html" class="btn-pill" style="margin-left:10px;">Sign Up</a>
            <% } %>
        </div>
    </div>
</header>

<section class="hero-banner">
    <div class="hero-content">
        <span style="font-weight:bold; letter-spacing:3px; font-size: 14px; text-transform: uppercase;">Handmade Tradition</span>
        <h1>Earthy Flavors.<br>Authentic Taste.</h1>
        <p>Experience Malaysian heritage with fresh, handmade kuih delivered to your doorstep.</p>
        <a href="menu.jsp" class="btn-solid-pop" style="font-size: 16px; padding: 18px 50px;">ORDER NOW</a>
    </div>
</section>

<section class="featured-menu">
    <h2 style="font-family: 'Playfair Display', serif; font-size: 38px; color: var(--espresso); margin-bottom: 30px;">Our Best Sellers</h2>

    <div class="carousel-container">
        <button class="carousel-nav prev" onclick="slideCarousel(-1)">&#10094;</button>
        <button class="carousel-nav next" onclick="slideCarousel(1)">&#10095;</button>

        <div class="carousel-viewport">
            <div id="featured-grid" class="carousel-track">
                <%
                    for(Kuih k : allKuih) {
                        boolean isBestSeller = false;
                        for(String name : bestSellerNames) {
                            if(k.getName().equalsIgnoreCase(name)) { isBestSeller = true; break; }
                        }
                        if(isBestSeller) {
                %>
                <div class="kuih-card">
                    <div class="img-container">
                        <img src="${pageContext.request.contextPath}/KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>">
                    </div>
                    <h3><%= k.getName() %></h3>
                    <a href="menu.jsp" class="btn-solid-pop">Order Now</a>
                </div>
                <% } } %>
            </div>
        </div>
    </div>

    <div style="margin-top: 40px;">
        <a href="all_menu.jsp" class="btn-solid-pop">VIEW ALL MENU</a>
    </div>
</section>

<footer>&copy; 2026 Kuih To You. Inspired by Heritage.</footer>

<script>
    let currentIndex = 0;

    function slideCarousel(direction) {
        const track = document.getElementById('featured-grid');
        const cards = document.querySelectorAll('.kuih-card');
        const viewport = document.querySelector('.carousel-viewport');

        if (cards.length === 0) return;

        const cardWidth = cards[0].offsetWidth + 30;
        const viewportWidth = viewport.offsetWidth;
        const visibleCards = Math.floor(viewportWidth / cardWidth);

        const maxIndex = cards.length - visibleCards;

        if (maxIndex <= 0) return;

        currentIndex += direction;

        if (currentIndex < 0) currentIndex = 0;
        if (currentIndex > maxIndex) currentIndex = maxIndex;

        const offset = -(currentIndex * cardWidth);
        track.style.transform = "translateX(" + offset + "px)";
    }
</script>
</body>
</html>