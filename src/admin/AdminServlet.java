package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Kuih;
import util.DataHandler; // This is the utility class we discussed

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-api")
public class AdminServlet extends HttpServlet {

    // 1. READ: This sends the list to your table when the page loads
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Get the list from your .txt file via DataHandler
        List<Kuih> list = util.DataHandler.readFromFile();

        // Manually construct the JSON string
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

        // Send it back to your HTML dashboard
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }

    // 2. CREATE, UPDATE, DELETE: This handles all changes
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String action = request.getParameter("action");
        List<Kuih> list = DataHandler.readFromFile();

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String stockStr = request.getParameter("stock");

            if (name != null && priceStr != null && stockStr != null) {
                double price = Double.parseDouble(priceStr);
                int stock = Integer.parseInt(stockStr);

                // FIX: Use list.get(list.size() - 1) instead of getLast() for older Java versions
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

        // Save the updated list back to the .txt file
        DataHandler.saveToFile(list);
    }
}