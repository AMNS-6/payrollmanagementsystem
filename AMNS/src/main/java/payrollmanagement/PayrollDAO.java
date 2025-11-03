package payrollmanagement;

import java.util.List;

public interface PayrollDAO {
		boolean runPayrollForMonth(int year, int month);
	    List<PayrollRunBean> getPayrollList(String monthYear);

}
