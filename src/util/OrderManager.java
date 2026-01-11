package util;

import java.io.*;
import java.util.*;
import jakarta.servlet.ServletContext;
import model.CartItem;

public class OrderManager {

    // UPDATED: Standardized method to include delivery and contact details
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
            out.println("Customer  : " + username);
            out.println("Date      : " + new Date());

            // 1. Log Method & Contact Info
            String displayMethod = (method != null) ? method.toUpperCase() : "PICKUP";
            out.println("Method    : " + displayMethod);

            if ("delivery".equalsIgnoreCase(method)) {
                out.println("Phone     : " + (phone != null ? phone : "N/A"));
                out.println("Address   : " + (address != null ? address.replace("\n", " ") : "N/A"));
            } else {
                out.println("Location  : Self-Pickup at HQ");
            }

            out.println("Items     :");
            double itemsSubtotal = 0;
            for (CartItem item : cart) {
                String name = item.getKuih().getName();
                int qty = item.getQuantity();
                double price = item.getKuih().getPrice();
                double subtotal = price * qty;

                out.println("  - " + String.format("%-20s", name) + " (x" + qty + ") : RM " + String.format("%.2f", subtotal));
                itemsSubtotal += subtotal;
            }

            // 2. Logic for Delivery Fee calculation in text file
            double finalTotal = itemsSubtotal;
            if ("delivery".equalsIgnoreCase(method)) {
                out.println("Service   : Delivery Fee (+RM 5.00)");
                finalTotal += 5.00;
            }

            out.println("GRAND TOTAL: RM " + String.format("%.2f", finalTotal));
            out.println("--------------------------------");
            out.flush();

            System.out.println("SUCCESS: Order logged for " + username + " via " + displayMethod);
        } catch (IOException e) {
            System.err.println("ERROR: Could not save order history: " + e.getMessage());
        }
    }
}