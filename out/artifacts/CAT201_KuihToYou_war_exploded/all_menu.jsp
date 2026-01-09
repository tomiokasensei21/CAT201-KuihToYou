<%@ page import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>
<%
    // Load the data
    List<Kuih> allKuih = DataHandler.readFromFile(application);

    // Calculate cart counter for the header
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
    <style>
        /* GLOBAL & HEADER STYLES */
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background-color: #f9f9f9; overflow-x: hidden; }

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
        .nav-links { display: flex; gap: 25px; align-items: center; }
        .nav-links a { text-decoration: none; color: #333; font-weight: 600; font-size: 14px; text-transform: uppercase; }
        .nav-links a:hover { color: #2e7d32; }
        .nav-actions { display: flex; gap: 15px; align-items: center; }

        .btn-pill {
            padding: 10px 25px; border-radius: 50px; text-decoration: none;
            font-weight: bold; font-size: 13px; transition: 0.3s; cursor: pointer; border: none;
        }
        .btn-secondary { background-color: white; border: 2px solid #c62828; color: #c62828; }

        /* GALLERY GRID */
        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 40px;
            padding: 50px;
            max-width: 1200px;
            margin: 0 auto;
        }

        /* --- HOVER STYLES --- */
        .gallery-card {
            background: white; border-radius: 20px; overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05); text-align: center;
            opacity: 0; /* Hidden initially for scroll animation */
            transform: translateY(30px);
            /* Smooth transition for both scroll and hover */
            transition: transform 0.4s cubic-bezier(0.165, 0.84, 0.44, 1),
            box-shadow 0.4s ease,
            opacity 0.6s ease-out;
        }

        .gallery-card.show {
            opacity: 1;
            transform: translateY(0);
        }

        /* THE LIFT EFFECT */
        .gallery-card:hover {
            transform: translateY(-12px) scale(1.02) !important;
            box-shadow: 0 20px 40px rgba(0,0,0,0.12);
        }

        /* IMAGE CONTAINER & ZOOM EFFECT */
        .img-container {
            width: 100%;
            height: 350px;
            overflow: hidden; /* Clips the zoomed image */
            border-radius: 20px 20px 0 0;
        }

        .gallery-card img {
            width: 100%; height: 100%; object-fit: cover;
            transition: transform 0.5s ease;
        }

        .gallery-card:hover img {
            transform: scale(1.1); /* Zoom in on hover */
        }

        .gallery-card h3 { font-size: 24px; color: #2e7d32; margin: 25px 0; }

        .btn-order {
            display: inline-block; background: #c62828; color: white;
            padding: 12px 35px; border-radius: 50px; text-decoration: none;
            margin-bottom: 30px; font-weight: bold; transition: 0.3s;
        }
        .btn-order:hover { background-color: #a31f1f; transform: scale(1.05); }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="index.html" class="logo">Kuih To You</a>
        <nav class="nav-links">
            <a href="index.html">Home</a>
            <a href="menu.jsp">Order Now</a>
            <a href="viewCart.jsp"> Cart (<%= totalCount %>)</a>
        </nav>
        <div class="nav-actions">
            <% if (session.getAttribute("userRole") != null) { %>
            <a href="index.html" class="btn-pill btn-secondary">Logout</a>
            <% } else { %>
            <a href="login.html" onclick="sessionStorage.setItem('redirectAfterLogin', 'all_menu.jsp');"
               style="text-decoration: none; color: #333; font-weight: 600; font-size: 14px;">Sign In</a>
            <a href="signup.html" class="btn-pill btn-secondary">Sign Up</a>
            <% } %>
        </div>
    </div>
</header>

<h1 style="text-align: center; margin-top: 50px; color: #2e7d32; font-size: 36px; font-weight: 700;">Menu</h1>

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
    // SCROLL ENTRANCE ANIMATION
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