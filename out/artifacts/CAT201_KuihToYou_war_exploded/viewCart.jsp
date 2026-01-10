<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.CartItem, model.Kuih" %>

<%
    // Calculate the total quantity for the header
    int totalItems = 0;
    List<CartItem> cartList = (List<CartItem>) session.getAttribute("cart");
    if (cartList != null) {
        for (CartItem item : cartList) {
            totalItems += item.getQuantity();
        }
    }

    // MEMBER 3: Get user for greeting
    String userName = (String) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart - Kuih To You</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;600&display=swap" rel="stylesheet">

    <style>
        /* --- EARTH & CLAY DESIGN SYSTEM --- */
        :root {
            --clay-orange: #b97c5a;     /* Main action color */
            --clay-dark: #a06648;       /* Hover state for buttons */
            --parchment-bg: #f3ece0;    /* Textured background base */
            --espresso: #4a2c2a;        /* Typography color */
            --warm-white: #fffcf7;      /* Card background */
            --warm-shadow: rgba(74, 44, 42, 0.12);
        }

        /* GLOBAL STYLES WITH FADING BATIK BACKGROUND */
        body {
            margin: 0;
            font-family: 'Lora', serif;
            background-color: var(--parchment-bg);
            /* Overlay set to 0.85 opacity per previous design preference */
            background-image:
                    linear-gradient(rgba(243, 236, 224, 0.85), rgba(243, 236, 224, 0.85)),
                    url('KuihMuihImage/batik_pattern.jpg');
            background-repeat: repeat;
            background-size: 350px;
            background-attachment: fixed;
            color: var(--espresso);
        }

        /* THEMED SOLID CLAY NAVBAR */
        header {
            background-color: var(--clay-orange);
            box-shadow: 0 4px 15px rgba(74, 44, 42, 0.2);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; display: flex;
            justify-content: space-between; align-items: center; padding: 12px 20px;
        }
        .logo {
            font-family: 'Playfair Display', serif; font-size: 26px;
            font-weight: bold; color: white !important; text-decoration: none;
        }
        .nav-links { display: flex; align-items: center; }
        .nav-links a {
            text-decoration: none; color: white !important;
            font-weight: 600; font-size: 13px; margin-left: 20px;
            text-transform: uppercase; letter-spacing: 1.5px;
        }

        /* New Style for Greeting in Cart Header */
        .user-greeting { margin-left: 20px; color: white; font-weight: bold; font-size: 14px; }

        /* UPDATED CART LAYOUT */
        .cart-wrapper {
            display: flex; gap: 40px; max-width: 1200px;
            margin: 60px auto; padding: 0 20px; align-items: flex-start;
        }
        .items-column { flex: 3; }
        .summary-column { flex: 2; position: sticky; top: 120px; }

        /* KUIH-CARD */
        .kuih-card {
            background: var(--warm-white); border-radius: 12px; padding: 30px;
            margin-bottom: 25px; box-shadow: 0 10px 25px var(--warm-shadow);
            display: grid; grid-template-columns: 220px 1fr auto; gap: 30px; align-items: center;
            border: 1px solid rgba(185, 124, 90, 0.1);
        }
        .kuih-card img { width: 220px; height: 220px; object-fit: cover; border-radius: 12px; }
        .item-info h3 {
            margin: 0; color: var(--espresso); font-family: 'Playfair Display', serif;
            font-size: 22px; text-transform: uppercase; letter-spacing: 0.5px;
        }

        /* PILL QUANTITY SELECTOR */
        .qty-pill {
            display: flex; align-items: center; background: #fdfaf5; border: 1.5px solid #efe5d9;
            border-radius: 50px; width: fit-content; margin-top: 20px; padding: 8px 20px;
        }
        .qty-btn { background: none; border: none; font-size: 22px; color: var(--clay-orange); cursor: pointer; text-decoration: none; padding: 0 12px; font-weight: bold; }
        .qty-val { font-weight: bold; margin: 0 15px; color: var(--espresso); font-size: 18px; }

        /* TRASH BUTTON */
        .trash-btn {
            border: 2.5px solid #ddd; border-radius: 50%; width: 45px; height: 45px;
            display: flex; align-items: center; justify-content: center;
            color: #888; text-decoration: none; font-size: 20px; transition: 0.3s;
        }
        .trash-btn:hover { background: #fee; border-color: #c62828; color: #c62828; }

        /* SUMMARY BOX */
        .summary-box {
            background: var(--warm-white); padding: 40px; border-radius: 15px;
            box-shadow: 0 15px 40px var(--warm-shadow); border: 1px solid rgba(185, 124, 90, 0.1);
        }
        .summary-box h3 {
            font-family: 'Playfair Display', serif; font-size: 28px;
            margin-top: 0; color: var(--espresso);
        }

        .total-row {
            display: flex; justify-content: space-between;
            font-size: 32px; font-weight: bold; color: var(--clay-orange);
            margin: 25px 0; font-family: 'Playfair Display', serif;
        }

        .btn-checkout {
            width: 100%;
            padding: 18px;
            background-color: var(--clay-orange);
            color: white;
            border: none;
            border-radius: 50px;
            font-weight: bold;
            font-size: 18px;
            cursor: pointer;
            transition: 0.3s;
            text-transform: uppercase;
            letter-spacing: 2px;
            box-shadow: 0 8px 20px rgba(185, 124, 90, 0.3);
        }
        .btn-checkout:hover { background-color: var(--clay-dark); transform: translateY(-3px); box-shadow: 0 12px 25px rgba(185, 124, 90, 0.4); }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="index.html" class="logo">KUIH TO YOU</a>
        <nav class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="all_menu.jsp">Menu</a>
            <a href="viewCart.jsp">🛒  Cart (<%= totalItems %>)</a>

            <%-- MEMBER 3: Greeting and Logout --%>
            <% if (userName != null) { %>
            <span class="user-greeting">Hi, <%= userName %>!</span>
            <a href="logout-action" style="color: white; background: rgba(255,255,255,0.2); padding: 5px 15px; border-radius: 20px; font-size: 12px;">Logout</a>
            <% } else { %>
            <a href="login.html">Sign In</a>
            <% } %>
        </nav>
    </div>
</header>

<div class="cart-wrapper">
    <div class="items-column">
        <h2 style="font-family: 'Playfair Display', serif; color: var(--espresso); margin-bottom: 25px; font-size: 36px;">Review Your Cart</h2>
        <%
            double grandTotal = 0;
            if (cartList == null || cartList.isEmpty()) {
        %>
        <div class="kuih-card" style="display: block; text-align: center; padding: 80px;">
            <p style="font-size: 22px; font-family: 'Playfair Display', serif;">Your Cart is empty.</p>
            <a href="menu.jsp" style="color: var(--clay-orange); font-weight: bold; font-size: 18px; text-decoration: underline;">Start Ordering Now</a>
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
                    <a href="RemoveFromCart?kuihId=<%= item.getKuih().getId() %>" class="qty-btn">-</a>
                    <span class="qty-val"><%= item.getQuantity() %></span>
                    <form action="AddToCart" method="POST" style="display:inline; margin:0;">
                        <input type="hidden" name="kuihId" value="<%= item.getKuih().getId() %>">
                        <input type="hidden" name="quantity" value="1">
                        <input type="hidden" name="source" value="cart">
                        <button type="submit" class="qty-btn" style="margin-top: -4px;">+</button>
                    </form>
                </div>
            </div>

            <div style="display: flex; flex-direction: column; justify-content: space-between; align-items: flex-end; height: 100%; min-height: 220px;">
                <span style="font-weight: bold; font-size: 24px; color: var(--espresso);">RM <%= String.format("%.2f", subtotal) %></span>
                <a href="RemoveFromCart?kuihId=<%= item.getKuih().getId() %>&action=clearRow"
                   class="trash-btn" onclick="return confirm('Remove this item from your cart?')">🗑️</a>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>

    <div class="summary-column">
        <div class="summary-box">
            <h3 style="margin-bottom: 10px; width: 100%;">Order Summary</h3>

            <hr style="border: 0; border-top: 1.5px solid #efe5d9; margin: 25px 0;">

            <div class="total-row">
                <span>Total</span>
                <span>RM <%= String.format("%.2f", grandTotal) %></span>
            </div>

            <%-- MEMBER 3: Form submission to CheckoutServlet --%>
            <form action="CheckoutServlet" method="POST">
                <button type="submit" class="btn-checkout" <%= (cartList == null || cartList.isEmpty()) ? "disabled style='background: #ccc; cursor: not-allowed; box-shadow: none;'" : "" %>>
                    Confirm Order
                </button>
            </form>

            <div style="margin-top: 25px; display: flex; flex-direction: column; gap: 15px;">
                <a href="menu.jsp" style="text-decoration: none; color: #666; font-size: 16px; font-weight: 600;">
                    ← Continue Browsing
                </a>
                <a href="RemoveFromCart?action=clearCart"
                   style="color: #c62828; font-size: 16px; text-decoration: underline; font-weight: bold;"
                   onclick="return confirm('Empty entire box?')">
                    Empty Entire Cart
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>