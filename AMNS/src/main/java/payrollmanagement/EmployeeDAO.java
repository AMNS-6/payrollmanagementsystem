package payrollmanagement;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface EmployeeDAO {
    int onboardEmployee(EmployeeBean emp) throws Exception;
    public EmployeeBean getEmployeeById(int empId);
    public EmployeeBean getEmployeeByUsername(String username) ;
    public int updateEmployee(EmployeeBean emp);
    public  List<EmployeeBean> getAllEmployees();
    public boolean deleteEmployee(int empId) throws Exception;
    public List<String> getAllEmploymentTypes();
    public List<String> getAllDesignations();
    public Map<Integer, String> getAllTeams();
    public Map<Integer, String> getAllShifts();
    public Map<Integer, String> getAllStructures();
    
}