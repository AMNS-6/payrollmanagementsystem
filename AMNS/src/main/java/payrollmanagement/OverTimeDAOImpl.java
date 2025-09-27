package payrollmanagement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OverTimeDAOImpl implements OverTimeDAO {

    private Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/payrollmanagement", "root", "santhoshi");
    }

    @Override
    public int applyOvertime(OverTimeBean bean) throws Exception {
        int otId = 0;
        try (Connection con = getConnection();
             CallableStatement cs = con.prepareCall("{CALL sp_apply_ot(?,?,?,?)}")) {
          
            cs.setDate(2, new java.sql.Date(bean.getOtDate().getTime()));
            cs.setDouble(3, bean.getHoursWorked());
            cs.setString(4, bean.getReason());

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    otId = rs.getInt("new_ot_id");
                }
            }
        }
        return otId;
    }

    @Override
    public String approveOvertime(OverTimeBean bean) throws Exception {
        String result = null;
        try (Connection con = getConnection();
             CallableStatement cs = con.prepareCall("{CALL sp_approve_ot(?,?,?,?)}")) {
            cs.setInt(1, bean.getOtId());        // ✅ correct
                
            cs.setString(3, bean.getStatus());
            cs.setString(4, bean.getReason());

            try (ResultSet rs = cs.executeQuery()) {
                if (rs.next()) {
                    result = rs.getString("result_message");
                }
            }
        }
        return result;
    }

    @Override
    public OverTimeBean calculateApprovedOvertime(OverTimeBean bean) throws Exception {
        OverTimeBean resultBean = new OverTimeBean();
        try (Connection con = getConnection();
             CallableStatement cs = con.prepareCall("{CALL sp_calc_approved_ot(?,?,?,?,?)}")) {
            
            cs.setInt(2, bean.getOtDate().getYear() + 1900);
            cs.setInt(3, bean.getOtDate().getMonth() + 1);
            cs.registerOutParameter(4, Types.DECIMAL);
            cs.registerOutParameter(5, Types.DECIMAL);

            cs.execute();
            double otHours = cs.getDouble(4);
            double otAmount = cs.getDouble(5);

            
            resultBean.setHoursWorked(otHours);
            resultBean.setReason("OT Amount: " + otAmount);
        }
        return resultBean;
    }

    @Override
    public List<OverTimeBean> getOvertimeRecordsForEmployee(int empId) throws Exception {
        List<OverTimeBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Overtime_Record WHERE emp_id = ? ORDER BY ot_date DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, empId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OverTimeBean bean = new OverTimeBean();
                    bean.setOtId(rs.getInt("ot_id"));
                     
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

    @Override
    public List<OverTimeBean> getPendingOvertimeRequests() throws Exception {
        List<OverTimeBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Overtime_Record WHERE status = 'Pending' ORDER BY ot_date DESC";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OverTimeBean bean = new OverTimeBean();
                bean.setOtId(rs.getInt("ot_id"));
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