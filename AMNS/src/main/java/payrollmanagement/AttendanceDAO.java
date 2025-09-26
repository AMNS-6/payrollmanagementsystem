package payrollmanagement;

import java.util.List;

public interface AttendanceDAO {
    boolean punchIn(int userId);                 // takes userId, resolves to empId
    boolean punchOut(int userId);                // same
    List<AttendanceBean> getAttendanceByEmp(int empId);
    void calculateAttendance(int empId, int year, int month); 
    void processAttendance(int userId, String date); // takes userId, resolves to empId
}