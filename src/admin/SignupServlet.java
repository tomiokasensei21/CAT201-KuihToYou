package admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import util.UserManager;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get data from the form fields
        String user = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // 2. Simple Validation
        if (user == null || user.isEmpty() || email == null || email.isEmpty() || pass == null || pass.isEmpty()) {
            response.sendRedirect("signup.html?error=empty_fields");
            return;
        }

        // 3. Save to users.txt using your Manager
        // IMPORTANT: Now passing 'email' as the second argument!
        util.UserManager.registerUser(user, email, pass, getServletContext());

        // 4. Redirect to login page
        response.sendRedirect("login.html?signup=success");
    }
}