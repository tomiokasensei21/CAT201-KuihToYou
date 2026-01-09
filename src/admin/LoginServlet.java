package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import util.UserManager; // Import the manager you just created

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // 1. Capture the redirect source from the hidden input
        String redirectSource = request.getParameter("redirectSource");

        // 2. Strict Admin Check (Hardcoded as per project requirements)
        if ("admin".equals(user)) {
            if ("admin123".equals(pass)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userRole", "admin");

                response.sendRedirect("admin_dashboard.html");
            } else {
                response.sendRedirect("login.html?error=admin_fail");
            }
        }
        // 3. Customer Check using UserManager (Member 3 Logic)
        else {
            // This now checks the users.txt file via the UserManager
            if (UserManager.isValidUser(user, pass, getServletContext())) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userRole", "customer");

                // DYNAMIC REDIRECT: Send user back to where they came from (e.g., Cart)
                if (redirectSource != null && !redirectSource.isEmpty()) {
                    response.sendRedirect(redirectSource);
                } else {
                    // Default fallback if no source is provided
                    response.sendRedirect("menu.jsp");
                }
            } else {
                // If the user/pass doesn't match a line in users.txt
                response.sendRedirect("login.html?error=invalid_credentials");
            }
        }
    }
}