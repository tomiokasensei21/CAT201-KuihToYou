<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CartItem" %>
<%@ page import="model.Kuih" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Shopping Cart - Kuih To You</title>
    <link rel="stylesheet" href="style.css"> </head>
<body>

<header class="navbar">
    <div class="logo">Your Cart</div>
    <nav>
        <a href="index.html">Back to Menu</a>
    </nav>
</header>

<section class="cart-container">
    <h2>Review Your Order</h2>

    <table border="1" class="cart-table">
        <thead>
        <tr>
            <th>Product</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Subtotal</th>
        </tr>
        </thead>
        <tbody>
        <%
            // 1. Get the cart from the session
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            double grandTotal = 0;

            if (cart == null || cart.isEmpty()) {
        %>
        <tr>
            <td colspan="4" style="text-align:center;">Your cart is empty.</td>
        </tr>
        <%
        } else {
            for (CartItem item : cart) {
                double subtotal = item.getKuih().getPrice() * item.getQuantity();
                grandTotal += subtotal;
        %>
        <tr>
            <td>
                <img src="KuihMuihImage/<%= item.getKuih().getImageFile() %>" width="50">
                <%= item.getKuih().getName() %>
            </td>
            <td>RM <%= String.format("%.2f", item.getKuih().getPrice()) %></td>
            <td><%= item.getQuantity() %></td>
            <td>RM <%= String.format("%.2f", subtotal) %></td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

    <div class="cart-summary">
        <h3>Total to Pay: RM <%= String.format("%.2f", grandTotal) %></h3>
        <button class="order-btn" onclick="location.href='checkout-action'">Confirm Order</button>
    </div>
</section>

</body>
</html>
