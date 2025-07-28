package model;

public class UserSessionRecord {
    private int sessionId;
    private String sessionTitle;
    private boolean attended;

    public UserSessionRecord(int sessionId, String sessionTitle, boolean attended) {
        this.sessionId = sessionId;
        this.sessionTitle = sessionTitle;
        this.attended = attended;
    }

    public int getSessionId() { return sessionId; }
    public String getSessionTitle() { return sessionTitle; }
    public boolean isAttended() { return attended; }
} 