package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // 1. Strict Admin Check
        if ("admin".equals(user)) {
            if ("admin123".equals(pass)) {
                // --- SECURITY FIX: CREATE THE ADMIN SESSION ---
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userRole", "admin"); // This matches the check in AdminServlet
                // ----------------------------------------------

                response.sendRedirect("admin_dashboard.html");
            } else {
                response.sendRedirect("login.html?error=admin_fail");
            }
        }
        // 2. Flexible Customer Check
        else {
            if (pass != null && pass.length() > 0) {
                // --- SECURITY FIX: CREATE A CUSTOMER SESSION ---
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userRole", "customer");
                // -----------------------------------------------

                response.sendRedirect("index.html?user=" + user);
            } else {
                response.sendRedirect("login.html?error=empty_pass");
            }
        }
    }
}