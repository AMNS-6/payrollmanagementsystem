<%@ page import="payrollmanagement.PayrollDAO,payrollmanagement.PayrollDAOImpl,payrollmanagement.PayrollRunBean" %>
<%@ page import="java.util.*" %>
<%
    String msg = "";
    String monthYear = "";
    List<PayrollRunBean> payrollList = new ArrayList<>();
    PayrollDAO dao = new PayrollDAOImpl();

    int currentYear = Calendar.getInstance().get(Calendar.YEAR);
    int currentMonth = Calendar.getInstance().get(Calendar.MONTH) + 1; // 0-based in Calendar

    // Handle payroll run
    if (request.getParameter("runPayroll") != null) {
        try {
            int year = Integer.parseInt(request.getParameter("year"));
            int month = Integer.parseInt(request.getParameter("month"));
            boolean ok = dao.runPayrollForMonth(year, month);
            msg = ok ? " Payroll processed successfully for " + month + "/" + year : "Error while processing payroll.";
            monthYear = year + "-" + (month < 10 ? "0" + month : month);
            if (ok) payrollList = dao.getPayrollList(monthYear);
        } catch (Exception e) {
            msg = "Invalid month/year input.";
        }
    } 
    // Handle listing without rerun
    else if (request.getParameter("monthYear") != null) {
        monthYear = request.getParameter("monthYear");
        payrollList = dao.getPayrollList(monthYear);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Payroll Summary</title>

  <!-- Bootstrap + Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

  <!-- jsPDF for PDF export -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.23/jspdf.plugin.autotable.min.js"></script>

  <style>
    body { background: #f9f9f9; font-family: 'Poppins', sans-serif; }
    .sidebar { height:100vh; background:#39bfbf; color:white; position:fixed; top:0; left:0; width:300px; padding-top:30px; display:flex; flex-direction:column; justify-content:space-between; transition:width 0.3s ease; overflow:hidden; text-align:center; }
    .sidebar.collapsed { width:70px; }
    .logo-text img { width:120px; height:auto; }
    .logo-tagline { font-size:12px; color:#fff; margin-top:6px; font-weight:400; }
    .sidebar.collapsed .logo-text, .sidebar.collapsed .logo-tagline { display:none; }
    .sidebar a { display:flex; align-items:center; gap:12px; color:#fff; padding:14px 20px; text-decoration:none; font-size:16px; margin:8px 0; border-radius:6px; }
    .sidebar a:hover { background:#12b5b5; }
    .sidebar.collapsed a { justify-content:center; gap:0; padding:14px; }
    .sidebar.collapsed a span { display:none; }
    .logout { background:#39bfbf; margin:15px; padding:10px 16px; border-radius:6px; text-align:center; }
    .logout:hover { background:#1a252f; }
    .toggle-btn { position:absolute; top:15px; left:15px; background:#39bfbf; border-radius:50%; width:40px; height:40px; border:none; color:#fff; font-size:18px; cursor:pointer; display:flex; align-items:center; justify-content:center; z-index:10; }
    .main { margin-left:300px; padding:20px; transition:margin-left 0.3s; }
    .main.collapsed { margin-left:70px; }
    .btn-custom { background-color:#39bfbf; border:none; color:white; }
    .btn-custom:hover { background-color:#12b5b5; }
    .alert { font-weight:bold; }
  </style>
</head>

<body>
  <!-- Sidebar -->
  <div class="sidebar" id="sidebar">
    <button class="toggle-btn" id="toggle-btn">
      <i class="fa-solid fa-arrow-left"></i>
    </button>
    <div class="logo-container">
      <div class="logo-text"><img src="images/logo.png"></div>
      <div class="logo-tagline">Your Punctual Partner for Workforce<br>Management</div>
    </div>
    <div class="menu">
      <a href="hr_dashboard.jsp"><i class="fa-solid fa-house"></i> <span>Dashboard</span></a>
      <a href="LoginReport.jsp"><i class="fa-solid fa-clipboard-check"></i> <span>Login Report</span></a>
      <a data-bs-toggle="collapse" href="#empSubmenu" role="button" aria-expanded="false" aria-controls="empSubmenu">
        <i class="fa-solid fa-users-gear me-2"></i> <span>Employee Management</span>
      </a>
      <div class="collapse submenu" id="empSubmenu">
        <a href="Onboarding.jsp"><i class="fa-solid fa-user-plus me-2"></i> Onboarding Employee</a>
        <a href="EmployeeList.jsp"><i class="fa-solid fa-id-card me-2"></i> List Employee</a>
      </div>
      <a href="LeaveApproval.html"><i class="fa-solid fa-user-check"></i> <span>Leave Approval</span></a>
      <a href="payroll_run.jsp"><i class="fa-solid fa-money-check-dollar"></i> <span>Payroll</span></a>
      <a href="OtApproval.jsp"><i class="fa-solid fa-stopwatch me-2"></i> <span>Overtime Approval</span></a>
      <a href="Holiday.jsp"><i class="fa-solid fa-calendar-days"></i> <span>Holidays</span></a>
    </div>
    <a href="#" class="logout" id="logoutBtn"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
  </div>

  <!-- Main Content -->
  <div class="main" id="main">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Payroll Summary</h2>
      <div class="d-flex align-items-center">
        <div class="top-btn me-3"><i class="fa-solid fa-bell"></i></div>
        <div class="top-btn"><i class="fa-solid fa-user"></i></div>
      </div>
    </div>

    <div class="container-fluid">
      <!-- Run Payroll Form -->
      <form method="post" class="text-center mb-3">
        <input type="hidden" name="runPayroll" value="true">
        <label>Year:</label>
        <input type="number" name="year" required value="<%= currentYear %>">
        <label>Month:</label>
        <input type="number" name="month" min="1" max="12" required value="<%= currentMonth %>">
        <button type="submit" class="btn btn-custom btn-lg">Run Payroll Summary</button>
      </form>

      <% if (!msg.isEmpty()) { %>
        <div class="alert <%= msg.contains("Error") || msg.contains("Success ") ? "alert-danger" : "alert-success" %> text-center">
          <%= msg %>
        </div>
      <% } %>

      <% if (payrollList != null && !payrollList.isEmpty()) { %>
      <div id="payrollTableContainer" class="table-responsive">
        <table id="payrollTable" class="table table-bordered table-striped text-center">
          <thead class="table-dark">
            <tr>
              <th>Payroll ID</th>
              <th>Emp ID</th>
              <th>Structure ID</th>
              <th>Month-Year</th>
              <th>Total Days</th>
              <th>Present</th>
              <th>Leave</th>
              <th>Holiday</th>
              <th>OT Hours</th>
              <th>OT Amount</th>
              <th>Gross Salary</th>
              <th>Allowances</th>
              <th>Deductions</th>
              <th>Net Salary</th>
              <th>Status</th>
              <th>Processed At</th>
              <th>Paid At</th>
              <th>Payslip</th>
            </tr>
          </thead>
          <tbody>
            <% for (PayrollRunBean p : payrollList) { %>
              <tr>
                <td><%= p.getPayrollId() %></td>
                <td><%= p.getEmpId() %></td>
                <td><%= p.getStructureId() %></td>
                <td><%= p.getMonthYear() %></td>
                <td><%= p.getTotalDays() %></td>
                <td><%= p.getPresentDays() %></td>
                <td><%= p.getLeaveDays() %></td>
                <td><%= p.getHolidayDays() %></td>
                <td><%= p.getOtHours() %></td>
                <td><%= p.getOtAmount() %></td>
                <td><%= p.getGrossSalary() %></td>
                <td><%= p.getTotalAllowances() %></td>
                <td><%= p.getTotalDeductions() %></td>
                <td><%= p.getNetSalary() %></td>
                <td><%= p.getStatus() %></td>
                <td><%= p.getProcessedAt() %></td>
                <td><%= p.getPaidAt() %></td>
                <td><a href="payroll_payslip.jsp?id=<%= p.getPayrollId() %>" class="btn btn-sm btn-outline-info">View</a></td>
              </tr>
            <% } %>
          </tbody>
        </table>

        <div class="text-end mt-3">
          <button id="downloadPdfBtn" class="btn btn-danger">Download PDF</button>
        </div>
      </div>
      <% } %>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

  <script>
    // Sidebar toggle
    const sidebar = document.getElementById('sidebar');
    const main = document.getElementById('main');
    const toggleBtn = document.getElementById('toggle-btn');
    const toggleIcon = toggleBtn.querySelector('i');
    toggleBtn.addEventListener('click', () => {
      sidebar.classList.toggle('collapsed');
      main.classList.toggle('collapsed');
      toggleIcon.classList.toggle('fa-bars');
      toggleIcon.classList.toggle('fa-arrow-left');
    });

    // PDF download
    document.getElementById("downloadPdfBtn")?.addEventListener("click", () => {
      const { jsPDF } = window.jspdf;
      const doc = new jsPDF({ orientation: "landscape" });
      doc.setFontSize(14);
      doc.text("Payroll Summary - <%= monthYear %>", 14, 15);
      doc.autoTable({ html: "#payrollTable", startY: 22, styles: { fontSize: 8, cellPadding: 2 } });
      doc.save("Payroll_Summary_<%= monthYear %>.pdf");
    });
  </script>
</body>
</html>
