package payrollmanagement;

import java.sql.Timestamp;

public class PayrollRunBean {
    private int payrollId;
    private int empId;
    private Integer structureId;
    private String monthYear;

    private int totalDays;
    private int presentDays;
    private int leaveDays;
    private int holidayDays;

    private double otHours;
    private double otAmount;

    private double grossSalary;
    private double totalAllowances;
    private double totalDeductions;
    private double netSalary;

    private String status;
    private Timestamp processedAt;
    private Timestamp paidAt;

    // --- Getters and Setters ---
    public int getPayrollId() { return payrollId; }
    public void setPayrollId(int payrollId) { this.payrollId = payrollId; }

    public int getEmpId() { return empId; }
    public void setEmpId(int empId) { this.empId = empId; }

    public Integer getStructureId() { return structureId; }
    public void setStructureId(Integer structureId) { this.structureId = structureId; }

    public String getMonthYear() { return monthYear; }
    public void setMonthYear(String monthYear) { this.monthYear = monthYear; }

    public int getTotalDays() { return totalDays; }
    public void setTotalDays(int totalDays) { this.totalDays = totalDays; }

    public int getPresentDays() { return presentDays; }
    public void setPresentDays(int presentDays) { this.presentDays = presentDays; }

    public int getLeaveDays() { return leaveDays; }
    public void setLeaveDays(int leaveDays) { this.leaveDays = leaveDays; }

    public int getHolidayDays() { return holidayDays; }
    public void setHolidayDays(int holidayDays) { this.holidayDays = holidayDays; }

    public double getOtHours() { return otHours; }
    public void setOtHours(double otHours) { this.otHours = otHours; }

    public double getOtAmount() { return otAmount; }
    public void setOtAmount(double otAmount) { this.otAmount = otAmount; }

    public double getGrossSalary() { return grossSalary; }
    public void setGrossSalary(double grossSalary) { this.grossSalary = grossSalary; }

    public double getTotalAllowances() { return totalAllowances; }
    public void setTotalAllowances(double totalAllowances) { this.totalAllowances = totalAllowances; }

    public double getTotalDeductions() { return totalDeductions; }
    public void setTotalDeductions(double totalDeductions) { this.totalDeductions = totalDeductions; }

    public double getNetSalary() { return netSalary; }
    public void setNetSalary(double netSalary) { this.netSalary = netSalary; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getProcessedAt() { return processedAt; }
    public void setProcessedAt(Timestamp processedAt) { this.processedAt = processedAt; }

    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }
}

