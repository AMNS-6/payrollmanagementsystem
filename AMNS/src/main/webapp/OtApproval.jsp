<%@ page import="payrollmanagement.*" %>
<%@ page import="java.util.*" %>

<%
    // Step 1: Verify HR/Manager session
    UserBean user = (UserBean) session.getAttribute("user");
    if (user == null || !"HR".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    OverTimeDAO otDao = new OverTimeDAOImpl();
    List<OverTimeBean> pendingList = new ArrayList<>();
    String msg = "";

    //  Step 2: Handle Approve/Reject
    String action = request.getParameter("action");
    String otIdStr = request.getParameter("otId");

    if (action != null && otIdStr != null) {
        try {
            int otId = Integer.parseInt(otIdStr);
            OverTimeBean bean = new OverTimeBean();
            bean.setOtId(otId);
            bean.setApproverEmpId(user.getEmpId());  // HR or Manager ID
            bean.setStatus(action);
            bean.setReason("Processed by " + user.getUsername());

            String result = otDao.approveOvertime(bean);

            // Prevent resubmission on refresh (Post-Redirect-Get)
            session.setAttribute("ot_message", "<div class='alert alert-success'>" + result + "</div>");
            response.sendRedirect("OtApproval.jsp");
            return;
        } catch (Exception e) {
            session.setAttribute("ot_message", "<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            response.sendRedirect("OtApproval.jsp");
            return;
        }
    }

    //  Step 3: Fetch message after redirect
    if (session.getAttribute("ot_message") != null) {
        msg = (String) session.getAttribute("ot_message");
        session.removeAttribute("ot_message");
    }

    //  Step 4: Fetch pending OT requests
    try {
        pendingList = otDao.getPendingOvertimeRequests();
    } catch (Exception e) {
        msg = "<div class='alert alert-danger'>Error fetching pending OT: " + e.getMessage() + "</div>";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OT Approval - Payroll Management</title>
 <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    body { background-color: #f8f9fa; }
    .container { margin-top: 40px; }
    .badge { font-size: 0.9rem; }
    h2 { margin-bottom: 25px; text-align:center; }
    #tablehd{
    background-color:#39bfbf !important;
    }
    .heading{
    color:#39bfbf !important;
    text-align:center;
    font-weight:bold;
    }
    
    /* Sidebar */
    .sidebar {
      height: 100vh;
      background: #39bfbf;
      color: white;
      position: fixed;
      top: 0;
      left: 0;
      width: 300px;
      padding-top: 30px;
      box-sizing: border-box;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      transition: width 0.3s ease;
      overflow: hidden;
      text-align: center;
    }

    .sidebar.collapsed {
      width: 70px;
    }

    /* Logo */
    .logo-container {
      margin-bottom: 20px;
    }

    .logo-text img {
      width: 120px;
      height: auto;
    }

    .logo-tagline {
      font-size: 12px;
      color: #fff;
      margin-top: 6px;
      font-weight: 400;
      line-height: 1.3;
    }

    .sidebar.collapsed .logo-text,
    .sidebar.collapsed .logo-tagline {
      display: none;
    }

    .menu {
      flex-grow: 1;
      text-align: left;
    }

    .sidebar a {
      display: flex;
      align-items: center;
      gap: 12px;
      color: #ffffff;
      padding: 14px 20px;
      text-decoration: none;
      font-size: 16px;
      margin: 8px 0;
      border-radius: 6px;
      transition: background 0.3s, padding 0.3s;
    }

    .sidebar a i {
      font-size: 18px;
      width: 20px;
      text-align: center;
    }

    .sidebar.collapsed a {
      justify-content: center;
      gap: 0;
      padding: 14px;
    }

    .sidebar.collapsed a span {
      display: none;
    }

    .sidebar a:hover {
      background: #12b5b5;
      color: #fff;
    }

    /* Submenu links */
    .submenu a {
      font-size: 15px;
      padding: 10px 40px;
      display: block;
      color: #fff;
    }

    .submenu a:hover {
      background: #12b5b5;
    }

    /* Logout style */
    .logout {
      background: #39bfbf;
      color: #fff !important;
      font-size: 14px;
      padding: 10px 16px;
      margin: 15px;
      border-radius: 6px;
      text-align: center;
    }

    .logout i {
      font-size: 14px;
    }

    .logout:hover {
      background: #1a252f;
    }
        /* Main Content */
    
    .main {
  margin-left: 300px;
  padding: 20px;
  padding-top: 60px; /* ✅ Prevent overlap with top toggle */
  transition: margin-left 0.3s;
}

.main.collapsed {
  margin-left: 70px;
  padding-top: 60px; /* ✅ Keep same spacing when collapsed */
}
    

    /* Toggle button */
    .toggle-btn {
      position: absolute;
      top: 15px;
      left: 15px;
      background: #39bfbf;
      border-radius: 50%;
      width: 40px;
      height: 40px;
      border: none;
      color: #fff;
      font-size: 18px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 2px 6px rgba(0,0,0,0.2);
      transition: background 0.3s;
      z-index: 10;
    }

    .toggle-btn:hover {
      background: #12b5b5;
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
      <a href="LoginReport.jsp"><i class="fa-solid fa-clipboard-check"></i> <span>Login Report</span></a>

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

    <!-- Logout Button -->
   <a href="#" class="logout" id="logoutBtn">
  <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
</a>
  </div>
  <div class="main" id="main">

    <h1 class="heading">Pending Overtime Requests</h1>
    <%= msg %>

    <table class="table table-striped table-bordered align-middle">
        <thead id ="tablehd"class="table text-center">
            <tr>
                <th>OT ID</th>
                <th>Employee ID</th>
                <th>OT Date</th>
                <th>Policy</th>
                <th>Reason</th>
                <th>Hours Worked</th>
                <th>Payout Cycle</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody class="text-center">
        <%
            if (pendingList != null && !pendingList.isEmpty()) {
                for (OverTimeBean ot : pendingList) {
        %>
            <tr>
                <td><%= ot.getOtId() %></td>
                <td><%= ot.getEmpId() %></td>
                <td><%= ot.getOtDate() %></td>
                <td><%= ot.getOtPolicyId() %></td>
                <td><%= ot.getReason() %></td>
                <td><%= ot.getHoursWorked() %></td>
                <td><%= ot.getPayoutCycle() %></td>
                <td><span class="badge bg-warning text-dark"><%= ot.getStatus() %></span></td>
                <td>
                    <form method="post" style="display:inline-block;">
                        <input type="hidden" name="otId" value="<%= ot.getOtId() %>"/>
                        <button type="submit" name="action" value="Approved" class="btn btn-success btn-sm me-1">Approve</button>
                        <button type="submit" name="action" value="Rejected" class="btn btn-danger btn-sm">Reject</button>
                    </form>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr><td colspan="9" class="text-center text-muted">No pending overtime requests found.</td></tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

  <!-- Sidebar Toggle -->
  <script>
    const sidebar = document.getElementById('sidebar');
    const main = document.getElementById('main');
    const toggleBtn = document.getElementById('toggle-btn');
    const toggleIcon = toggleBtn.querySelector('i');
    toggleBtn.addEventListener('click', ()=>{
      sidebar.classList.toggle('collapsed');
      main.classList.toggle('collapsed');
      toggleIcon.classList.toggle('fa-bars');
      toggleIcon.classList.toggle('fa-arrow-left');
    });
  </script>
</body>
</html>
