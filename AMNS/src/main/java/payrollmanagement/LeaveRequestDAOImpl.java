package payrollmanagement;


import java.sql.*;

public class LeaveRequestDAOImpl {

    public boolean submitLeaveRequest(LeaveRequestBean leave) {
        boolean success = false;
        try (Connection con = ConnectionFactory.getConnection()) {
            CallableStatement cs = con.prepareCall("{CALL sp_request_leave(?, ?, ?, ?, ?)}");
            cs.setInt(1, leave.getEmpId());
            cs.setInt(2, leave.getLeaveTypeId());
            cs.setDate(3, leave.getStartDate());
            cs.setDate(4, leave.getEndDate());
            cs.setString(5, leave.getReason());

            cs.execute();
            success = true;
            System.out.println("✅ Leave request submitted successfully.");
        } catch (SQLException e) {
            System.out.println("❌ Failed to submit leave: " + e.getMessage());
        }
        return success;
    }
}
