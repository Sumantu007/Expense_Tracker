
package com.expensetracker.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // MySQL database details.
    private static final String DB_URL =
        "jdbc:mysql://localhost:3306/expense_tracker?useSSL=false&serverTimezone=UTC";

    private static final String DB_USER = "root";

    // Replace this with your actual MySQL password.
    private static final String DB_PASSWORD = "SUMANTU@007";

    // Create a connection with MySQL.
    public static Connection getConnection() throws SQLException {

        try {
            // Load the MySQL JDBC driver.
            Class.forName("com.mysql.cj.jdbc.Driver");

        } catch (ClassNotFoundException e) {
            throw new SQLException(
                "MySQL JDBC Driver not found. Add MySQL Connector/J.",
                e
            );
        }

        return DriverManager.getConnection(
            DB_URL,
            DB_USER,
            DB_PASSWORD
        );
    }
}
