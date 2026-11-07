
<%@ page import="java.sql.*" %>
<%@ page import="com.expensetracker.database.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int id = 0;
    try {
        id = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    String title = "";
    String category = "";
    String entryType = "";
    String amount = "";
    String entryDate = "";

    boolean found = false;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT title, category, entry_type, amount, entry_date " +
             "FROM transactions WHERE id=? AND user_id=?")) {

        ps.setInt(1, id);
        ps.setInt(2, userId);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                found = true;
                title = rs.getString("title");
                category = rs.getString("category");
                entryType = rs.getString("entry_type");
                amount = rs.getString("amount");
                entryDate = rs.getDate("entry_date").toString();
            }
        }
    } catch (Exception e) {
        throw new ServletException(e);
    }

    if (!found) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Transaction - PocketWise</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f1f5f9;
            margin: 0;
            padding: 30px;
        }
        .container {
            max-width: 500px;
            margin: 30px auto;
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 15px #0001;
        }
        h2 { color: #2563eb; }
        label { display: block; margin-top: 15px; }
        input, select {
            width: 100%;
            padding: 11px;
            margin-top: 6px;
            box-sizing: border-box;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
        }
        button, .cancel {
            display: inline-block;
            margin-top: 20px;
            padding: 11px 18px;
            border: 0;
            border-radius: 6px;
            text-decoration: none;
            cursor: pointer;
        }
        button { background: #2563eb; color: white; }
        .cancel { background: #64748b; color: white; }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit Transaction</h2>

    <form action="update-transaction.jsp" method="post">
        <input type="hidden" name="id" value="<%= id %>">

        <label>Title</label>
        <input type="text" name="title"
               value="<%= title %>" required>

        <label>Category</label>
        <input type="text" name="category"
               value="<%= category %>" required>

        <label>Transaction Type</label>
        <select name="entryType" required>
            <option value="INCOME" <%= "INCOME".equalsIgnoreCase(entryType) ? "selected" : "" %>>Income</option>
            <option value="EXPENSE" <%= "EXPENSE".equalsIgnoreCase(entryType) ? "selected" : "" %>>Expense</option>
        </select>

        <label>Amount</label>
        <input type="number" name="amount" step="0.01"
               min="0.01" value="<%= amount %>" required>

        <label>Date</label>
        <input type="date" name="entryDate"
               value="<%= entryDate %>" required>

        <button type="submit">Update Transaction</button>
        <a class="cancel" href="dashboard.jsp">Cancel</a>
    </form>
</div>

</body>
</html>
