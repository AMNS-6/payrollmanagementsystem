<%@ page import="payrollmanagement.UserBean" %>
<%@ page import="payrollmanagement.EmployeeBean" %>
<%@ page import="payrollmanagement.EmployeeDAO" %>
<%@ page import="payrollmanagement.EmployeeDAOImpl" %>
<%@ page import="payrollmanagement.OverTimeBean" %>
<%@ page import="payrollmanagement.OverTimeDAO" %>
<%@ page import="payrollmanagement.OverTimeDAOImpl" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<%
    // ✅ Step 1: Verify session
    UserBean user = (UserBean) session.getAttribute("user");
    if (user == null || !"EMPLOYEE".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ✅ Step 2: Fetch employee info dynamically
    EmployeeDAO empDao = new EmployeeDAOImpl();
    EmployeeBean emp = empDao.getEmployeeById(user.getUserId());

    if (emp == null) {
        out.println("<h3 style='color:red'> No employee record found for " + user.getUsername() + "</h3>");
        return;
    }

    // ✅ Step 3: Handle OT submission with redirect
    String otDateStr = request.getParameter("otDate");
    String reason = request.getParameter("reason");
    String hoursStr = request.getParameter("hours");

    OverTimeDAO otDao = new OverTimeDAOImpl();

    if ("POST".equalsIgnoreCase(request.getMethod()) && otDateStr != null && reason != null && hoursStr != null) {
        try {
            OverTimeBean ot = new OverTimeBean();
            ot.setEmpId(emp.getEmpId());
            ot.setOtDate(java.sql.Date.valueOf(otDateStr));
            ot.setReason(reason);
            ot.setHoursWorked(Double.parseDouble(hoursStr));
            ot.setOtPolicyId(1);
            ot.setPayoutCycle(new java.util.Date());

            int newId = otDao.applyOvertime(ot);

            // ✅ Save success message in session and redirect
            session.setAttribute("ot_message", "Overtime request submitted successfully (Request ID: " + newId + ")");
            response.sendRedirect("OtRequest.jsp");
            return;

        } catch (Exception e) {
            session.setAttribute("ot_message", "Error submitting overtime: " + e.getMessage());
            response.sendRedirect("OtRequest.jsp");
            return;
        }
    }

    // ✅ Step 4: Show message once
    String message = (String) session.getAttribute("ot_message");
    if (message != null) {
        session.removeAttribute("ot_message");
    }

    // ✅ Step 5: Fetch overtime records dynamically
    List<OverTimeBean> otList = new ArrayList<>();
    try {
        otList = otDao.getOvertimeRecordsForEmployee(emp.getEmpId());
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OT Request - Payroll Management</title>
  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    body { margin:0; font-family:Arial, sans-serif; background:#f4f6f9; color:#333; transition:all 0.3s ease; }
    .sidebar { height:100vh; background:#39bfbf; color:white; position:fixed; top:0; left:0; width:300px;
      padding-top:30px; display:flex; flex-direction:column; justify-content:space-between; transition:width 0.3s ease; overflow:hidden; text-align:center; }
    .sidebar.collapsed { width:70px; }
    .logo-text img { width:120px; height:auto; }
    .logo-tagline { font-size:12px; color:#fff; margin-top:6px; font-weight:400; }
    .sidebar.collapsed .logo-text, .sidebar.collapsed .logo-tagline { display:none; }
    .sidebar a { display:flex; align-items:center; gap:12px; color:#fff; padding:14px 20px; text-decoration:none;
      font-size:16px; margin:8px 0; border-radius:6px; }
    .sidebar a:hover { background:#12b5b5; }
    .sidebar.collapsed a { justify-content:center; gap:0; padding:14px; }
    .sidebar.collapsed a span { display:none; }
    .logout { background:#39bfbf; margin:15px; padding:10px 16px; border-radius:6px; text-align:center; }
    .logout:hover { background:#1a252f; }
    .toggle-btn { position:absolute; top:15px; left:15px; background:#39bfbf; border-radius:50%; width:40px; height:40px;
      border:none; color:#fff; font-size:18px; cursor:pointer; display:flex; align-items:center; justify-content:center; z-index:10; }
    .main { margin-left:300px; padding:20px; transition:margin-left 0.3s; }
    .main.collapsed { margin-left:70px; }
    .btn-custom { background-color:#39bfbf; border:none; }
    .msg { text-align:center; font-weight:bold; color:green; }
  </style>
</head>
<body>

  <!-- Sidebar -->
  <div class="sidebar" id="sidebar">
    <button class="toggle-btn" id="toggle-btn"><i class="fa-solid fa-arrow-left"></i></button>
    <div class="logo-container">
      <div class="logo-text"><img src="images/logo.png"></div>
      <div class="logo-tagline">Your Punctual Partner for Workforce<br>Management</div>
    </div>
    <div class="menu">
        <a href="emp_dashboard.jsp"><i class="fa-solid fa-gauge"></i> <span>Dashboard</span></a>
        <a href="EmpProfile.jsp"><i class="fa-solid fa-user"></i> <span>Profile</span></a>
        <a href="attendance.jsp"><i class="fa-solid fa-calendar-check"></i> <span>Attendance</span></a>
        <a href="LeaveRequest.jsp"><i class="fa-solid fa-leaf"></i> <span>Leave Request</span></a>
        <a href="EmpPaySlip.html"><i class="fa-solid fa-file-invoice"></i> <span>My Payslips</span></a>
        <a href="OtRequest.jsp" class="active"><i class="fa-solid fa-clock"></i> <span>OT Request</span></a>
    </div>
    <a href="LogoutServlet" class="logout"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
  </div>

  <!-- Main -->
  <div class="main" id="main">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Overtime Request</h2>
    </div>

    <% if (message != null) { %>
      <p class="msg"><%= message %></p>
    <% } %>

    <!-- ✅ OT Request Form -->
    <div class="card p-4 shadow mb-5">
      <form action="OtRequest.jsp" method="post">
        <div class="mb-3">
          <label class="form-label">Employee Name</label>
          <input type="text" class="form-control" value="<%= emp.getFirst_name() + " " + emp.getLast_name() %>" readonly>
        </div>

        <div class="mb-3">
          <label class="form-label">Employee ID</label>
          <input type="text" class="form-control" value="<%= emp.getEmpId() %>" readonly>
        </div>

        <div class="mb-3">
          <label class="form-label">Overtime Date</label>
          <input type="date" class="form-control" name="otDate" required>
        </div>

        <div class="mb-3">
          <label class="form-label">Reason for Overtime</label>
          <textarea class="form-control" name="reason" rows="3" required></textarea>
        </div>

        <div class="mb-3">
          <label class="form-label">Hours Worked</label>
          <input type="number" step="0.25" class="form-control" name="hours" required>
        </div>

        <button type="submit" class="btn btn-custom w-100">Submit Request</button>
      </form>
    </div>

    <!-- ✅ OT Requests Table -->
    <div class="card p-4 shadow">
      <h5 class="mb-3">My Overtime Requests</h5>
      <table class="table table-striped">
        <thead>
          <tr>
            <th>OT Date</th>
            <th>Reason</th>
            <th>Hours Worked</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          <%
            if (otList != null && !otList.isEmpty()) {
              for (OverTimeBean ot : otList) {
                  String badgeClass = "bg-warning";
                  if ("Approved".equalsIgnoreCase(ot.getStatus())) badgeClass = "bg-success";
                  else if ("Rejected".equalsIgnoreCase(ot.getStatus())) badgeClass = "bg-danger";
          %>
              <tr>
                <td><%= ot.getOtDate() %></td>
                <td><%= ot.getReason() %></td>
                <td><%= ot.getHoursWorked() %></td>
                <td><span class="badge <%= badgeClass %>"><%= ot.getStatus() %></span></td>
              </tr>
          <%
              }
            } else {
          %>
              <tr><td colspan="4" class="text-center">No overtime records found.</td></tr>
          <% } %>
        </tbody>
      </table>
    </div>
  </div>

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
