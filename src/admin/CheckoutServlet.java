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

        // 2. Security Check: Must be logged in and have items
        if (user != null && cart != null && !cart.isEmpty()) {

            // 3. Save to orders.txt
            OrderManager.saveOrder(user, cart, getServletContext());

            // 4. Clear the cart session after successful order
            session.removeAttribute("cart");

            // 5. Redirect to menu with success message
            response.sendRedirect("menu.jsp?status=order_success");
        } else {
            // If not logged in, send to login page
            response.sendRedirect("login.html?error=must_login");
        }
    }
}