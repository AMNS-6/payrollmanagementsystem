<%@ page import="payrollmanagement.UserBean" %>
<%@ page import="payrollmanagement.EmployeeBean" %>
<%@ page import="payrollmanagement.EmployeeDAO" %>
<%@ page import="payrollmanagement.EmployeeDAOImpl" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<%
    // ✅ Step 1: Verify session
    UserBean user = (UserBean) session.getAttribute("user");
    if (user == null || !"EMPLOYEE".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // ✅ Step 2: Fetch employee info
    EmployeeDAO empDao = new EmployeeDAOImpl();
    EmployeeBean emp = empDao.getEmployeeByUserId(user.getUserId());

    if (emp == null) {
        out.println("<h3 style='color:red'>⚠ No employee record found for " + user.getUsername() + "</h3>");
        return;
    }

    // ✅ Step 3: Handle form submission
    String otDate = request.getParameter("otDate");
    String reason = request.getParameter("reason");
    String hoursStr = request.getParameter("hours");

    if (otDate != null && reason != null && hoursStr != null) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/amns", "root", "gniharika@4");

            String sql = "INSERT INTO Overtime_Record(emp_id, ot_policy_id, ot_date, reason, hours_worked, status, payout_cycle) "
                    + "VALUES (?, ?, ?, ?, ?, 'Pending', ?)";

         ps = conn.prepareStatement(sql);
         ps.setInt(1, emp.getEmpId());
         ps.setInt(2, 1); // ✅ assuming standard policy = 1
         ps.setString(3, otDate);
         ps.setString(4, reason);
         ps.setDouble(5, Double.parseDouble(hoursStr));
         ps.setDate(6, new java.sql.Date(System.currentTimeMillis())); // ✅ payout_cycle = current month end or similar
         ps.executeUpdate();
        } catch (Exception e) {
            out.println("<pre style='color:red'>" + e.getMessage() + "</pre>");
            e.printStackTrace();  // logs in server console
        } finally {
            try { if (ps != null) ps.close(); } catch(Exception ex) {}
            try { if (conn != null) conn.close(); } catch(Exception ex) {}
        }
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
    body.dark-mode { background:#1e1e2f; color:#e5e5e5; }
    body.dark-mode .card { background:#2b2b3c; color:#fff; }
    body.dark-mode .table th { background:#39bfbf !important; }
    body.dark-mode .sidebar { background:#252537; }
    body.dark-mode .sidebar a:hover { background:#39bfbf; }

    /* Sidebar */
    .sidebar { height:100vh; background:#39bfbf; color:white; position:fixed; top:0; left:0; width:300px;
      padding-top:30px; display:flex; flex-direction:column; justify-content:space-between;
      transition:width 0.3s ease; overflow:hidden; text-align:center; }
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

    /* Toggle Button */
    .toggle-btn { position:absolute; top:15px; left:15px; background:#39bfbf; border-radius:50%; width:40px; height:40px;
      border:none; color:#fff; font-size:18px; cursor:pointer; display:flex; align-items:center; justify-content:center; z-index:10; }

    /* Main */
    .main { margin-left:300px; padding:20px; transition:margin-left 0.3s; }
    .main.collapsed { margin-left:70px; }
    .btn-custom { background-color:#39bfbf; border:none; }
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
        <a href="#"><i class="fa-solid fa-calendar-check"></i> <span>Attendance</span></a>
        <a href="LeaveRequest.jsp"><i class="fa-solid fa-leaf"></i> <span>Leave Request</span></a>
        <a href="EmpPaySlip.jsp"><i class="fa-solid fa-file-invoice"></i> <span>My Payslips</span></a>
        <a href="EmpPayRollSummary.jsp"><i class="fa-solid fa-user"></i> <span>Payroll Summary</span></a>
        <a href="OtRequest.jsp" class="active"><i class="fa-solid fa-clock"></i> <span>OT Request</span></a>
    </div>
    <a href="LogoutServlet" class="logout"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
  </div>

  <!-- Main -->
  <div class="main" id="main">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Overtime Request</h2>
    </div>

    <!-- ✅ OT Request Form -->
    <div class="card p-4 shadow mb-5">
      <form action="OtRequest.jsp" method="post">

        <input type="hidden" name="empId" value="<%= emp.getEmpId() %>"/>

        <div class="mb-3">
          <label class="form-label">Employee Name</label>
          <input type="text" class="form-control" value="<%= emp.getFirst_name() %> <%= emp.getLast_name() %>" readonly>
        </div>

        <div class="mb-3">
          <label for="ot_date" class="form-label">Overtime Date</label>
          <input type="date" class="form-control" id="ot_date" name="otDate" required>
        </div>

        <div class="mb-3">
          <label for="reason" class="form-label">Reason for Overtime</label>
          <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
        </div>

        <div class="mb-3">
          <label for="hours_worked" class="form-label">Hours Worked</label>
          <input type="number" step="0.25" class="form-control" id="hours_worked" name="hours" required>
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
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/amns", "root", "gniharika@4");

                String fetchSql = "SELECT ot_date, reason, hours_worked, status FROM Overtime_Record WHERE emp_id=? ORDER BY ot_date DESC";
                ps = conn.prepareStatement(fetchSql);
                ps.setInt(1, emp.getEmpId());
                rs = ps.executeQuery();

                while (rs.next()) {
                    String status = rs.getString("status");
                    String badgeClass = "bg-warning";
                    if ("Approved".equalsIgnoreCase(status)) badgeClass = "bg-success";
                    else if ("Rejected".equalsIgnoreCase(status)) badgeClass = "bg-danger";
          %>
              <tr>
                <td><%= rs.getString("ot_date") %></td>
                <td><%= rs.getString("reason") %></td>
                <td><%= rs.getDouble("hours_worked") %></td>
                <td><span class="badge <%= badgeClass %>"><%= status %></span></td>
              </tr>
          <%
                }
            } catch (Exception e) {
                out.println("<pre style='color:red'>" + e.getMessage() + "</pre>");
                e.printStackTrace();
            } finally {
                try { if (rs != null) rs.close(); } catch(Exception ex) {}
                try { if (ps != null) ps.close(); } catch(Exception ex) {}
                try { if (conn != null) conn.close(); } catch(Exception ex) {}
            }
          %>
        </tbody>
      </table>
    </div>
  </div>

  <!-- JS -->
  <script>
    const sidebar=document.getElementById('sidebar');
    const main=document.getElementById('main');
    const toggleBtn=document.getElementById('toggle-btn');
    const toggleIcon=toggleBtn.querySelector('i');
    toggleBtn.addEventListener('click',()=>{
      sidebar.classList.toggle('collapsed');
      main.classList.toggle('collapsed');
      toggleIcon.classList.toggle('fa-bars');
      toggleIcon.classList.toggle('fa-arrow-left');
    });
  </script>
</body>
</html>