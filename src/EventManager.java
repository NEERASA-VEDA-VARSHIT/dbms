import database.DBUtil;
import database.DatabaseSetup;
import dao.ReportDAO;
import model.*;

import java.sql.Connection;
import java.util.List;
import java.util.Scanner;

public class EventManager {
    
    public static void main(String[] args) {
        System.out.println("=== Event Management JDBC System ===");
        System.out.println();
        
        // Check database connection
        if (!DatabaseSetup.checkDatabaseConnection()) {
            System.err.println("ERROR: Cannot connect to database!");
            System.err.println("Please ensure MySQL is running and the database 'event_management' exists.");
            System.err.println("Database configuration: localhost:3306/event_management");
            System.exit(1);
        }
        
        // Initialize database if needed
        try {
            DatabaseSetup.initializeDatabase();
        } catch (Exception e) {
            System.err.println("Warning: Could not initialize database schema. Proceeding with existing data.");
        }
        
        Scanner scanner = new Scanner(System.in);
        
        while (true) {
            System.out.println("\n=== Available Reports ===");
            System.out.println("1. Sessions at capacity and waitlisted counts");
            System.out.println("2. Revenue by ticket category");
            System.out.println("3. Attendee counts per speaker");
            System.out.println("4. Discount code usage rates");
            System.out.println("5. Average session feedback scores");
            System.out.println("6. Record of sessions attended by a user");
            System.out.println("7. Run all reports");
            System.out.println("0. Exit");
            System.out.print("\nEnter your choice (0-7): ");
            
            int choice = scanner.nextInt();
            
            try (Connection conn = DBUtil.getConnection()) {
                switch (choice) {
                    case 1:
                        displaySessionsAtCapacity(conn);
                        break;
                    case 2:
                        displayRevenueByTicketCategory(conn);
                        break;
                    case 3:
                        displayAttendeeCountsPerSpeaker(conn);
                        break;
                    case 4:
                        displayDiscountCodeUsageRates(conn);
                        break;
                    case 5:
                        displayAverageSessionFeedbackScores(conn);
                        break;
                    case 6:
                        displaySessionsAttendedByUser(conn, scanner);
                        break;
                    case 7:
                        displayAllReports(conn);
                        break;
                    case 0:
                        System.out.println("Thank you for using Event Management System!");
                        return;
                    default:
                        System.out.println("Invalid choice. Please try again.");
                }
            } catch (Exception e) {
                System.err.println("Error: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
    
    private static void displaySessionsAtCapacity(Connection conn) throws Exception {
        System.out.println("\n=== Sessions at Capacity and Waitlisted Counts ===");
        List<SessionCapacityInfo> sessions = ReportDAO.getSessionsAtCapacityAndWaitlist(conn);
        
        if (sessions.isEmpty()) {
            System.out.println("No sessions found at capacity or with waitlist.");
        } else {
            System.out.printf("%-10s | %-30s | %-8s | %-15s | %-12s%n", 
                "Session ID", "Title", "Capacity", "Confirmed", "Waitlist");
            System.out.println("=".repeat(80));
            
            for (SessionCapacityInfo s : sessions) {
                System.out.printf("%-10d | %-30s | %-8d | %-15d | %-12d%n",
                    s.getSessionId(), 
                    truncateString(s.getTitle(), 30), 
                    s.getCapacity(),
                    s.getConfirmedCount(), 
                    s.getWaitlistCount());
            }
        }
    }
    
    private static void displayRevenueByTicketCategory(Connection conn) throws Exception {
        System.out.println("\n=== Revenue by Ticket Category ===");
        List<TicketRevenue> revenues = ReportDAO.getRevenueByTicketCategory(conn);
        
        if (revenues.isEmpty()) {
            System.out.println("No revenue data found.");
        } else {
            System.out.printf("%-20s | %-15s | %-12s%n", "Ticket Type", "Total Revenue", "Tickets Sold");
            System.out.println("=".repeat(50));
            
            double totalRevenue = 0;
            int totalTickets = 0;
            
            for (TicketRevenue r : revenues) {
                System.out.printf("%-20s | $%-14.2f | %-12d%n",
                    r.getTicketType(), r.getTotalRevenue(), r.getTicketsSold());
                totalRevenue += r.getTotalRevenue();
                totalTickets += r.getTicketsSold();
            }
            
            System.out.println("-".repeat(50));
            System.out.printf("%-20s | $%-14.2f | %-12d%n", "TOTAL", totalRevenue, totalTickets);
        }
    }
    
    private static void displayAttendeeCountsPerSpeaker(Connection conn) throws Exception {
        System.out.println("\n=== Attendee Counts per Speaker ===");
        List<SpeakerAttendeeCount> speakerCounts = ReportDAO.getAttendeeCountsPerSpeaker(conn);
        
        if (speakerCounts.isEmpty()) {
            System.out.println("No speaker data found.");
        } else {
            System.out.printf("%-10s | %-30s | %-15s%n", "Speaker ID", "Speaker Name", "Attendee Count");
            System.out.println("=".repeat(60));
            
            for (SpeakerAttendeeCount sc : speakerCounts) {
                System.out.printf("%-10d | %-30s | %-15d%n",
                    sc.getSpeakerId(), 
                    truncateString(sc.getSpeakerName(), 30), 
                    sc.getAttendeeCount());
            }
        }
    }
    
    private static void displayDiscountCodeUsageRates(Connection conn) throws Exception {
        System.out.println("\n=== Discount Code Usage Rates ===");
        List<DiscountCodeUsage> discountCodes = ReportDAO.getDiscountCodeUsageRates(conn);
        
        if (discountCodes.isEmpty()) {
            System.out.println("No discount codes found.");
        } else {
            System.out.printf("%-15s | %-12s | %-12s | %-10s%n", "Code", "Times Used", "Usage Limit", "Usage %");
            System.out.println("=".repeat(55));
            
            for (DiscountCodeUsage d : discountCodes) {
                double usagePercent = (double) d.getTimesUsed() / d.getUsageLimit() * 100;
                System.out.printf("%-15s | %-12d | %-12d | %-8.1f%%%n",
                    d.getCode(), d.getTimesUsed(), d.getUsageLimit(), usagePercent);
            }
        }
    }
    
    private static void displayAverageSessionFeedbackScores(Connection conn) throws Exception {
        System.out.println("\n=== Average Session Feedback Scores ===");
        List<SessionFeedbackScore> feedbackScores = ReportDAO.getAverageSessionFeedbackScores(conn);
        
        if (feedbackScores.isEmpty()) {
            System.out.println("No feedback data found.");
        } else {
            System.out.printf("%-10s | %-30s | %-15s%n", "Session ID", "Session Title", "Average Score");
            System.out.println("=".repeat(60));
            
            for (SessionFeedbackScore f : feedbackScores) {
                if (f.getAverageScore() > 0) {
                    System.out.printf("%-10d | %-30s | %-15.2f%n",
                        f.getSessionId(), 
                        truncateString(f.getSessionTitle(), 30), 
                        f.getAverageScore());
                }
            }
        }
    }
    
    private static void displaySessionsAttendedByUser(Connection conn, Scanner scanner) throws Exception {
        System.out.print("\nEnter user ID to view sessions: ");
        int userId = scanner.nextInt();
        
        System.out.println("\n=== Sessions Attended by User (ID: " + userId + ") ===");
        List<UserSessionRecord> userSessions = ReportDAO.getSessionsAttendedByUser(conn, userId);
        
        if (userSessions.isEmpty()) {
            System.out.println("No sessions found for user ID: " + userId);
        } else {
            System.out.printf("%-10s | %-30s | %-10s%n", "Session ID", "Session Title", "Attended");
            System.out.println("=".repeat(55));
            
            for (UserSessionRecord us : userSessions) {
                System.out.printf("%-10d | %-30s | %-10s%n",
                    us.getSessionId(), 
                    truncateString(us.getSessionTitle(), 30), 
                    us.isAttended() ? "Yes" : "No");
            }
        }
    }
    
    private static void displayAllReports(Connection conn) throws Exception {
        System.out.println("\n" + "=".repeat(80));
        System.out.println("RUNNING ALL REPORTS");
        System.out.println("=".repeat(80));
        
        displaySessionsAtCapacity(conn);
        displayRevenueByTicketCategory(conn);
        displayAttendeeCountsPerSpeaker(conn);
        displayDiscountCodeUsageRates(conn);
        displayAverageSessionFeedbackScores(conn);
        
        System.out.println("\n" + "=".repeat(80));
        System.out.println("ALL REPORTS COMPLETED");
        System.out.println("=".repeat(80));
    }
    
    private static String truncateString(String str, int maxLength) {
        if (str.length() <= maxLength) {
            return str;
        }
        return str.substring(0, maxLength - 3) + "...";
    }
} 