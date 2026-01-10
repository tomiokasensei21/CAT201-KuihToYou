package util;

import java.io.*;
import java.util.*;
import jakarta.servlet.ServletContext;
import model.CartItem;

public class OrderManager {
    // UPDATED: Added method, address, and phone parameters
    public static void saveOrder(String username, String method, String address, String phone, List<CartItem> cart, ServletContext context) {
        String filePath = context.getRealPath("/data/orders.txt");

        if (filePath == null) {
            filePath = context.getRealPath("/") + "data" + File.separator + "orders.txt";
        }

        File file = new File(filePath);
        if (file.getParentFile() != null && !file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        try (PrintWriter out = new PrintWriter(new FileWriter(file, true))) {
            out.println("=== NEW ORDER ===");
            out.println("Customer: " + username);
            out.println("Date: " + new Date());

            // NEW: Log Delivery Details
            out.println("Method: " + (method != null ? method.toUpperCase() : "PICKUP"));
            if ("delivery".equals(method)) {
                out.println("Phone: " + phone);
                out.println("Address: " + address);
            }

            double grandTotal = 0;
            for (CartItem item : cart) {
                String name = item.getKuih().getName();
                int qty = item.getQuantity();
                double price = item.getKuih().getPrice();
                double subtotal = price * qty;

                out.println("- " + name + " (x" + qty + ") : RM " + String.format("%.2f", subtotal));
                grandTotal += subtotal;
            }

            // NEW: Add delivery fee to the grand total in the file
            if ("delivery".equals(method)) {
                out.println("Delivery Fee: RM 5.00");
                grandTotal += 5.00;
            }

            out.println("GRAND TOTAL: RM " + String.format("%.2f", grandTotal));
            out.println("--------------------------------");
            out.flush();
            System.out.println("SUCCESS: Order logged in " + filePath);
        } catch (IOException e) {
            System.err.println("ERROR: Could not save order history: " + e.getMessage());
        }
    }
}