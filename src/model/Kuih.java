package model;

public class Kuih {
    private int id;
    private String name;
    private double price;
    private int stock;

    public Kuih(int id, String name, double price, int stock) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.stock = stock;
    }

    // This converts the object back to a text line for the .txt file
    @Override
    public String toString() {
        return id + "," + name + "," + price + "," + stock;
    }

    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getStock() { return stock; }

    public void setName(String name) { this.name = name; }
    public void setPrice(double price) { this.price = price; }
    public void setStock(int stock) { this.stock = stock; }
}