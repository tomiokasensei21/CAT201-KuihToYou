package model;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import util.DataHandler;
import util.OrderManager;

public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        String user = (String) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        // 1. Get delivery data from request
        String method = request.getParameter("method");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        // 2. Default values if Pickup is selected (to avoid nulls in your database/file)
        if ("pickup".equals(method)) {
            address = "N/A (Self-Pickup)";
            phone = "N/A (Self-Pickup)";
        }

        if (user != null && cart != null && !cart.isEmpty()) {

            // 3. Update Stock Logic
            List<Kuih> allKuih = DataHandler.readFromFile(getServletContext());
            if (allKuih != null) {
                for (CartItem itemInCart : cart) {
                    for (Kuih product : allKuih) {
                        if (product.getId().equals(itemInCart.getKuih().getId())) {
                            int newStock = product.getStock() - itemInCart.getQuantity();
                            product.setStock(Math.max(0, newStock));
                        }
                    }
                }
                DataHandler.saveToFile(allKuih, getServletContext());
            }

            // 4. Calculate Total and Apply Delivery Fee
            double totalPrice = 0;
            for (CartItem item : cart) {
                totalPrice += item.getKuih().getPrice() * item.getQuantity();
            }

            if ("delivery".equals(method)) {
                totalPrice += 5.00;
            }

            // 5. Save Order with Delivery Info
            // Ensure your OrderManager.saveOrder method is updated to accept these parameters
            OrderManager.saveOrder(user, method, address, phone, cart, getServletContext());

            // 6. Set Session Attributes for Receipt Generation in index.jsp
            session.setAttribute("orderUser", user);
            session.setAttribute("orderItems", new ArrayList<>(cart));
            session.setAttribute("orderTotal", totalPrice);

            // 7. Cleanup and Redirect
            session.removeAttribute("cart");
            response.sendRedirect("index.jsp?status=order_success");

        } else {
            response.sendRedirect("login.html?error=must_login");
        }
    }
}