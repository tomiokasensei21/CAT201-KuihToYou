package CartProduct;
import java.util.ArrayList;

public class Cart {
    private ArrayList<Product> selectedKuih = new ArrayList<>();

    public void addItem(Product p) {
        selectedKuih.add(p);
        System.out.println(p.getName() + " added to cart!");
    }

    public double getTotal() {
        double total = 0;
        for (Product p : selectedKuih) {
            total += p.getPrice()* p.getQuantity(); // Basic addition loop
        }
        return total;
    }


}
