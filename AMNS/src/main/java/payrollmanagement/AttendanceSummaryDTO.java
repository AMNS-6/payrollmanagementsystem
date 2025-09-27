package payrollmanagement;

public class AttendanceSummaryDTO {
    private int totalDays;
    private int presentDays;
    private int leaveDays;
    private int holidayDays;
    private int sundayDays;
    private int absentDays;
    private double overtimeHours;

    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }

    public int getPresentDays() { return presentDays; }
    public void setPresentDays(int presentDays) { this.presentDays = presentDays; }

    public int getLeaveDays() { return leaveDays; }
    public void setLeaveDays(int leaveDays) { this.leaveDays = leaveDays; }

    public int getHolidayDays() { return holidayDays; }
    public void setHolidayDays(int holidayDays) { this.holidayDays = holidayDays; }

    public int getSundayDays() { return sundayDays; }
    public void setSundayDays(int sundayDays) { this.sundayDays = sundayDays; }

    public int getAbsentDays() { return absentDays; }
    public void setAbsentDays(int absentDays) { this.absentDays = absentDays; }

    public double getOvertimeHours() { return overtimeHours; }
    public void setOvertimeHours(double overtimeHours) { this.overtimeHours = overtimeHours; }
}