<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Log in | PocketWise</title><link rel="stylesheet" href="assets/css/style.css">
</head>
<body class="form-page">
    <main class="form-card">
        <a class="brand" href="start.html"><span class="brand-mark">₹</span> Expense_Tracker</a>
        <p class="eyebrow">WELCOME BACK</><h1>Good to see you.</h1>
        <p class="form-intro">Log in to pick up where you left off.</p>
        <% if (request.getParameter("error") != null) { %>
            <p class="notice error"><%= request.getParameter("error") %></p>
        <% } %>
        <% if (request.getParameter("message") != null) { %>
            <p class="notice"><%= request.getParameter("message") %></p>
        <% } %>
        <form action="login" method="post">
            <!-- The name attributes match the parameters read by LoginServlet. -->
            <label>Email address<input type="email" name="email" placeholder="you@example.com" required></label>
            <label>Password<input type="password" name="password" placeholder="Enter your password" required></label>
            <button class="button form-button" type="submit">Log in to your account →</button>
        </form>
        <p class="form-switch">New to PocketWise? <a href="register.jsp">Create an account</a></p>
        <a class="back-link" href="start.html">← Back to home</a>
    </main>
</body>
</html>
