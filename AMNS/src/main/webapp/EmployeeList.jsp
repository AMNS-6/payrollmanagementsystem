<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, payrollmanagement.EmployeeBean, payrollmanagement.EmployeeDAO, payrollmanagement.EmployeeDAOImpl" %>
<%
    EmployeeDAO dao = new EmployeeDAOImpl();

    // Handle delete if requested
    String deleteId = request.getParameter("deleteEmpId");
    if (deleteId != null) {
        try {
            int empId = Integer.parseInt(deleteId);
            dao.deleteEmployee(empId); // remove from DB
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Load fresh employee list
    List<EmployeeBean> employees = dao.getAllEmployees();
%>
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
    .action-icons i, .action-icons a i { cursor:pointer; margin:0 5px; }
    .action-icons i:hover, .action-icons a i:hover { transform:scale(1.2); }
    .bg-custom{ background-color:#39bfbf; }
    .sidebar { height: 100vh; background: #39bfbf; color: white; position: fixed; top: 0; left: 0; width: 300px; padding-top: 30px; box-sizing: border-box; display: flex; flex-direction: column; justify-content: space-between; transition: width 0.3s ease; overflow: hidden; text-align: center; z-index: 1000; }
    .sidebar.collapsed { width: 70px; }
    .logo-container { margin-bottom: 20px; }
    .logo-text img { width: 120px; height: auto; }
    .logo-tagline { font-size: 12px; color: #fff; margin-top: 6px; font-weight: 400; line-height: 1.3; }
    .sidebar.collapsed .logo-text, .sidebar.collapsed .logo-tagline { display: none; }
    .menu { flex-grow: 1; text-align: left; }
    .sidebar a { display: flex; align-items: center; gap: 12px; color: #ffffff; padding: 14px 20px; text-decoration: none; font-size: 16px; margin: 8px 0; border-radius: 6px; transition: background 0.3s, padding 0.3s; }
    .sidebar a i { font-size: 18px; width: 20px; text-align: center; }
    .sidebar.collapsed a { justify-content: center; gap: 0; padding: 14px; }
    .sidebar.collapsed a span { display: none; }
    .sidebar a:hover { background: #12b5b5; color: #fff; }
    .submenu a { font-size: 15px; padding: 10px 40px; display: block; color: #fff; }
    .submenu a:hover { background: #12b5b5; }
    .logout { background: #39bfbf; color: #fff !important; font-size: 14px; padding: 10px 16px; margin: 15px; border-radius: 6px; text-align: center; }
    .logout:hover { background: #1a252f; }
    .toggle-btn { position: absolute; top: 15px; left: 15px; background: #39bfbf; border-radius: 50%; width: 40px; height: 40px; border: none; color: #fff; font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(0,0,0,0.2); transition: background 0.3s; z-index: 1100; }
    .toggle-btn:hover { background: #12b5b5; }
    .main-content { margin-left: 300px; padding: 20px; transition: margin-left 0.3s ease, width 0.3s ease; width: calc(100% - 300px); }
    .sidebar.collapsed ~ .main-content { margin-left: 70px; width: calc(100% - 70px); }
    .delete-modal { max-width: 600px; }
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
      <a href="hr_dashboard.jsp"><i class="fa-solid fa-house"></i> <span>Dashboard</span></a>
      <a href="loginReport.jsp"><i class="fa-solid fa-clipboard-check"></i> <span>Login Report</span></a>
      <a data-bs-toggle="collapse" href="#empSubmenu"><i class="fa-solid fa-users-gear me-2"></i> <span>Employee Management</span></a>
      <div class="collapse submenu" id="empSubmenu">
        <a href="Onboarding.jsp"><i class="fa-solid fa-user-plus me-2"></i> Onboarding Employee</a>
        <a href="EmployeeList.jsp"><i class="fa-solid fa-id-card me-2"></i> List Employee</a>
      </div>
      <a href="LeaveApproval.jsp"><i class="fa-solid fa-user-check"></i> <span>Leave Approval</span></a>
      <a href="PayRoll.jsp"><i class="fa-solid fa-money-check-dollar"></i> <span>Payroll</span></a>
      <a href="OtApproval.jsp"><i class="fa-solid fa-stopwatch me-2"></i> <span>Overtime Approval</span></a>
      <a href="Holiday.jsp"><i class="fa-solid fa-calendar-days"></i> <span>Holidays</span></a>
    </div>
    <a href="logout.jsp" class="logout"><i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span></a>
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
            <tbody>
              <%
                int i = 1;
                for (EmployeeBean emp : employees) {
              %>
              <tr>
                <td><%= i++ %></td>
                <td><%= emp.getEmpId() %></td>
                <td><%= emp.getFirst_name() %> <%= emp.getLast_name() %></td>
                <td><%= emp.getEmail() %></td>
                <td><%= emp.getPhone() %></td>
                <td class="action-icons">
                 <!-- View Employee Profile -->
				<!-- View Employee Profile -->
			    <a href="EmpProfileHR.jsp?empId=<%= emp.getEmpId() %>">
			        <i class="fa-solid fa-eye text-primary"></i>
			    </a>

                  <!-- Modify/Edit Employee -->
                  <a href="ModifyEmp.jsp?empId=<%= emp.getEmpId() %>">
                    <i class="fa-solid fa-pen-to-square text-success"></i>
                  </a>

                  <!-- Delete Employee -->
                  <i class="fa-solid fa-trash text-danger"
                     onclick="openDeleteModal('<%= emp.getEmpId() %>')"></i>
                </td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
    </main>
  </div>

  <!-- Delete Modal -->
  <div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered delete-modal">
      <div class="modal-content">
        <div class="modal-header bg-danger text-white">
          <h5 class="modal-title">Confirm Delete</h5>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          Are you sure you want to delete this employee?
        </div>
        <div class="modal-footer">
          <form method="post" id="deleteForm">
            <input type="hidden" name="deleteEmpId" id="deleteEmpId">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
            <button type="submit" class="btn btn-danger">Yes</button>
          </form>
        </div>
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
      toggleIcon.classList.toggle('fa-arrow-left');
      toggleIcon.classList.toggle('fa-bars');
    });

    function openDeleteModal(empId) {
      document.getElementById("deleteEmpId").value = empId;
      new bootstrap.Modal(document.getElementById("deleteModal")).show();
    }
  </script>
</body>
</html>
