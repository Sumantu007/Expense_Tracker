package com.expensetracker.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
        "jdbc:mysql://localhost:3306/expense_tracker?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

    private static final String USER = "root";

    private static final String PASSWORD = "SUMANTU@007";

    public static Connection getConnection() {

        Connection con = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DriverManager.getConnection(
                URL,
                USER,
                PASSWORD
            );

            System.out.println("MySQL Connected Successfully!");

        } catch (ClassNotFoundException | SQLException e) {

            e.printStackTrace();

        }

        return con;
    }
}