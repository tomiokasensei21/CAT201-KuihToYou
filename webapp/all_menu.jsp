<%@ page import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Gallery - Kuih To You</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;600&display=swap" rel="stylesheet">
    <style>
        /* --- EARTH & CLAY DESIGN SYSTEM --- */
        :root {
            --clay-orange: #b97c5a;     /* Main action color */
            --clay-dark: #a06648;       /* Button hover state */
            --parchment-bg: #f3ece0;    /* Textured background base */
            --espresso: #4a2c2a;        /* Typography color */
            --warm-white: #fffcf7;      /* Card background color */
        }

        /* GLOBAL STYLES WITH BATIK BACKGROUND */
        body {
            margin: 0;
            font-family: 'Lora', serif;
            background-color: var(--parchment-bg);
            /* Fading Batik Trick: Overlay + Image */
            background-image:
                    linear-gradient(rgba(243, 236, 224, 0.85), rgba(243, 236, 224, 0.85)),
                    url('KuihMuihImage/batik_pattern.jpg');
            background-repeat: repeat;
            background-size: 350px;
            background-attachment: fixed;
            color: var(--espresso);
        }

        /* HEADER STYLING */
        header {
            background-color: var(--clay-orange);
            box-shadow: 0 4px 10px rgba(74, 44, 42, 0.15);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; display: flex;
            justify-content: space-between; align-items: center; padding: 15px 20px;
        }
        .logo { font-family: 'Playfair Display', serif; font-size: 26px; font-weight: bold; color: white; text-decoration: none; }
        .nav-links { display: flex; gap: 25px; align-items: center; }
        .nav-links a { text-decoration: none; color: white; font-weight: 600; font-size: 14px; text-transform: uppercase; letter-spacing: 1px; }

        .btn-pill {
            padding: 8px 22px; border-radius: 50px; text-decoration: none;
            font-weight: bold; font-size: 12px; transition: 0.3s; cursor: pointer; border: 1px solid white;
            background: rgba(255,255,255,0.2); color: white;
        }
        .btn-pill:hover { background: white; color: var(--clay-orange); }

        /* GALLERY GRID */
        .gallery-title {
            text-align: center; margin: 60px 0 20px;
            font-family: 'Playfair Display', serif; font-size: 42px;
            text-transform: uppercase; letter-spacing: 2px;
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 40px; padding: 40px 60px;
            max-width: 1300px; margin: 0 auto;
        }

        /* --- THE EARTHY GALLERY CARD --- */
        .gallery-card {
            background: var(--warm-white); border-radius: 18px; overflow: hidden;
            box-shadow: 0 10px 25px rgba(74, 44, 42, 0.1); text-align: center;
            opacity: 0; transform: translateY(30px);
            transition: transform 0.6s cubic-bezier(0.165, 0.84, 0.44, 1), box-shadow 0.4s ease, opacity 0.6s ease-out;
        }

        .gallery-card.show { opacity: 1; transform: translateY(0); }

        .gallery-card:hover {
            transform: translateY(-12px) !important;
            box-shadow: 0 20px 45px rgba(185, 124, 90, 0.2);
        }

        /* IMAGE ZOOM LOGIC */
        .img-container {
            width: 90%; height: 280px; margin: 20px auto 10px;
            overflow: hidden; border-radius: 12px;
        }

        .gallery-card img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform 0.6s ease;
        }

        .gallery-card:hover img { transform: scale(1.1); }

        .gallery-card h3 {
            font-family: 'Playfair Display', serif; font-size: 26px;
            color: var(--espresso); margin: 20px 0 10px;
        }

        .btn-order {
            display: inline-block; background: var(--clay-orange); color: white;
            padding: 12px 35px; border-radius: 8px; text-decoration: none;
            margin-bottom: 25px; font-weight: bold; transition: 0.3s;
            text-transform: uppercase; letter-spacing: 1px;
        }
        .btn-order:hover { background-color: var(--clay-dark); transform: scale(1.03); }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="index.jsp" class="logo">KUIH TO YOU</a>
        <nav class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="menu.jsp">Order Now</a>
            <a href="viewCart.jsp"> Cart (<%= totalCount %>)</a>
        </nav>
        <div class="nav-links">
            <% if (session.getAttribute("userRole") != null) { %>
            <a href="Logout" class="btn-pill">Logout</a>
            <% } else { %>
            <a href="login.html" onclick="sessionStorage.setItem('redirectAfterLogin', 'all_menu.jsp');"

               style="text-decoration: none; color: #333; font-weight: 600; font-size: 14px;">Sign In</a>

            <a href="signup.html" class="btn-pill btn-secondary">Sign Up</a>

            <% }%>
        </nav>
    </div>
    </div>
</header>

<h1 class="gallery-title">Our Menu</h1>

<div class="gallery-grid">
    <% for(Kuih k : allKuih) { %>
    <div class="gallery-card">
        <div class="img-container">
            <img src="KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>">
        </div>
        <h3><%= k.getName() %></h3>
        <a href="menu.jsp" class="btn-order">Order Now</a>
    </div>
    <% } %>
</div>



<script>
    // SCROLL ENTRANCE ANIMATION logic
    const observerOptions = { threshold: 0.1 };
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('show');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.gallery-card').forEach(card => {
        observer.observe(card);
    });
</script>

</body>
</html>