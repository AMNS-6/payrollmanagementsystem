<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="payrollmanagement.*" %>
<%@ page import="java.util.*" %>
<%
    LeaveApprovalDAO dao = new LeaveApprovalDAOImpl();

    String action = request.getParameter("action");
    String leaveIdStr = request.getParameter("leaveId");
    String remarks = request.getParameter("remarks");

    if (action != null && leaveIdStr != null) {
        int leaveId = Integer.parseInt(leaveIdStr);
        String newStatus = "";

        if (action.equals("approve")) newStatus = "Approved";
        else if (action.equals("reject")) newStatus = "Rejected";

        if (!newStatus.isEmpty()) {
            boolean updated = dao.updateLeaveStatus(leaveId, newStatus, remarks);
            if (updated) {
                out.println("<script>alert('Leave " + newStatus + " successfully!'); window.location='LeaveApproval.jsp';</script>");
            } else {
                out.println("<script>alert('Failed to update leave status.');</script>");
            }
        }
    }

    List<LeaveApprovalBean> leaveList = dao.getAllLeaves();
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Leave Approval</title>
  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    body { margin: 0; font-family: Arial, sans-serif; background: #f4f6f9; color: #333; transition: all 0.3s ease; }
    body.dark-mode { background: #1e1e2f; color: #e5e5e5; }
    body.dark-mode .card { background: #2b2b3c; color: #fff; }
    body.dark-mode .table th { background: #39bfbf !important; }
    body.dark-mode .sidebar { background: #252537; }
    body.dark-mode .sidebar a:hover { background: #39bfbf; }

    .sidebar { height: 100vh; background: #39bfbf; color: white; position: fixed; top: 0; left: 0; width: 300px;
      padding-top: 30px; box-sizing: border-box; display: flex; flex-direction: column; justify-content: space-between;
      transition: width 0.3s ease; overflow: hidden; text-align: center; }
    .sidebar.collapsed { width: 70px; }
    .logo-container { margin-bottom: 20px; }
    .logo-text img { width: 120px; height: auto; }
    .logo-tagline { font-size: 12px; color: #fff; margin-top: 6px; line-height: 1.3; }
    .sidebar.collapsed .logo-text, .sidebar.collapsed .logo-tagline { display: none; }
    .menu { flex-grow: 1; text-align: left; }
    .sidebar a { display: flex; align-items: center; gap: 12px; color: #fff; padding: 14px 20px; text-decoration: none;
      font-size: 16px; margin: 8px 0; border-radius: 6px; transition: background 0.3s; }
    .sidebar a:hover { background: #12b5b5; }
    .sidebar.collapsed a { justify-content: center; gap: 0; padding: 14px; }
    .sidebar.collapsed a span { display: none; }
    .logout { background: #39bfbf; padding: 10px; margin: 15px; border-radius: 6px; }
    .logout:hover { background: #1a252f; }

    .toggle-btn { position: absolute; top: 15px; left: 15px; background: #39bfbf; border-radius: 50%; width: 40px; height: 40px;
      border: none; color: #fff; font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center;
      box-shadow: 0 2px 6px rgba(0,0,0,0.2); z-index: 10; }
    .toggle-btn:hover { background: #12b5b5; }

    .main { margin-left: 300px; padding: 20px; transition: margin-left 0.3s; }
    .main.collapsed { margin-left: 70px; }
    .table th { background: #39bfbf; color: #fff; }
    .action-btn { padding: 4px 10px; border-radius: 5px; font-size: 14px; cursor: pointer; border: none; }
    .approve-btn { background: #28a745; color: #fff; }
    .reject-btn { background: #dc3545; color: #fff; }
    .top-btn { width: 40px; height: 40px; border-radius: 50%; background: #e5e7eb;
      display: flex; align-items: center; justify-content: center; margin-left: 10px; cursor: pointer; }
    .top-btn i { font-size: 18px; }
    body.dark-mode .top-btn { background: #444; }

    .remarks-input {
      width: 180px; min-width: 150px; font-size: 14px; padding: 6px 10px; border: 1px solid #ccc; border-radius: 6px;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    .remarks-input:focus { outline: none; border-color: #39bfbf; box-shadow: 0 0 5px rgba(57, 191, 191, 0.5); }
    body.dark-mode .remarks-input { background: #2b2b3c; color: #fff; border: 1px solid #666; }
    body.dark-mode .remarks-input:focus { border-color: #39bfbf; box-shadow: 0 0 5px rgba(57, 191, 191, 0.8); }
    /* Disabled buttons (after approve/reject) */
.action-btn:disabled {
  background: #ccc !important;
  color: #666 !important;
  cursor: not-allowed;
  opacity: 0.7;
  border: none;
  box-shadow: none;
}

.action-btn:disabled:hover {
  background: #ccc !important;
  color: #666 !important;
}
    
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
      <a href="loginReport.jsp"><i class="fa-solid fa-clipboard-check"></i> <span>Login Report</span></a>

      <!-- Employee Management with Submenu -->
      <a data-bs-toggle="collapse" href="#empSubmenu" role="button" aria-expanded="false" aria-controls="empSubmenu">
        <i class="fa-solid fa-users-gear me-2"></i> <span>Employee Management</span>
      </a>
      <div class="collapse submenu" id="empSubmenu">
        <a href="Onboarding.jsp"><i class="fa-solid fa-user-plus me-2"></i> Onboarding Employee</a>
        <a href="EmployeeList.jsp"><i class="fa-solid fa-id-card me-2"></i> List Employee</a>
      </div>

      <a href="LeaveApproval.jsp"><i class="fa-solid fa-user-check"></i> <span>Leave Approval</span></a>
      <a href="PayRoll.html"><i class="fa-solid fa-money-check-dollar"></i> <span>Payroll</span></a>
      <a href="OtApproval.jsp"><i class="fa-solid fa-stopwatch me-2"></i> <span>Overtime Approval</span></a>
      <a href="Holiday.jsp"><i class="fa-solid fa-calendar-days"></i> <span>Holidays</span></a>
    </div>

    <!-- Logout -->
    <a href="#" class="logout" id="logoutBtn">
      <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
    </a>
  </div>

<div class="main" id="main">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2>Leave Approval</h2>
    <div class="d-flex align-items-center">
      <div class="top-btn" id="theme-toggle"><i class="fa-solid fa-moon"></i></div>
      <div class="top-btn"><i class="fa-solid fa-bell"></i></div>
      <div class="top-btn"><i class="fa-solid fa-user"></i></div>
    </div>
  </div>

  <div class="card p-3 shadow-sm">
    <h5 class="mb-3">Pending Leave Requests</h5>
    <table class="table table-striped">
      <thead>
        <tr>
          <th>Employee</th>
          <th>Leave Type</th>
          <th>From</th>
          <th>To</th>
          <th>Total Days</th>
          <th>Reason</th>
          <th>Status</th>
          <th>Remarks</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <%
          for(LeaveApprovalBean leave : leaveList){
        %>
       <tr>
  <td><%= leave.getEmployeeName() %></td>
  <td><%= leave.getLeaveType() %></td>
  <td><%= leave.getStartDate() %></td>
  <td><%= leave.getEndDate() %></td>
  <td><%= leave.getNumberOfDays() %></td>
  <td><button class="btn btn-sm btn-info view-reason" data-reason="<%= leave.getReason() %>">View</button></td>
  <td>
    <% if("Pending".equalsIgnoreCase(leave.getStatus())) { %>
      <span class="badge bg-warning">Pending</span>
    <% } else if("Approved".equalsIgnoreCase(leave.getStatus())) { %>
      <span class="badge bg-success">Approved</span>
    <% } else { %>
      <span class="badge bg-danger">Rejected</span>
    <% } %>
  </td>
  <td>
    <input type="text" class="remarks-input"
           value="<%= leave.getRemarks() != null ? leave.getRemarks() : "" %>"
           placeholder="Add remark"
           <%= !"Pending".equalsIgnoreCase(leave.getStatus()) ? "readonly" : "" %> >
  </td>
  <td>
    <% boolean isPending = "Pending".equalsIgnoreCase(leave.getStatus()); %>
    <form method="post" style="display:inline;">
      <input type="hidden" name="leaveId" value="<%= leave.getLeaveId() %>">
      <input type="hidden" name="remarks" class="remarks-hidden">
      <button type="submit" name="action" value="approve"
              class="action-btn approve-btn"
              <%= !isPending ? "disabled" : "" %> >
        Approve
      </button>
    </form>
    <form method="post" style="display:inline;">
      <input type="hidden" name="leaveId" value="<%= leave.getLeaveId() %>">
      <input type="hidden" name="remarks" class="remarks-hidden">
      <button type="submit" name="action" value="reject"
              class="action-btn reject-btn"
              <%= !isPending ? "disabled" : "" %> >
        Reject
      </button>
    </form>
  </td>
</tr>

        <% } %>
      </tbody>
    </table>
  </div>
</div>

<!-- Reason Modal -->
<div class="modal fade" id="reasonModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Leave Reason</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body" id="reasonText"></div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
const sidebar = document.getElementById('sidebar');
const main = document.getElementById('main');
const toggleBtn = document.getElementById('toggle-btn');
const toggleIcon = toggleBtn.querySelector('i');

toggleBtn.addEventListener('click', () => {
  sidebar.classList.toggle('collapsed');
  main.classList.toggle('collapsed');
  toggleIcon.classList.toggle('fa-arrow-left');
  toggleIcon.classList.toggle('fa-bars');
});

const themeToggle = document.getElementById("theme-toggle");
themeToggle.addEventListener("click", () => {
  document.body.classList.toggle("dark-mode");
  const icon = themeToggle.querySelector("i");
  icon.classList.toggle("fa-moon");
  icon.classList.toggle("fa-sun");
});

document.querySelectorAll("form").forEach(form => {
  form.addEventListener("submit", (e) => {
    const row = form.closest("tr");
    const remark = row.querySelector(".remarks-input").value || "";
    form.querySelector(".remarks-hidden").value = remark;
  });
});

document.querySelectorAll(".view-reason").forEach(btn => {
  btn.addEventListener("click", () => {
    const reason = btn.getAttribute("data-reason");
    document.getElementById("reasonText").textContent = reason;
    new bootstrap.Modal(document.getElementById("reasonModal")).show();
  });
});
</script>
</body>
</html>
