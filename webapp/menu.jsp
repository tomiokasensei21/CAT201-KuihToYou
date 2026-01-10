<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>

<%
    // 1. Logic: Calculate cart counter
    int totalCount = 0;
    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");
    if (currentCart != null) {
        for(CartItem item : currentCart) {
            totalCount += item.getQuantity();
        }
    }

    // 2. Logic: Load data from text file via application context
    List<Kuih> allKuih = DataHandler.readFromFile(application);

    // 3. Logic: Get user name for greeting
    String userName = (String) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu - Kuih To You</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* --- EARTH & CLAY DESIGN SYSTEM --- */
        :root {
            --clay-orange: #b97c5a;
            --clay-dark: #a06648;
            --parchment-bg: #f3ece0;
            --espresso: #4a2c2a;
            --warm-white: #fffcf7;
            --warm-shadow: rgba(74, 44, 42, 0.18);
        }

        /* GLOBAL STYLES WITH FADING BATIK BACKGROUND */
        body {
            margin: 0;
            font-family: 'Lora', serif;
            background-color: var(--parchment-bg);
            /* Overlay set to 0.85 opacity for an elegant 'faded' heritage look */
            background-image:
                    linear-gradient(rgba(243, 236, 224, 0.85), rgba(243, 236, 224, 0.85)),
                    url('KuihMuihImage/batik_pattern.jpg');
            background-repeat: repeat;
            background-size: 350px;
            background-attachment: fixed;
            color: var(--espresso);
        }

        /* THEMED SOLID CLAY NAVIGATION BAR */
        header {
            background-color: var(--clay-orange);
            box-shadow: 0 4px 15px rgba(74, 44, 42, 0.25);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; display: flex;
            justify-content: space-between; align-items: center; padding: 12px 25px;
        }
        .logo {
            font-family: 'Playfair Display', serif; font-size: 26px;
            font-weight: bold; color: white !important; text-decoration: none;
        }
        nav a {
            text-decoration: none; color: white !important;
            font-weight: 600; font-size: 13px; margin-left: 20px;
            text-transform: uppercase; letter-spacing: 1.5px;
        }

        /* User Greeting in Navbar */
        .user-greeting { margin-left: 20px; color: white; font-weight: bold; font-size: 14px; opacity: 0.9; }

        /* MENU GRID */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            justify-content: center; gap: 40px; padding: 50px;
            max-width: 1200px; margin: 0 auto;
        }

        /* --- ENFORCED FRAME CARDS --- */
        .kuih-card {
            background: var(--warm-white);
            border-radius: 20px;
            overflow: hidden;
            text-align: center;
            padding: 15px; /* Creates the 'frame' padding effect */
            padding-bottom: 25px;
            box-shadow: 0 10px 25px var(--warm-shadow);
            border: 1px solid rgba(185, 124, 90, 0.1);
            opacity: 0; transform: translateY(40px);
            transition: opacity 0.7s ease-out, transform 0.7s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .kuih-card.show { opacity: 1; transform: translateY(0); }
        .kuih-card:hover { transform: translateY(-12px) !important; box-shadow: 0 15px 40px rgba(185, 124, 90, 0.2); }

        .img-wrapper {
            width: 100%;
            height: 280px;
            overflow: hidden;
            border-radius: 12px; /* Rounds image inside frame */
        }
        .img-wrapper img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .kuih-card:hover .img-wrapper img { transform: scale(1.1); }

        /* TYPOGRAPHY & BUTTONS */
        .kuih-card h3 {
            font-family: 'Playfair Display', serif; font-size: 24px;
            margin: 20px 0 10px; color: var(--espresso);
        }
        .price-text { color: var(--clay-orange); font-size: 1.2rem; font-weight: bold; margin-bottom: 20px; }

        .qty-control {
            display: inline-flex; align-items: center;
            background: #fdfaf5; border: 1.5px solid #efe5d9;
            border-radius: 4px; padding: 5px 15px; margin-bottom: 20px;
        }
        .qty-btn { background: none; border: none; font-size: 1.4rem; color: var(--clay-orange); cursor: pointer; padding: 0 10px; font-weight: bold; }

        .add-btn {
            background-color: var(--clay-orange); color: white; border: none;
            padding: 12px 35px; border-radius: 4px; font-weight: 600;
            cursor: pointer; transition: 0.3s; text-transform: uppercase;
            letter-spacing: 1px; font-family: 'Lora', serif;
        }
        .add-btn:hover { background-color: var(--clay-dark); transform: scale(1.02); }
    </style>
</head>
<body>

<%-- STATUS NOTIFICATION --%>
<% if ("added".equals(request.getParameter("status"))) { %>
<div style="background-color: #fdfaf5; color: var(--clay-orange); padding: 15px; text-align: center; border-bottom: 1px solid #efe5d9;">
    ✨ Excellent choice! Added to your Cart. <a href="viewCart.jsp" style="font-weight: bold; color: var(--espresso);">Review Cart</a>
</div>
<% } %>

<header>
    <div class="nav-container">
        <a href="index.jsp" class="logo">KUIH TO YOU</a>
        <nav>
            <a href="index.jsp">Home</a>
            <a href="all_menu.jsp">Menu</a>
            <a href="viewCart.jsp">🛒 Cart (<%= totalCount %>)</a>

            <%-- GREETING & LOGOUT --%>
            <% if (userName != null) { %>
            <span class="user-greeting">Hi, <%= userName %>!</span>
            <a href="logout-action" style="background: rgba(255,255,255,0.2); padding: 5px 15px; border-radius: 20px; font-size: 12px;">Logout</a>
            <% } else { %>
            <a href="login.html">Sign In</a>
            <% } %>
        </nav>
    </div>
</header>

<h1 style="text-align: center; margin-top: 50px; font-family: 'Playfair Display', serif; color: var(--espresso); font-size: 42px;">OUR COLLECTION</h1>

<section class="menu-grid">
    <% for(Kuih k : allKuih) { %>
    <div class="kuih-card">
        <div class="img-wrapper">
            <img src="KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>">
        </div>
        <div class="product-info" style="padding: 15px;">
            <h3><%= k.getName() %></h3>
            <p class="price-text">RM <%= String.format("%.2f", k.getPrice()) %></p>

            <form action="AddToCart" method="POST">
                <input type="hidden" name="kuihId" value="<%= k.getId() %>">
                <div class="qty-control">
                    <button type="button" class="qty-btn" onclick="changeQty('<%= k.getId() %>', -1)">−</button>
                    <input type="number" name="quantity" id="qty-<%= k.getId() %>" value="1" min="1" readonly
                           style="width: 40px; text-align: center; border: none; background: transparent; font-weight: bold; color: var(--espresso);">
                    <button type="button" class="qty-btn" onclick="changeQty('<%= k.getId() %>', 1)">+</button>
                </div>
                <br>
                <button type="submit" class="add-btn">Add to Cart</button>
            </form>
        </div>
    </div>
    <% } %>
</section>

<script>
    // Logic: Interactive quantity buttons
    function changeQty(id, delta) {
        const input = document.getElementById('qty-' + id);
        let currentVal = parseInt(input.value);
        if (currentVal + delta >= 1) { input.value = currentVal + delta; }
    }

    // Intersection Observer: Smooth scroll reveals
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('show');
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.kuih-card').forEach(card => { observer.observe(card); });
</script>
</body>
</html>