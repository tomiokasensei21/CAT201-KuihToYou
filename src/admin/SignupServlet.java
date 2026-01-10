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

        String user = request.getParameter("username");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // 1. Gentle Validation
        if (user == null || user.trim().isEmpty() || email == null || email.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            response.sendRedirect("signup.html?error=empty_fields");
            return;
        }

        // 2. CHECK IF USERNAME IS ALREADY LOVED
        if (UserManager.isUsernameTaken(user, getServletContext())) {
            // Send back the name so we can tell them: "This name is already taken!"
            response.sendRedirect("signup.html?error=name_taken&attempt=" + user);
            return;
        }

        // 3. Register the New Family Member
        UserManager.registerUser(user, email, pass, getServletContext());

        // 4. SUCCESS: Redirect with the user's name for a personalized welcome
        response.sendRedirect("login.html?signup=success&newMember=" + user);
    }
}