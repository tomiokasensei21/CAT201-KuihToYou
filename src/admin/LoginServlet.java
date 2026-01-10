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

        // 1. Validation for empty fields
        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            response.sendRedirect("login.html?error=empty_fields");
            return;
        }

        // 2. Strict Admin Check
        // This is where the redirection to the Admin Dashboard happens
        if ("admin".equalsIgnoreCase(user)) {
            if ("admin123".equals(pass)) {
                setupSession(request, user, "admin");
                // Consistent with your admin_dashboard.html filename
                response.sendRedirect("index.jsp");
            } else {
                response.sendRedirect("login.html?error=admin_fail&user=admin");
            }
            return;
        }

        // 3. Customer Check (Redirects to Storefront)
        int status = UserManager.validateUser(user, pass, getServletContext());

        if (status == 0) {
            setupSession(request, user, "customer");
            response.sendRedirect("index.jsp");
        }
        else if (status == 1) {
            response.sendRedirect("login.html?error=no_user&attempt=" + user);
        }
        else if (status == 2) {
            response.sendRedirect("login.html?error=wrong_pass&user=" + user);
        }
    }

    private void setupSession(HttpServletRequest request, String username, String role) {
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("user", username);
        newSession.setAttribute("userRole", role);
        newSession.setMaxInactiveInterval(30 * 60); // 30 minutes session
    }
}