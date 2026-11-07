
package com.expensetracker.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.expensetracker.dao.UserDAO;
import com.expensetracker.util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Check empty fields.
        if (email == null || password == null
                || email.trim().isEmpty()
                || password.isEmpty()) {

            response.sendRedirect(
                    "login.jsp?error=Please+enter+email+and+password"
            );
            return;
        }

        email = email.trim().toLowerCase();

        try {

            // Find the saved password hash.
            String savedHash = userDAO.getPasswordHash(email);

            // Verify the entered password.
            if (savedHash != null &&
                    PasswordUtil.matches(password, savedHash)) {

                // Get the user's database ID.
                Integer userId = userDAO.getUserId(email);

                if (userId != null) {

                    // Create a new session after successful login.
                    HttpSession session = request.getSession(true);
                    session.setAttribute("userId", userId);
                    session.setAttribute("userEmail", email);

                    response.sendRedirect("dashboard.jsp");

                } else {

                    response.sendRedirect(
                            "login.jsp?error=Incorrect+email+or+password"
                    );
                }

            } else {

                response.sendRedirect(
                        "login.jsp?error=Incorrect+email+or+password"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "login.jsp?error=Unable+to+sign+in"
            );
        }
    }
}
