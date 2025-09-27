<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>OT Request - Payroll Management</title>
  <!-- Bootstrap CSS -->
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
      padding-top:30px; box-sizing:border-box; display:flex; flex-direction:column; justify-content:space-between;
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
    .btn-custom {
    background-color: #39bfbf; /* teal */
    border: none;
  }
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
        <a href="EmployeeDashboard.html"><i class="fa-solid fa-house"></i> <span>Dashboard</span></a>
        <a href="EmpProfile.html"><i class="fa-solid fa-user"></i> <span>Profile</span></a>
        <a href="Attendance.html"><i class="fa-solid fa-calendar-check"></i> <span>Attendance</span></a>
        <a href="LeaveRequest.html"><i class="fa-solid fa-leaf"></i> <span>Leave Request</span></a>
        <a href="EmpPaySlip.html"><i class="fa-solid fa-file-invoice"></i> <span>My Payslips</span></a>
        <a href="OTRequest.html" class="active"><i class="fa-solid fa-stopwatch me-2"></i> <span>OT Request</span></a>
    </div>
    <a href="#" class="logout"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
  </div>

  <!-- Main -->
  <div class="main" id="main">
    <!-- Top Navbar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Overtime Request</h2>
    </div>

    <!-- OT Request Form -->
    <div class="card p-4 shadow mb-5">
      <form action="overtime_request_process.php" method="POST">
        <div class="mb-3">
          <label for="emp_id" class="form-label">Employee ID</label>
          <input type="number" class="form-control" id="emp_id" name="emp_id" required>
        </div>

        <div class="mb-3">
          <label for="ot_date" class="form-label">Overtime Date</label>
          <input type="date" class="form-control" id="ot_date" name="ot_date" required>
        </div>

        <div class="mb-3">
          <label for="reason" class="form-label">Reason for Overtime</label>
          <textarea class="form-control" id="reason" name="reason" rows="3"></textarea>
        </div>

        <div class="mb-3">
          <label for="hours_worked" class="form-label">Hours Worked</label>
          <input type="number" step="0.25" class="form-control" id="hours_worked" name="hours_worked" required>
        </div>


        <button type="submit" class="btn btn-custom w-100">Submit Request</button>
      </form>
    </div>

    <!-- OT Requests Table -->
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
          <!-- Sample data (replace with backend data) -->
          <tr>
            <td>2025-09-01</td>
            <td>Urgent deployment</td>
            <td>5.00</td>
            <td><span class="badge bg-warning">Pending</span></td>
          </tr>
          <tr>
            <td>2025-08-28</td>
            <td>Client call</td>
            <td>2.50</td>
            <td><span class="badge bg-success">Approved</span></td>
          </tr>
          <tr>
            <td>2025-08-15</td>
            <td>Server maintenance</td>
            <td>6.00</td>
            <td><span class="badge bg-danger">Rejected</span></td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Script -->
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
    // Theme Toggle
    const themeToggle=document.getElementById("theme-toggle");
    themeToggle.addEventListener("click",()=>{
      document.body.classList.toggle("dark-mode");
      const icon=themeToggle.querySelector("i");
      icon.classList.toggle("fa-moon");
      icon.classList.toggle("fa-sun");
    });
  </script>
</body>
</html>