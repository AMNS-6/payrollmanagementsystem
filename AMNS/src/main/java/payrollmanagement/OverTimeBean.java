package payrollmanagement;

import java.util.Date;

public class OverTimeBean {
    private int otId;   // matches Overtime_Record.ot_id
    
    private Date otDate;
    private String reason;
    private double hoursWorked;
    private String status;
    private int otPolicyId;
    private Date payoutCycle;

    // --- Getters & Setters ---
    public int getOtId() { return otId; }
    public void setOtId(int otId) { this.otId = otId; }

    

    public Date getOtDate() { return otDate; }
    public void setOtDate(Date otDate) { this.otDate = otDate; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public double getHoursWorked() { return hoursWorked; }
    public void setHoursWorked(double hoursWorked) { this.hoursWorked = hoursWorked; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getOtPolicyId() { return otPolicyId; }
    public void setOtPolicyId(int otPolicyId) { this.otPolicyId = otPolicyId; }

    public Date getPayoutCycle() { return payoutCycle; }
    public void setPayoutCycle(Date payoutCycle) { this.payoutCycle = payoutCycle; }
}