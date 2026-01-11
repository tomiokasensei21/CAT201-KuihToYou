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

        // 1. Validation for empty fields (KEPT OLD FEATURE)
        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            response.sendRedirect("login.html?error=empty_fields");
            return;
        }

        // 2. Strict Admin Check (KEPT OLD FEATURE)
        if ("admin".equalsIgnoreCase(user)) {
            if ("admin123".equals(pass)) {
                setupSession(request, user, "admin");
                // ADDED status parameter to trigger popout
                response.sendRedirect("index.jsp?status=login_success");
            } else {
                response.sendRedirect("login.html?error=admin_fail&user=admin");
            }
            return;
        }

        // 3. Customer Check (KEPT OLD FEATURE)
        int status = UserManager.validateUser(user, pass, getServletContext());

        if (status == 0) {
            setupSession(request, user, "customer");
            // ADDED status parameter to trigger popout
            response.sendRedirect("index.jsp?status=login_success");
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
        // This makes sure the JSP popup logic can also see it
        newSession.setAttribute("loginTrigger", true);
        newSession.setMaxInactiveInterval(30 * 60);
    }
}