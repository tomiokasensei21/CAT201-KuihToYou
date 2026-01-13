package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Kuih;
import util.DataHandler;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/admin-api")
public class AdminServlet extends HttpServlet {

    private boolean isAuthorized(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null && "admin".equals(session.getAttribute("userRole")));
    }

    /**
     * READ: Fetches the menu AND available images
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (!isAuthorized(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\": \"Unauthorized access.\"}");
            return;
        }

        // 1. Get Product List
        List<Kuih> list = DataHandler.readFromFile(getServletContext());

        // 2. Get Available Images from folder
        String imageFolderPath = getServletContext().getRealPath("/KuihMuihImage");
        File folder = new File(imageFolderPath);
        String[] imageFiles = folder.list((dir, name) ->
                name.toLowerCase().endsWith(".jpg") ||
                        name.toLowerCase().endsWith(".png") ||
                        name.toLowerCase().endsWith(".jpeg")
        );
        if (imageFiles == null) imageFiles = new String[0];

        // 3. Build Wrapped JSON Response
        StringBuilder json = new StringBuilder();
        json.append("{");

        // Part A: Products
        json.append("\"products\": [");
        for (int i = 0; i < list.size(); i++) {
            Kuih k = list.get(i);
            json.append("{");
            json.append("\"id\":\"").append(k.getId()).append("\",");
            json.append("\"name\":\"").append(k.getName()).append("\",");
            json.append("\"price\":").append(k.getPrice()).append(",");
            json.append("\"image\":\"").append(k.getImageFile()).append("\",");
            json.append("\"stock\":").append(k.getStock());
            json.append("}");
            if (i < list.size() - 1) json.append(",");
        }
        json.append("],");

        // Part B: Available Images
        json.append("\"images\": [");
        for (int i = 0; i < imageFiles.length; i++) {
            json.append("\"").append(imageFiles[i]).append("\"");
            if (i < imageFiles.length - 1) json.append(",");
        }
        json.append("]");

        json.append("}");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // ... (Keep your existing doPost logic exactly as it is) ...
        // It already reads the "image" parameter, which will now come from the dropdown.

        if (!isAuthorized(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        List<Kuih> list = DataHandler.readFromFile(getServletContext());

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");
            String image = request.getParameter("image");
            String stockStr = request.getParameter("stock");

            if (name != null && priceStr != null && image != null) {
                double price = Double.parseDouble(priceStr);
                int stock = Integer.parseInt(stockStr);
                String newId = "K" + System.currentTimeMillis();
                list.add(new Kuih(newId, name, price, image, stock));
            }
        } else if ("update".equals(action)) {
            String id = request.getParameter("id");
            String newImage = request.getParameter("image");

            for (Kuih k : list) {
                if (k.getId().equals(id)) {
                    k.setName(request.getParameter("name"));
                    k.setPrice(Double.parseDouble(request.getParameter("price")));
                    k.setStock(Integer.parseInt(request.getParameter("stock")));
                    if (newImage != null && !newImage.trim().isEmpty()) {
                        k.setImageFile(newImage.trim());
                    }
                    break;
                }
            }
        } else if ("delete".equals(action)) {
            String id = request.getParameter("id");
            if (id != null) {
                list.removeIf(k -> k.getId().equals(id));
            }
        }

        DataHandler.saveToFile(list, getServletContext());
        response.sendRedirect("admin_dashboard.jsp?status=updated");
    }
}