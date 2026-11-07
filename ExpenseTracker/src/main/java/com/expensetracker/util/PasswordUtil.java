
package com.expensetracker.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class PasswordUtil {

    // Number of iterations used for password hashing.
    private static final int ITERATIONS = 120000;

    // Length of the generated password hash in bits.
    private static final int KEY_LENGTH = 256;

    // Generate a secure password hash with a random salt.
    public static String hashPassword(String password) throws Exception {

        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be empty");
        }

        // Create a random 16-byte salt.
        byte[] salt = new byte[16];
        SecureRandom random = new SecureRandom();
        random.nextBytes(salt);

        // Generate the password hash.
        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(),
                salt,
                ITERATIONS,
                KEY_LENGTH
        );

        byte[] hash;

        try {
            SecretKeyFactory factory =
                    SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

            hash = factory.generateSecret(spec).getEncoded();

        } finally {
            spec.clearPassword();
        }

        // Store salt and hash together.
        String encodedSalt = Base64.getEncoder().encodeToString(salt);
        String encodedHash = Base64.getEncoder().encodeToString(hash);

        return encodedSalt + ":" + encodedHash;
    }

    // Check whether the entered password matches the saved password hash.
    public static boolean matches(String password, String savedValue)
            throws Exception {

        if (password == null || savedValue == null) {
            return false;
        }

        String[] parts = savedValue.split(":", -1);

        if (parts.length != 2) {
            return false;
        }

        try {
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] savedHash = Base64.getDecoder().decode(parts[1]);

            if (salt.length != 16 || savedHash.length != KEY_LENGTH / 8) {
                return false;
            }

            PBEKeySpec spec = new PBEKeySpec(
                    password.toCharArray(),
                    salt,
                    ITERATIONS,
                    KEY_LENGTH
            );

            byte[] enteredHash;

            try {
                SecretKeyFactory factory =
                        SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");

                enteredHash = factory.generateSecret(spec).getEncoded();

            } finally {
                spec.clearPassword();
            }

            // Compare hashes securely.
            return MessageDigest.isEqual(savedHash, enteredHash);

        } catch (IllegalArgumentException e) {
            // Invalid Base64 data in the saved password.
            return false;
        }
    }
}
