
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Only logged-in users can add transactions.
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Add Transaction | PocketWise</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #eff6ff, #f8fafc, #eef2ff);
            color: #172554;
        }

        .topbar {
            background: white;
            padding: 18px 6%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e5eaf2;
        }

        .brand {
            font-size: 25px;
            color: #2563eb;
            font-weight: 800;
            text-decoration: none;
        }

        .brand span {
            color: #172554;
        }

        .back-link {
            color: #2563eb;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
        }

        .page {
            width: 100%;
            max-width: 1000px;
            margin: 45px auto;
            padding: 0 20px;
        }

        .heading {
            text-align: center;
            margin-bottom: 30px;
        }

        .heading .tag {
            color: #2563eb;
            letter-spacing: 2px;
            font-size: 11px;
            font-weight: 800;
            margin-bottom: 10px;
        }

        .heading h1 {
            font-size: 30px;
            margin-bottom: 9px;
        }

        .heading p {
            color: #718096;
            font-size: 14px;
        }

        .form-card {
            background: white;
            border-radius: 22px;
            display: grid;
            grid-template-columns: 35% 65%;
            overflow: hidden;
            box-shadow: 0 15px 50px #1e3a8a12;
            border: 1px solid #e9eef7;
        }

        .side-panel {
            background: linear-gradient(155deg, #1d4ed8, #4338ca);
            color: white;
            padding: 35px 28px;
        }

        .side-panel .symbol {
            font-size: 45px;
            margin-bottom: 25px;
        }

        .side-panel h2 {
            font-size: 24px;
            line-height: 1.35;
            margin-bottom: 15px;
        }

        .side-panel p {
            color: #dbeafe;
            font-size: 13px;
            line-height: 1.8;
        }

        .tip {
            margin-top: 45px;
            padding: 16px;
            border: 1px solid #ffffff40;
            background: #ffffff15;
            border-radius: 13px;
            font-size: 12px;
            line-height: 1.7;
        }

        .form-content {
            padding: 35px;
        }

        .form-content h3 {
            font-size: 21px;
            margin-bottom: 7px;
        }

        .form-content .subtitle {
            color: #94a3b8;
            font-size: 13px;
            margin-bottom: 25px;
        }

        .field {
            margin-bottom: 19px;
        }

        label {
            display: block;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 8px;
            color: #334155;
        }

        input, select, textarea {
            width: 100%;
            border: 1px solid #dce4ef;
            border-radius: 10px;
            padding: 13px 14px;
            font-size: 14px;
            outline: none;
            color: #172554;
            background: white;
        }

        input:focus, select:focus, textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px #2563eb15;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        .type-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .type-option {
            position: relative;
        }

        .type-option input {
            position: absolute;
            opacity: 0;
            width: 1px;
            height: 1px;
        }

        .type-option label {
            border: 1px solid #dce4ef;
            border-radius: 11px;
            padding: 14px;
            display: block;
            text-align: center;
            cursor: pointer;
            transition: .2s;
        }

        .type-option label span {
            display: block;
            font-size: 22px;
            margin-bottom: 5px;
        }

        .income-choice input:checked + label {
            background: #ecfdf5;
            color: #047857;
            border: 2px solid #10b981;
        }

        .expense-choice input:checked + label {
            background: #fff1f2;
            color: #be123c;
            border: 2px solid #f43f5e;
        }

        .two-columns {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .amount-field {
            position: relative;
        }

        .amount-field span {
            position: absolute;
            top: 13px;
            left: 14px;
            font-weight: 700;
            color: #64748b;
        }

        .amount-field input {
            padding-left: 34px;
        }

        .submit-btn {
            width: 100%;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 11px;
            padding: 15px;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            margin-top: 5px;
            transition: .2s;
        }

        .submit-btn:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
        }

        .cancel {
            display: block;
            text-align: center;
            text-decoration: none;
            margin-top: 17px;
            color: #64748b;
            font-size: 13px;
        }

        .footer {
            text-align: center;
            padding: 25px;
            color: #94a3b8;
            font-size: 12px;
        }

        @media(max-width: 750px) {
            .form-card {
                grid-template-columns: 1fr;
            }

            .side-panel {
                padding: 25px;
            }

            .side-panel .symbol {
                margin-bottom: 10px;
            }

            .tip {
                margin-top: 20px;
            }
        }

        @media(max-width: 480px) {
            .form-content {
                padding: 22px;
            }

            .two-columns {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .heading h1 {
                font-size: 25px;
            }
        }
    </style>
</head>

<body>

<header class="topbar">

    <a href="dashboard.jsp" class="brand">
        Pocket<span>Wise.</span>
    </a>

    <a href="dashboard.jsp" class="back-link">
        ← Back to Dashboard
    </a>

</header>

<main class="page">

    <section class="heading">
        <p class="tag">TAKE CONTROL OF YOUR MONEY</p>
        <h1>Add a New Transaction</h1>
        <p>Every small entry helps you understand your financial journey.</p>
    </section>

    <section class="form-card">

        <aside class="side-panel">

            <div class="symbol">💰</div>

            <h2>Every rupee has a story.</h2>

            <p>
                Record your income and expenses regularly.
                Build better financial habits and keep your
                spending under control.
            </p>

            <div class="tip">
                💡 <b>Money tip</b><br>
                Track your daily spending. Small expenses
                can make a big difference at the end of the month.
            </div>

        </aside>

        <div class="form-content">

            <h3>Transaction Details</h3>
            <p class="subtitle">Enter the details below to save your transaction.</p>

            <form action="add-transaction" method="post" id="transactionForm">

                <!-- Select income or expense -->
                <div class="field">
                    <label>Transaction Type</label>

                    <div class="type-options">

                        <div class="type-option income-choice">
                            <input type="radio"
                                   name="entryType"
                                   id="income"
                                   value="INCOME"
                                   required>

                            <label for="income">
                                <span>↙️</span>
                                Income
                            </label>
                        </div>

                        <div class="type-option expense-choice">
                            <input type="radio"
                                   name="entryType"
                                   id="expense"
                                   value="EXPENSE"
                                   required
                                   checked>

                            <label for="expense">
                                <span>↗️</span>
                                Expense
                            </label>
                        </div>

                    </div>
                </div>

                <!-- Transaction title -->
                <div class="field">
                    <label for="title">Transaction Title</label>

                    <input type="text"
                           id="title"
                           name="title"
                           placeholder="e.g. Hostel Rent, Monthly Salary"
                           maxlength="120"
                           required>
                </div>

                <div class="two-columns">

                    <!-- Category -->
                    <div class="field">
                        <label for="category">Category</label>

                        <select name="category" id="category" required>
                            <option value="">Select category</option>

                            <option value="Salary">Salary</option>
                            <option value="Other Income">Other Income</option>
                            <option value="Food">Food</option>
                            <option value="Housing">Housing</option>
                            <option value="Transport">Transport</option>
                            <option value="Education">Education</option>
                            <option value="Shopping">Shopping</option>
                            <option value="Bills">Bills</option>
                            <option value="Entertainment">Entertainment</option>
                            <option value="Healthcare">Healthcare</option>
                            <option value="Travel">Travel</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <!-- Amount -->
                    <div class="field">
                        <label for="amount">Amount (₹)</label>

                        <div class="amount-field">
                            <span>₹</span>

                            <input type="number"
                                   id="amount"
                                   name="amount"
                                   placeholder="0.00"
                                   min="0.01"
                                   max="999999999"
                                   step="0.01"
                                   required>
                        </div>
                    </div>

                </div>

                <!-- Date -->
                <div class="field">
                    <label for="entryDate">Transaction Date</label>

                    <input type="date"
                           id="entryDate"
                           name="entryDate"
                           required>
                </div>

                <!-- Notes -->
                <div class="field">
                    <label for="notes">Notes (Optional)</label>

                    <textarea id="notes"
                              name="notes"
                              maxlength="500"
                              placeholder="Write a short description about this transaction..."></textarea>
                </div>

                <button type="submit" class="submit-btn">
                    Save Transaction →
                </button>

                <a href="dashboard.jsp" class="cancel">
                    Cancel and return to dashboard
                </a>

            </form>

        </div>

    </section>

</main>

<footer class="footer">
    PocketWise © 2026 | Your money, your decisions.
</footer>

<script>
    // Automatically select today's date.
    document.getElementById("entryDate").value =
        new Date().toLocaleDateString("en-CA");

    // Basic validation before submitting.
    document.getElementById("transactionForm")
        .addEventListener("submit", function(event) {

            const amount = Number(
                document.getElementById("amount").value
            );

            if (!Number.isFinite(amount) || amount <= 0) {
                alert("Please enter a valid amount.");
                event.preventDefault();
            }
        });
</script>

</body>
</html>
