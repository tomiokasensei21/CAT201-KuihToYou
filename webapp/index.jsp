<%@ page contentType="text/html;charset=UTF-8" language="java" import="util.DataHandler, model.Kuih, model.CartItem, java.util.List, java.util.ArrayList, java.util.Collections" %>
<%
    // 1. Data Loading & 6 Random Best Sellers Logic
    List<Kuih> allKuih = DataHandler.readFromFile(application);
    List<Kuih> randomBestSellers = new ArrayList<>();
    if (allKuih != null && !allKuih.isEmpty()) {
        List<Kuih> shuffleList = new ArrayList<>(allKuih);
        Collections.shuffle(shuffleList);
        int limit = Math.min(shuffleList.size(), 6);
        for(int i = 0; i < limit; i++) {
            randomBestSellers.add(shuffleList.get(i));
        }
    }

    // 2. Cart Count Logic
    int totalCount = 0;
    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");
    if (currentCart != null) {
        for(CartItem item : currentCart) {
            totalCount += item.getQuantity();
        }
    }

    // 3. User Session Logic
    String userName = (String) session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");
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
            justify-content: space-between; align-items: center; padding: 0 20px;
            height: 70px;
        }
        .logo-wrapper { display: flex; align-items: center; text-decoration: none; }
        .logo-img { height: 45px; width: auto; object-fit: contain; transition: 0.3s; }
        .logo-img:hover { transform: scale(1.05); }

        .nav-actions { display: flex; gap: 20px; align-items: center; }
        .nav-actions a, .nav-actions span {
            text-decoration: none; color: white !important; font-weight: 600;
            font-size: 13px; text-transform: uppercase; letter-spacing: 1.5px;
        }

        .user-greeting { background: rgba(255, 255, 255, 0.1); padding: 5px 12px; border-radius: 4px; font-size: 12px !important; }
        .btn-pill {
            background: rgba(255, 255, 255, 0.2); border: 1.5px solid white;
            padding: 8px 20px; border-radius: 50px; transition: 0.3s; cursor: pointer;
        }
        .btn-pill:hover { background: white; color: var(--clay-orange) !important; }

        .hero-banner {
            background-image: linear-gradient(rgba(0,0,0,0.4), rgba(0,0,0,0.4)), url('${pageContext.request.contextPath}/KuihMuihImage/hero_landscape.jpg');
            background-size: cover; background-position: center;
            height: 550px; display: flex; align-items: center; justify-content: center; text-align: center;
        }
        .hero-content { max-width: 800px; padding: 20px; color: white; display: flex; flex-direction: column; align-items: center; gap: 25px; }
        .hero-content h1 { font-family: 'Playfair Display', serif; font-size: 56px; margin: 0; letter-spacing: 2px; text-shadow: 0 2px 10px rgba(0,0,0,0.4); line-height: 1.2; }

        .featured-menu { padding: 80px 20px; max-width: 1300px; margin: 0 auto; text-align: center; }
        .carousel-container { position: relative; margin: 40px auto; padding: 0 60px; }
        .carousel-viewport { overflow: hidden; padding: 20px 0; }
        .carousel-track { display: flex; gap: 30px; transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1); }

        .carousel-nav {
            position: absolute; top: 50%; transform: translateY(-50%);
            background: var(--clay-orange); color: white; border: none;
            width: 45px; height: 45px; border-radius: 50%; cursor: pointer; z-index: 10;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2); transition: 0.3s;
        }
        .carousel-nav:hover { background: var(--clay-dark); transform: translateY(-50%) scale(1.1); }

        .kuih-card {
            background: var(--warm-white); border-radius: 20px; overflow: hidden;
            box-shadow: 0 10px 25px var(--warm-shadow); text-align: center;
            padding: 15px; padding-bottom: 25px; min-width: 320px; flex: 0 0 auto;
            transition: transform 0.4s ease, box-shadow 0.4s ease;
            position: relative;
        }
        .kuih-card:hover { transform: translateY(-12px); box-shadow: 0 20px 45px rgba(185, 124, 90, 0.25); }
        .kuih-card .img-container { width: 100%; height: 280px; overflow: hidden; border-radius: 12px; margin-bottom: 15px; }
        .kuih-card img { width: 100%; height: 100%; object-fit: cover; transition: 0.5s ease; }
        .kuih-card:hover img { transform: scale(1.08); }
        .kuih-card h3 { font-family: 'Playfair Display', serif; font-size: 26px; color: var(--espresso); margin: 15px 0 5px; }
        .sub-detail { color: #999; font-size: 14px; margin-bottom: 20px; min-height: 20px; }

        .btn-solid-pop {
            display: inline-block; background-color: var(--clay-orange); color: white !important;
            padding: 12px 35px; font-size: 14px; font-weight: bold; text-decoration: none;
            border-radius: 50px; transition: 0.3s;
        }
        .btn-solid-pop:hover { background-color: var(--clay-dark); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(185, 124, 90, 0.3); }

        .btn-outline-dark {
            display: inline-block; border: 2px solid var(--espresso); color: var(--espresso) !important;
            padding: 15px 45px; font-size: 15px; font-weight: 800; text-decoration: none;
            border-radius: 50px; transition: 0.3s; margin-top: 40px; letter-spacing: 2px;
            text-transform: uppercase;
        }
        .btn-outline-dark:hover { background: var(--espresso); color: var(--warm-white) !important; transform: translateY(-2px); }

        .sold-out { filter: grayscale(0.8); opacity: 0.7; }
        .sold-out-badge {
            position: absolute; top: 15px; right: 15px; background: var(--espresso);
            color: white; padding: 5px 12px; border-radius: 4px; font-size: 10px;
            font-weight: bold; text-transform: uppercase; z-index: 5;
        }
        .btn-disabled { background-color: #777 !important; cursor: not-allowed; pointer-events: none; }

        .del-option { display: flex; align-items: center; gap: 10px; padding: 12px; border: 1px solid #ddd; border-radius: 8px; margin-bottom: 10px; cursor: pointer; transition: 0.2s; }
        .del-option:hover { border-color: var(--clay-orange); background: #fdfaf7; }
        .del-input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; margin-top: 5px; font-family: 'Lora'; box-sizing: border-box; }

        footer { text-align: center; padding: 60px 20px; color: #777; border-top: 1px solid rgba(74, 44, 42, 0.1); }
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
            <a href="viewCart.jsp">🛒 Cart (<%= totalCount %>)</a>
            <% if (userName != null) { %>
            <span class="user-greeting">Hi, <%= userName %>!</span>
            <% if ("admin".equals(userRole)) { %><a href="admin_dashboard.jsp" style="color: #ffd700 !important; border-bottom: 1px solid #ffd700;">Admin Panel</a><% } %>
            <a onclick="confirmLogout(event)" class="btn-pill">Logout</a>
            <% } else { %>
            <a href="login.html">Sign In</a>
            <a href="signup.html" class="btn-pill">Sign Up</a>
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
    <h2 style="font-family: 'Playfair Display', serif; font-size: 42px; color: var(--espresso); margin-bottom: 10px;">Our Best Sellers</h2>
    <div class="carousel-container">
        <button class="carousel-nav" style="left:0" onclick="slideCarousel(-1)">&#10094;</button>
        <button class="carousel-nav" style="right:0" onclick="slideCarousel(1)">&#10095;</button>
        <div class="carousel-viewport">
            <div id="featured-grid" class="carousel-track">
                <%
                    if (!randomBestSellers.isEmpty()) {
                        for(Kuih k : randomBestSellers) {
                            boolean isOutOfStock = (k.getStock() <= 0);
                            String fullName = k.getName();
                            String nameOnly = fullName;
                            String pcsLabel = "";

                            if (fullName.toLowerCase().contains("pcs")) {
                                int startBracket = fullName.indexOf("(");
                                if (startBracket != -1) {
                                    nameOnly = fullName.substring(0, startBracket).trim();
                                    pcsLabel = fullName.substring(startBracket);
                                }
                            }
                %>
                <div class="kuih-card <%= isOutOfStock ? "sold-out" : "" %>">
                    <% if (isOutOfStock) { %>
                    <div class="sold-out-badge">Out of Stock</div>
                    <% } %>
                    <div class="img-container">
                        <img src="${pageContext.request.contextPath}/KuihMuihImage/<%= k.getImageFile() %>" alt="<%= nameOnly %>">
                    </div>
                    <h3><%= nameOnly %></h3>
                    <div class="sub-detail"><%= pcsLabel %></div>
                    <% if (isOutOfStock) { %>
                    <span class="btn-solid-pop btn-disabled">Sold Out</span>
                    <% } else { %>
                    <a href="menu.jsp" class="btn-solid-pop">Order Now</a>
                    <% } %>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>

    <div style="margin-top: 20px;">
        <a href="all_menu.jsp" class="btn-outline-dark">Explore Full Menu</a>
    </div>
</section>



<footer>&copy; 2026 Kuih To You.</footer>

<script>
    let currentIndex = 0;
    function slideCarousel(direction) {
        const track = document.getElementById('featured-grid');
        const cards = document.querySelectorAll('.kuih-card');
        if (cards.length === 0) return;

        const cardWidth = 350;
        const viewportWidth = document.querySelector('.carousel-viewport').offsetWidth;
        const visibleCards = Math.floor(viewportWidth / cardWidth);
        const maxIndex = Math.max(0, cards.length - visibleCards);

        currentIndex = Math.max(0, Math.min(currentIndex + direction, maxIndex));
        track.style.transform = "translateX(" + (-(currentIndex * cardWidth)) + "px)";
    }

    function confirmLogout(event) {
        event.preventDefault();
        Swal.fire({
            title: 'Leaving so soon?',
            text: "We'll miss you! Do you want to logout?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#b97c5a',
            cancelButtonColor: '#4a2c2a',
            confirmButtonText: 'Yes, logout',
            cancelButtonText: 'Stay here',
            background: '#fffcf7'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'LogoutServlet';
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const params = new URLSearchParams(window.location.search);

        const Toast = Swal.mixin({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true,
            background: '#fffcf7',
            color: '#4a2c2a'
        });

        if (params.get('status') === 'login_success') {
            Toast.fire({
                icon: 'success',
                title: 'Welcome Back, <%= userName %>!'
            });
            window.history.replaceState({}, document.title, window.location.pathname);
        }

        if (params.get('status') === 'logout_success') {
            Toast.fire({
                icon: 'info',
                title: 'Successfully logged out.'
            });
            window.history.replaceState({}, document.title, window.location.pathname);
        }


    });
</script>
</body>
</html>