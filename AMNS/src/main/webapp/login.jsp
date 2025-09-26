<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="payrollmanagement.UserDAO, payrollmanagement.UserDAOImpl, payrollmanagement.UserBean" %>

<%
    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String role = request.getParameter("role");  
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAOImpl();
        UserBean user = dao.login(username, password, role);

        if (user != null) {
            // ✅ Update last login
            dao.updateLastLogin(user.getUserId());

            // ✅ Save user bean in session
            session.setAttribute("user", user);

            // ✅ Redirect based on role
            if ("HR".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("hr_dashboard.jsp");
            } else if ("EMPLOYEE".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect("emp_dashboard.jsp");
            } else {
                message = "❌ Unknown role. Please contact admin.";
            }
        } else {
            message = "❌ Invalid credentials for " + role + "!";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee Attendance Management - Login</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background: url("images/bg.jpg") no-repeat center center fixed; background-size: cover; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; position: relative; }
body::before { content: ""; position: absolute; inset: 0; background: rgba(230, 247, 247, 0.4); z-index: 0; }
.login-card { max-width: 900px; border-radius: 20px; overflow: hidden; box-shadow: 0 8px 25px rgba(0,0,0,0.15); z-index: 1; position: relative; }
.left-panel { background: #39bfbf; color: #fff; display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 40px; }
.left-panel h2 { margin-top: 20px; font-weight: bold; }
.right-panel { padding: 40px; background: #fff; }
.nav-tabs .nav-link.active { border-bottom: 3px solid #39bfbf; font-weight: bold; color: #39bfbf; }
.btn-login { background: #39bfbf; color: white; border-radius: 25px; padding: 10px 30px; transition: all 0.3s ease; }
.btn-login:hover { background: #2f9f9f; }
.extra-links { margin-top: 15px; }
.extra-links a { font-size: 0.9rem; color: #39bfbf; text-decoration: none; margin: 0 8px; }
.extra-links a:hover { text-decoration: underline; }

</style>
</head>
<body>

<div class="container d-flex align-items-center justify-content-center min-vh-100">
  <div class="row login-card w-100">
    
    <!-- Left Panel -->
    <div class="col-md-6 left-panel text-center">
      <img src="images/logo.png" alt="Company Logo" class="img-fluid" style="max-width: 260px;">
      <h2>Welcome</h2>
      <p>Employee Attendance Management System</p>
    </div>
    <!-- Right Panel -->
    <div class="col-md-6 right-panel">
      <!-- Tabs -->
      <ul class="nav nav-tabs justify-content-center mb-4" id="loginTabs" role="tablist">
        <li class="nav-item">
          <a class="nav-link text-dark active" id="employee-tab" data-bs-toggle="tab" href="#employee" role="tab">Employee Login</a>
        </li>
        <li class="nav-item">
          <a class="nav-link text-dark" id="hr-tab" data-bs-toggle="tab" href="#hr" role="tab">HR Login</a>
        </li>
      </ul>

      <!-- Tab Contents -->
      <div class="tab-content" id="loginTabsContent">
        
        <!-- Employee Login -->
        <div class="tab-pane fade show active" id="employee" role="tabpanel">
          <form method="post">
            <input type="hidden" name="role" value="EMPLOYEE">
            <div class="mb-3">
              <label class="form-label">Username</label>
              <input type="text" class="form-control" name="username" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Password</label>
              <input type="password" class="form-control" name="password" required>
            </div>
            <div class="d-grid">
              <button type="submit" class="btn btn-login">Login</button>
            </div>
          </form>
        </div>

        <!-- HR Login -->
        <div class="tab-pane fade" id="hr" role="tabpanel">
          <form method="post">
            <input type="hidden" name="role" value="HR">
            <div class="mb-3">
              <label class="form-label">HR Username</label>
              <input type="text" class="form-control" name="username" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Password</label>
              <input type="password" class="form-control" name="password" required>
            </div>
            <div class="d-grid">
              <button type="submit" class="btn btn-login">Login</button>
            </div>
          </form>
        </div>
      </div>

      <% if (!message.isEmpty()) { %>
        <div class="alert alert-danger mt-3"><%= message %></div>
      <% } %>

    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>