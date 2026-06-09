package com.gympro.util;

import java.util.regex.Pattern;

/**
 * Utility class providing validation methods for user input fields.
 */
public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[0-9]{10}$");

    private static final Pattern NAME_PATTERN =
            Pattern.compile("^[A-Za-z\\s]{2,100}$");

    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%^&+=!]).{8,}$");

    /** Checks that a string is not null or blank */
    public static boolean isNotEmpty(String value) {
        return value != null && !value.trim().isEmpty();
    }

    /** Validates email format */
    public static boolean isValidEmail(String email) {
        return isNotEmpty(email) && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    /** Validates 10-digit phone number */
    public static boolean isValidPhone(String phone) {
        return isNotEmpty(phone) && PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    /** Validates name — letters and spaces only */
    public static boolean isValidName(String name) {
        return isNotEmpty(name) && NAME_PATTERN.matcher(name.trim()).matches();
    }

    /**
     * Validates password strength:
     * min 8 chars, uppercase, lowercase, digit, special char.
     */
    public static boolean isValidPassword(String password) {
        return isNotEmpty(password) && PASSWORD_PATTERN.matcher(password).matches();
    }

    /** Validates that a positive integer ID is non-zero */
    public static boolean isValidId(int id) {
        return id > 0;
    }

    /** Trims a string safely, returning empty string if null */
    public static String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}
