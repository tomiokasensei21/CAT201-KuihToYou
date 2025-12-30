package model;

public class CartItem {
    private Kuih kuih;
    private int quantity;

    public CartItem(Kuih kuih, int quantity) {
        this.kuih = kuih;
        this.quantity = quantity;
    }

    // Calculation logic for this specific row
    public double getSubtotal() {
        return kuih.getPrice() * quantity;
    }

    // Getters and Setters
    public Kuih getKuih() { return kuih; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
