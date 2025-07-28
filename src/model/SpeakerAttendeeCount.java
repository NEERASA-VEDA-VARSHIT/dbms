package model;

public class SpeakerAttendeeCount {
    private int speakerId;
    private String speakerName;
    private int attendeeCount;

    public SpeakerAttendeeCount(int speakerId, String speakerName, int attendeeCount) {
        this.speakerId = speakerId;
        this.speakerName = speakerName;
        this.attendeeCount = attendeeCount;
    }

    public int getSpeakerId() { return speakerId; }
    public String getSpeakerName() { return speakerName; }
    public int getAttendeeCount() { return attendeeCount; }
} 