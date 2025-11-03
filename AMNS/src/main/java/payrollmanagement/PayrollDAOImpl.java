package payrollmanagement;

import java.sql.*;
import java.util.*;

public class PayrollDAOImpl implements PayrollDAO {

    @Override
    public boolean runPayrollForMonth(int year, int month) {
        boolean success = false;
        try (Connection con = ConnectionFactory.getConnection();
             CallableStatement cs = con.prepareCall("{CALL sp_run_payroll_for_month(?,?)}")) {

            cs.setInt(1, year);
            cs.setInt(2, month);
            cs.execute();
            success = true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    @Override
    public List<PayrollRunBean> getPayrollList(String monthYear) {
        List<PayrollRunBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Payroll_Run WHERE month_year = ? ORDER BY emp_id";

        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, monthYear);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PayrollRunBean p = new PayrollRunBean();
                p.setPayrollId(rs.getInt("payroll_id"));
                p.setEmpId(rs.getInt("emp_id"));
                p.setStructureId((Integer) rs.getObject("structure_id"));
                p.setMonthYear(rs.getString("month_year"));

                p.setTotalDays(rs.getInt("total_days"));
                p.setPresentDays(rs.getInt("present_days"));
                p.setLeaveDays(rs.getInt("leave_days"));
                p.setHolidayDays(rs.getInt("holiday_days"));

                p.setOtHours(rs.getDouble("ot_hours"));
                p.setOtAmount(rs.getDouble("ot_amount"));

                p.setGrossSalary(rs.getDouble("gross_salary"));
                p.setTotalAllowances(rs.getDouble("total_allowances"));
                p.setTotalDeductions(rs.getDouble("total_deductions"));
                p.setNetSalary(rs.getDouble("net_salary"));

                p.setStatus(rs.getString("status"));
                p.setProcessedAt(rs.getTimestamp("processed_at"));
                p.setPaidAt(rs.getTimestamp("paid_at"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
