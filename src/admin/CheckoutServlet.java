package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

import model.CartItem;
import util.OrderManager;

public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // 1. Get user and cart from session
        String user = (String) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        // 2. Security check
        if (user != null && cart != null && !cart.isEmpty()) {

            // 3. Save order to file (Order object logically exists here)
            OrderManager.saveOrder(user, cart, getServletContext());

            // ===== GUI DATA (REQUIRED BY CAPTAIN) =====
            session.setAttribute("orderUser", user);
            session.setAttribute("orderItems", cart);

            double totalPrice = 0;
            for (CartItem item : cart) {
                totalPrice += item.getKuih().getPrice() * item.getQuantity();
            }
            session.setAttribute("orderTotal", totalPrice);
            // ========================================

            // 4. Clear cart after order
            session.removeAttribute("cart");

            // 5. Redirect to home page for confirmation GUI
            response.sendRedirect("index.jsp?status=order_success");

        } else {
            // Not logged in or empty cart
            response.sendRedirect("login.html?error=must_login");
        }
    }
}