<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="payrollmanagement.EmployeeBean, payrollmanagement.EmployeeDAO, payrollmanagement.EmployeeDAOImpl, payrollmanagement.UserBean" %>

<%
    UserBean user = (UserBean) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    EmployeeDAO dao = new EmployeeDAOImpl();
    EmployeeBean emp = dao.getEmployeeByUsername(user.getUsername());
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Employee Profile</title>

  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    :root { --accent: #39bfbf; --light: #f8f9fa; }
    body { background: var(--light); font-family: "Segoe UI", Arial, sans-serif; margin:0; }
    .card { border-radius:12px; box-shadow:0 6px 18px rgba(0,0,0,0.08); border:0; }
    .card-header { background:var(--accent); color:#fff; font-weight:600; }
    .profile-label { font-weight:600; }
    .row + .row { margin-top:10px; }

    /* Sidebar (same as before) */
    .sidebar { height:100vh; background:#39bfbf; color:white; position:fixed; top:0; left:0; width:300px;
      padding-top:30px; display:flex; flex-direction:column; justify-content:space-between; transition:width 0.3s; overflow:hidden; text-align:center;}
    .sidebar.collapsed { width:70px; }
    .logo-text img { width:120px; height:auto; }
    .logo-tagline { font-size:12px; color:#fff; margin-top:6px; font-weight:400; }
    .sidebar.collapsed .logo-text, .sidebar.collapsed .logo-tagline { display:none; }
    .sidebar a { display:flex; align-items:center; gap:12px; color:#fff; padding:14px 20px; text-decoration:none; font-size:16px; margin:8px 0; border-radius:6px; }
    .sidebar a:hover { background:#12b5b5; }
    .sidebar.collapsed a { justify-content:center; gap:0; padding:14px; }
    .sidebar.collapsed a span { display:none; }
    .logout { background:#39bfbf; margin:15px; border-radius:6px; text-align:center; padding:10px 16px; }
    .logout:hover { background:#1a252f; }
    .toggle-btn { position:absolute; top:15px; left:15px; background:#39bfbf; border-radius:50%; width:40px; height:40px;
      border:none; color:#fff; font-size:18px; cursor:pointer; display:flex; align-items:center; justify-content:center; }
    .content { margin-left:300px; padding:20px; transition: margin-left 0.3s; }
    .content.collapsed { margin-left:70px; }
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
    <a href="LeaveRequest.html"><i class="fa-solid fa-plane-departure"></i> <span>Leave Request</span></a>
    <a href="EmpPaySlip.html"><i class="fa-solid fa-file-invoice-dollar"></i> <span>My Payslips</span></a>
    <a href="OtRequest.jsp"><i class="fa-solid fa-stopwatch me-2"></i> <span>OT Request</span></a>
  </div>
  <a href="#" class="logout" id="logoutBtn"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
</div>

<!-- Main Content -->
<main class="content" id="main">
  <div class="card">
    <div class="card-header"><i class="fa-solid fa-id-card me-2"></i> Employee Profile</div>
    <div class="card-body">
      <% if (emp == null) { %>
        <div class="alert alert-warning">⚠️ Profile not found for <b><%= user.getUsername() %></b></div>
      <% } else { %>

      <h4 class="mb-4">Welcome, <%= emp.getFirst_name() %> <%= emp.getLast_name() %></h4>

      <!-- Identity (no accordion) -->
      <h5>Identity</h5>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">Name:</span> <%= emp.getFirst_name() %> <%= emp.getLast_name() %></div>
        <div class="col-md-6"><span class="profile-label">DOB:</span> <%= emp.getDob() %></div>
      </div>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">Gender:</span> <%= emp.getGender() %></div>
        <div class="col-md-6"><span class="profile-label">Marital Status:</span> <%= emp.getMarital_status() %></div>
      </div>

      <!-- Contact -->
      <h5 class="mt-4">Contact Info</h5>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">Email:</span> <%= emp.getEmail() %></div>
        <div class="col-md-6"><span class="profile-label">Phone:</span> <%= emp.getPhone() %></div>
      </div>
      <div class="row">
        <div class="col-md-12"><span class="profile-label">Address:</span> <%= emp.getAddress_line1() %>, <%= emp.getCity() %>, <%= emp.getState() %> - <%= emp.getPostal_code() %></div>
      </div>

      <!-- Emergency -->
      <h5 class="mt-4">Emergency Contact</h5>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">Name:</span> <%= emp.getEmergency_name() %></div>
        <div class="col-md-6"><span class="profile-label">Relation:</span> <%= emp.getEmergency_relation() %></div>
      </div>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">Phone:</span> <%= emp.getEmergency_phone() %></div>
      </div>

      <!-- Employment -->
      <h5 class="mt-4">Employment Details</h5>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">Date of Joining:</span> <%= emp.getDate_of_joining() %></div>
        <div class="col-md-6"><span class="profile-label">Designation:</span> <%= emp.getDesignation() %></div>
      </div>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">Employment Type:</span> <%= emp.getEmployment_type() %></div>
        <div class="col-md-3"><span class="profile-label">Team ID:</span> <%= emp.getTeam_id() %></div>
        <div class="col-md-3"><span class="profile-label">Shift ID:</span> <%= emp.getShift_id() %></div>
      </div>

      <!-- Bank & Legal -->
      <h5 class="mt-4">Bank & Legal</h5>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">Bank:</span> <%= emp.getBank_name() %></div>
        <div class="col-md-6"><span class="profile-label">Account No:</span> <%= emp.getAccount_number() %></div>
      </div>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">IFSC:</span> <%= emp.getIfsc_code() %></div>
        <div class="col-md-6"><span class="profile-label">UAN:</span> <%= emp.getUan_number() %></div>
      </div>
      <div class="row">
        <div class="col-md-6"><span class="profile-label">PAN:</span> <%= emp.getPan_number() %></div>
        <div class="col-md-6"><span class="profile-label">Aadhaar:</span> <%= emp.getAadhar_number() %></div>
      </div>

      <% } %>
    </div>
  </div>
</main>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
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
</script>
</body>
</html>
