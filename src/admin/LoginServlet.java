package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import util.UserManager;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String redirectSource = request.getParameter("redirectSource");

        // 1. Validation for empty fields
        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            response.sendRedirect("login.html?error=empty_fields");
            return;
        }

        // 2. Strict Admin Check
        if ("admin".equals(user)) {
            if ("admin123".equals(pass)) {
                setupSession(request, user, "admin");
                response.sendRedirect("admin_dashboard.html");
            } else {
                response.sendRedirect("login.html?error=admin_fail");
            }
        }
        // 3. Customer Check using UserManager
        else {
            if (UserManager.isValidUser(user, pass, getServletContext())) {
                setupSession(request, user, "customer");

                // Handle Dynamic Redirection
                if (redirectSource != null && !redirectSource.isEmpty() && !redirectSource.equals("null")) {
                    response.sendRedirect(redirectSource);
                } else {
                    response.sendRedirect("menu.jsp");
                }
            } else {
                // Invalid credentials (user not found or wrong password)
                response.sendRedirect("login.html?error=invalid_credentials");
            }
        }
    }

    /**
     * Helper method to manage session security and attributes
     */
    private void setupSession(HttpServletRequest request, String username, String role) {
        // Invalidate existing session to prevent session fixation attacks
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        // Create new session
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("user", username);
        newSession.setAttribute("userRole", role);

        // Optional: Set session timeout (e.g., 30 minutes)
        newSession.setMaxInactiveInterval(30 * 60);
    }
}