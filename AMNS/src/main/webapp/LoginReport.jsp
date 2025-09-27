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
      body {
        background: #f4f6f9;
        transition: all 0.3s ease;
      }
      body.dark-mode { background: #1e1e2f; color: #e5e5e5; }
      body.dark-mode .card { background: #2b2b3c; color: #fff; }
      body.dark-mode .table th { background: #39bfbf !important; }

      /* Sidebar */
      .sidebar { height: 100vh; background: #39bfbf; color: white; position: fixed; top:0; left:0; width:300px; padding-top:30px; transition: width 0.3s ease; overflow:hidden; }
      .sidebar.collapsed { width:70px; }
      .sidebar a { display:flex; align-items:center; gap:12px; color:white; padding:12px 20px; text-decoration:none; border-radius:6px; margin:8px 0; }
      .sidebar a:hover { background:#12b5b5; }
      .sidebar.collapsed a span { display:none; }
      .sidebar.collapsed a { justify-content:center; gap:0; }

      .main { margin-left:300px; padding:20px; transition: margin-left 0.3s; }
      .main.collapsed { margin-left:70px; }

      .table th { background:#39bfbf; color:white; }

      /* Toggle button */
      .toggle-btn {
        position: absolute; top: 15px; left: 15px;
        background: #39bfbf; border-radius: 50%; width: 40px; height: 40px;
        border: none; color: #fff; font-size: 18px;
        display:flex; align-items:center; justify-content:center;
        cursor:pointer; z-index:10;
      }
      .toggle-btn:hover { background:#12b5b5; }

      /* Top buttons */
      .top-btn { width:40px; height:40px; border-radius:50%; background:#e5e7eb;
        display:flex; align-items:center; justify-content:center; margin-left:10px; cursor:pointer; }
      .top-btn i { font-size:18px; }
      body.dark-mode .top-btn { background:#444; }
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

      <a href="LeaveApproval.html"><i class="fa-solid fa-user-check"></i> <span>Leave Approval</span></a>
      <a href="PayRoll.html"><i class="fa-solid fa-money-check-dollar"></i> <span>Payroll</span></a>
      <a href="OtApproval.html"><i class="fa-solid fa-stopwatch me-2"></i> <span>Overtime Approval</span></a>
      <a href="Holiday.html"><i class="fa-solid fa-calendar-days"></i> <span>Holidays</span></a>
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
      <h2><i class="fa-solid fa-clipboard-list"></i> Login Report</h2>
      <div class="d-flex align-items-center">
        <div class="top-btn" id="theme-toggle"><i class="fa-solid fa-moon"></i></div>
        <div class="top-btn"><i class="fa-solid fa-bell"></i></div>
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
