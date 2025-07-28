package model;

public class SessionFeedbackScore {
    private int sessionId;
    private String sessionTitle;
    private double averageScore;

    public SessionFeedbackScore(int sessionId, String sessionTitle, double averageScore) {
        this.sessionId = sessionId;
        this.sessionTitle = sessionTitle;
        this.averageScore = averageScore;
    }

    public int getSessionId() { return sessionId; }
    public String getSessionTitle() { return sessionTitle; }
    public double getAverageScore() { return averageScore; }
} 