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
        // (userName, userRole, welcomeShown, etc.)
        if (session != null) {
            session.invalidate();
        }

        // 3. Redirect back to index.jsp with the status parameter
        // This parameter is detected by the JavaScript in index.jsp to show the toast
        response.sendRedirect("index.jsp?status=logged_out");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to the GET logic for consistency
        doGet(request, response);
    }
}