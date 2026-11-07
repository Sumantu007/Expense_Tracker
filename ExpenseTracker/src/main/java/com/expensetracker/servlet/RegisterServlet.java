
package com.expensetracker.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.expensetracker.dao.UserDAO;
import com.expensetracker.model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

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

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate registration fields.
        if (fullName == null || email == null || password == null
                || fullName.trim().isEmpty()
                || email.trim().isEmpty()
                || password.isEmpty()) {

            request.setAttribute("errorMessage",
                    "Please fill in all fields.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
            return;
        }

        email = email.trim().toLowerCase();

        try {

            // Check for an existing email.
            if (userDAO.emailExists(email)) {

                request.setAttribute("errorMessage",
                        "Email may already be registered. Please use another email.");

                request.getRequestDispatcher("register.jsp")
                       .forward(request, response);
                return;
            }

            // Create user object.
            User user = new User();

            user.setFullName(fullName.trim());
            user.setEmail(email);
            user.setPassword(password);

            // Save user in MySQL.
            boolean result = userDAO.registerUser(user);

            if (result) {
                response.sendRedirect("login.jsp?registered=success");
            } else {
                request.setAttribute("errorMessage",
                        "Registration failed. Please try again.");

                request.getRequestDispatcher("register.jsp")
                       .forward(request, response);
            }

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute("errorMessage",
                    "Registration failed. Please check your database connection.");

            request.getRequestDispatcher("register.jsp")
                   .forward(request, response);
        }
    }
}
