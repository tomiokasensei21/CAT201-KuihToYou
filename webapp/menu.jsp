<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>

<%
    // 1. Calculate cart counter
    int totalCount = 0;
    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");
    if (currentCart != null) {
        for(CartItem item : currentCart) {
            totalCount += item.getQuantity();
        }
    }

    // 2. Fix the 'getServletContext' error by using 'application'
    List<Kuih> allKuih = DataHandler.readFromFile(application);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu - Kuih To You</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* Modern 2-Column Grid */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(2, 380px);
            justify-content: center;
            gap: 50px;
            padding: 50px;
        }

        /* 40% GUI Mark Feature: Interactive Cards [cite: 14, 30] */
        .product-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            overflow: hidden;
            text-align: center;
            padding-bottom: 25px;
            transition: all 0.3s ease; /* Smooth transition */
            border: 1px solid #eee;
        }

        .product-card:hover {
            transform: translateY(-10px); /* Lifts up on hover */
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .img-wrapper img {
            width: 100%;
            height: 280px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .product-card:hover .img-wrapper img {
            transform: scale(1.05); /* Slight zoom on hover */
        }

        /* Professional Quantity Controls  */
        .qty-control {
            display: inline-flex;
            align-items: center;
            background: #f1f1f1;
            border-radius: 30px;
            padding: 5px 15px;
            margin-bottom: 20px;
        }

        .qty-btn {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #c32127;
            cursor: pointer;
            padding: 0 10px;
            font-weight: bold;
        }

        /* Improved Add to Cart Button  */
        .add-btn {
            background-color: #c32127;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 30px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .add-btn:hover {
            background-color: #a01a1f;
            box-shadow: 0 5px 15px rgba(195, 33, 39, 0.3);
        }
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
        <a href="viewCart.jsp" class="cart-link">🛒 Cart (<%= totalCount %>)</a>
        <% if (session.getAttribute("userRole") != null) { %>
        <a href="Logout" style="color: #c32127; font-weight: bold;">Logout</a>
        <% } else { %>
        <a href="login.html">Sign In</a>
        <% } %>
    </nav>
</header>

<h1 style="text-align: center; margin-top: 40px; color: #2c3e50;">Our Traditional Favorites</h1>

<section class="menu-grid">
    <% for(Kuih k : allKuih) { %>
    <div class="product-card">
        <div class="img-wrapper">
            <img src="KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>">
        </div>
        <div class="product-info" style="padding: 20px;">
            <h3 style="margin-bottom: 10px;"><%= k.getName() %></h3>
            <p style="color: #c32127; font-size: 1.2rem; font-weight: bold; margin-bottom: 20px;">
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
        if (currentVal + delta >= 1) {
            input.value = currentVal + delta;
        }
    }
</script>

</body>
</html>