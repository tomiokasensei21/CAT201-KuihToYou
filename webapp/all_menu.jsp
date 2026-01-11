<%@ page contentType="text/html;charset=UTF-8" language="java" import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>

<%

    // 1. Load data from text file

    List<Kuih> allKuih = DataHandler.readFromFile(application);



    // 2. Calculate cart counter

    int totalCount = 0;

    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");

    if (currentCart != null) {

        for(CartItem item : currentCart) {

            totalCount += item.getQuantity();

        }

    }



    // 3. User & Role Information

    String userName = (String) session.getAttribute("user");

    String userRole = (String) session.getAttribute("userRole");

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Gallery - Kuih To You</title>

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

            color: var(--espresso); overflow-x: hidden;

        }



        header {

            background-color: var(--clay-orange);

            box-shadow: 0 4px 15px rgba(74, 44, 42, 0.25);

            position: sticky; top: 0; z-index: 1000;

        }

        .nav-container {

            max-width: 1200px; margin: 0 auto; display: flex;

            justify-content: space-between; align-items: center;

            padding: 0 20px; height: 70px;

        }

        .logo-wrapper { display: flex; align-items: center; text-decoration: none; }

        .logo-img { height: 45px; width: auto; object-fit: contain; transition: 0.3s; }

        .logo-img:hover { transform: scale(1.05); }



        .nav-links { display: flex; gap: 25px; align-items: center; }

        .nav-links a, .nav-links span {

            text-decoration: none; color: white !important;

            font-weight: 600; font-size: 13px;

            text-transform: uppercase; letter-spacing: 1.5px;

        }



        .user-greeting { background: rgba(255, 255, 255, 0.1); padding: 5px 12px; border-radius: 4px; font-size: 12px !important; }

        .btn-pill {

            padding: 8px 22px; border-radius: 50px; text-decoration: none;

            font-weight: bold; font-size: 12px; transition: 0.3s; cursor: pointer; border: 1.5px solid white;

            background: rgba(255,255,255,0.2); color: white;

        }

        .btn-pill:hover { background: white; color: var(--clay-orange) !important; }



        .gallery-title {

            text-align: center; margin: 60px 0 10px;

            font-family: 'Playfair Display', serif; font-size: 42px;

            color: var(--espresso); letter-spacing: 1px;

        }

        .gallery-subtitle { text-align: center; color: #888; font-style: italic; margin-bottom: 40px; }



        .gallery-grid {

            display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));

            gap: 40px; padding: 40px 60px; max-width: 1300px; margin: 0 auto;

        }



        .gallery-card {

            background: var(--warm-white); border-radius: 20px; overflow: hidden;

            box-shadow: 0 10px 25px var(--warm-shadow); text-align: center;

            padding: 15px; padding-bottom: 25px;

            opacity: 0; transform: translateY(30px);

            transition: transform 0.6s cubic-bezier(0.165, 0.84, 0.44, 1), box-shadow 0.4s ease, opacity 0.6s ease-out;

            position: relative; /* Added for badge positioning */

        }

        .gallery-card.show { opacity: 1; transform: translateY(0); }

        .gallery-card:hover { transform: translateY(-12px) !important; box-shadow: 0 20px 45px rgba(185, 124, 90, 0.25); }



        /* --- NEW: STOCK MANAGEMENT STYLES --- */

        .gallery-card.sold-out { filter: grayscale(0.8); opacity: 0.7; }

        .sold-out-badge {

            position: absolute; top: 25px; right: 25px; background: var(--espresso);

            color: white; padding: 6px 15px; border-radius: 50px; font-size: 11px;

            font-weight: bold; z-index: 5; text-transform: uppercase;

        }

        .btn-disabled { background-color: #888 !important; cursor: not-allowed; pointer-events: none; transform: none !important; }



        .img-container { width: 100%; height: 280px; overflow: hidden; border-radius: 12px; margin-bottom: 15px; }

        .gallery-card img { width: 100%; height: 100%; object-fit: cover; }



        .gallery-card h3 { font-family: 'Playfair Display', serif; font-size: 26px; color: var(--espresso); margin: 15px 0 5px; }

        .sub-detail { color: #999; font-size: 14px; margin-bottom: 20px; min-height: 20px; }



        .btn-solid-pop {

            display: inline-block; background-color: var(--clay-orange); color: white !important;

            padding: 12px 40px; font-size: 14px; font-weight: bold; text-decoration: none;

            border-radius: 50px; transition: 0.3s;

        }

        .btn-solid-pop:hover { background-color: var(--clay-dark); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(185, 124, 90, 0.3); }

    </style>

</head>

<body>



<header>

    <div class="nav-container">

        <a href="index.jsp" class="logo-wrapper">

            <img src="${pageContext.request.contextPath}/KuihMuihImage/kuihtoyoulogo.png" alt="Logo" class="logo-img">

        </a>

        <nav class="nav-links">

            <a href="index.jsp">Home</a>

            <a href="menu.jsp">Order Now</a>

            <a href="viewCart.jsp">🛒 Cart (<%= totalCount %>)</a>



            <% if (userName != null) { %>

            <span class="user-greeting">Hi, <%= userName %>!</span>

            <% if ("admin".equals(userRole)) { %><a href="admin_dashboard.jsp" style="color: #ffd700 !important; border-bottom: 1px solid #ffd700;">Admin Panel</a><% } %>

            <a onclick="confirmLogout(event)" class="btn-pill">Logout</a>

            <% } else { %>

            <a href="login.html">Sign In</a>

            <a href="signup.html" class="btn-pill">Sign Up</a>

            <% } %>

        </nav>

    </div>

</header>



<h1 class="gallery-title">The Heritage Collection</h1>

<p class="gallery-subtitle">A curated display of Malaysia's finest traditional delicacies</p>



<div class="gallery-grid">

    <% if (allKuih != null) {

        for(Kuih k : allKuih) {

            // STOCK CHECK

            boolean isOutOfStock = (k.getStock() <= 0);



            // NAME SPLITTING LOGIC

            String fullName = k.getName();

            String cleanTitle = fullName;

            String subDetail = "";



            if(fullName.contains("(")) {

                cleanTitle = fullName.substring(0, fullName.indexOf("(")).trim();

                subDetail = fullName.substring(fullName.indexOf("("));

            }

    %>

    <div class="gallery-card <%= isOutOfStock ? "sold-out" : "" %>">

        <% if (isOutOfStock) { %>

        <div class="sold-out-badge">Out of Stock</div>

        <% } %>



        <div class="img-container">

            <img src="KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>">

        </div>

        <h3><%= cleanTitle %></h3>

        <p class="sub-detail"><%= subDetail %></p>



        <% if (isOutOfStock) { %>

        <span class="btn-solid-pop btn-disabled">Sold Out</span>

        <% } else { %>

        <a href="menu.jsp" class="btn-solid-pop">Order Now</a>

        <% } %>

    </div>

    <%  }

    } %>

</div>



<script>

    const observer = new IntersectionObserver((entries) => {

        entries.forEach(entry => {

            if (entry.isIntersecting) {

                entry.target.classList.add('show');

                observer.unobserve(entry.target);

            }

        });

    }, { threshold: 0.1 });



    document.querySelectorAll('.gallery-card').forEach(card => observer.observe(card));



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

            if (result.isConfirmed) { window.location.href = 'LogoutServlet'; }

        });

    }



    document.addEventListener('DOMContentLoaded', function() {

        const params = new URLSearchParams(window.location.search);

        if (params.get('status') === 'logged_out') {

            Swal.fire({

                toast: true, position: 'top-end', icon: 'info',

                title: 'Logged out. See you soon! 👋',

                showConfirmButton: false, timer: 3000, background: '#fcfaf7', iconColor: '#b97c5a'

            });

            window.history.replaceState({}, document.title, window.location.pathname);

        }

    });

</script>

</body>

</html>

