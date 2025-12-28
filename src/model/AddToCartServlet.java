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
        // We check for "userRole" based on your AdminServlet authorization logic
        if (session.getAttribute("userRole") == null) {
            // If not logged in, redirect to login page
            response.sendRedirect("login.html");
            return; // Crucial: This stops the rest of the code from running
        }

        // 2. ONLY RUNS IF LOGGED IN: Capture the quantity
        String id = request.getParameter("kuihId");
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

        // 4. Find the Kuih details using DataHandler
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

        // 6. Save and stay on menu
        session.setAttribute("cart", cart);
        response.sendRedirect("menu.jsp?status=added");
    }

    private Kuih findKuihById(String id) {
        // Reads from products.txt using the context
        List<Kuih> allKuih = util.DataHandler.readFromFile(getServletContext());

        for (Kuih k : allKuih) {
            if (k.getId().equals(id)) {
                return k;
            }
        }
        return null;
    }
}
