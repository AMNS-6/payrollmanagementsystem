<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*, payrollmanagement.*" %>

<%
    UserBean user = (UserBean) session.getAttribute("user");
    

    AttendanceDAOImpl attendanceDAO = new AttendanceDAOImpl();
    List<AttendanceBean> attendanceList = new ArrayList<>();
    AttendanceSummaryDTO summary = new AttendanceSummaryDTO();
    String message = "";

    try {
        int empId = -1;
        try (Connection conn = ConnectionFactory.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT emp_id, first_name, last_name FROM Employee_Master WHERE user_id=?")) {
                ps.setInt(1, user.getUserId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        empId = rs.getInt("emp_id");
                        user.setUsername(rs.getString("first_name") + " " + rs.getString("last_name"));
                    }
                }
            }
        }

        if (empId > 0) {
            // Process today's attendance automatically
            String today = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
            attendanceDAO.processAttendance(user.getUserId(), today);

            // Fetch attendance for employee
            attendanceList = attendanceDAO.getAttendanceByEmp(empId);

            // Fetch monthly summary
            Calendar cal = Calendar.getInstance();
            int year = cal.get(Calendar.YEAR);
            int month = cal.get(Calendar.MONTH) + 1;
            summary = attendanceDAO.getAttendanceSummary(user.getUserId(), year, month);
        }

    } catch (Exception e) {
        e.printStackTrace();
        message = "❌ Error while generating attendance report!";
    }

    SimpleDateFormat sdfTime = new SimpleDateFormat("hh:mm a");
    SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Employee Attendance Report</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <style>
    body { margin: 0; font-family: Arial, sans-serif; background-color: #f8f9fa; display: flex; }
       /* Sidebar */
    .sidebar {
      height:100vh; 
      background:#39bfbf; 
      color:white;
      position:fixed;
      top:0; 
      left:0; 
      width:300px;
      padding-top:30px; 
      box-sizing:border-box;
      display:flex; 
      flex-direction:column; 
      justify-content:space-between;
      transition:width 0.3s ease; 
      overflow:hidden; 
      text-align:center;
    }
    .sidebar.collapsed { 
    width:70px;
     }
      /* Logo */
    .logo-container {
      margin-bottom: 20px;
    }
     
    .logo-text img { 
    width:120px; 
    height:auto;
     }
    .logo-tagline { 
    font-size:12px; 
    color:#fff; 
    margin-top:6px; 
    font-weight:400;
    line-weight:1.3;
     }
    .sidebar.collapsed .logo-text,
     .sidebar.collapsed .logo-tagline { 
     display:none; 
     }
     .menu {
      flex-grow: 1;
      text-align: left;
    }
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

    /* Toggle Button */
    .toggle-btn {
      position:absolute; top:15px; left:15px;
      background:#39bfbf; border-radius:50%; width:40px; height:40px;
      border:none; color:#fff; font-size:18px; cursor:pointer;
      display:flex; align-items:center; justify-content:center;
      z-index:10;
    }
        .main { margin-left:200px; padding:20px; width: calc(100% - 300px);}
    .table th { background-color: #f1f3f4; }
    .clock-time { color: #48dbb7; font-weight: bold; }
    .duration { color: #6fc149; font-size:0.9rem; margin:0 8px;}
    .overtime { color:#08a82d; font-weight:bold; }
    .logout { background:#39bfbf; margin:15px; padding:10px 16px; border-radius:6px; text-align:center; }
    .logout:hover { background:#1a252f; }
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
  <a href="emp_dashboard.jsp"><i class="fa-solid fa-house"></i> <span>Dashboard</span></a>
  <a href="EmpProfile.jsp"><i class="fa-solid fa-user"></i> <span>Profile</span></a>
  <a href="attendance.jsp"><i class="fa-solid fa-calendar-check"></i> <span>Attendance</span></a>
  <a href="LeaveRequest.jsp"><i class="fa-solid fa-plane-departure"></i> <span>Leave Request</span></a>
  <a href="EmpPaySlip.html"><i class="fa-solid fa-file-invoice-dollar"></i> <span>My Payslips</span></a>
  <a href="OtRequest.jsp"><i class="fa-solid fa-stopwatch me-2"></i> <span>OT Request</span></a>
</div>


    <a href="#" class="logout" id="logoutBtn">
  <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
</a>
  </div>

  <!-- Main Content -->
  <div class="main">
    <h3>My Attendance Report - <%= user.getUsername() %></h3>
    <% if (!message.isEmpty()) { %>
      <div class="alert alert-info"><%= message %></div>
    <% } %>

    <!-- Attendance Table -->
    <div class="card shadow mt-3">
      <div class="card-body">
        <table class="table table-hover align-middle text-center">
          <thead>
            <tr>
              <th>Date</th>
              <th>Clock-in and Out</th>
              <th>Overtime (hrs)</th>
            </tr>
          </thead>
          <tbody>
            <%
            for (AttendanceBean ab : attendanceList) {
                String status = ab.getStatus();
                if ("Leave".equalsIgnoreCase(status) || "Holiday".equalsIgnoreCase(status) || "WeeklyOff".equalsIgnoreCase(status)) {
            %>
            <tr>
              <td><%= sdfDate.format(ab.getAttendanceDate()) %></td>
              <td class="text-danger fw-bold"><%= status %></td>
              <td>-</td>
            </tr>
            <%
                } else {
                    // Convert java.util.Date to Timestamp safely
                    Timestamp firstIn = ab.getFirstIn() != null ? new Timestamp(ab.getFirstIn().getTime()) : null;
                    Timestamp firstOut = ab.getLastOut() != null ? new Timestamp(ab.getLastOut().getTime()) : null;
            %>
            <tr>
              <td><%= sdfDate.format(ab.getAttendanceDate()) %></td>
              <td>
                <span class="clock-time"><%= firstIn != null ? sdfTime.format(firstIn) : "-" %></span>
                <span class="duration">— <%= firstIn != null && firstOut != null ? ((firstOut.getTime()-firstIn.getTime())/(1000*3600))+"h" : "-" %> —</span>
                <span class="clock-time"><%= firstOut != null ? sdfTime.format(firstOut) : "-" %></span>
              </td>
              <td class="overtime"><%= ab.getOvertimeHours() > 0 ? ab.getOvertimeHours() : "-" %></td>
            </tr>
            <%
                }
            }
            %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Attendance Summary -->
    <div class="card shadow mt-4">
      <div class="card-body">
        <h5><i class="fa-solid fa-chart-pie"></i> Attendance Summary (This Month)</h5>
        <table class="table table-bordered text-center mt-3">
          <thead class="table-light">
            <tr>
              <th>Total Working Days</th>
              <th>Present</th>
              <th>Leaves Taken</th>
              <th>Holidays</th>
              <th>Sundays</th>
              <th>Absents</th>
              <th>Overtime (hrs)</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td><%= summary.getTotalDays() %></td>
              <td><%= summary.getPresentDays() %></td>
              <td><%= summary.getLeaveDays() %></td>
              <td><%= summary.getHolidayDays() %></td>
              <td><%= summary.getSundayDays() %></td>
              <td><%= summary.getAbsentDays() %></td>
              <td><%= summary.getOvertimeHours() %></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

  </div>

</body>
</html>
