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

        // NEW: Get delivery data from request
        String method = request.getParameter("method");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        if (user != null && cart != null && !cart.isEmpty()) {

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

            // UPDATED: Passing delivery info to OrderManager
            OrderManager.saveOrder(user, method, address, phone, cart, getServletContext());

            session.setAttribute("orderUser", user);
            session.setAttribute("orderItems", new ArrayList<>(cart));

            double totalPrice = 0;
            for (CartItem item : cart) {
                totalPrice += item.getKuih().getPrice() * item.getQuantity();
            }

            // Add RM 5.00 delivery fee if applicable
            if ("delivery".equals(method)) {
                totalPrice += 5.00;
            }
            session.setAttribute("orderTotal", totalPrice);

            session.removeAttribute("cart");
            response.sendRedirect("index.jsp?status=order_success");

        } else {
            response.sendRedirect("login.html?error=must_login");
        }
    }
}