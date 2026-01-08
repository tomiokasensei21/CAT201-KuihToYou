package util;

import model.Kuih;
import java.io.*;
import java.util.*;
import jakarta.servlet.ServletContext;

public class DataHandler {
    // Changed file name to products.txt
    private static final String FILE_NAME = "products.txt";
    private static final String DATA_FOLDER = "data";

    // READ FROM TXT
    public static List<Kuih> readFromFile(ServletContext context) {
        List<Kuih> list = new ArrayList<>();
        // This creates a path relative to your webapp folder
        String filePath = context.getRealPath("/data/products.txt");
        File file = new File(filePath);

        if (!file.exists()) return list;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                // Matching the 5-field merged Kuih model (ID, Name, Price, Image, Stock)
                if (parts.length == 5) {
                    list.add(new Kuih(
                            parts[0].trim(),           // ID (String)
                            parts[1].trim(),           // Name
                            Double.parseDouble(parts[2].trim()), // Price
                            parts[3].trim(),           // imageFile
                            Integer.parseInt(parts[4].trim())    // Stock
                    ));
                }
            }
        } catch (IOException | NumberFormatException e) {
            e.printStackTrace();
        }
        return list;
    }

    // SAVE TO TXT
    public static void saveToFile(List<Kuih> list, ServletContext context) {
        String filePath = context.getRealPath("/") + DATA_FOLDER + File.separator + FILE_NAME;
        try (PrintWriter out = new PrintWriter(new FileWriter(filePath))) {
            for (Kuih k : list) {
                out.println(k.getId() + "," + k.getName() + "," + k.getPrice() + "," + k.getImageFile() + "," + k.getStock());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}