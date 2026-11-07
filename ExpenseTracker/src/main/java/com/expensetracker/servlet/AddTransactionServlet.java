package com.expensetracker.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.expensetracker.dao.TransactionDAO;

@WebServlet("/add-transaction")
public class AddTransactionServlet extends HttpServlet {

    // Only a signed-in user can add a transaction to their own account.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");
            String type = request.getParameter("entryType");
            String title = request.getParameter("title");
            String category = request.getParameter("category");
            BigDecimal amount = new BigDecimal(request.getParameter("amount"));
            Date date = Date.valueOf(request.getParameter("entryDate"));
            String notes = request.getParameter("notes");

            // Reject invalid amounts and unexpected transaction types.
            if (amount.compareTo(BigDecimal.ZERO) <= 0
                    || (!"INCOME".equals(type) && !"EXPENSE".equals(type))) {
                response.sendRedirect("add-transaction.jsp?error=Check+your+details");
                return;
            }

            new TransactionDAO().add(userId, type, title, category, amount, date, notes);
            response.sendRedirect("dashboard.jsp?message=Transaction+saved");
        } catch (Exception e) {
            response.sendRedirect("add-transaction.jsp?error=Could+not+save+transaction");
        }
    }
}
