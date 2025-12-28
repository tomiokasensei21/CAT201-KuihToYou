package CartProduct;

public class Product {
    private String id;
    private String name;
    private double price;
    private String imageFile;
    private int quantity;

    // Constructor: To create a new kuih object
    public Product(String id, String name, double price, String imageFile, int quantity) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.imageFile = imageFile;
        this.quantity = quantity;

    }

    // Getter methods
    public String getId() {return id;}
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public String getImageFile() { return imageFile; }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

}
