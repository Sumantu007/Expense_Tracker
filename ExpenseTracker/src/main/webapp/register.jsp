
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>PocketWise - Register</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body {
            background: #f1f5f9;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: Arial, sans-serif;
        }

        .register-card {
            width: 100%;
            max-width: 430px;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
        }

        .brand {
            color: #2563eb;
            font-weight: bold;
            font-size: 26px;
        }

        .btn-register {
            background: #2563eb;
            color: white;
            width: 100%;
        }

        .btn-register:hover {
            background: #1d4ed8;
            color: white;
        }
    </style>
</head>

<body>

<div class="register-card">

    <div class="text-center mb-4">
        <div class="brand">Expense_Tracker</div>
        <h4 class="mt-2">Create Account</h4>
        <p class="text-secondary">Start managing your expenses today.</p>
    </div>

    <%-- Display registration errors --%>
    <%
        String errorMessage =
            (String) request.getAttribute("errorMessage");

        if (errorMessage != null) {
    %>
        <div class="alert alert-danger">
            <%= errorMessage %>
        </div>
    <%
        }

        String successMessage =
            request.getParameter("registered");

        if ("success".equals(successMessage)) {
    %>
        <div class="alert alert-success">
            Registration successful! Please login.
        </div>
    <%
        }
    %>

    <form action="register" method="post">

        <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input type="text"
                   name="fullName"
                   class="form-control"
                   placeholder="Enter your full name"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Email Address</label>
            <input type="email"
                   name="email"
                   class="form-control"
                   placeholder="Enter your email"
                   required>
        </div>

        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password"
                   name="password"
                   class="form-control"
                   placeholder="Create a password"
                   minlength="6"
                   required>
        </div>

        <button type="submit" class="btn btn-register py-2">
            Create Account
        </button>

    </form>

    <p class="text-center mt-4 mb-0">
        Already have an account?
        <a href="login.jsp">Login</a>
    </p>

</div>

</body>
</html>
