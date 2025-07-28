package model;

public class DiscountCodeUsage {
    private String code;
    private int timesUsed;
    private int usageLimit;

    public DiscountCodeUsage(String code, int timesUsed, int usageLimit) {
        this.code = code;
        this.timesUsed = timesUsed;
        this.usageLimit = usageLimit;
    }

    public String getCode() { return code; }
    public int getTimesUsed() { return timesUsed; }
    public int getUsageLimit() { return usageLimit; }
} 