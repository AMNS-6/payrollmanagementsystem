package payrollmanagement;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EmployeeDAOImpl implements EmployeeDAO {

    @Override
    public int onboardEmployee(EmployeeBean emp) throws Exception {
        int newEmployeeId = -1;
        Connection conn = null;
        CallableStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionFactory.getConnection();

            String sql = "{CALL sp_onboard_employee(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
            stmt = conn.prepareCall(sql);

            // Login
            stmt.setString(1, emp.getUsername());
            stmt.setString(2, emp.getPassword_hash());
            stmt.setString(3, emp.getRole());

            // Employee
            stmt.setString(4, emp.getFirst_name());
            stmt.setString(5, emp.getLast_name());
            if (emp.getDob() != null) {
                stmt.setDate(6, new java.sql.Date(emp.getDob().getTime()));
            } else {
                stmt.setNull(6, java.sql.Types.DATE);
            }
            stmt.setString(7, emp.getGender());
            stmt.setString(8, emp.getMarital_status());
            stmt.setString(9, emp.getEmail());
            stmt.setString(10, emp.getPhone());
            stmt.setString(11, emp.getAddress_line1());
            stmt.setString(12, emp.getAddress_line2());
            stmt.setString(13, emp.getCity());
            stmt.setString(14, emp.getState());
            stmt.setString(15, emp.getPostal_code());
            stmt.setString(16, emp.getCountry());

            // Emergency
            stmt.setString(17, emp.getEmergency_name());
            stmt.setString(18, emp.getEmergency_relation());
            stmt.setString(19, emp.getEmergency_phone());

            // Employment
            if (emp.getDate_of_joining() != null) {
                stmt.setDate(20, new java.sql.Date(emp.getDate_of_joining().getTime()));
            } else {
                stmt.setNull(20, java.sql.Types.DATE);
            }
            stmt.setString(21, emp.getEmployment_type());
            stmt.setString(22, emp.getDesignation());
            stmt.setInt(23, emp.getTeam_id());

            // Bank & IDs
            stmt.setString(24, emp.getBank_name());
            stmt.setString(25, emp.getAccount_number());
            stmt.setString(26, emp.getIfsc_code());
            stmt.setString(27, emp.getPan_number());
            stmt.setString(28, emp.getAadhar_number());
            stmt.setString(29, emp.getUan_number());

            // Links
            stmt.setInt(30, emp.getShift_id());
            stmt.setInt(31, emp.getStructure_id());

            // Execute procedure
            boolean hasResult = stmt.execute();
            if (hasResult) {
                rs = stmt.getResultSet();
                if (rs.next()) {
                    newEmployeeId = rs.getInt("new_employee_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); 
            throw new RuntimeException("Error while onboarding employee: " + e.getMessage(), e);
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }

        return newEmployeeId;
    }

    // ✅ New method to fetch Employee by username
    @Override
    public EmployeeBean getEmployeeByUsername(String username) {
        EmployeeBean emp = null;
        String sql = "SELECT * FROM employees WHERE username = ?"; // ⚠ check your actual table name
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    emp = new EmployeeBean();
                    emp.setEmpId(rs.getInt("emp_id"));
                    emp.setUsername(rs.getString("username"));
                    emp.setPassword_hash(rs.getString("password_hash"));
                    emp.setRole(rs.getString("role"));
                    emp.setFirst_name(rs.getString("first_name"));
                    emp.setLast_name(rs.getString("last_name"));
                    // map more fields if you need them later
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emp;
    }
}