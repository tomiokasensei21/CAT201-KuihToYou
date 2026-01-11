package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

/**
 * LogoutServlet handles the termination of user sessions.
 * It clears session data and redirects the user back to the homepage
 * with a success status to trigger a friendly UI notification.
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get the current session without creating a new one
        HttpSession session = request.getSession(false);

        // 2. If a session exists, invalidate it to clear all attributes
        if (session != null) {
            session.invalidate();
        }

        // 3. Redirect back to index.jsp with the CORRECT status parameter
        // Changed "logged_out" to "logout_success" to match your index.jsp script
        response.sendRedirect("index.jsp?status=logout_success");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}