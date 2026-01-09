package model;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Iterator;

@WebServlet("/RemoveFromCart")
public class RemoveFromCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        String id = request.getParameter("kuihId");
        String action = request.getParameter("action"); // 'clearRow' or 'clearCart'

        if (cart != null) {
            // Clear the entire cart
            if ("clearCart".equals(action)) {
                cart.clear();

            }
            // Remove specific items
            else if (id != null) {
                Iterator<CartItem> iterator = cart.iterator();
                while (iterator.hasNext()) {
                    CartItem item = iterator.next();
                    if (item.getKuih().getId().equals(id)) {

                        // If 'clearRow', remove the item regardless of quantity
                        if ("clearRow".equals(action)) {
                            iterator.remove();
                        }
                        // Otherwise,decrease quantity by 1
                        else {
                            item.setQuantity(item.getQuantity() - 1);
                            if (item.getQuantity() <= 0) {
                                iterator.remove();
                            }
                        }
                        break;
                    }
                }
            }
        }

        session.setAttribute("cart", cart);
        response.sendRedirect("viewCart.jsp");
    }
}
