package payrollmanagement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OverTimeDAOImpl implements OverTimeDAO {


    // ✅ Apply Overtime using Stored Procedure sp_apply_ot
    @Override
    public int applyOvertime(OverTimeBean bean) throws Exception {
        int newOtId = 0;
        String sql = "{CALL sp_apply_ot(?,?,?,?)}";

        try (Connection con = ConnectionFactory.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, bean.getEmpId()); // You must add empId in OverTimeBean
            cs.setDate(2, new java.sql.Date(bean.getOtDate().getTime()));
            cs.setDouble(3, bean.getHoursWorked());
            cs.setString(4, bean.getReason());

            // Procedure returns new_ot_id
            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    newOtId = rs.getInt("new_ot_id");
                }
            }
        } catch (SQLException e) {
            throw new Exception("Error applying overtime: " + e.getMessage(), e);
        }

        return newOtId;
    }

    // ✅ Approve or Reject Overtime using sp_approve_ot
    @Override
    public String approveOvertime(OverTimeBean bean) throws Exception {
        String resultMessage = null;
        String sql = "{CALL sp_approve_ot(?,?,?,?)}";

        try (Connection con = ConnectionFactory.getConnection();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setInt(1, bean.getOtId());
            cs.setInt(2, bean.getApproverEmpId()); // ✅ HR/Manager empId
            cs.setString(3, bean.getStatus());     // "Approved" or "Rejected"
            cs.setString(4, bean.getReason());     // Remarks

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    resultMessage = rs.getString("result_message");
                }
            }
        } catch (SQLException e) {
            throw new Exception("Error approving overtime: " + e.getMessage(), e);
        }

        return resultMessage;
    }

    // ✅ Calculate Approved OT (Optional Logic)
    @Override
    public OverTimeBean calculateApprovedOvertime(OverTimeBean bean) throws Exception {
        OverTimeBean result = new OverTimeBean();
        String sql = "SELECT SUM(hours_worked) AS total_hours FROM Overtime_Record " +
                     "WHERE emp_id = ? AND status = 'Approved' " +
                     "AND MONTH(ot_date) = MONTH(?) AND YEAR(ot_date) = YEAR(?)";

        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bean.getEmpId());
            ps.setDate(2, new java.sql.Date(bean.getOtDate().getTime()));
            ps.setDate(3, new java.sql.Date(bean.getOtDate().getTime()));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    result.setHoursWorked(rs.getDouble("total_hours"));
                }
            }
        }

        return result;
    }

    // ✅ Fetch all OT records for a specific employee
    @Override
    public List<OverTimeBean> getOvertimeRecordsForEmployee(int empId) throws Exception {
        List<OverTimeBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Overtime_Record WHERE emp_id = ? ORDER BY ot_date DESC";

        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, empId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OverTimeBean bean = new OverTimeBean();
                    bean.setOtId(rs.getInt("ot_id"));
                    bean.setEmpId(rs.getInt("emp_id"));
                    bean.setOtPolicyId(rs.getInt("ot_policy_id"));
                    bean.setOtDate(rs.getDate("ot_date"));
                    bean.setReason(rs.getString("reason"));
                    bean.setHoursWorked(rs.getDouble("hours_worked"));
                    bean.setStatus(rs.getString("status"));
                    bean.setPayoutCycle(rs.getDate("payout_cycle"));
                    list.add(bean);
                }
            }
        }
        return list;
    }

    // ✅ Fetch all pending OT requests (for manager approval)
    @Override
    public List<OverTimeBean> getPendingOvertimeRequests() throws Exception {
        List<OverTimeBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Overtime_Record WHERE status = 'Pending' ORDER BY ot_date DESC";

        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                OverTimeBean bean = new OverTimeBean();
                bean.setOtId(rs.getInt("ot_id"));
                bean.setEmpId(rs.getInt("emp_id"));
                bean.setOtPolicyId(rs.getInt("ot_policy_id"));
                bean.setOtDate(rs.getDate("ot_date"));
                bean.setReason(rs.getString("reason"));
                bean.setHoursWorked(rs.getDouble("hours_worked"));
                bean.setStatus(rs.getString("status"));
                bean.setPayoutCycle(rs.getDate("payout_cycle"));
                list.add(bean);
            }
        }
        return list;
    }
}
