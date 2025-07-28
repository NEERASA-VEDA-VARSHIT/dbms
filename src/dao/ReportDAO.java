package dao;

import model.SessionCapacityInfo;
import java.sql.*;
import java.util.*;
import model.TicketRevenue;
import model.SpeakerAttendeeCount;
import model.DiscountCodeUsage;
import model.SessionFeedbackScore;
import model.UserSessionRecord;

public class ReportDAO {
    public static List<SessionCapacityInfo> getSessionsAtCapacityAndWaitlist(Connection conn) throws SQLException {
        String sql = "SELECT s.session_id, s.title, s.capacity, " +
                     "SUM(CASE WHEN se.status = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_count, " +
                     "SUM(CASE WHEN se.status = 'waitlist' THEN 1 ELSE 0 END) AS waitlist_count " +
                     "FROM session s " +
                     "LEFT JOIN session_enrollment se ON s.session_id = se.session_id " +
                     "GROUP BY s.session_id, s.title, s.capacity " +
                     "HAVING confirmed_count >= s.capacity OR waitlist_count > 0";
        List<SessionCapacityInfo> result = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                result.add(new SessionCapacityInfo(
                    rs.getInt("session_id"),
                    rs.getString("title"),
                    rs.getInt("capacity"),
                    rs.getInt("confirmed_count"),
                    rs.getInt("waitlist_count")
                ));
            }
        }
        return result;
    }

    // Revenue by ticket category
    public static List<TicketRevenue> getRevenueByTicketCategory(Connection conn) throws SQLException {
        String sql = "SELECT tt.name AS ticket_type, SUM(r.amount_paid) AS total_revenue, COUNT(*) AS tickets_sold " +
                     "FROM ticket_type tt " +
                     "LEFT JOIN registration r ON tt.ticket_type_id = r.ticket_type_id " +
                     "GROUP BY tt.name";
        List<TicketRevenue> result = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                result.add(new TicketRevenue(
                    rs.getString("ticket_type"),
                    rs.getDouble("total_revenue"),
                    rs.getInt("tickets_sold")
                ));
            }
        }
        return result;
    }

    // Attendee counts per speaker
    public static List<SpeakerAttendeeCount> getAttendeeCountsPerSpeaker(Connection conn) throws SQLException {
        String sql = "SELECT sp.speaker_id, s.name AS speaker_name, COUNT(DISTINCT se.registration_id) AS attendee_count " +
                     "FROM speaker s " +
                     "JOIN session_speaker sp ON s.speaker_id = sp.speaker_id " +
                     "JOIN session sess ON sp.session_id = sess.session_id " +
                     "LEFT JOIN session_enrollment se ON sess.session_id = se.session_id AND se.status = 'confirmed' " +
                     "GROUP BY sp.speaker_id, s.name";
        List<SpeakerAttendeeCount> result = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                result.add(new SpeakerAttendeeCount(
                    rs.getInt("speaker_id"),
                    rs.getString("speaker_name"),
                    rs.getInt("attendee_count")
                ));
            }
        }
        return result;
    }

    // Discount code usage rates
    public static List<DiscountCodeUsage> getDiscountCodeUsageRates(Connection conn) throws SQLException {
        String sql = "SELECT dc.code, dc.used AS times_used, dc.usage_limit FROM discount_code dc";
        List<DiscountCodeUsage> result = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                result.add(new DiscountCodeUsage(
                    rs.getString("code"),
                    rs.getInt("times_used"),
                    rs.getInt("usage_limit")
                ));
            }
        }
        return result;
    }

    // Average session feedback scores
    public static List<SessionFeedbackScore> getAverageSessionFeedbackScores(Connection conn) throws SQLException {
        String sql = "SELECT s.session_id, s.title AS session_title, AVG(f.rating) AS average_score " +
                     "FROM session s " +
                     "LEFT JOIN feedback f ON s.session_id = f.session_id " +
                     "GROUP BY s.session_id, s.title";
        List<SessionFeedbackScore> result = new ArrayList<>();
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                result.add(new SessionFeedbackScore(
                    rs.getInt("session_id"),
                    rs.getString("session_title"),
                    rs.getDouble("average_score")
                ));
            }
        }
        return result;
    }

    // Record of sessions attended by a user
    public static List<UserSessionRecord> getSessionsAttendedByUser(Connection conn, int userId) throws SQLException {
        String sql = "SELECT s.session_id, s.title AS session_title, se.attended " +
                     "FROM session s " +
                     "JOIN session_enrollment se ON s.session_id = se.session_id " +
                     "JOIN registration r ON se.registration_id = r.registration_id " +
                     "WHERE r.user_id = ?";
        List<UserSessionRecord> result = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    result.add(new UserSessionRecord(
                        rs.getInt("session_id"),
                        rs.getString("session_title"),
                        rs.getBoolean("attended")
                    ));
                }
            }
        }
        return result;
    }
} 