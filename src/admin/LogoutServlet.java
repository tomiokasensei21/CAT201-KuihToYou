package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the current session
        HttpSession session = request.getSession(false);

        // 2. If a session exists, invalidate (delete) it
        if (session != null) {
            session.invalidate();
        }

        // 3. Redirect the user back to the login page with a logout message
        response.sendRedirect("login.html?logout=success");
    }
}