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

    // Helper method to check if the user is a logged-in admin
    private boolean isAuthorized(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        // This checks if a session exists AND if the "userRole" attribute is "admin"
        return (session != null && "admin".equals(session.getAttribute("userRole")));
    }

    // 1. READ: This sends the list to your table when the page loads
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // --- SECURITY CHECK START ---
        if (!isAuthorized(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // Send 401 Error
            response.getWriter().write("{\"error\": \"Unauthorized access. Please login as admin.\"}");
            return;
        }
        // --- SECURITY CHECK END ---

        List<Kuih> list = util.DataHandler.readFromFile();

        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < list.size(); i++) {
            model.Kuih k = list.get(i);
            json.append("{");
            json.append("\"id\":").append(k.getId()).append(",");
            json.append("\"name\":\"").append(k.getName()).append("\",");
            json.append("\"price\":").append(k.getPrice()).append(",");
            json.append("\"stock\":").append(k.getStock());
            json.append("}");
            if (i < list.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }

    // 2. CREATE, UPDATE, DELETE: This handles all changes
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // --- SECURITY CHECK START ---
        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        // --- SECURITY CHECK END ---

        String action = request.getParameter("action");
        List<Kuih> list = DataHandler.readFromFile();

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");

            if (name != null && priceStr != null && stockStr != null) {
                double price = Double.parseDouble(priceStr);
                int stock = Integer.parseInt(stockStr);

                int newId = list.isEmpty() ? 1 : list.get(list.size() - 1).getId() + 1;
                list.add(new Kuih(newId, name, price, stock));
            }

        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            for (Kuih k : list) {
                if (k.getId() == id) {
                    k.setName(request.getParameter("name"));
                    k.setPrice(Double.parseDouble(request.getParameter("price")));
                    k.setStock(Integer.parseInt(request.getParameter("stock")));
                    break;
                }
            }
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                list.removeIf(k -> k.getId() == id);
            }
        }

        DataHandler.saveToFile(list);
    }
}