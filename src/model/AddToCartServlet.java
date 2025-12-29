package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/AddToCart")
public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. SECURITY GATE: Check if user is logged in first
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null) {
            response.sendRedirect("login.html");
            return;
        }

        // 2. Capture the quantity and the redirection source
        String id = request.getParameter("kuihId");
        String source = request.getParameter("source"); // Capture the page source

        int quantityToAdd = 1;
        try {
            String qtyStr = request.getParameter("quantity");
            if (qtyStr != null) {
                quantityToAdd = Integer.parseInt(qtyStr);
            }
        } catch (NumberFormatException e) {
            quantityToAdd = 1;
        }

        // 3. Manage the cart list in the session
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // 4. Find the Kuih details
        Kuih selectedKuih = findKuihById(id);

        // 5. Add to cart logic
        if (selectedKuih != null) {
            boolean found = false;
            for (CartItem item : cart) {
                if (item.getKuih().getId().equals(id)) {
                    item.setQuantity(item.getQuantity() + quantityToAdd);
                    found = true;
                    break;
                }
            }

            if (!found) {
                cart.add(new CartItem(selectedKuih, quantityToAdd));
            }
        }

        // 6. Save back to session
        session.setAttribute("cart", cart);

        // 7. SMART REDIRECT
        if ("cart".equals(source)) {
            // Stay in the cart if the '+' button was clicked there
            response.sendRedirect("viewCart.jsp");
        } else {
            // Go back to the menu if adding from the main shop
            response.sendRedirect("menu.jsp?status=added");
        }
    }

    private Kuih findKuihById(String id) {
        List<Kuih> allKuih = util.DataHandler.readFromFile(getServletContext());
        for (Kuih k : allKuih) {
            if (k.getId().equals(id)) {
                return k;
            }
        }
        return null;
    }
}