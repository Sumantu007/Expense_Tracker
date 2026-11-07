
<%@ page import="java.util.List,java.util.ArrayList,java.math.BigDecimal,com.expensetracker.dao.TransactionDAO,com.expensetracker.model.Transaction" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Session protection
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");

    BigDecimal income = BigDecimal.ZERO;
    BigDecimal expenses = BigDecimal.ZERO;
    BigDecimal balance = BigDecimal.ZERO;

    List<Transaction> transactions = new ArrayList<Transaction>();
    String loadError = null;

    try {
        TransactionDAO dao = new TransactionDAO();

        income = dao.totalFor(userId, "INCOME");
        expenses = dao.totalFor(userId, "EXPENSE");
        transactions = dao.findByUser(userId);

        if (income == null) income = BigDecimal.ZERO;
        if (expenses == null) expenses = BigDecimal.ZERO;

        if (transactions == null) {
            transactions = new ArrayList<Transaction>();
        }

        balance = income.subtract(expenses);

    } catch (Exception e) {
        e.printStackTrace();
        loadError = "Unable to load transactions. Please check your database.";
    }

    BigDecimal total = income.add(expenses);

    double incomePercent = 0;
    double expensePercent = 0;

    if (total.compareTo(BigDecimal.ZERO) > 0) {
        incomePercent = income.doubleValue() * 100 / total.doubleValue();
        expensePercent = expenses.doubleValue() * 100 / total.doubleValue();
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Expense_Tracker | Dashboard</title>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Arial, sans-serif;
}

body {
    background: #f4f7fc;
    color: #18243a;
}

.topbar {
    background: white;
    padding: 17px 5%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    border-bottom: 1px solid #e8edf5;
    position: sticky;
    top: 0;
    z-index: 10;
}

.brand {
    color: #2563eb;
    font-size: 25px;
    font-weight: 800;
    text-decoration: none;
}

.brand span {
    color: #172554;
}

.user-area {
    display: flex;
    align-items: center;
    gap: 18px;
}

.user-email {
    color: #64748b;
    font-size: 13px;
}

.logout {
    text-decoration: none;
    color: #dc2626;
    font-weight: 600;
    font-size: 14px;
}

.container {
    max-width: 1250px;
    margin: auto;
    padding: 35px 22px;
}

.welcome {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    margin-bottom: 30px;
}

.welcome h1 {
    font-size: 30px;
    margin-bottom: 8px;
}

.welcome p {
    color: #718096;
}

.eyebrow {
    color: #2563eb;
    font-weight: 800;
    font-size: 11px;
    letter-spacing: 2px;
    margin-bottom: 10px;
}

.add-btn {
    background: #2563eb;
    color: white;
    text-decoration: none;
    padding: 13px 21px;
    border-radius: 11px;
    font-weight: 700;
}

.add-btn:hover {
    background: #1d4ed8;
}

.alert {
    padding: 13px 16px;
    background: #fff1f2;
    color: #be123c;
    border-radius: 10px;
    margin-bottom: 20px;
}

.cards {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    margin-bottom: 25px;
}

.card {
    background: white;
    padding: 25px;
    border-radius: 18px;
    border: 1px solid #edf0f6;
    box-shadow: 0 7px 25px #17255408;
}

.card-label {
    color: #718096;
    font-size: 14px;
    font-weight: 600;
}

.card h2 {
    font-size: 29px;
    margin: 15px 0 8px;
}

.card small {
    color: #94a3b8;
}

.balance-card {
    background: linear-gradient(135deg, #1d4ed8, #4338ca);
    color: white;
}

.balance-card .card-label,
.balance-card small {
    color: #dbeafe;
}

.income-card h2 {
    color: #059669;
}

.expense-card h2 {
    color: #e11d48;
}

.card-icon {
    width: 42px;
    height: 42px;
    display: grid;
    place-items: center;
    border-radius: 12px;
    font-size: 22px;
    background: #eff6ff;
    margin-bottom: 18px;
}

.balance-card .card-icon {
    background: #ffffff25;
}

.middle-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 22px;
    margin-bottom: 25px;
}

.panel {
    background: white;
    padding: 25px;
    border: 1px solid #edf0f6;
    border-radius: 18px;
    box-shadow: 0 7px 25px #17255408;
}

.panel h3 {
    font-size: 18px;
    margin-bottom: 8px;
}

.panel-subtitle {
    color: #94a3b8;
    font-size: 13px;
    margin-bottom: 20px;
}

.chart-container {
    height: 240px;
}

.legend {
    display: flex;
    justify-content: center;
    gap: 25px;
    margin-top: 15px;
    font-size: 13px;
    color: #64748b;
}

.dot {
    display: inline-block;
    width: 9px;
    height: 9px;
    border-radius: 50%;
    margin-right: 6px;
}

.income-dot {
    background: #10b981;
}

.expense-dot {
    background: #f43f5e;
}

.progress-item {
    margin: 25px 0;
}

.progress-info {
    display: flex;
    justify-content: space-between;
    margin-bottom: 10px;
    font-size: 13px;
}

.progress-track {
    height: 10px;
    background: #edf2f7;
    border-radius: 20px;
    overflow: hidden;
}

.progress-fill {
    height: 100%;
    border-radius: 20px;
}

.income-fill {
    background: #10b981;
}

.expense-fill {
    background: #f43f5e;
}

.transaction-panel {
    background: white;
    border-radius: 18px;
    padding: 25px;
    border: 1px solid #edf0f6;
    box-shadow: 0 7px 25px #17255408;
}

.transaction-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 22px;
}

.transaction-heading h3 {
    font-size: 19px;
}

.table-wrap {
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 850px;
}

th {
    text-align: left;
    padding: 14px 12px;
    color: #94a3b8;
    font-size: 12px;
    border-bottom: 1px solid #edf0f6;
}

td {
    padding: 17px 12px;
    border-bottom: 1px solid #f1f5f9;
    font-size: 13px;
}

.transaction-name {
    font-weight: 700;
}

.type {
    padding: 6px 11px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 700;
}

.income-type {
    color: #047857;
    background: #d1fae5;
}

.expense-type {
    color: #be123c;
    background: #ffe4e6;
}

.income-amount {
    color: #059669;
    font-weight: 800;
}

.expense-amount {
    color: #e11d48;
    font-weight: 800;
}

.action-buttons {
    display: flex;
    gap: 7px;
}

.edit-btn {
    background: #f59e0b;
    color: white;
    border: none;
    padding: 7px 12px;
    border-radius: 6px;
    text-decoration: none;
    font-size: 12px;
    cursor: pointer;
}

.delete-btn {
    background: #dc2626;
    color: white;
    border: none;
    padding: 7px 12px;
    border-radius: 6px;
    font-size: 12px;
    cursor: pointer;
}

.edit-btn:hover {
    background: #d97706;
}

.delete-btn:hover {
    background: #b91c1c;
}

.empty {
    text-align: center;
    padding: 35px;
    color: #94a3b8;
}

.footer {
    text-align: center;
    padding: 25px;
    color: #94a3b8;
    font-size: 12px;
}

@media(max-width: 800px) {
    .cards,
    .middle-grid {
        grid-template-columns: 1fr;
    }

    .welcome {
        align-items: flex-start;
        flex-direction: column;
    }
}

@media(max-width: 500px) {
    .user-email {
        display: none;
    }

    .welcome h1 {
        font-size: 24px;
    }
}

</style>

</head>

<body>

<header class="topbar">

    <a href="dashboard.jsp" class="brand">
        Expense<span>Tracker.</span>
    </a>

    <div class="user-area">

        <span class="user-email">
            Signed in: <%= userEmail == null ? "User" : userEmail %>
        </span>

        <a href="logout" class="logout">Logout ↗</a>

    </div>

</header>


<main class="container">

    <!-- WELCOME -->

    <section class="welcome">

        <div>

            <p class="eyebrow">YOUR PERSONAL FINANCE SPACE</p>

            <h1>Hello, welcome back! 👋</h1>

            <p>Track your money. Understand your habits. Save smarter.</p>

        </div>

        <a href="add-transaction.jsp" class="add-btn">
            + Add Transaction
        </a>

    </section>


    <% if (loadError != null) { %>

        <div class="alert">
            <%= loadError %>
        </div>

    <% } %>


    <!-- SUMMARY CARDS -->

    <section class="cards">

        <article class="card balance-card">

            <div class="card-icon">💳</div>

            <p class="card-label">Available Balance</p>

            <h2>₹ <%= balance.toPlainString() %></h2>

            <small>Your income minus your expenses</small>

        </article>


        <article class="card income-card">

            <div class="card-icon">↙️</div>

            <p class="card-label">Total Income</p>

            <h2>₹ <%= income.toPlainString() %></h2>

            <small>Money received</small>

        </article>


        <article class="card expense-card">

            <div class="card-icon">↗️</div>

            <p class="card-label">Total Expenses</p>

            <h2>₹ <%= expenses.toPlainString() %></h2>

            <small>Money spent</small>

        </article>

    </section>


    <!-- CHARTS -->

    <section class="middle-grid">

        <div class="panel">

            <h3>Income vs Expenses</h3>

            <p class="panel-subtitle">
                Your overall money distribution
            </p>

            <div class="chart-container">
                <canvas id="moneyChart"></canvas>
            </div>

            <div class="legend">
                <span><i class="dot income-dot"></i>Income</span>
                <span><i class="dot expense-dot"></i>Expenses</span>
            </div>

        </div>


        <div class="panel">

            <h3>Financial Overview</h3>

            <p class="panel-subtitle">
                A quick look at your money activity
            </p>

            <div class="progress-item">

                <div class="progress-info">
                    <span>Total Income</span>
                    <b>₹ <%= income.toPlainString() %></b>
                </div>

                <div class="progress-track">
                    <div class="progress-fill income-fill"
                         style="width:<%= incomePercent %>%">
                    </div>
                </div>

            </div>


            <div class="progress-item">

                <div class="progress-info">
                    <span>Total Expenses</span>
                    <b>₹ <%= expenses.toPlainString() %></b>
                </div>

                <div class="progress-track">
                    <div class="progress-fill expense-fill"
                         style="width:<%= expensePercent %>%">
                    </div>
                </div>

            </div>


            <div class="progress-item">

                <div class="progress-info">
                    <span>Remaining Balance</span>
                    <b>₹ <%= balance.toPlainString() %></b>
                </div>

                <p style="color:#64748b;font-size:13px;margin-top:12px;">
                    Keep recording your daily income and expenses.
                </p>

            </div>

        </div>

    </section>


    <!-- TRANSACTION TABLE -->

    <section class="transaction-panel">

        <div class="transaction-heading">

            <div>
                <p class="eyebrow">YOUR MONEY ACTIVITY</p>
                <h3>Recent Transactions</h3>
            </div>

        </div>


        <div class="table-wrap">

            <table>

                <thead>

                    <tr>
                        <th>TRANSACTION</th>
                        <th>CATEGORY</th>
                        <th>DATE</th>
                        <th>TYPE</th>
                        <th>AMOUNT</th>
                        <th>ACTION</th>
                    </tr>

                </thead>


                <tbody>

                <% if (transactions.isEmpty()) { %>

                    <tr>
                        <td colspan="6" class="empty">
                            No transactions yet. Add your first transaction!
                        </td>
                    </tr>

                <% } else { %>

                    <% for (Transaction item : transactions) {

                        boolean isIncome =
                            "INCOME".equalsIgnoreCase(item.getEntryType());

                    %>

                    <tr>

                        <td class="transaction-name">
                            <%= item.getTitle() %>
                        </td>

                        <td>
                            <%= item.getCategory() %>
                        </td>

                        <td>
                            <%= item.getEntryDate() %>
                        </td>

                        <td>

                            <% if (isIncome) { %>

                                <span class="type income-type">
                                    INCOME
                                </span>

                            <% } else { %>

                                <span class="type expense-type">
                                    EXPENSE
                                </span>

                            <% } %>

                        </td>

                        <td class="<%= isIncome ? "income-amount" : "expense-amount" %>">

                            <%= isIncome ? "+" : "-" %>
                            ₹ <%= item.getAmount() %>

                        </td>


                        <!-- EDIT AND DELETE -->

                        <td>

                            <div class="action-buttons">

                                <a class="edit-btn"
                                   href="editTransaction.jsp?id=<%= item.getId() %>">
                                    Edit
                                </a>


                                <form action="deleteTransaction.jsp"
                                      method="post"
                                      style="display:inline;">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= item.getId() %>">

                                    <button type="submit"
                                            class="delete-btn"
                                            onclick="return confirm('Are you sure you want to delete this transaction?');">

                                        Delete

                                    </button>

                                </form>

                            </div>

                        </td>

                    </tr>

                    <% } %>

                <% } %>

                </tbody>

            </table>

        </div>

    </section>

</main>


<footer class="footer">

    PocketWise © 2026 | Manage your money with confidence.

</footer>


<!-- CHART JS -->

<script>

const incomeValue = Number("<%= income.toPlainString() %>");
const expenseValue = Number("<%= expenses.toPlainString() %>");

new Chart(document.getElementById("moneyChart"), {

    type: "doughnut",

    data: {

        labels: ["Income", "Expenses"],

        datasets: [{

            data: [incomeValue, expenseValue],

            backgroundColor: ["#10b981", "#f43f5e"],

            borderWidth: 0,

            hoverOffset: 8

        }]

    },

    options: {

        responsive: true,

        maintainAspectRatio: false,

        cutout: "72%",

        plugins: {

            legend: {
                display: false
            }

        }

    }

});

</script>

</body>
</html>
