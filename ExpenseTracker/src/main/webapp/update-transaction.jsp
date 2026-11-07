
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.expensetracker.database.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    request.setCharacterEncoding("UTF-8");

    try {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title").trim();
        String category = request.getParameter("category").trim();
        String entryType = request.getParameter("entryType").trim().toUpperCase();
        BigDecimal amount = new BigDecimal(request.getParameter("amount"));
        Date entryDate = Date.valueOf(request.getParameter("entryDate"));

        if (title.isEmpty() || category.isEmpty()
                || amount.compareTo(BigDecimal.ZERO) <= 0
                || !(entryType.equals("INCOME") || entryType.equals("EXPENSE"))) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "UPDATE transactions SET title=?, category=?, entry_type=?, amount=?, entry_date=? " +
                 "WHERE id=? AND user_id=?")) {

            ps.setString(1, title);
            ps.setString(2, category);
            ps.setString(3, entryType);
            ps.setBigDecimal(4, amount);
            ps.setDate(5, entryDate);
            ps.setInt(6, id);
            ps.setInt(7, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("dashboard.jsp?message=updated");
            } else {
                response.sendRedirect("dashboard.jsp?message=notfound");
            }
            return;
        }

    } catch (Exception e) {
        application.log("Transaction update failed", e);
        response.sendRedirect("dashboard.jsp?message=error");
    }
%>
