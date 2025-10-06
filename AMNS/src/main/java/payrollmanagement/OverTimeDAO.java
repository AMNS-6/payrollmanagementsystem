package payrollmanagement;

import java.util.List;

public interface OverTimeDAO {
    int applyOvertime(OverTimeBean bean) throws Exception;
    String approveOvertime(OverTimeBean bean) throws Exception;
    OverTimeBean calculateApprovedOvertime(OverTimeBean bean) throws Exception;
    List<OverTimeBean> getOvertimeRecordsForEmployee(int empId) throws Exception;
    List<OverTimeBean> getPendingOvertimeRequests() throws Exception; // ✅ new for managers
    

}