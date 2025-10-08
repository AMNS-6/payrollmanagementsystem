package payrollmanagement;

import java.util.List;

public interface LeaveApprovalDAO {
    List<LeaveApprovalBean> getAllLeaves() throws Exception;
    boolean updateLeaveStatus(int leaveId, String status, String remarks) throws Exception;
}
