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

        // 2. Simple Validation for empty fields
        if (user == null || user.trim().isEmpty() || email == null || email.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            response.sendRedirect("signup.html?error=empty_fields");
            return;
        }

        // 3. CHECK IF USERNAME ALREADY EXISTS
        // This calls the method in UserManager to scan users.txt
        if (UserManager.isUsernameTaken(user, getServletContext())) {
            // If the name exists, stop here and alert the user
            response.sendRedirect("signup.html?error=name_taken");
            return;
        }

        // 4. Save to users.txt using your Manager
        // If the code reaches here, it means the username is unique
        UserManager.registerUser(user, email, pass, getServletContext());

        // 5. Redirect to login page with success message
        response.sendRedirect("login.html?signup=success");
    }
}