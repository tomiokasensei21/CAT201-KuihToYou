package util;

import java.io.*;
import jakarta.servlet.ServletContext;

public class UserManager {
    private static final String DATA_FILE = "/data/users.txt";

    public static boolean isUsernameTaken(String username, ServletContext context) {
        String filePath = context.getRealPath(DATA_FILE);
        if (filePath == null) return false;
        File file = new File(filePath);
        if (!file.exists()) return false;

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 1 && parts[0].trim().equalsIgnoreCase(username.trim())) {
                    return true;
                }
            }
        } catch (IOException e) { return false; }
        return false;
    }

    public static void registerUser(String username, String email, String password, ServletContext context) {
        String filePath = context.getRealPath(DATA_FILE);
        if (filePath == null) filePath = "users.txt";
        File file = new File(filePath);
        if (file.getParentFile() != null && !file.getParentFile().exists()) file.getParentFile().mkdirs();

        try (PrintWriter out = new PrintWriter(new FileWriter(file, true))) {
            out.println(username.trim() + "," + email.trim() + "," + password.trim());
        } catch (IOException e) { e.printStackTrace(); }
    }

    /**
     * UPDATED: Returns Status Codes
     * 0: Success | 1: No such user | 2: Wrong password
     */
    public static int validateUser(String username, String password, ServletContext context) {
        String filePath = context.getRealPath(DATA_FILE);
        if (filePath == null) return 1;
        File file = new File(filePath);
        if (!file.exists()) return 1;

        boolean userFound = false;
        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 3) {
                    String storedUser = parts[0].trim();
                    String storedPass = parts[2].trim();
                    if (storedUser.equalsIgnoreCase(username.trim())) {
                        userFound = true;
                        if (storedPass.equals(password.trim())) return 0;
                    }
                }
            }
        } catch (IOException e) { return 1; }
        return userFound ? 2 : 1;
    }
}