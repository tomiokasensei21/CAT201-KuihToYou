package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Kuih;
import util.DataHandler;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-api")
public class AdminServlet extends HttpServlet {

    private boolean isAuthorized(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null && "admin".equals(session.getAttribute("userRole")));
    }

    // 1. READ: Fixed with getServletContext() and 5-field JSON
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isAuthorized(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized access.\"}");
            return;
        }

        // FIX: Added getServletContext()
        List<Kuih> list = DataHandler.readFromFile(getServletContext());

        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < list.size(); i++) {
            Kuih k = list.get(i);
            json.append("{");
            json.append("\"id\":\"").append(k.getId()).append("\","); // ID is String
            json.append("\"name\":\"").append(k.getName()).append("\",");
            json.append("\"price\":").append(k.getPrice()).append(",");
            json.append("\"image\":\"").append(k.getImageFile()).append("\","); // Added Image
            json.append("\"stock\":").append(k.getStock());
            json.append("}");
            if (i < list.size() - 1) json.append(",");
        }
        json.append("]");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }

    // 2. CREATE, UPDATE, DELETE: Fixed parameters and Kuih constructor
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        // FIX: Added getServletContext()
        List<Kuih> list = DataHandler.readFromFile(getServletContext());

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String image = request.getParameter("image"); // Added image parameter
            String stockStr = request.getParameter("stock");

            if (name != null && priceStr != null && stockStr != null) {
                double price = Double.parseDouble(priceStr);
                int stock = Integer.parseInt(stockStr);
                String imgFile = (image == null || image.isEmpty()) ? "default.jpg" : image;

                // FIX: Use String ID and the 5-parameter constructor
                String newId = "K" + (list.size() + 1);
                list.add(new Kuih(newId, name, price, imgFile, stock));
            }

        } else if ("update".equals(action)) {
            String id = request.getParameter("id"); // ID is now String
            for (Kuih k : list) {
                if (k.getId().equals(id)) { // Use .equals() for String comparison
                    k.setName(request.getParameter("name"));
                    k.setPrice(Double.parseDouble(request.getParameter("price")));
                    k.setStock(Integer.parseInt(request.getParameter("stock")));
                    // Option to update image if needed:
                    if(request.getParameter("image") != null) k.setStock(Integer.parseInt(request.getParameter("stock")));
                    break;
                }
            }
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            if (id != null) {
                list.removeIf(k -> k.getId().equals(id)); // String comparison
            }
        }

        // FIX: Added getServletContext()
        DataHandler.saveToFile(list, getServletContext());
        response.sendRedirect("admin_dashboard.html"); // Redirect back after action
    }
}