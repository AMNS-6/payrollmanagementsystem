package payrollmanagement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LeaveApprovalDAOImpl implements LeaveApprovalDAO {

    @Override
    public List<LeaveApprovalBean> getAllLeaves() throws Exception {
        List<LeaveApprovalBean> leaveList = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = ConnectionFactory.getConnection();

            String sql = "SELECT l.leave_id, l.emp_id, CONCAT(e.first_name, ' ', e.last_name) AS emp_name, " +
                         "l.leave_type_id, p.leave_name, l.start_date, l.end_date, l.number_of_days, l.reason, l.status, l.remarks " +
                         "FROM leave_application l " +
                         "JOIN employee_master e ON l.emp_id = e.emp_id " +
                         "JOIN leave_policy p ON l.leave_type_id = p.leave_type_id " +
                         "ORDER BY l.start_date DESC";

            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                LeaveApprovalBean leave = new LeaveApprovalBean();
                leave.setLeaveId(rs.getInt("leave_id"));
                leave.setEmpId(rs.getInt("emp_id"));
                leave.setEmployeeName(rs.getString("emp_name"));
                leave.setLeaveTypeId(rs.getInt("leave_type_id"));
                leave.setLeaveType(rs.getString("leave_name"));
                leave.setStartDate(rs.getDate("start_date"));
                leave.setEndDate(rs.getDate("end_date"));
                leave.setNumberOfDays(rs.getDouble("number_of_days"));
                leave.setReason(rs.getString("reason"));
                leave.setStatus(rs.getString("status"));
                leave.setRemarks(rs.getString("remarks"));

                leaveList.add(leave);
            }

        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }

        return leaveList;
    }
    @Override
    public boolean updateLeaveStatus(int leaveId, String status, String remarks) throws Exception {
        boolean success = false;
        String sql = "UPDATE leave_application SET status = ?, remarks = ?, updated_at = NOW() WHERE leave_id = ?";

        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, remarks);
            ps.setInt(3, leaveId);

            success = ps.executeUpdate() > 0;
        }
        return success;
    }

}
