<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.CartItem, model.Kuih" %>

<%
    // 1. Calculate the total quantity for the header
    int totalItems = 0;
    List<CartItem> cartList = (List<CartItem>) session.getAttribute("cart");
    if (cartList != null) {
        for (CartItem item : cartList) {
            totalItems += item.getQuantity();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart - Kuih To You</title>
    <style>
        /* GLOBAL & HEADER STYLES */
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background-color: #f9f9f9; color: #333; }

        header {
            background-color: white; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; display: flex;
            justify-content: space-between; align-items: center; padding: 15px 20px;
        }
        .logo { font-size: 24px; font-weight: bold; color: #2e7d32; text-decoration: none; }
        .nav-links a { text-decoration: none; color: #333; font-weight: 600; font-size: 14px; margin-left: 20px; text-transform: uppercase; }

        /* UPDATED CART LAYOUT: WIDER BOXES */
        .cart-wrapper {
            display: flex; gap: 40px; max-width: 1200px;
            margin: 40px auto; padding: 0 20px; align-items: flex-start;
        }
        .items-column { flex: 3; } /* More space for the large images */
        .summary-column { flex: 2; position: sticky; top: 120px; } /* Larger sidebar */

        /* KUIH-CARD WITH LARGER IMAGES */
        .kuih-card {
            background: white; border-radius: 12px; padding: 30px;
            margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: grid; grid-template-columns: 220px 1fr auto; gap: 30px; align-items: center;
        }

        /* UPSCALED IMAGE: Matching all_menu gallery size */
        .kuih-card img {
            width: 220px; height: 220px;
            object-fit: cover; border-radius: 12px;
        }

        .item-info h3 {
            margin: 0; color: #2e7d32; font-size: 18px;
            text-transform: uppercase; letter-spacing: 0.5px;
        }

        /* PILL QUANTITY SELECTOR (Upscaled) */
        .qty-pill {
            display: flex; align-items: center; border: 2px solid #ddd;
            border-radius: 50px; width: fit-content; margin-top: 20px; padding: 8px 20px;
        }
        .qty-btn { background: none; border: none; font-size: 20px; color: #c62828; cursor: pointer; text-decoration: none; padding: 0 12px; }
        .qty-val { font-weight: bold; margin: 0 15px; color: #333; font-size: 18px; }

        /* TRASH BUTTON */
        .trash-btn {
            border: 2px solid #ddd; border-radius: 50%; width: 45px; height: 45px;
            display: flex; align-items: center; justify-content: center;
            color: #2e7d32; text-decoration: none; font-size: 20px; transition: 0.2s;
        }
        .trash-btn:hover { background: #f9f9f9; border-color: #2e7d32; }

        /* LARGER SUMMARY BOX */
        .summary-box { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .summary-box h3 { font-size: 26px; margin-top: 0; color: #2e7d32; }

        .total-row {
            display: flex; justify-content: space-between;
            font-size: 30px; font-weight: bold; color: #c62828; margin: 25px 0;
        }

        .btn-checkout {
            display: inline-block;   /* allow natural width */
            width: 80%;             /* stop full width */
            padding: 12px 30px;      /* control size */
            background-color: #c62828;
            color: white;
            border-radius: 30px;
            font-weight: bold;
            font-size: 18px;
            text-decoration: none;
            text-align: center;
            transition: 0.3s;
        }

        .btn-checkout:hover { background-color: #a31f1f; transform: scale(1.02); }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="index.html" class="logo">Kuih To You</a>
        <nav class="nav-links">
            <a href="index.html">Home</a>
            <a href="all_menu.jsp">Menu</a>
            <a href="viewCart.jsp">🛒 Cart (<%= totalItems %>)</a>
        </nav>
    </div>
</header>

<div class="cart-wrapper">
    <div class="items-column">
        <h2 style="color: #2e7d32; margin-bottom: 25px; font-size: 28px;">Review Your Cart</h2>
        <%
            double grandTotal = 0;
            if (cartList == null || cartList.isEmpty()) {
        %>
        <div class="kuih-card" style="display: block; text-align: center; padding: 60px;">
            <p style="font-size: 18px;">Your Cart is empty. Time to fill it with tradition!</p>
            <a href="menu.jsp" style="color: #2e7d32; font-weight: bold; font-size: 18px;">Back to Browsing</a>
        </div>
        <%
        } else {
            for (CartItem item : cartList) {
                double subtotal = item.getKuih().getPrice() * item.getQuantity();
                grandTotal += subtotal;
        %>
        <div class="kuih-card">
            <img src="KuihMuihImage/<%= item.getKuih().getImageFile() %>" alt="<%= item.getKuih().getName() %>">

            <div class="item-info">
                <h3><%= item.getKuih().getName().toUpperCase() %></h3>
                <div class="qty-pill">
                    <a href="RemoveFromCart?kuihId=<%= item.getKuih().getId() %>" class="qty-btn" style="color: #c62828;">-</a>
                    <span class="qty-val"><%= item.getQuantity() %></span>
                    <form action="AddToCart" method="POST" style="display:inline; margin:0;">
                        <input type="hidden" name="kuihId" value="<%= item.getKuih().getId() %>">
                        <input type="hidden" name="quantity" value="1">
                        <input type="hidden" name="source" value="cart">
                        <button type="submit" class="qty-btn" style="color: #2e7d32; margin-top: -4px;">+</button>
                    </form>
                </div>
            </div>

            <div style="display: flex; flex-direction: column; justify-content: space-between; align-items: flex-end; height: 100%; min-height: 220px;">
                <span style="font-weight: bold; font-size: 22px; color: #333;">RM <%= String.format("%.2f", subtotal) %></span>
                <a href="RemoveFromCart?kuihId=<%= item.getKuih().getId() %>&action=clearRow"
                   class="trash-btn" onclick="return confirm('Remove this item from your cart')">🗑️</a>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>

    <div class="summary-column">
        <div class="summary-box">
            <h3 style="color: #2e7d32; margin-top: 0; margin-bottom: 10px; width: 100%;">Order Summary</h3>
            <p style="color: #666; font-size: 14px; margin-bottom: 0;"></p>

            <hr style="border: 0; border-top: 1px solid #eee; margin: 20px 0; width: 60%;">

            <div class="total-row">
                <span>Total</span>
                <span>RM <%= String.format("%.2f", grandTotal) %></span>
            </div>

            <a href="checkout-action" class="btn-checkout">Confirm Order</a>

            <div style="margin-top: 25px; display: flex; flex-direction: column; gap: 12px;">
                <a href="menu.jsp" style="text-decoration: none; color: #666; font-size: 18px; font-weight: 600;">
                    ← Continue Browsing
                </a>
                <a href="RemoveFromCart?action=clearCart"
                   style="color: #c62828; font-size: 18px; text-decoration: none; font-weight: bold;"
                   onclick="return confirm('Empty entire box?')">
                    Empty Entire Cart
                </a>
            </div>
        </div>
    </div>
</div>

</body>
</html>