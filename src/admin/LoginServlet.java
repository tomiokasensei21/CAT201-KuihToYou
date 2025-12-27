package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // 1. Strict Admin Check
        if ("admin".equals(user)) {
            if ("admin123".equals(pass)) {
                response.sendRedirect("admin_dashboard.html");
            } else {
                // Admin entered the wrong password
                response.sendRedirect("login.html?error=admin_fail");
            }
        }
        // 2. Flexible Customer Check
        else {
            // Here, we accept any username/password for now
            // (In a real app, you'd check a Database here)
            if (pass != null && pass.length() > 0) {
                response.sendRedirect("index.html?user=" + user);
            } else {
                response.sendRedirect("login.html?error=empty_pass");
            }
        }
    }
}
