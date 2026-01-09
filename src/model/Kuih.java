package model;

public class Kuih {
    private String id;
    private String name;
    private double price;
    private String imageFile;
    private int stock;        // inventory logic

    public Kuih(String id, String name, double price, String imageFile, int stock) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.imageFile = imageFile;
        this.stock = stock;
    }

    // Text File Bridge
    @Override
    public String toString() {
        return id + "," + name + "," + price + "," + imageFile + "," + stock;
    }

    // Getters and Setters
    public String getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public String getImageFile() { return imageFile; }
    public int getStock() { return stock; }

    public void setName(String name) { this.name = name; }
    public void setPrice(double price) { this.price = price; }
    public void setStock(int stock) { this.stock = stock; }
}

