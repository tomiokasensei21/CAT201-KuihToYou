package util;

import model.Kuih;
import java.io.*;
import java.util.*;

public class DataHandler {
    // TIP: Use a simple name. Tomcat looks in the 'bin' folder by default.
    private static final String FILE_PATH = "C:/Users/LENOVO/IdeaProjects/CAT201-KuihToYou/data/kuih.txt";

    // READ FROM TXT
    public static List<Kuih> readFromFile() {
        List<Kuih> list = new ArrayList<>();
        File file = new File(FILE_PATH);

        if (!file.exists()) return list; // Return empty list if file isn't there yet

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length == 4) {
                    list.add(new Kuih(
                            Integer.parseInt(parts[0]),
                            parts[1],
                            Double.parseDouble(parts[2]),
                            Integer.parseInt(parts[3])
                    ));
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return list;
    }

    // SAVE TO TXT
    public static void saveToFile(List<Kuih> list) {
        try (PrintWriter out = new PrintWriter(new FileWriter(FILE_PATH))) {
            for (Kuih k : list) {
                out.println(k.getId() + "," + k.getName() + "," + k.getPrice() + "," + k.getStock());
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}