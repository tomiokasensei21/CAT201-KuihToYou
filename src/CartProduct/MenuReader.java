package CartProduct;

import java.io.File;
import java.util.ArrayList;
import java.util.Scanner;

public class MenuReader {
    public ArrayList<Product> getMenuObjects() {
        ArrayList<Product> menuList = new ArrayList<>();
        try {
            File myFile = new File("products.txt");
            Scanner reader = new Scanner(myFile);
            while (reader.hasNextLine()) {
                String[] data = reader.nextLine().split(",");
                // Create object: ID, Name, Price, Image, Qty (default 1)
                Product p = new Product(data[0], data[1], Double.parseDouble(data[2]), data[3], 1);
                menuList.add(p);
            }
            reader.close();
        } catch (Exception e) {
            System.out.println("Error loading menu: " + e.getMessage());
        }
        return menuList;
    }

    }




