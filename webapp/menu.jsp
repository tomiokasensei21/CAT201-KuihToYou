<%
    String status = request.getParameter("status");
    if ("added".equals(status)) {
%>
<div style="background-color: #d4edda; color: #155724; padding: 15px; text-align: center; border-bottom: 1px solid #c3e6cb;">
    Item added to cart successfully! <a href="viewCart.jsp">Go to Cart</a>
</div>
<% } %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="util.DataHandler, model.Kuih, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Menu - Kuih To You</title>
    <link rel="stylesheet" href="style.css"> </head>
<body>

<header class="navbar">
    <div class="logo">Kuih To You</div>
    <nav>
        <a href="index.html">Home</a>
        <a href="menu.jsp" class="active">Menu</a>
        <a href="viewCart.jsp" class="cart-link">🛒 View Cart</a>
    </nav>
</header>

<h1 style="text-align: center; margin-top: 30px;">Our Traditional Favorites</h1>

<section class="menu-grid">
    <%
        List<Kuih> allKuih = DataHandler.readFromFile(getServletContext());
        for(Kuih k : allKuih) {
    %>
    <div class="product-card">
        <div class="img-wrapper">
            <img src="KuihMuihImage/<%= k.getImageFile() %>" alt="<%= k.getName() %>">
        </div>
        <div class="product-info">
            <h3><%= k.getName() %></h3>
            <p class="price">RM <%= String.format("%.2f", k.getPrice()) %></p>

            <form action="AddToCart" method="POST">
                <input type="hidden" name="kuihId" value="<%= k.getId() %>">
                <div class="quantity-control">
                    <button type="button" onclick="changeQty('<%= k.getId() %>', -1)">-</button>
                    <input type="number" name="quantity" id="qty-<%= k.getId() %>" value="1" min="1" readonly>
                    <button type="button" onclick="changeQty('<%= k.getId() %>', 1)">+</button>
                </div>
                <button type="submit" class="add-btn">ADD TO ORDER</button>
            </form>
        </div>
    </div>
    <% } %>
</section>

<script>
    // JavaScript for the Plus/Minus buttons
    function changeQty(id, delta) {
        const input = document.getElementById('qty-' + id);
        let currentVal = parseInt(input.value);
        if (currentVal + delta >= 1) {
            input.value = currentVal + delta;
        }
    }
</script>

</body>
</html>   update my menu.jsp too