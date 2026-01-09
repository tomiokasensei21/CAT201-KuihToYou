package util;

import java.io.*;
import jakarta.servlet.ServletContext;

public class UserManager {

    // Relative path for the data file
    private static final String DATA_FILE = "/data/users.txt";

    /**
     * NEW METHOD: Check if username already exists in users.txt
     * Returns true if name exists, false if it is unique.
     */
    public static boolean isUsernameTaken(String username, ServletContext context) {
        String filePath = context.getRealPath(DATA_FILE);
        if (filePath == null) return false;

        File file = new File(filePath);
        if (!file.exists()) return false;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 1) {
                    String storedUsername = parts[0].trim();
                    // Case-insensitive check (recommended for better UX)
                    if (storedUsername.equalsIgnoreCase(username.trim())) {
                        return true;
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("UserManager Error (Check Name): " + e.getMessage());
        }
        return false;
    }

    /**
     * MEMBER 3: SAVE NEW USER
     * Saves user in the format: username,email,password
     */
    public static void registerUser(String username, String email, String password, ServletContext context) {
        String filePath = context.getRealPath(DATA_FILE);

        // Fallback for local testing if realPath is null
        if (filePath == null) {
            filePath = "users.txt";
        }

        File file = new File(filePath);

        // Ensure the directory /data/ exists
        if (file.getParentFile() != null && !file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        try (PrintWriter out = new PrintWriter(new FileWriter(file, true))) {
            // Saving using a comma as the delimiter
            out.println(username.trim() + "," + email.trim() + "," + password.trim());
            out.flush();
            System.out.println("UserManager: Successfully registered " + username);
        } catch (IOException e) {
            System.err.println("UserManager Error (Register): " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * MEMBER 3: VALIDATE USER
     * Checks strictly for matching Username and Password
     */
    public static boolean isValidUser(String username, String password, ServletContext context) {
        String filePath = context.getRealPath(DATA_FILE);

        if (filePath == null) return false;

        File file = new File(filePath);

        if (!file.exists()) {
            System.out.println("UserManager: users.txt not found at " + filePath);
            return false;
        }

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                // Split by comma
                String[] parts = line.split(",");

                if (parts.length >= 3) {
                    String storedUsername = parts[0].trim();
                    String storedPassword = parts[2].trim();

                    // Strict check: Must match both username and password
                    if (storedUsername.equals(username.trim()) && storedPassword.equals(password.trim())) {
                        return true;
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("UserManager Error (Validate): " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
}