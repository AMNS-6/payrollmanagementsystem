package payrollmanagement;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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

    
    
    
    @Override
    public EmployeeBean getEmployeeById(int empId) {
        EmployeeBean emp = null;
        String sql = "SELECT u.username, u.role, e.* " +
                     "FROM Employee_Master e " +
                     "JOIN Users u ON e.user_id = u.user_id " +
                     "WHERE e.emp_id = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, empId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    emp = new EmployeeBean();

                    emp.setEmpId(rs.getInt("emp_id"));
                    emp.setUsername(rs.getString("username"));
                    emp.setFirst_name(rs.getString("first_name"));
                    emp.setLast_name(rs.getString("last_name"));
                    emp.setDob(rs.getDate("dob"));
                    emp.setGender(rs.getString("gender"));
                    emp.setMarital_status(rs.getString("marital_status"));
                    emp.setEmail(rs.getString("email"));
                    emp.setPhone(rs.getString("phone"));
                    emp.setAddress_line1(rs.getString("address_line1"));
                    emp.setAddress_line2(rs.getString("address_line2"));
                    emp.setCity(rs.getString("city"));
                    emp.setState(rs.getString("state"));
                    emp.setPostal_code(rs.getString("postal_code"));
                    emp.setCountry(rs.getString("country"));
                    emp.setEmergency_name(rs.getString("emergency_name"));
                    emp.setEmergency_relation(rs.getString("emergency_relation"));
                    emp.setEmergency_phone(rs.getString("emergency_phone"));
                    emp.setDate_of_joining(rs.getDate("date_of_joining"));
                    emp.setEmployment_type(rs.getString("employment_type"));
                    emp.setDesignation(rs.getString("designation"));
                    emp.setTeam_id(rs.getInt("team_id"));
                    emp.setBank_name(rs.getString("bank_name"));
                    emp.setAccount_number(rs.getString("account_number"));
                    emp.setIfsc_code(rs.getString("ifsc_code"));
                    emp.setPan_number(rs.getString("pan_number"));
                    emp.setAadhar_number(rs.getString("aadhar_number"));
                    emp.setUan_number(rs.getString("uan_number"));
                    emp.setShift_id(rs.getInt("shift_id"));
                    emp.setStructure_id(rs.getInt("structure_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emp;
    }

    // ✅ New method to fetch Employee by username
    @Override
    public EmployeeBean getEmployeeByUsername(String username) {
        EmployeeBean emp = null;
        String sql = "SELECT u.username, u.role, e.* " +
                     "FROM Employee_Master e " +
                     "JOIN Users u ON e.user_id = u.user_id " +
                     "WHERE u.username = ?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    emp = new EmployeeBean();

                    emp.setEmpId(rs.getInt("emp_id"));
                    emp.setUsername(rs.getString("username"));  // from Users
                    emp.setFirst_name(rs.getString("first_name"));
                    emp.setLast_name(rs.getString("last_name"));
                    emp.setDob(rs.getDate("dob"));
                    emp.setGender(rs.getString("gender"));
                    emp.setMarital_status(rs.getString("marital_status"));
                    emp.setEmail(rs.getString("email"));
                    emp.setPhone(rs.getString("phone"));
                    emp.setAddress_line1(rs.getString("address_line1"));
                    emp.setAddress_line2(rs.getString("address_line2"));
                    emp.setCity(rs.getString("city"));
                    emp.setState(rs.getString("state"));
                    emp.setPostal_code(rs.getString("postal_code"));
                    emp.setCountry(rs.getString("country"));
                    emp.setEmergency_name(rs.getString("emergency_name"));
                    emp.setEmergency_relation(rs.getString("emergency_relation"));
                    emp.setEmergency_phone(rs.getString("emergency_phone"));
                    emp.setDate_of_joining(rs.getDate("date_of_joining"));
                    emp.setEmployment_type(rs.getString("employment_type"));
                    emp.setDesignation(rs.getString("designation"));
                    emp.setTeam_id(rs.getInt("team_id"));
                    emp.setBank_name(rs.getString("bank_name"));
                    emp.setAccount_number(rs.getString("account_number"));
                    emp.setIfsc_code(rs.getString("ifsc_code"));
                    emp.setPan_number(rs.getString("pan_number"));
                    emp.setAadhar_number(rs.getString("aadhar_number"));
                    emp.setUan_number(rs.getString("uan_number"));
                    emp.setShift_id(rs.getInt("shift_id"));
                    emp.setStructure_id(rs.getInt("structure_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emp;
    }

    
    @Override
 // ✅ Update Employee (full bean)
    public int updateEmployee(EmployeeBean emp) {
        int rowUpdated = 0;
        String sql = "UPDATE employee_master SET " +
                     "first_name=?, last_name=?, dob=?, gender=?, marital_status=?, " + // identity
                     "email=?, phone=?, address_line1=?, address_line2=?, city=?, state=?, postal_code=?, country=?, " + // contact
                     "emergency_name=?, emergency_relation=?, emergency_phone=?, " + // emergency
                     "date_of_joining=?, employment_type=?, designation=?, team_id=?, " + // employment
                     "bank_name=?, account_number=?, ifsc_code=?, pan_number=?, aadhar_number=?, uan_number=?, " + // bank/legal
                     "shift_id=?, structure_id=? " + // links
                     "WHERE emp_id=?";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Login



            // Identity
            ps.setString(1, emp.getFirst_name());
            ps.setString(2, emp.getLast_name());
            ps.setDate(3, emp.getDob());
            ps.setString(4, emp.getGender());
            ps.setString(5, emp.getMarital_status());

            // Contact
            ps.setString(6, emp.getEmail());
            ps.setString(7, emp.getPhone());
            ps.setString(8, emp.getAddress_line1());
            ps.setString(9, emp.getAddress_line2());
            ps.setString(10, emp.getCity());
            ps.setString(11, emp.getState());
            ps.setString(12, emp.getPostal_code());
            ps.setString(13, emp.getCountry());

            // Emergency
            ps.setString(14, emp.getEmergency_name());
            ps.setString(15, emp.getEmergency_relation());
            ps.setString(16, emp.getEmergency_phone());

            // Employment
            ps.setDate(17, emp.getDate_of_joining());
            ps.setString(18, emp.getEmployment_type());
            ps.setString(19, emp.getDesignation());
            ps.setInt(20, emp.getTeam_id());

            // Bank & Legal
            ps.setString(21, emp.getBank_name());
            ps.setString(22, emp.getAccount_number());
            ps.setString(23, emp.getIfsc_code());
            ps.setString(24, emp.getPan_number());
            ps.setString(25, emp.getAadhar_number());
            ps.setString(26, emp.getUan_number());

            // Links
            ps.setInt(27, emp.getShift_id());
            ps.setInt(28, emp.getStructure_id());

            // Where clause
            ps.setInt(29, emp.getEmpId());

            rowUpdated = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return rowUpdated;
    }
    
   
    
    @Override
    public List<EmployeeBean> getAllEmployees() {
        List<EmployeeBean> employees = new ArrayList<>();
        String sql = "SELECT emp_id, first_name, last_name, email, phone FROM Employee_Master";

        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                EmployeeBean emp = new EmployeeBean();
                emp.setEmpId(rs.getInt("emp_id"));
                emp.setFirst_name(rs.getString("first_name"));
                emp.setLast_name(rs.getString("last_name"));
                emp.setEmail(rs.getString("email"));
                emp.setPhone(rs.getString("phone"));
                employees.add(emp);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return employees;
    }

    @Override
    public boolean deleteEmployee(int empId) throws Exception {
        String sql = "DELETE FROM Employee_Master WHERE emp_id=?";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, empId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }
    
    @Override
    public List<String> getAllEmploymentTypes() {
        List<String> list = new ArrayList<>();
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT DISTINCT employment_type FROM Employee_Master")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("employment_type"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<String> getAllDesignations() {
        List<String> list = new ArrayList<>();
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT DISTINCT designation FROM Employee_Master")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("designation"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Map<Integer, String> getAllTeams() {
        Map<Integer, String> map = new LinkedHashMap<>();
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT team_id, team_name FROM Team_Master")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getInt("team_id"), rs.getString("team_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
    
    @Override
    public Map<Integer, String> getAllShifts() {
        Map<Integer, String> map = new LinkedHashMap<>();
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT shift_id, shift_name FROM Shift_Master")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getInt("shift_id"), rs.getString("shift_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
    
    
    @Override
    public Map<Integer, String> getAllStructures() {
        Map<Integer, String> map = new LinkedHashMap<>();
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT structure_id, structure_name FROM Salary_Structure")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getInt("structure_id"), rs.getString("structure_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }


}