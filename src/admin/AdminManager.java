package admin;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

public class AdminManager {
    // Path to the file where kuih data is saved
    private static final String FILE_PATH = "data/products.txt";

    // Method to add a new Kuih to the inventory
    public void addKuih(String name, double price, int stock) {
        try (FileWriter fw = new FileWriter(FILE_PATH, true);
             BufferedWriter bw = new BufferedWriter(fw)) {
            
            // Saving as: Name,Price,Stock
            bw.write(name + "," + price + "," + stock);
            bw.newLine();
            System.out.println("Success: " + name + " added to inventory.");
            
        } catch (IOException e) {
            System.err.println("Error: Could not save data. " + e.getMessage());
        }
    }
}