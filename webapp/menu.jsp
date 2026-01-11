<%@ page contentType="text/html;charset=UTF-8" language="java" import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>
<%
    // 1. Session & Data Retrieval
    int totalCount = 0;
    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");
    if (currentCart != null) {
        for(CartItem item : currentCart) { totalCount += item.getQuantity(); }
    }
    List<Kuih> allKuih = DataHandler.readFromFile(application);

    // 2. User & Role Information
    String userName = (String) session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu - Kuih To You Collection</title>
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
            background-repeat: repeat; background-size: 350px; background-attachment: fixed;
            color: var(--espresso);
            overflow-x: hidden;
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
        .logo-img { height: 45px; width: auto; object-fit: contain; }

        .nav-actions { display: flex; gap: 20px; align-items: center; }
        .nav-actions a, .nav-actions span {
            text-decoration: none; color: white !important; font-weight: 600;
            font-size: 13px; text-transform: uppercase; letter-spacing: 1.5px;
        }

        .user-greeting {
            background: rgba(255, 255, 255, 0.1);
            padding: 5px 12px;
            border-radius: 4px;
            font-size: 12px !important;
        }

        .btn-pill {
            background: rgba(255, 255, 255, 0.2); border: 1.5px solid white;
            padding: 8px 20px; border-radius: 50px; font-size: 12px; transition: 0.3s;
            cursor: pointer;
        }
        .btn-pill:hover { background: white; color: var(--clay-orange) !important; }

        .menu-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 40px; padding: 50px; max-width: 1200px; margin: 0 auto;
        }

        .kuih-card {
            background: var(--warm-white); border-radius: 20px; text-align: center;
            padding: 15px; padding-bottom: 25px; box-shadow: 0 10px 25px var(--warm-shadow);
            opacity: 0; transform: translateY(30px);
            transition: transform 0.6s cubic-bezier(0.165, 0.84, 0.44, 1), box-shadow 0.4s ease, opacity 0.6s ease-out;
            position: relative; /* For the badge positioning */
        }
        .kuih-card.show { opacity: 1; transform: translateY(0); }

        .kuih-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 20px 45px rgba(185, 124, 90, 0.25);
        }

        /* NEW: STOCK VISUALS */
        .kuih-card.out-of-stock { filter: grayscale(0.7); opacity: 0.8; }
        .stock-badge {
            position: absolute; top: 25px; right: 25px;
            background: var(--espresso); color: white;
            padding: 6px 14px; border-radius: 50px;
            font-size: 11px; font-weight: bold; z-index: 5;
        }
        .btn-sold-out { background-color: #888 !important; cursor: not-allowed; pointer-events: none; }

        .img-wrapper { width: 100%; height: 280px; overflow: hidden; border-radius: 12px; }
        .img-wrapper img { width: 100%; height: 100%; object-fit: cover; transition: 0.5s ease; }
        .kuih-card:hover .img-wrapper img { transform: scale(1.08); }

        .kuih-title { font-family: 'Playfair Display', serif; font-size: 1.6rem; margin: 15px 0 5px; color: var(--espresso); }
        .kuih-sub { color: #999; font-size: 0.9rem; margin-bottom: 5px; font-style: italic; }
        .price-text { color: var(--clay-orange); font-size: 1.2rem; font-weight: bold; margin: 5px 0 15px; }

        .qty-control {
            display: inline-flex; align-items: center;
            background: #fdfaf5; border: 1px solid #efe5d9;
            border-radius: 50px; padding: 5px 15px; margin-bottom: 15px;
        }
        .qty-btn { background: none; border: none; font-size: 1.4rem; color: var(--clay-orange); cursor: pointer; padding: 0 10px; font-weight: bold; }
        .qty-input { width: 40px; text-align: center; border: none; background: transparent; font-family: 'Lora'; font-weight: bold; color: var(--espresso); font-size: 1rem; }

        .add-btn {
            background-color: var(--clay-orange); color: white; border: none;
            padding: 14px 40px; border-radius: 50px; font-weight: bold;
            cursor: pointer; text-transform: uppercase; letter-spacing: 1px;
            transition: 0.3s; box-shadow: 0 5px 15px rgba(185, 124, 90, 0.2);
        }
        .add-btn:hover { background: var(--clay-dark); transform: translateY(-2px); }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="index.jsp" class="logo-wrapper">
            <img src="${pageContext.request.contextPath}/KuihMuihImage/kuihtoyoulogo.png" alt="Logo" class="logo-img">
        </a>
        <div class="nav-actions">
            <a href="index.jsp">Home</a>
            <a href="all_menu.jsp">Gallery</a>
            <a href="viewCart.jsp">🛒 Cart (<%= totalCount %>)</a>

            <% if (userName != null) { %>
            <span class="user-greeting">Hi, <%= userName %>!</span>
            <% if ("admin".equals(userRole)) { %>
            <a href="admin_dashboard.jsp" style="color: #ffd700 !important;">Admin Panel</a>
            <% } %>
            <a onclick="confirmLogout(event)" class="btn-pill">Logout</a>
            <% } else { %>
            <a href="login.html">Sign In</a>
            <a href="signup.html" class="btn-pill">Sign Up</a>
            <% } %>
        </div>
    </div>
</header>

<h1 style="text-align: center; margin-top: 60px; font-family: 'Playfair Display', serif; font-size: 48px; color: var(--espresso);">OUR COLLECTION</h1>
<p style="text-align: center; color: #888; margin-top: -20px;">Freshly made everyday with love.</p>

<section class="menu-grid">
    <% if (allKuih != null) {
        for(Kuih k : allKuih) {
            // STOCK CHECK LOGIC
            boolean isOutOfStock = (k.getStock() <= 0);

            String fullName = k.getName();
            String cleanTitle = fullName;
            String subDetail = "";

            if(fullName.contains("(")) {
                cleanTitle = fullName.substring(0, fullName.indexOf("(")).trim();
                subDetail = fullName.substring(fullName.indexOf("("));
            }
    %>
    <div class="kuih-card <%= isOutOfStock ? "out-of-stock" : "" %>">
        <% if (isOutOfStock) { %>
        <div class="stock-badge">SOLD OUT</div>
        <% } %>

        <div class="img-wrapper"><img src="KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>"></div>

        <h3 class="kuih-title"><%= cleanTitle %></h3>
        <p class="kuih-sub"><%= subDetail %></p>
        <p class="price-text">RM <%= String.format("%.2f", k.getPrice()) %></p>

        <% if (!isOutOfStock) { %>
        <form action="AddToCart" method="POST">
            <input type="hidden" name="kuihId" value="<%= k.getId() %>">
            <div class="qty-control">
                <button type="button" class="qty-btn" onclick="changeQty('<%= k.getId() %>', -1)">−</button>
                <input type="number" name="quantity" id="qty-<%= k.getId() %>" value="1" min="1" readonly class="qty-input">
                <button type="button" class="qty-btn" onclick="changeQty('<%= k.getId() %>', 1)">+</button>
            </div><br>
            <button type="submit" class="add-btn">Add to Cart</button>
        </form>
        <% } else { %>
        <div class="qty-control" style="opacity: 0.5;">
            <span style="font-size: 0.9rem; font-weight: bold; color: #777;">Unavailable</span>
        </div><br>
        <button type="button" class="add-btn btn-sold-out">Out of Stock</button>
        <% } %>
    </div>
    <%  }
    } %>
</section>

<footer style="text-align: center; padding: 60px 20px; color: #777; border-top: 1px solid rgba(74, 44, 42, 0.1);">
    &copy; 2026 Kuih To You. Handcrafted Tradition.
</footer>

<script>
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('show');
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.kuih-card').forEach(card => observer.observe(card));

    function changeQty(id, delta) {
        const input = document.getElementById('qty-' + id);
        if(!input) return;
        let currentVal = parseInt(input.value);
        if (!isNaN(currentVal)) {
            input.value = Math.max(1, currentVal + delta);
        }
    }

    function confirmLogout(event) {
        event.preventDefault();
        Swal.fire({
            title: 'Logging out?',
            text: "Are you sure you want to leave?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#b97c5a',
            cancelButtonColor: '#4a2c2a',
            confirmButtonText: 'Yes, Logout',
            background: '#fcfaf7'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'LogoutServlet';
            }
        });
    }
</script>
</body>
</html>