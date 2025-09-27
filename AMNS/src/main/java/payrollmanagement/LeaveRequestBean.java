package payrollmanagement;

public class LeaveRequestBean {
    private int empId;
    private String name;
    private String leaveType;
    private String fromDate;
    private String toDate;
    private String fromHalf;
    private String toHalf;
    private double noOfDays;
    private int creditDays;
    private String reason;
    private String status;

    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLeaveType() { return leaveType; }
    public void setLeaveType(String leaveType) { this.leaveType = leaveType; }

    public String getFromDate() { return fromDate; }
    public void setFromDate(String fromDate) { this.fromDate = fromDate; }

    public String getToDate() { return toDate; }
    public void setToDate(String toDate) { this.toDate = toDate; }

    public String getFromHalf() { return fromHalf; }
    public void setFromHalf(String fromHalf) { this.fromHalf = fromHalf; }

    public String getToHalf() { return toHalf; }
    public void setToHalf(String toHalf) { this.toHalf = toHalf; }

    public double getNoOfDays() { return noOfDays; }
    public void setNoOfDays(double noOfDays) { this.noOfDays = noOfDays; }

    public int getCreditDays() { return creditDays; }
    public void setCreditDays(int creditDays) { this.creditDays = creditDays; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}