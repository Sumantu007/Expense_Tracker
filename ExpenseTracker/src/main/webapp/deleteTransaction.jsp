
<%@ page import="java.sql.*" %>
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

    try {
        int id = Integer.parseInt(request.getParameter("id"));

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "DELETE FROM transactions WHERE id=? AND user_id=?")) {

            ps.setInt(1, id);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("dashboard.jsp?message=deleted");
            } else {
                response.sendRedirect("dashboard.jsp?message=notfound");
            }
            return;
        }

    } catch (Exception e) {
        application.log("Transaction deletion failed", e);
        response.sendRedirect("dashboard.jsp?message=error");
    }
%>
