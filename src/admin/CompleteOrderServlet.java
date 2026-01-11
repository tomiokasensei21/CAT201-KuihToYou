package admin;

import java.io.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet("/complete-order")
public class CompleteOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String customerName = request.getParameter("customer");
        String orderDate = request.getParameter("date");

        if (customerName == null || orderDate == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        String filePath = getServletContext().getRealPath("/data/orders.txt");
        File inputFile = new File(filePath);

        // Ensure the directory exists
        if (!inputFile.exists()) {
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        File tempFile = new File(inputFile.getAbsolutePath() + ".tmp");

        try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
             BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {

            String line;
            List<String> currentOrderBlock = new ArrayList<>();

            while ((line = reader.readLine()) != null) {
                // If we hit a new order marker, process the previous block
                if (line.startsWith("=== NEW ORDER ===")) {
                    processAndWriteBlock(writer, currentOrderBlock, customerName, orderDate);
                    currentOrderBlock.clear();
                }
                currentOrderBlock.add(line);
            }
            // Process the final block in the file
            processAndWriteBlock(writer, currentOrderBlock, customerName, orderDate);
        }

        // Atomic swap of files
        if (inputFile.delete()) {
            if (!tempFile.renameTo(inputFile)) {
                throw new IOException("Could not rename temporary file to orders.txt");
            }
        } else {
            throw new IOException("Could not delete original orders.txt");
        }

        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void processAndWriteBlock(BufferedWriter writer, List<String> block, String targetName, String targetDate) throws IOException {
        if (block.isEmpty()) return;

        boolean matchesName = false;
        boolean matchesDate = false;

        // Strict checking within the block
        for (String line : block) {
            if (line.trim().equals("Customer: " + targetName)) matchesName = true;
            if (line.trim().equals("Date: " + targetDate)) matchesDate = true;
        }

        // If it's NOT the order we want to complete, write it back to the file
        if (!(matchesName && matchesDate)) {
            for (String line : block) {
                writer.write(line);
                writer.newLine();
            }
        }
    }
}