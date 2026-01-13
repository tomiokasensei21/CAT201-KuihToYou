<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.io.*, java.util.*" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    if (!"admin".equals(userRole)) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Queue - Kuih To You</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:wght@400;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --clay-orange: #b97c5a;
            --clay-dark: #a06648;
            --espresso: #4a2c2a;
            --parchment-bg: #f3ece0;
            --warm-white: #fffcf7;
            --warm-shadow: rgba(74, 44, 42, 0.18);
        }

        body {
            margin: 0; font-family: 'Lora', serif; background-color: var(--parchment-bg);
            background-image: linear-gradient(rgba(243, 236, 224, 0.85), rgba(243, 236, 224, 0.85)), url('KuihMuihImage/batik_pattern.jpg');
            background-repeat: repeat; background-size: 350px; background-attachment: fixed;
            color: var(--espresso);
        }

        header {
            background-color: var(--clay-orange);
            box-shadow: 0 4px 15px rgba(74, 44, 42, 0.25);
            position: sticky; top: 0; z-index: 1000;
        }
        .nav-container { max-width: 1200px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; height: 70px; }
        .logo-img { height: 45px; transition: transform 0.3s ease; }
        .logo-img:hover { transform: scale(1.05); }

        .nav-actions { display: flex; align-items: center; gap: 20px; }
        .nav-link { color: white; text-decoration: none; font-weight: 600; font-size: 14px; transition: 0.3s; position: relative; }
        .nav-link::after {
            content: ''; position: absolute; width: 0; height: 2px; bottom: -5px; left: 0;
            background-color: white; transition: width 0.3s;
        }
        .nav-link:hover::after { width: 100%; }

        .btn-pill {
            text-decoration: none; color: white; border: 1.5px solid white;
            padding: 8px 20px; border-radius: 50px; font-size: 12px; font-weight: bold;
            text-transform: uppercase; transition: 0.3s;
        }
        .btn-pill:hover { background: white; color: var(--clay-orange); }

        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        .header-section h1 { font-family: 'Playfair Display', serif; font-size: 42px; margin: 0 0 30px 0; }

        .controls-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 35px; gap: 15px; }
        .search-bar {
            flex: 1; padding: 15px 25px; border-radius: 50px;
            border: 1px solid rgba(185, 124, 90, 0.2); background: var(--warm-white);
            outline: none; font-family: 'Lora'; transition: 0.3s;
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
        }
        .search-bar:focus { border-color: var(--clay-orange); box-shadow: 0 4px 15px var(--warm-shadow); }

        .filter-btn {
            padding: 10px 22px; border-radius: 50px; border: 1px solid var(--clay-orange);
            background: var(--warm-white); color: var(--clay-orange); cursor: pointer;
            font-weight: bold; transition: 0.3s; font-size: 12px; text-transform: uppercase;
        }
        .filter-btn:hover { background: #fdfaf5; transform: translateY(-1px); }
        .filter-btn.active { background: var(--clay-orange); color: white; box-shadow: 0 4px 10px rgba(185, 124, 90, 0.3); }

        .order-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(380px, 1fr)); gap: 30px; }
        .order-card {
            background: var(--warm-white); border-radius: 20px; padding: 25px;
            box-shadow: 0 10px 30px var(--warm-shadow); border-top: 5px solid var(--clay-orange);
            display: flex; flex-direction: column; transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        .order-card:hover { transform: translateY(-8px); box-shadow: 0 15px 45px rgba(74, 44, 42, 0.25); }
        .order-card.hidden { display: none; }

        .method-badge { padding: 5px 14px; border-radius: 50px; font-size: 10px; font-weight: 800; margin-bottom: 12px; align-self: flex-start; text-transform: uppercase; letter-spacing: 0.5px; }
        .delivery-bg { background: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; }
        .pickup-bg { background: #f6ffed; color: #389e0d; border: 1px solid #b7eb8f; }

        .customer-name { font-size: 24px; font-weight: bold; margin-bottom: 4px; color: var(--espresso); }
        .order-date { font-size: 12px; color: #8a7b6f; margin-bottom: 18px; font-style: italic; }

        .receipt-box {
            background: #fff; border: 1px solid #eee; padding: 20px; border-radius: 12px;
            font-family: 'Courier New', Courier, monospace; font-size: 13px; line-height: 1.6;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.02);
        }
        .receipt-item { display: flex; justify-content: space-between; border-bottom: 1px dashed #e0e0e0; padding: 6px 0; }

        .delivery-section { margin-top: 15px; padding-top: 12px; border-top: 1px solid #f0f0f0; font-family: 'Lora'; font-size: 13px; color: #5c4b40; }
        .delivery-section b { color: var(--espresso); }

        .card-footer { display: flex; justify-content: space-between; align-items: center; margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px; }
        .grand-total { font-weight: 800; color: var(--clay-orange); font-size: 22px; }

        .btn-action {
            padding: 10px 20px; border-radius: 50px; cursor: pointer;
            font-size: 11px; font-weight: bold; text-transform: uppercase;
            border: 1px solid #ddd; transition: 0.3s;
        }
        .btn-print { background: white; color: var(--espresso); border-color: #dcd6ce; }
        .btn-print:hover { background: #f8f5f1; border-color: var(--clay-orange); }

        .btn-done { background: var(--clay-orange); color: white; border: none; box-shadow: 0 4px 10px rgba(185, 124, 90, 0.2); }
        .btn-done:hover { background: var(--clay-dark); transform: scale(1.05); }
    </style>
</head>
<body>

<header>
    <div class="nav-container">
        <a href="index.jsp"><img src="KuihMuihImage/kuihtoyoulogo.png" alt="Logo" class="logo-img"></a>
        <div class="nav-actions">
            <a href="index.jsp" class="nav-link">Storefront</a>
            <a href="admin_dashboard.jsp" class="nav-link">Inventory</a>
            <a href="LogoutServlet" class="btn-pill">Logout</a>
        </div>
    </div>
</header>

<div class="container">
    <div class="header-section">
        <h1>Order Fulfillment Queue</h1>
    </div>

    <div class="controls-row">
        <input type="text" id="orderSearch" class="search-bar" placeholder="Search customer name..." onkeyup="filterOrders()">
        <div class="filter-group">
            <button class="filter-btn active" onclick="setFilter('ALL', this)">All Orders</button>
            <button class="filter-btn" onclick="setFilter('DELIVERY', this)">Delivery</button>
            <button class="filter-btn" onclick="setFilter('PICKUP', this)">Pickup</button>
        </div>
    </div>

    <div class="order-grid" id="orderGrid">
        <%
            String path = application.getRealPath("/data/orders.txt");
            File f = new File(path);
            if (f.exists()) {
                try (BufferedReader br = new BufferedReader(new FileReader(f))) {
                    String ln;
                    List<String> itemsList = new ArrayList<>();
                    String cust = "", dt = "", meth = "", ph = "", addr = "", ttl = "";

                    while ((ln = br.readLine()) != null) {
                        ln = ln.trim();
                        if (ln.startsWith("=== NEW ORDER ===")) {
                            itemsList.clear(); cust=dt=meth=ph=addr=ttl="";
                        }
                        else if (ln.contains("Customer")) cust = ln.substring(ln.indexOf(":") + 1).trim();
                        else if (ln.contains("Date")) dt = ln.substring(ln.indexOf(":") + 1).trim();
                        else if (ln.contains("Method")) meth = ln.substring(ln.indexOf(":") + 1).trim();
                        else if (ln.contains("Phone")) ph = ln.substring(ln.indexOf(":") + 1).trim();
                        else if (ln.contains("Address")) addr = ln.substring(ln.indexOf(":") + 1).trim();
                        else if (ln.startsWith("-")) itemsList.add(ln);
                        else if (ln.contains("GRAND TOTAL")) {
                            ttl = ln.substring(ln.indexOf(":") + 1).trim();
                            String safeId = cust.replaceAll("[^a-zA-Z0-9]", "");
        %>
        <div class="order-card" data-method="<%= meth.toUpperCase() %>" data-search="<%= cust.toLowerCase() %>">
            <span class="method-badge <%= meth.equalsIgnoreCase("DELIVERY") ? "delivery-bg" : "pickup-bg" %>">
                <%= meth %>
            </span>
            <div class="customer-name"><%= cust %></div>
            <div class="order-date">Placed on: <%= dt %></div>

            <div class="receipt-box" id="items-<%= safeId %>">
                <div style="font-weight: bold; text-align: center; margin-bottom: 12px; color: #888; letter-spacing: 2px; font-size: 11px;">--- ORDER ITEMS ---</div>
                <% for(String item : itemsList) { %>
                <div class="receipt-item">
                    <span><%= item.replace("-", "").trim() %></span>
                </div>
                <% } %>

                <div class="delivery-section">
                    <div><b>Method:</b> <%= meth %></div>
                    <% if(meth.equalsIgnoreCase("DELIVERY")) { %>
                    <div><b>Phone:</b> <%= ph %></div>
                    <div><b>Address:</b> <%= addr %></div>
                    <% } else { %>
                    <div style="color: #389e0d; font-weight: bold; font-size: 11px; margin-top: 5px;">✓ SELF-PICKUP AT HQ</div>
                    <% } %>
                </div>
            </div>

            <div class="card-footer">
                <div class="grand-total"><%= ttl %></div>
                <div class="action-group" style="display:flex; gap:10px;">
                    <button class="btn-action btn-print" onclick="printReceipt('<%= cust %>','<%= dt %>','<%= meth %>','<%= ph %>','<%= addr %>','<%= ttl %>','items-<%= safeId %>')">Print</button>
                    <button class="btn-action btn-done" onclick="completeOrder(this, '<%= cust %>', '<%= dt %>')">Done</button>
                </div>
            </div>
        </div>
        <%
                        }
                    }
                } catch(Exception e) {}
            }
        %>
    </div>
</div>

<script>
    // Robust Filter Logic
    function setFilter(type, btn) {
        document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        filterOrders();
    }

    function filterOrders() {
        // Get query and trim whitespace
        const query = document.getElementById('orderSearch').value.toLowerCase().trim();

        // Find which filter is active
        const activeBtn = document.querySelector('.filter-btn.active');
        const filterText = activeBtn.innerText.toUpperCase();

        document.querySelectorAll('.order-card').forEach(card => {
            const method = card.getAttribute('data-method') || "";
            const name = card.getAttribute('data-search') || "";

            // Search match
            const matchSearch = name.includes(query);

            // Filter match: If 'ALL' is in the button text, show everything.
            // Otherwise, check if the method (DELIVERY/PICKUP) matches the button text.
            const matchFilter = (filterText.includes('ALL') || filterText.includes(method));

            if (matchSearch && matchFilter) {
                card.style.display = 'flex';
                card.classList.remove('hidden');
            } else {
                card.style.display = 'none';
                card.classList.add('hidden');
            }
        });
    }

    function completeOrder(btn, customer, date) {
        const card = btn.closest('.order-card');
        Swal.fire({
            title: 'Complete Order?',
            text: 'This will archive the order and remove it from the active queue.',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#b97c5a',
            cancelButtonColor: '#4a2c2a',
            confirmButtonText: 'Yes, Done!',
            cancelButtonText: 'Wait',
            timer: 5000,
            timerProgressBar: true
        }).then((result) => {
            if (result.isConfirmed) {
                card.style.opacity = '0.5';
                card.style.pointerEvents = 'none';
                fetch('complete-order', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: `customer=\${encodeURIComponent(customer)}&date=\${encodeURIComponent(date)}`
                }).then(() => {
                    card.style.transform = 'scale(0.9)';
                    setTimeout(() => card.remove(), 300);
                });
            }
        });
    }

    function printReceipt(name, date, method, phone, address, total, itemsId) {
        const itemsHtml = document.getElementById(itemsId).innerHTML;
        const printWindow = window.open('', '_blank');
        printWindow.document.write(`
            <html>
            <head>
                <title>Receipt - \${name}</title>
                <style>
                    body { font-family: 'Courier New', Courier, monospace; width: 300px; padding: 10px; color: #000; }
                    .center { text-align: center; }
                    hr { border: 0; border-top: 1px dashed #000; margin: 10px 0; }
                    .item-line { font-size: 13px; margin: 5px 0; }
                    .total { text-align: right; font-size: 18px; font-weight: bold; margin-top: 15px; }
                </style>
            </head>
            <body>
                <div class="center">
                    <h2 style="margin:0;">KUIH TO YOU</h2>
                    <p style="font-size:12px;">Official Order Receipt</p>
                </div>
                <hr>
                <div style="font-size:12px;">
                    <div><b>Customer:</b> \${name}</div>
                    <div><b>Date:</b> \${date}</div>
                </div>
                <hr>
                \${itemsHtml}
                <hr>
                <div class="total">TOTAL: \${total}</div>
                <div class="center" style="margin-top:20px; font-size:10px;">
                    Thank you for your order!<br>www.kuihtoyou.com
                </div>
                <script>window.print(); setTimeout(() => window.close(), 500);<\/script>
            </body>
            </html>
        `);
        printWindow.document.close();
    }
</script>
</body>
</html>