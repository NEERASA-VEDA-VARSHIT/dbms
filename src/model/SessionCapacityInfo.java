package model;

public class SessionCapacityInfo {
    private int sessionId;
    private String title;
    private int capacity;
    private int confirmedCount;
    private int waitlistCount;

    public SessionCapacityInfo(int sessionId, String title, int capacity, int confirmedCount, int waitlistCount) {
        this.sessionId = sessionId;
        this.title = title;
        this.capacity = capacity;
        this.confirmedCount = confirmedCount;
        this.waitlistCount = waitlistCount;
    }

    public int getSessionId() { return sessionId; }
    public String getTitle() { return title; }
    public int getCapacity() { return capacity; }
    public int getConfirmedCount() { return confirmedCount; }
    public int getWaitlistCount() { return waitlistCount; }
} 