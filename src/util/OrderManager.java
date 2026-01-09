package util;

import java.io.*;
import java.util.*;
import jakarta.servlet.ServletContext;
import model.CartItem;

public class OrderManager {
    public static void saveOrder(String username, List<CartItem> cart, ServletContext context) {
        // Use the context to find the 'data' folder in your deployment
        String filePath = context.getRealPath("/data/orders.txt");

        // Fallback for SmartTomcat path issues
        if (filePath == null) {
            filePath = "orders.txt";
        }

        File file = new File(filePath);

        // Ensure the data directory exists
        if (file.getParentFile() != null && !file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        try (PrintWriter out = new PrintWriter(new FileWriter(file, true))) {
            out.println("=== NEW ORDER ===");
            out.println("Customer: " + username);
            out.println("Date: " + new Date());

            double grandTotal = 0;
            for (CartItem item : cart) {
                String name = item.getKuih().getName();
                int qty = item.getQuantity();
                double price = item.getKuih().getPrice();
                double subtotal = price * qty;

                out.println("- " + name + " (x" + qty + ") : RM " + String.format("%.2f", subtotal));
                grandTotal += subtotal;
            }

            out.println("GRAND TOTAL: RM " + String.format("%.2f", grandTotal));
            out.println("--------------------------------");
            out.flush();
            System.out.println("MEMBER 3 SUCCESS: Order saved to " + filePath);
        } catch (IOException e) {
            System.err.println("MEMBER 3 ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }
}