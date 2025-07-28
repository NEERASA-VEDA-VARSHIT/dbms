package model;

public class TicketRevenue {
    private String ticketType;
    private double totalRevenue;
    private int ticketsSold;

    public TicketRevenue(String ticketType, double totalRevenue, int ticketsSold) {
        this.ticketType = ticketType;
        this.totalRevenue = totalRevenue;
        this.ticketsSold = ticketsSold;
    }

    public String getTicketType() { return ticketType; }
    public double getTotalRevenue() { return totalRevenue; }
    public int getTicketsSold() { return ticketsSold; }
} 