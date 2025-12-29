<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DataHandler, model.Kuih, model.CartItem, java.util.List" %>

<%
    // 1. CALCULATE CART COUNTER AT THE TOP
    int totalCount = 0;
    List<CartItem> currentCart = (List<CartItem>) session.getAttribute("cart");
    if (currentCart != null) {
        for(CartItem item : currentCart) {
            totalCount += item.getQuantity();
        }
    }

    // 2. FETCH KUIH DATA USING THE 'application' OBJECT
    // This fixes the "Cannot resolve method getServletContext" error.
    List<Kuih> allKuih = DataHandler.readFromFile(application);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu - Kuih To You</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* CSS to ensure your grid is centered and 2-columns */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(2, 400px);
            justify-content: center;
            gap: 40px;
            padding: 40px;
        }
        .product-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            text-align: center;
            padding-bottom: 20px;
        }
        .img-wrapper img {
            width: 100%;
            height: 250px;
            object-fit: cover; /* Large images as requested */
        }
    </style>
</head>
<body>

<%
    // Success message logic
    String status = request.getParameter("status");
    if ("added".equals(status)) {
%>
<div style="background-color: #d4edda; color: #155724; padding: 15px; text-align: center; border-bottom: 1px solid #c3e6cb;">
    Item added to cart successfully! <a href="viewCart.jsp">Go to Cart</a>
</div>
<% } %>

<header class="navbar">
    <div class="logo">Kuih To You</div>
    <nav>
        <a href="index.html">Home</a>
        <a href="viewCart.jsp" class="cart-link">🛒 View Cart (<%= totalCount %>)</a>
    </nav>
</header>

<h1 style="text-align: center; margin-top: 30px;">Our Traditional Favorites</h1>

<section class="menu-grid">
    <% for(Kuih k : allKuih) { %>
    <div class="product-card">
        <div class="img-wrapper">
            <img src="KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>">
        </div>
        <div class="product-info">
            <h3><%= k.getName() %></h3>
            <p class="price">RM <%= String.format("%.2f", k.getPrice()) %></p>

            <form action="AddToCart" method="POST">
                <input type="hidden" name="kuihId" value="<%= k.getId() %>">
                <div class="quantity-control" style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-bottom: 10px;">
                    <button type="button" onclick="changeQty('<%= k.getId() %>', -1)">-</button>
                    <input type="number" name="quantity" id="qty-<%= k.getId() %>" value="1" min="1" readonly style="width: 40px; text-align: center;">
                    <button type="button" onclick="changeQty('<%= k.getId() %>', 1)">+</button>
                </div>
                <button type="submit" class="add-btn">ADD TO ORDER</button>
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