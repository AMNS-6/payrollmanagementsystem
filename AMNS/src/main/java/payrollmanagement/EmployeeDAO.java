package payrollmanagement;

public interface EmployeeDAO {
    int onboardEmployee(EmployeeBean emp) throws Exception;

    // 🔑 Add this method
    EmployeeBean getEmployeeByUsername(String username);
}