package payrollmanagement;

import java.util.Date;

public class AttendanceBean {
private int attendanceId;
private int empId;
private String empName;
private Date attendanceDate;
private Date firstIn;
private Date lastOut;
double totalWorkHours;
private double overtimeHours;
private String status;

// --- Getters & Setters ---
public int getAttendanceId() {
return attendanceId;
}
public void setAttendanceId(int attendanceId) {
this.attendanceId = attendanceId;
}

public int getEmpId() {
return empId;
}
public void setEmpId(int empId) {
this.empId = empId;
}
public String getEmpName() { 
        return empName; 
}
public void setEmpName(String empName) { 
    this.empName = empName; 
 }

public Date getAttendanceDate() {
return attendanceDate;
}
public void setAttendanceDate(Date attendanceDate) {
this.attendanceDate = attendanceDate;
}

public Date getFirstIn() {
return firstIn;
}
public void setFirstIn(Date firstIn) {
this.firstIn = firstIn;
}

public Date getLastOut() { return lastOut; }
public void setLastOut(Date lastOut) { this.lastOut = lastOut; }

public double getTotalWorkHours() { return totalWorkHours; }
public void setTotalWorkHours(double totalWorkHours) { this.totalWorkHours = totalWorkHours; }

public double getOvertimeHours() { return overtimeHours; }
public void setOvertimeHours(double overtimeHours) { this.overtimeHours = overtimeHours; }

public String getStatus() { return status; }
public void setStatus(String status) { this.status = status; }
}