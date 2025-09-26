package payrollmanagement;


import java.sql.Date;

public class LeaveRequestBean {
    private int empId;
    private int leaveTypeId;
    private Date startDate;
    private Date endDate;
    private String reason;

    // Getters and setters
    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }
    public int getLeaveTypeId() { return leaveTypeId; }
    public void setLeaveTypeId(int leaveTypeId) { this.leaveTypeId = leaveTypeId; }
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}

