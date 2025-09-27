package payrollmanagement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAOImpl implements AttendanceDAO {

    // 🔍 Map user_id → emp_id
    private int getEmpIdByUserId(int userId, Connection con) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement(
                "SELECT emp_id FROM Employee_Master WHERE user_id=?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("emp_id");
            }
        }
        return -1;
    }

    @Override
    public boolean punchIn(int userId) {
        String sql = "CALL sp_record_punch(?, 'IN')";
        try (Connection conn = ConnectionFactory.getConnection()) {
            int empId = getEmpIdByUserId(userId, conn);
            if (empId > 0) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, empId);
                    ps.executeUpdate();
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean punchOut(int userId) {
        String sql = "CALL sp_record_punch(?, 'OUT')";
        try (Connection conn = ConnectionFactory.getConnection()) {
            int empId = getEmpIdByUserId(userId, conn);
            if (empId > 0) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, empId);
                    ps.executeUpdate();
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<AttendanceBean> getAttendanceByEmp(int empId) {
        List<AttendanceBean> list = new ArrayList<>();
        String sql = "SELECT * FROM Attendance WHERE emp_id=? ORDER BY attendance_date DESC";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, empId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AttendanceBean ab = new AttendanceBean();
                    ab.setAttendanceId(rs.getInt("attendance_id"));
                    ab.setEmpId(rs.getInt("emp_id"));
                    ab.setAttendanceDate(rs.getDate("attendance_date"));
                    ab.setFirstIn(rs.getTimestamp("first_in"));
                    ab.setLastOut(rs.getTimestamp("last_out"));
                    ab.setTotalWorkHours(rs.getDouble("total_work_hours"));
                    ab.setOvertimeHours(rs.getDouble("overtime_hours"));
                    ab.setStatus(rs.getString("status"));
                    list.add(ab);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public void calculateAttendance(int empId, int year, int month) {
        String sql = "{CALL sp_calc_attendance(?,?,?,?,?,?,?,?)}";
        try (Connection conn = ConnectionFactory.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setInt(1, empId);
            cs.setInt(2, year);
            cs.setInt(3, month);
            cs.registerOutParameter(4, Types.INTEGER); // total days
            cs.registerOutParameter(5, Types.INTEGER); // present days
            cs.registerOutParameter(6, Types.INTEGER); // leave days
            cs.registerOutParameter(7, Types.INTEGER); // holidays
            cs.registerOutParameter(8, Types.INTEGER); // absent days
            cs.execute();
            System.out.println("Total Days: " + cs.getInt(4));
            System.out.println("Present: " + cs.getInt(5));
            System.out.println("Leave: " + cs.getInt(6));
            System.out.println("Holidays: " + cs.getInt(7));
            System.out.println("Absent: " + cs.getInt(8));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void processAttendance(int userId, String date) {
        String sql = "{CALL sp_process_attendance(?,?)}";
        try (Connection conn = ConnectionFactory.getConnection()) {
            int empId = getEmpIdByUserId(userId, conn);
            if (empId > 0) {
                try (CallableStatement cs = conn.prepareCall(sql)) {
                    cs.setInt(1, empId);
                    cs.setString(2, date);
                    cs.execute();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    @Override
    public AttendanceSummaryDTO getAttendanceSummary(int userId, int year, int month) {
        AttendanceSummaryDTO summary = new AttendanceSummaryDTO();

        try (Connection conn = ConnectionFactory.getConnection()) {
            // convert userId → empId
            int empId = getEmpIdByUserId(userId, conn);
            if (empId == -1) {
                System.out.println("No empId found for userId: " + userId);
                return summary;
            }

            String proc = "{CALL sp_calc_attendance_counts(?,?,?,?,?,?,?,?)}";
            try (CallableStatement cs = conn.prepareCall(proc)) {
                cs.setInt(1, empId);
                cs.setInt(2, year);
                cs.setInt(3, month);

                cs.registerOutParameter(4, Types.INTEGER); // total_days
                cs.registerOutParameter(5, Types.INTEGER); // present_days
                cs.registerOutParameter(6, Types.INTEGER); // leave_days
                cs.registerOutParameter(7, Types.INTEGER); // holiday_days
                cs.registerOutParameter(8, Types.INTEGER); // absent_days

                cs.execute();

                summary.setTotalDays(cs.getInt(4));
                summary.setPresentDays(cs.getInt(5));
                summary.setLeaveDays(cs.getInt(6));
                summary.setHolidayDays(cs.getInt(7));
                summary.setAbsentDays(cs.getInt(8));
            }

            // get overtime
            String sql = "SELECT IFNULL(SUM(overtime_hours),0) FROM Attendance " +
                         "WHERE emp_id=? AND YEAR(attendance_date)=? AND MONTH(attendance_date)=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, empId);
                ps.setInt(2, year);
                ps.setInt(3, month);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    summary.setOvertimeHours(rs.getDouble(1));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return summary;
    }
    @Override
    public boolean processAttendanceForAll(String date) {
        String sql = "{CALL sp_process_attendance_for_all(?)}";
        try (Connection conn = ConnectionFactory.getConnection();
             CallableStatement cs = conn.prepareCall(sql)) {
            cs.setString(1, date);
            cs.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    @Override
    public List<AttendanceBean> getAllAttendance() {
        List<AttendanceBean> list = new ArrayList<>();
        String sql = "SELECT a.*, e.first_name, e.last_name " +
                     "FROM Attendance a " +
                     "JOIN Employee_Master e ON a.emp_id = e.emp_id " +
                     "ORDER BY a.attendance_date DESC";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                AttendanceBean ab = new AttendanceBean();
                ab.setAttendanceId(rs.getInt("attendance_id"));
                ab.setEmpId(rs.getInt("emp_id"));
                ab.setEmpName(rs.getString("first_name") + " " + rs.getString("last_name"));
                ab.setAttendanceDate(rs.getDate("attendance_date"));
                ab.setFirstIn(rs.getTimestamp("first_in"));
                ab.setLastOut(rs.getTimestamp("last_out"));
                ab.setTotalWorkHours(rs.getDouble("total_work_hours"));
                ab.setOvertimeHours(rs.getDouble("overtime_hours"));
                ab.setStatus(rs.getString("status"));
                list.add(ab);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    

}
