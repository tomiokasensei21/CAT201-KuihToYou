package util;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Kuih;
import java.io.IOException;
import java.util.List;

@WebServlet("/GetProducts") // This must match the fetch() in your index.html
public class GetProductsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve the list using existing DataHandler
        List<Kuih> allKuih = DataHandler.readFromFile(getServletContext());

        // Build the JSON string manually
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < allKuih.size(); i++) {
            Kuih k = allKuih.get(i);
            json.append("{")
                    .append("\"id\":\"").append(k.getId()).append("\",")
                    .append("\"name\":\"").append(k.getName()).append("\",")
                    .append("\"price\":").append(k.getPrice()).append(",")
                    .append("\"image\":\"").append(k.getImageFile()).append("\"")
                    .append("}");

            if (i < allKuih.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        //  Set the correct headers so the browser knows this is JSON data
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());

    }
}