package payrollmanagement;

import java.util.List;

public interface LeaveRequestDAO {
    
    boolean applyLeave(LeaveRequestBean leave);
    
    List<LeaveRequestBean> getLeavesByEmpId(int userId);
    
    // Add this method declaration here:
    int getEmpIdByUserId(int userId);
}
