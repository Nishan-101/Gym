package com.gympro.util;

import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 * Utility class for date formatting and conversion.
 */
public class DateUtil {

    private static final String DATE_FORMAT     = "yyyy-MM-dd";
    private static final String DISPLAY_FORMAT  = "dd MMM yyyy";

    /**
     * Parses a date string (yyyy-MM-dd) into a java.sql.Date.
     * Returns null if parsing fails.
     */
    public static Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
            sdf.setLenient(false);
            java.util.Date parsed = sdf.parse(dateStr.trim());
            return new Date(parsed.getTime());
        } catch (ParseException e) {
            return null;
        }
    }

    /**
     * Formats a java.sql.Date to a human-readable string (dd MMM yyyy).
     */
    public static String formatDate(Date date) {
        if (date == null) return "";
        return new SimpleDateFormat(DISPLAY_FORMAT).format(date);
    }

    /**
     * Adds months to a java.sql.Date and returns the new date.
     */
    public static Date addMonths(Date date, int months) {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.setTime(date);
        cal.add(java.util.Calendar.MONTH, months);
        return new Date(cal.getTimeInMillis());
    }
}
