package com.expensetracker.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.expensetracker.database.DBConnection;
import com.expensetracker.model.Transaction;

public class TransactionDAO {

    // Add income or expense
    public void add(int userId, String type, String title, String category,
                    BigDecimal amount, Date date, String notes) throws Exception {

        String sql = "INSERT INTO transactions "
                + "(user_id, entry_type, title, category, amount, entry_date, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, type);
            ps.setString(3, title);
            ps.setString(4, category);
            ps.setBigDecimal(5, amount);
            ps.setDate(6, date);
            ps.setString(7, notes);

            ps.executeUpdate();
        }
    }

    // Get all transactions for one user
    public List<Transaction> findByUser(int userId) throws Exception {

        List<Transaction> rows = new ArrayList<Transaction>();

        String sql = "SELECT * FROM transactions WHERE user_id = ? "
                + "ORDER BY entry_date DESC, id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    rows.add(new Transaction(
                            rs.getInt("id"),
                            rs.getInt("user_id"),
                            rs.getString("entry_type"),
                            rs.getString("title"),
                            rs.getString("category"),
                            rs.getBigDecimal("amount"),
                            rs.getDate("entry_date"),
                            rs.getString("notes")
                    ));
                }
            }
        }

        return rows;
    }

    // Calculate total income or expenses
    public BigDecimal totalFor(int userId, String type) throws Exception {

        String sql = "SELECT COALESCE(SUM(amount), 0) AS total "
                + "FROM transactions WHERE user_id = ? AND entry_type = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, type);

            try (ResultSet rs = ps.executeQuery()) {
                rs.next();
                return rs.getBigDecimal("total");
            }
        }
    }

    // Find one transaction belonging to the logged-in user
    public Transaction findById(int transactionId, int userId) throws Exception {

        String sql = "SELECT * FROM transactions WHERE id = ? AND user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, transactionId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return new Transaction(
                            rs.getInt("id"),
                            rs.getInt("user_id"),
                            rs.getString("entry_type"),
                            rs.getString("title"),
                            rs.getString("category"),
                            rs.getBigDecimal("amount"),
                            rs.getDate("entry_date"),
                            rs.getString("notes")
                    );
                }
            }
        }

        return null;
    }

    // Update an existing income or expense
    public boolean update(int transactionId, int userId, String type,
                          String title, String category, BigDecimal amount,
                          Date date, String notes) throws Exception {

        String sql = "UPDATE transactions SET entry_type = ?, title = ?, "
                + "category = ?, amount = ?, entry_date = ?, notes = ? "
                + "WHERE id = ? AND user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, type);
            ps.setString(2, title);
            ps.setString(3, category);
            ps.setBigDecimal(4, amount);
            ps.setDate(5, date);
            ps.setString(6, notes);
            ps.setInt(7, transactionId);
            ps.setInt(8, userId);

            return ps.executeUpdate() > 0;
        }
    }

    // Delete an income or expense
    public boolean deleteById(int transactionId, int userId) throws Exception {

        String sql = "DELETE FROM transactions WHERE id = ? AND user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, transactionId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        }
    }
}