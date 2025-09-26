<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Employee List</title>
  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

  <style>
    body { background:#f8f9fa; font-family: "Segoe UI", Arial, sans-serif; }
    .card { border-radius:12px; box-shadow:0 6px 18px rgba(0,0,0,0.08); border:0; }
    .card-header { background:#39bfbf; color:#fff; font-weight:600; }
    table th { background:#e9f7f7; }
    .action-icons i { cursor:pointer; margin:0 5px; }
    .action-icons i:hover { transform:scale(1.2); }
    .bg-custom{ background-color:#39bfbf; }

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
      z-index: 1000;
    }

    .sidebar.collapsed {
      width: 70px;
    }

    /* Logo */
    .logo-container { margin-bottom: 20px; }
    .logo-text img { width: 120px; height: auto; }
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

    .menu { flex-grow: 1; text-align: left; }

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

    .sidebar.collapsed a span { display: none; }

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

    .submenu a:hover { background: #12b5b5; }

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
    .logout i { font-size: 14px; }
    .logout:hover { background: #1a252f; }

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
      z-index: 1100;
    }
    .toggle-btn:hover { background: #12b5b5; }

    /* Main content */
    .main-content {
      margin-left: 300px;
      padding: 20px;
      transition: margin-left 0.3s ease, width 0.3s ease;
      width: calc(100% - 300px);
    }
    .sidebar.collapsed ~ .main-content {
      margin-left: 70px;
      width: calc(100% - 70px);
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
      <a href="HrDashBoard.jsp"><i class="fa-solid fa-house"></i> <span>Dashboard</span></a>
      <a href="LoginReport.jsp"><i class="fa-solid fa-clipboard-check"></i> <span>Login Report</span></a>
      <a data-bs-toggle="collapse" href="#empSubmenu" role="button" aria-expanded="false" aria-controls="empSubmenu">
        <i class="fa-solid fa-users-gear me-2"></i> <span>Employee Management</span>
      </a>
      <div class="collapse submenu" id="empSubmenu">
        <a href="Onboarding.jsp"><i class="fa-solid fa-user-plus me-2"></i> Onboarding Employee</a>
        <a href="EmployeeList.jsp"><i class="fa-solid fa-id-card me-2"></i> List Employee</a>
      </div>
      <a href="LeaveApproval.jsp"><i class="fa-solid fa-user-check"></i> <span>Leave Approval</span></a>
      <a href="PayRoll.jsp"><i class="fa-solid fa-money-check-dollar"></i> <span>Payroll</span></a>
      <a href="OtApproval.jsp"><i class="fa-solid fa-stopwatch me-2"></i> <span>Overtime Approval</span></a>
      <a href="Holiday.jsp"><i class="fa-solid fa-calendar-days"></i> <span>Holidays</span></a>
    </div>
    <a href="#" class="logout"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
  </div>

  <!-- Main Content -->
  <div class="main-content">
    <main class="container-fluid my-5">
      <div class="card">
        <div class="card-header">
          <i class="fa-solid fa-users me-2"></i> Employee List
        </div>
        <div class="card-body table-responsive">
          <table class="table table-bordered table-striped align-middle">
            <thead>
              <tr>
                <th>#</th>
                <th>Employee ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody id="employeeTable">
              <!-- Rows will be populated via JS -->
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </div>

  <!-- Modal for View Details -->
  <div class="modal fade" id="viewModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-scrollable modal-lg">
      <div class="modal-content">
        <div class="modal-header bg-custom text-white">
          <h5 class="modal-title">Employee Details</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body" id="viewBody"></div>
      </div>
    </div>
  </div>

  <!-- Scripts -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    const sidebar = document.getElementById('sidebar');
    const toggleBtn = document.getElementById('toggle-btn');
    const toggleIcon = toggleBtn.querySelector('i');

    toggleBtn.addEventListener('click', () => {
      sidebar.classList.toggle('collapsed');
      if (sidebar.classList.contains('collapsed')) {
        toggleIcon.classList.remove('fa-arrow-left');
        toggleIcon.classList.add('fa-bars');
      } else {
        toggleIcon.classList.remove('fa-bars');
        toggleIcon.classList.add('fa-arrow-left');
      }
    });

    // Retrieve employees from localStorage
    let employees = JSON.parse(localStorage.getItem("employeeList")) || [];

    // If the last saved employee exists, push it to list
    const latest = JSON.parse(localStorage.getItem("employeeData"));
    if (latest) {
      if (!employees.find(e => e.emp_id === latest.emp_id)) {
        employees.push(latest);
        localStorage.setItem("employeeList", JSON.stringify(employees));
        localStorage.removeItem("employeeData");
      }
    }

    const tableBody = document.getElementById("employeeTable");

    function renderTable() {
      tableBody.innerHTML = "";
      employees.forEach((emp, index) => {
        let row = `
          <tr>
            <td>${index+1}</td>
            <td>${emp.emp_id || "Auto"}</td>
            <td>${emp.first_name || ""} ${emp.last_name || ""}</td>
            <td>${emp.email || ""}</td>
            <td>${emp.phone || ""}</td>
            <td class="action-icons">
              <i class="fa-solid fa-eye text-primary" onclick="viewEmployee(${index})"></i>
              <i class="fa-solid fa-pen-to-square text-success" onclick="editEmployee(${index})"></i>
              <i class="fa-solid fa-trash text-danger" onclick="deleteEmployee(${index})"></i>
            </td>
          </tr>
        `;
        tableBody.innerHTML += row;
      });
    }

    // View
    function viewEmployee(index) {
      const emp = employees[index];
      let details = "<ul class='list-group'>";
      for (let key in emp) {
        details += `<li class="list-group-item"><b>${key.replace("_"," ").toUpperCase()}:</b> ${emp[key]}</li>`;
      }
      details += "</ul>";
      document.getElementById("viewBody").innerHTML = details;
      new bootstrap.Modal(document.getElementById("viewModal")).show();
    }

    // Edit
    function editEmployee(index) {
      localStorage.setItem("editEmployee", JSON.stringify({index, data: employees[index]}));
      alert("Redirecting to Onboarding form for editing...");
      window.location.href = "Onboarding.html";
    }

    // Delete
    function deleteEmployee(index) {
      if (confirm("Are you sure you want to delete this employee?")) {
        employees.splice(index, 1);
        localStorage.setItem("employeeList", JSON.stringify(employees));
        renderTable();
      }
    }

    renderTable();
  </script>
</body>
</html>
    