package payrollmanagement;

import java.util.Date;

public class OverTimeBean {
    private int otId;   // matches Overtime_Record.ot_id
    private int empId;
    private int  ApproverEmpId;
    private int otPolicyId;
	private Date otDate;
    private String reason;
    private double hoursWorked;
    private String status;
    private Date payoutCycle;
    private Date approvedAt;
	private Date createdAt;
    private Date updatedAt;

    // --- Getters & Setters ---
    public int getOtId() { return otId; }
    public void setOtId(int otId) { this.otId = otId; }

    public int getEmpId() {
		return empId;
	}
	public void setEmpId(int empId) {
		this.empId = empId;
	}
	

    public int getApproverEmpId() {
		return ApproverEmpId;
	}
	public void setApproverEmpId(int approverEmpId) {
		ApproverEmpId = approverEmpId;
	}
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
    public Date getApprovedAt() {
		return approvedAt;
	}
	public void setApprovedAt(Date approvedAt) {
		this.approvedAt = approvedAt;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public Date getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}


}