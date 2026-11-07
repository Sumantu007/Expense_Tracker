package com.expensetracker.database;

import java.sql.Connection;

public class DBTest {

    public static void main(String[] args) {

        // Try connecting to MySQL
        try {

            Connection con = DBConnection.getConnection();

            // Display successful connection message
            System.out.println("Database Connected Successfully!");

            // Close database connection
            con.close();

        } catch (Exception e) {

            // Display error if connection fails
            System.out.println("Database Connection Failed!");
            e.printStackTrace();
        }
    }
}