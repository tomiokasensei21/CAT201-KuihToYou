package util;

import java.io.*;
import jakarta.servlet.ServletContext;

public class UserManager {

    // MEMBER 3: SAVE NEW USER (Updated with Email and Debugging)
    public static void registerUser(String username, String email, String password, ServletContext context) {
        // 1. Get the path
        String filePath = context.getRealPath("/data/users.txt");

        // 2. CRITICAL FIX: If path is null, use a fallback local path
        if (filePath == null) {
            // This ensures the code doesn't crash if Tomcat's realPath fails
            filePath = "users.txt";
        }

        System.out.println("MEMBER 3 DEBUG: Attempting to save to: " + filePath);

        File file = new File(filePath);

        // 3. Ensure the folder exists
        if (file.getParentFile() != null && !file.getParentFile().exists()) {
            file.getParentFile().mkdirs();
        }

        try (PrintWriter out = new PrintWriter(new FileWriter(file, true))) {
            out.println(username + "," + email + "," + password);
            out.flush();
            System.out.println("MEMBER 3 SUCCESS: Saved " + username);
        } catch (IOException e) {
            System.err.println("MEMBER 3 ERROR: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // MEMBER 3: VALIDATE USER (Updated for 3-column format)
    public static boolean isValidUser(String username, String password, ServletContext context) {
        String filePath = context.getRealPath("/data/users.txt");
        File file = new File(filePath);

        if (!file.exists()) {
            System.out.println("DEBUG: users.txt not found at " + filePath);
            return false;
        }

        try (BufferedReader br = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                // parts[0] = username, parts[1] = email, parts[2] = password
                if (parts.length == 3) {
                    if (parts[0].trim().equals(username) && parts[2].trim().equals(password)) {
                        return true;
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }
}