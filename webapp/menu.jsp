<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>

<%
    // Calculate cart counter
    int totalCount = 0;
    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");
    if (currentCart != null) {
        for(CartItem item : currentCart) {
            totalCount += item.getQuantity();
        }
    }

    // Load data from text file via application context
    List<Kuih> allKuih = DataHandler.readFromFile(application);

    // MEMBER 3: Get user name for greeting
    String userName = (String) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu - Kuih To You</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* (Your existing CSS remains the same) */
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); justify-content: center; gap: 40px; padding: 50px; max-width: 1200px; margin: 0 auto; }
        .kuih-card { background: white; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.08); overflow: hidden; text-align: center; padding-bottom: 25px; border: 1px solid #eee; opacity: 0; transform: translateY(40px); transition: opacity 0.7s ease-out, transform 0.7s cubic-bezier(0.165, 0.84, 0.44, 1); }
        .kuih-card.show { opacity: 1; transform: translateY(0); }
        .kuih-card:hover { transform: translateY(-12px) !important; box-shadow: 0 15px 40px rgba(0,0,0,0.15); }
        .img-wrapper { width: 100%; height: 280px; overflow: hidden; }
        .img-wrapper img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .kuih-card:hover .img-wrapper img { transform: scale(1.1); }
        .qty-control { display: inline-flex; align-items: center; background: #f1f1f1; border: 1.5px solid #eee; border-radius: 30px; padding: 5px 15px; margin-bottom: 20px; }
        .qty-btn { background: none; border: none; font-size: 1.5rem; color: #c32127; cursor: pointer; padding: 0 10px; font-weight: bold; }
        .add-btn { background-color: #c32127; color: white; border: none; padding: 12px 30px; border-radius: 30px; font-weight: bold; cursor: pointer; transition: background 0.3s, transform 0.2s; text-transform: uppercase; letter-spacing: 1px; }
        .add-btn:hover { background-color: #a01a1f; transform: scale(1.05); box-shadow: 0 5px 15px rgba(195, 33, 39, 0.3); }

        /* New Style for Greeting */
        .user-greeting { margin-right: 15px; color: #2e7d32; font-weight: bold; }
    </style>
</head>
<body>

<%
    String status = request.getParameter("status");
    if ("added".equals(status)) {
%>
<div style="background-color: #d4edda; color: #155724; padding: 15px; text-align: center; border-bottom: 1px solid #c3e6cb;">
    ✨ Excellent choice! Kuih added to cart. <a href="viewCart.jsp" style="font-weight: bold;">Check Cart</a>
</div>
<% } %>

<header class="navbar">
    <div class="logo">Kuih To You</div>
    <nav>
        <a href="index.html">Home</a>
        <a href="all_menu.jsp">Menu</a>
        <a href="viewCart.jsp" class="cart-link">🛒 Cart (<%= totalCount %>)</a>

        <%-- MEMBER 3: DYNAMIC NAVIGATION LOGIC --%>
        <% if (session.getAttribute("user") != null) { %>
            <span class="user-greeting">Hi, <%= userName %>!</span>
            <%-- Match the url-pattern in web.xml: /logout-action --%>
            <a href="logout-action" style="color: #c32127; font-weight: bold;">Logout</a>
        <% } else { %>
            <a href="login.html">Sign In</a>
        <% } %>
    </nav>
</header>

<h1 style="text-align: center; margin-top: 40px; color: #2e7d32; font-size: 32px;">Our Traditional Favorites</h1>

<section class="menu-grid">
    <% for(Kuih k : allKuih) { %>
    <div class="kuih-card">
        <div class="img-wrapper">
            <img src="KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>">
        </div>
        <div class="product-info" style="padding: 25px;">
            <h3 style="margin-bottom: 10px; color: #2e7d32;"><%= k.getName() %></h3>
            <p style="color: #333; font-size: 1.2rem; font-weight: bold; margin-bottom: 20px;">
                RM <%= String.format("%.2f", k.getPrice()) %>
            </p>

            <form action="AddToCart" method="POST">
                <input type="hidden" name="kuihId" value="<%= k.getId() %>">
                <div class="qty-control">
                    <button type="button" class="qty-btn" onclick="changeQty('<%= k.getId() %>', -1)">−</button>
                    <input type="number" name="quantity" id="qty-<%= k.getId() %>" value="1" min="1" readonly
                           style="width: 40px; text-align: center; border: none; background: transparent; font-weight: bold; font-size: 1.1rem;">
                    <button type="button" class="qty-btn" onclick="changeQty('<%= k.getId() %>', 1)">+</button>
                </div>
                <br>
                <button type="submit" class="add-btn">Add To Cart</button>
            </form>
        </div>
    </div>
    <% } %>
</section>

<script>
    function changeQty(id, delta) {
        const input = document.getElementById('qty-' + id);
        let currentVal = parseInt(input.value);
        if (currentVal + delta >= 1) { input.value = currentVal + delta; }
    }

    const observerOptions = { threshold: 0.1 };
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('show');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.kuih-card').forEach(card => { observer.observe(card); });
</script>
</body>
</html>