<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Kuih" %>

<%
    // 1. Calculate the total quantity from the session
    int totalItems = 0;
    List<CartItem> cartList = (List<CartItem>) session.getAttribute("cart");

    if (cartList != null) {
        for (CartItem item : cartList) {
            totalItems += item.getQuantity(); // Sums every piece added
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Shopping Cart - Kuih To You</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<header class="navbar">
    <div class="logo">Your Cart</div>
    <nav>
        <a href="index.html">Home</a>
        <a href="menu.jsp">Menu</a>
        <a href="viewCart.jsp" class="cart-link">
            🛒 View Cart <span>(<%= totalItems %>)</span>
        </a>
        <%
            // Only show Logout if userRole exists
            if (session.getAttribute("userRole") != null) {
        %>
        <a href="Logout" style="color: #c32127; font-weight: bold;">Logout</a>
        <% } else { %>
        <a href="login.html">Sign In</a>
        <% } %>
    </nav>
</header>

<section class="cart-container" style="padding: 20px;">
    <h2>Review Your Order</h2>

    <table border="1" class="cart-table" style="width: 100%; border-collapse: collapse; text-align: left;">
        <thead>
        <tr style="background-color: #f2f2f2;">
            <th>Product</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Subtotal</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            // Re-check for the table display logic
            double grandTotal = 0;

            if (cartList == null || cartList.isEmpty()) {
        %>
        <tr>
            <td colspan="5" style="text-align:center; padding: 20px;">Your cart is empty.</td>
        </tr>
        <%
        } else {
            for (CartItem item : cartList) {
                double subtotal = item.getKuih().getPrice() * item.getQuantity();
                grandTotal += subtotal;
        %>
        <tr>
            <td style="padding: 10px;">
                <img src="KuihMuihImage/<%= item.getKuih().getImageFile() %>" width="120" style="vertical-align: middle; margin-right: 15px; border-radius: 8px;">
                <%= item.getKuih().getName() %>
            </td>
            <td>RM <%= String.format("%.2f", item.getKuih().getPrice()) %></td>

            <td>
                <div style="display: flex; align-items: center; gap: 10px;">
                    <a href="RemoveFromCart?kuihId=<%= item.getKuih().getId() %>"
                       style="text-decoration: none; padding: 2px 8px; border: 1px solid #ddd; border-radius: 4px; color: black;">-</a>

                    <span><%= item.getQuantity() %></span>

                    <form action="AddToCart" method="POST" style="margin: 0;">
                        <input type="hidden" name="kuihId" value="<%= item.getKuih().getId() %>">
                        <input type="hidden" name="quantity" value="1">
                        <input type="hidden" name="source" value="cart">
                        <button type="submit" style="padding: 2px 8px; border: 1px solid #ddd; border-radius: 4px; cursor: pointer;">+</button>
                    </form>
                </div>
            </td>

            <td>RM <%= String.format("%.2f", subtotal) %></td>
            <td>
                <a href="RemoveFromCart?kuihId=<%= item.getKuih().getId() %>&action=clearRow"
                   style="color: red; text-decoration: none; font-size: 0.8rem;"
                   onclick="return confirm('Remove all <%= item.getKuih().getName() %> from your cart?')">
                    Remove Product
                </a>
            </td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <div class="cart-summary" style="margin-top: 20px; text-align: right;">
        <h3>Total to Pay: RM <%= String.format("%.2f", grandTotal) %></h3>

        <div style="display: flex; justify-content: flex-end; gap: 10px;">
            <button class="order-btn"
                    style="background-color: #d9534f; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;"
                    onclick="if(confirm('Are you sure you want to clear your entire cart?')) location.href='RemoveFromCart?action=clearCart'">
                Clear Entire Cart
            </button>

            <button class="order-btn"
                    style="background-color: #6c757d; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;"
                    onclick="location.href='menu.jsp'">
                Continue Ordering
            </button>

            <button class="order-btn"
                    style="background-color: #c32127; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer;"
                    onclick="location.href='checkout-action'">
                Confirm Order
            </button>
        </div>
    </div>
</section>

</body>
</html>