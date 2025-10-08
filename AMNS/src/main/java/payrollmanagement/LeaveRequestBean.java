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

    // Emp ID
    public int getEmpId() {
        return empId;
    }
    public void setEmpId(int empId) {
        this.empId = empId;
    }

    // Employee Name
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    // Leave Type (EL/CL/SL etc)
    public String getLeaveType() {
        return leaveType;
    }
    public void setLeaveType(String leaveType) {
        this.leaveType = leaveType;
    }

    // From Date
    public String getFromDate() {
        return fromDate;
    }
    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    // To Date
    public String getToDate() {
        return toDate;
    }
    public void setToDate(String toDate) {
        this.toDate = toDate;
    }

    // From Half (First/Second Half)
    public String getFromHalf() {
        return fromHalf;
    }
    public void setFromHalf(String fromHalf) {
        this.fromHalf = fromHalf;
    }

    // To Half (First/Second Half)
    public String getToHalf() {
        return toHalf;
    }
    public void setToHalf(String toHalf) {
        this.toHalf = toHalf;
    }

    // Number of Days
    public double getNoOfDays() {
        return noOfDays;
    }
    public void setNoOfDays(double noOfDays) {
        this.noOfDays = noOfDays;
    }

    // Credit Days (static in JSP)
    public int getCreditDays() {
        return creditDays;
    }
    public void setCreditDays(int creditDays) {
        this.creditDays = creditDays;
    }

    // Reason
    public String getReason() {
        return reason;
    }
    public void setReason(String reason) {
        this.reason = reason;
    }

    // Status (Pending/Approved/Rejected)
    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }
}
