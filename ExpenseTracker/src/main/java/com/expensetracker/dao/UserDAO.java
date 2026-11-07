
package com.expensetracker.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.expensetracker.database.DBConnection;
import com.expensetracker.model.User;
import com.expensetracker.util.PasswordUtil;

public class UserDAO {

    // Check whether email already exists.
    public boolean emailExists(String email) throws Exception {

        String sql = "SELECT id FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // Register a new user.
    public boolean registerUser(User user) throws Exception {

        String sql = "INSERT INTO users "
                + "(full_name, email, password_hash) VALUES (?, ?, ?)";

        String hashedPassword =
                PasswordUtil.hashPassword(user.getPassword());

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPassword);

            return ps.executeUpdate() > 0;
        }
    }

    // Get saved password hash using email.
    public String getPasswordHash(String email) throws Exception {

        String sql = "SELECT password_hash FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getString("password_hash");
                }
            }
        }

        return null;
    }

    // Get user ID using email.
    public Integer getUserId(String email) throws Exception {

        String sql = "SELECT id FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }

        return null;
    }
}
