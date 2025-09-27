package payrollmanagement;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LeaveRequestDAOImpl implements LeaveRequestDAO {

    // Apply new leave
    @Override
    public boolean applyLeave(LeaveRequestBean leave) {
        boolean success = false;
        String sql = "INSERT INTO leave_application "
                   + "(emp_id, leave_type_id, start_date, end_date, number_of_days, reason, status, applied_at, created_at, updated_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, NOW(), NOW(), NOW())";

        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, leave.getEmpId());
            ps.setInt(2, getLeaveTypeId(leave.getLeaveType()));  // Map leave type string to id
            ps.setString(3, leave.getFromDate());
            ps.setString(4, leave.getToDate());
            ps.setDouble(5, leave.getNoOfDays());
            ps.setString(6, leave.getReason());
            ps.setString(7, leave.getStatus());

            int rows = ps.executeUpdate();
            success = rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    // Get emp_id from user_id
    @Override
    public int getEmpIdByUserId(int userId) {
        int empId = 0;
        String sql = "SELECT emp_id FROM employee_master WHERE user_id = ?";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    empId = rs.getInt("emp_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return empId;
    }

    // Fetch applied leaves for a user (by user_id)
    @Override
    public List<LeaveRequestBean> getLeavesByEmpId(int userId) {
        List<LeaveRequestBean> list = new ArrayList<>();
        String sql = "SELECT la.emp_id, la.leave_type_id, la.start_date, la.end_date, la.number_of_days, "
                   + "la.reason, la.status, e.first_name, e.last_name "
                   + "FROM leave_application la "
                   + "JOIN employee_master e ON la.emp_id = e.emp_id "
                   + "JOIN users u ON e.user_id = u.user_id "
                   + "WHERE u.user_id = ? "
                   + "ORDER BY la.applied_at DESC";

        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                LeaveRequestBean l = new LeaveRequestBean();
                l.setEmpId(rs.getInt("emp_id"));
                l.setName(rs.getString("first_name") + " " + rs.getString("last_name"));
                l.setLeaveType(getLeaveTypeName(rs.getInt("leave_type_id")));  // Map id back to string
                l.setFromDate(rs.getString("start_date"));
                l.setToDate(rs.getString("end_date"));
                l.setNoOfDays(rs.getDouble("number_of_days"));
                l.setReason(rs.getString("reason"));
                l.setStatus(rs.getString("status"));

                // Optional placeholders for UI - adjust if your schema supports half days
                l.setCreditDays((int) rs.getDouble("number_of_days"));
                l.setFromHalf("First Half");
                l.setToHalf("Second Half");

                list.add(l);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Map leave type string (like "EL") to leave_type_id (int)
    private int getLeaveTypeId(String type) {
        switch (type) {
            case "EL": return 1;
            case "CL": return 2;
            case "SL": return 3;
            case "OD": return 4;
            case "ML": return 5;
            case "PL": return 6;
            default: return 0;
        }
    }

    // Map leave_type_id (int) back to leave type string
    private String getLeaveTypeName(int id) {
        switch (id) {
            case 1: return "EL";
            case 2: return "CL";
            case 3: return "SL";
            case 4: return "OD";
            case 5: return "ML";
            case 6: return "PL";
            default: return "Unknown";
        }
    }
}