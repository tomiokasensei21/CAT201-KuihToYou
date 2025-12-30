package admin;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 1. Get the current session if it exists
        HttpSession session = request.getSession(false);

        if (session != null) {
            // 2. Clear all session data (Admin or Customer)
            session.invalidate();
        }

        // 3. Redirect to homepage with a status flag for the alert
        response.sendRedirect("index.html?status=loggedout");
    }
}
