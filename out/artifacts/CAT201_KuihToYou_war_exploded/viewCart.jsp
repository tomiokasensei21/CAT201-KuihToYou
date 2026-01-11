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

    // 2. Get user and role for greeting and admin access
    String userName = (String) session.getAttribute("user");
    String userRole = (String) session.getAttribute("userRole");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart - Kuih To You</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        :root {
            --clay-orange: #b97c5a;
            --clay-dark: #a06648;
            --parchment-bg: #f3ece0;
            --espresso: #4a2c2a;
            --warm-white: #fffcf7;
            --warm-shadow: rgba(74, 44, 42, 0.18);
        }

        body {
            margin: 0; font-family: 'Lora', serif; background-color: var(--parchment-bg);
            background-image: linear-gradient(rgba(243, 236, 224, 0.85), rgba(243, 236, 224, 0.85)),
            url('${pageContext.request.contextPath}/KuihMuihImage/batik_pattern.jpg');
            background-repeat: repeat; background-size: 350px; background-attachment: fixed;
            color: var(--espresso);
            overflow-x: hidden;
        }

        header {
            background-color: var(--clay-orange);
            box-shadow: 0 4px 15px rgba(74, 44, 42, 0.25);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container {
            max-width: 1200px; margin: 0 auto; display: flex;
            justify-content: space-between; align-items: center; padding: 0 20px;
            height: 70px;
        }
        .logo-wrapper { display: flex; align-items: center; text-decoration: none; }
        .logo-img { height: 45px; width: auto; object-fit: contain; transition: 0.3s; }

        .nav-actions { display: flex; gap: 20px; align-items: center; }
        .nav-actions a, .nav-actions span {
            text-decoration: none; color: white !important; font-weight: 600;
            font-size: 13px; text-transform: uppercase; letter-spacing: 1.5px;
        }

        .user-greeting {
            background: rgba(255, 255, 255, 0.1);
            padding: 5px 12px;
            border-radius: 4px;
            font-size: 12px !important;
        }

        .btn-pill {
            background: rgba(255, 255, 255, 0.2); border: 1.5px solid white;
            padding: 8px 20px; border-radius: 50px; font-size: 12px; transition: 0.3s;
            cursor: pointer;
        }
        .btn-pill:hover { background: white; color: var(--clay-orange) !important; }

        .cart-wrapper {
            display: flex; gap: 40px; max-width: 1200px;
            margin: 60px auto; padding: 0 20px; align-items: flex-start;
        }
        .items-column { flex: 3; }
        .summary-column { flex: 2; position: sticky; top: 120px; }

        .kuih-card {
            background: var(--warm-white); border-radius: 20px; padding: 30px;
            margin-bottom: 25px; box-shadow: 0 10px 25px var(--warm-shadow);
            display: grid; grid-template-columns: 220px 1fr auto; gap: 30px; align-items: center;
        }
        .kuih-card img { width: 220px; height: 220px; object-fit: cover; border-radius: 12px; }
        .item-info h3 {
            margin: 0; color: var(--espresso); font-family: 'Playfair Display', serif;
            font-size: 24px; text-transform: uppercase;
        }

        .qty-pill {
            display: flex; align-items: center; background: #fdfaf5; border: 1.5px solid #efe5d9;
            border-radius: 50px; width: fit-content; margin-top: 20px; padding: 8px 20px;
        }
        .qty-btn { background: none; border: none; font-size: 22px; color: var(--clay-orange); cursor: pointer; text-decoration: none; padding: 0 12px; font-weight: bold; }
        .qty-val { font-weight: bold; margin: 0 15px; color: var(--espresso); font-size: 18px; }

        .trash-btn {
            border: 2px solid #ddd; border-radius: 50%; width: 45px; height: 45px;
            display: flex; align-items: center; justify-content: center;
            color: #888; text-decoration: none; font-size: 20px; transition: 0.3s;
        }
        .trash-btn:hover { background: #fee; border-color: #c62828; color: #c62828; }

        .summary-box {
            background: var(--warm-white); padding: 40px; border-radius: 20px;
            box-shadow: 0 15px 40px var(--warm-shadow);
        }
        .summary-box h3 { font-family: 'Playfair Display', serif; font-size: 28px; margin: 0; color: var(--espresso); }

        .total-row {
            display: flex; justify-content: space-between;
            font-size: 32px; font-weight: bold; color: var(--clay-orange);
            margin: 25px 0; font-family: 'Playfair Display', serif;
        }

        .btn-checkout {
            width: 100%; padding: 18px; background-color: var(--clay-orange);
            color: white; border: none; border-radius: 50px; font-weight: bold;
            font-size: 18px; cursor: pointer; transition: 0.3s;
            text-transform: uppercase; letter-spacing: 2px;
            box-shadow: 0 8px 20px rgba(185, 124, 90, 0.3);
            text-align: center;
            display: block;
            text-decoration: none;
        }
        .btn-checkout:hover:not([disabled]) { background-color: var(--clay-dark); transform: translateY(-3px); }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="index.jsp" class="logo-wrapper">
            <img src="${pageContext.request.contextPath}/KuihMuihImage/kuihtoyoulogo.png" alt="Logo" class="logo-img">
        </a>
        <div class="nav-actions">
            <a href="index.jsp">Home</a>
            <a href="menu.jsp">Menu</a>
            <a href="viewCart.jsp">🛒 Cart (<%= totalItems %>)</a>

            <% if (userName != null) { %>
            <span class="user-greeting">Hi, <%= userName %>!</span>
            <% if ("admin".equals(userRole)) { %>
            <a href="admin_dashboard.jsp" style="color: #ffd700 !important; border-bottom: 1px solid #ffd700;">Admin Panel</a>
            <% } %>
            <a onclick="confirmLogout(event)" class="btn-pill">Logout</a>
            <% } else { %>
            <a href="login.html">Sign In</a>
            <a href="signup.html" class="btn-pill">Sign Up</a>
            <% } %>
        </div>
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
                <h3><%= item.getKuih().getName() %></h3>
                <div class="qty-pill">
                    <a href="RemoveFromCart?kuihId=<%= item.getKuih().getId() %>" class="qty-btn" style="text-decoration: none;">−</a>
                    <span class="qty-val"><%= item.getQuantity() %></span>
                    <form action="AddToCart" method="POST" style="display:inline; margin:0;">
                        <input type="hidden" name="kuihId" value="<%= item.getKuih().getId() %>">
                        <input type="hidden" name="quantity" value="1">
                        <input type="hidden" name="source" value="cart">
                        <button type="submit" class="qty-btn">+</button>
                    </form>
                </div>
            </div>

            <div style="display: flex; flex-direction: column; justify-content: space-between; align-items: flex-end; height: 100%; min-height: 200px;">
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
            <h3>Order Summary</h3>
            <hr style="border: 0; border-top: 1.5px solid #efe5d9; margin: 25px 0;">
            <div class="total-row">
                <span>Total</span>
                <span>RM <%= String.format("%.2f", grandTotal) %></span>
            </div>

            <form action="index.jsp" method="GET">
                <input type="hidden" name="status" value="order_success">
                <button type="submit" class="btn-checkout" <%= (cartList == null || cartList.isEmpty()) ? "disabled style='background: #ccc; cursor: not-allowed; box-shadow: none;'" : "" %>>
                    Next
                </button>
            </form>

            <div style="margin-top: 25px; display: flex; flex-direction: column; gap: 15px;">
                <a href="menu.jsp" style="text-decoration: none; color: #666; font-size: 16px; font-weight: 600;">← Continue Browsing</a>
                <a href="RemoveFromCart?action=clearCart"
                   style="color: #c62828; font-size: 16px; text-decoration: underline; font-weight: bold;"
                   onclick="return confirm('Empty entire box?')">Empty Entire Cart</a>
            </div>
        </div>
    </div>
</div>

<script>
    function confirmLogout(event) {
        event.preventDefault();
        Swal.fire({
            title: 'Logging out?',
            text: "Are you sure you want to leave?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#b97c5a',
            cancelButtonColor: '#4a2c2a',
            confirmButtonText: 'Yes, Logout',
            background: '#fcfaf7'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = 'LogoutServlet';
            }
        });
    }

    document.addEventListener('DOMContentLoaded', function() {
        const params = new URLSearchParams(window.location.search);
        if (params.get('status') === 'logged_out') {
            Swal.fire({
                toast: true, position: 'top-end', icon: 'info',
                title: 'Logged out. See you soon! 👋',
                showConfirmButton: false, timer: 3000, background: '#fcfaf7', iconColor: '#b97c5a'
            });
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    });
</script>
</body>
</html>