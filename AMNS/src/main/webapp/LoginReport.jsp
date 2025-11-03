<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, payrollmanagement.*" %>

<%
    String message = "";
    List<AttendanceBean> attendanceList = new ArrayList<>();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String action = request.getParameter("action");

        if ("runAttendanceReport".equals(action)) {
            try {
                AttendanceDAO dao = new AttendanceDAOImpl();
                String today = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

                boolean success = dao.processAttendanceForAll(today);

                if (success) {
                    attendanceList = dao.getAllAttendance();
                    request.setAttribute("attendanceList", attendanceList);
                    message = "✅ Attendance processed successfully for " + today;
                } else {
                    message = "❌ Attendance processing failed!";
                }

            } catch (Exception e) {
                e.printStackTrace();
                message = "❌ Error while generating attendance report!";
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login Report - Attendance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
         :root { --accent: #39bfbf; --danger: #dc3545; --light: #f8f9fa; }
    body { background: var(--light); font-family: "Segoe UI", Arial, sans-serif; margin:0; }
    .card { border-radius:12px; box-shadow:0 6px 18px rgba(0,0,0,0.08); border:0; }
    .card-header { background:var(--accent); color:#fff; font-weight:600; }
    .btn-accent { background:var(--accent); color:#fff; border:0; }
    .btn-accent:hover { background:#2ea1a1; }
    .accordion-button:not(.collapsed) { background: rgba(57,191,191,0.1); color: #0b3c3c; }
    .was-validated .form-control:invalid,
    .was-validated .form-select:invalid { border: 2px solid var(--danger); }
        /* Sidebar */
    .sidebar {
      height:100vh; background:#39bfbf; color:white;
      position:fixed; top:0; left:0; width:300px;
      padding-top:30px; box-sizing:border-box;
      display:flex; flex-direction:column; justify-content:space-between;
      transition:width 0.3s ease; overflow:hidden; text-align:center;
    }
    .sidebar.collapsed { width:70px; }
    .logo-text img { width:120px; height:auto; }
    .logo-tagline { font-size:12px; color:#fff; margin-top:6px; font-weight:400; }
    .sidebar.collapsed .logo-text, .sidebar.collapsed .logo-tagline { display:none; }
    .sidebar a {
      display:flex; align-items:center; gap:12px; color:#fff;
      padding:14px 20px; text-decoration:none; font-size:16px;
      margin:8px 0; border-radius:6px;
    }
    .sidebar a:hover { background:#12b5b5; }
    .sidebar.collapsed a { justify-content:center; gap:0; padding:14px; }
    .sidebar.collapsed a span { display:none; }
    .logout { background:#39bfbf; margin:15px; padding:10px 16px; border-radius:6px; text-align:center; }
    .logout:hover { background:#1a252f; }
        .logout { background: #39bfbf; margin: 15px; border-radius: 6px; text-align: center; padding: 10px 16px; }
    .logout:hover { background: #1a252f; }
    .toggle-btn { position: absolute; top: 15px; left: 15px; background: #39bfbf; border-radius: 50%; width: 40px; 
      height: 40px; border: none; color: #fff; font-size: 18px; cursor: pointer; display: flex; align-items: center; 
      justify-content: center; }
    .content { margin-left: 300px; padding: 20px; transition: margin-left 0.3s ease; }
    .content.collapsed { margin-left: 70px; }
    /* Accordion header */
.accordion-toggle {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  font-weight: 400;
  font-size: 16px;
  text-decoration: none;
  color: #0b3c3c;

  border-radius: 6px;
  transition: background 0.2s ease, color 0.2s ease;
}

/* Hover effect */
.accordion-toggle:hover {
  background: rgba(57, 191, 191, 0.1);
  color: #39bfbf;
}

/* Arrow */
.accordion-arrow {
  transition: transform 0.3s ease;
  font-size: 14px;
}

/* Rotate arrow when expanded */
.accordion-toggle[aria-expanded="true"] .accordion-arrow {
  transform: rotate(180deg);
}

/* Accordion body styling */
.accordion-body {
  padding: 16px;
 
  border: 1px solid #eee;
  border-radius: 6px;
  margin-top: 6px;
}
    .main { 
    margin-left: 300px; padding: 20px; transition: margin-left 0.3s ease, width 0.3s ease; width: calc(100% - 300px); 
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

  <!-- Main -->
  <div class="main" id="main">
    <!-- Top Navbar -->
     <div class="d-flex justify-content-between align-items-center mb-4">

      <div class="d-flex align-items-center">
        <div class="top-btn" id="theme-toggle"><i class="fa-solid d"></i></div>
        <div>
        <a href="notifications.jsp" class="top-btn"style="color: black;" title="View Notifications">
  		<i class="fa-solid fa-bell"></i>
		</a>
        </div>
        <div class="top-btn"><i class="fa-solid fa-user"></i></div>
      </div>
    </div>

    <% if (!message.isEmpty()) { %>
        <div class="alert alert-info"><%= message %></div>
    <% } %>

    <!-- Run Attendance Report Button -->
    <div class="card p-4 mb-4">
        <form method="post">
            <input type="hidden" name="action" value="runAttendanceReport">
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-database"></i> Run Attendance Report (Today)
            </button>
        </form>
    </div>

    <!-- Attendance Report Table -->
    <%
        List<AttendanceBean> list = (List<AttendanceBean>) request.getAttribute("attendanceList");
        if (list != null && !list.isEmpty()) {
    %>
    <div class="card p-4">
        <h5><i class="fa-solid fa-table"></i> Attendance Report</h5>
        <div class="table-responsive mt-3">
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>Emp ID</th>
                        <th>Emp Name</th>
                        <th>Date</th>
                        <th>First In</th>
                        <th>Last Out</th>
                        <th>Total Hours</th>
                        <th>OT Hours</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <% for (AttendanceBean row : list) { %>
                    <tr>
                        <td><%= row.getEmpId() %></td>
                        <td><%= row.getEmpName() %></td>
                        <td><%= row.getAttendanceDate() %></td>
                        <td><%= row.getFirstIn() %></td>
                        <td><%= row.getLastOut() %></td>
                        <td><%= row.getTotalWorkHours() %></td>
                        <td><%= row.getOvertimeHours() %></td>
                        <td><%= row.getStatus() %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>
  </div>

  <!-- Logout Modal -->
  <div class="modal fade" id="logoutModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title"><i class="fa-solid fa-right-from-bracket"></i> Confirm Logout</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">Are you sure you want to logout?</div>
        <div class="modal-footer">
          <button class="btn btn-secondary" data-bs-dismiss="modal">No</button>
          <button class="btn btn-danger" id="confirmLogoutBtn">Yes, Logout</button>
        </div>
      </div>
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
    if (sidebar.classList.contains('collapsed')) {
      toggleIcon.classList.replace('fa-arrow-left', 'fa-bars');
    } else {
      toggleIcon.classList.replace('fa-bars', 'fa-arrow-left');
    }
  });

  // Theme toggle
  const themeToggle = document.getElementById("theme-toggle");
  themeToggle.addEventListener("click", () => {
    document.body.classList.toggle("dark-mode");
    const icon = themeToggle.querySelector("i");
    icon.classList.toggle("fa-sun");
    icon.classList.toggle("fa-moon");
  });

  // Logout modal
  const logoutBtn = document.getElementById("logoutBtn");
  const confirmLogoutBtn = document.getElementById("confirmLogoutBtn");
  if (logoutBtn) {
    logoutBtn.addEventListener("click", (e) => {
      e.preventDefault();
      const modal = new bootstrap.Modal(document.getElementById("logoutModal"));
      modal.show();
    });
  }
  if (confirmLogoutBtn) {
    confirmLogoutBtn.addEventListener("click", () => {
      window.location.href = "login.jsp";
    });
  }
</script>
</body>
</html>
