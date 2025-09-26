<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="payrollmanagement.EmployeeBean, payrollmanagement.EmployeeDAOImpl" %>
<%@ page import="java.sql.Date" %>
<%
    String message = "";
    String status = "danger";  // bootstrap alert style
    int empId = -1;
    boolean success = false;

    try {
        request.setCharacterEncoding("UTF-8");

        EmployeeBean emp = new EmployeeBean();
        String teamIdStr = request.getParameter("team_id");
        if (teamIdStr != null && !teamIdStr.isEmpty()) {
            emp.setTeam_id(Integer.parseInt(teamIdStr));
        }

        // Login
        emp.setUsername(request.getParameter("username"));
        emp.setPassword_hash(request.getParameter("password_hash"));
        emp.setRole(request.getParameter("role"));

        // Personal
        emp.setFirst_name(request.getParameter("first_name"));
        emp.setLast_name(request.getParameter("last_name"));
        String dobStr = request.getParameter("dob");
        if (dobStr != null && !dobStr.isEmpty()) {
            emp.setDob(Date.valueOf(dobStr));
        }
        emp.setGender(request.getParameter("gender"));
        emp.setMarital_status(request.getParameter("marital_status"));

        // Contact
        emp.setEmail(request.getParameter("email"));
        emp.setPhone(request.getParameter("phone"));
        emp.setAddress_line1(request.getParameter("address_line1"));
        emp.setAddress_line2(request.getParameter("address_line2"));
        emp.setCity(request.getParameter("city"));
        emp.setState(request.getParameter("state"));
        emp.setPostal_code(request.getParameter("postal_code"));
        emp.setCountry(request.getParameter("country"));

        // Emergency
        emp.setEmergency_name(request.getParameter("emergency_name"));
        emp.setEmergency_relation(request.getParameter("emergency_relation"));
        emp.setEmergency_phone(request.getParameter("emergency_phone"));

        // Employment
        String dojStr = request.getParameter("date_of_joining");
        if (dojStr != null && !dojStr.isEmpty()) {
            emp.setDate_of_joining(Date.valueOf(dojStr));
        }
        emp.setEmployment_type(request.getParameter("employment_type"));
        emp.setDesignation(request.getParameter("designation"));

        // Bank / IDs
        emp.setBank_name(request.getParameter("bank_name"));
        emp.setAccount_number(request.getParameter("account_number"));
        emp.setIfsc_code(request.getParameter("ifsc_code"));
        emp.setUan_number(request.getParameter("uan_number"));
        emp.setPan_number(request.getParameter("pan_number"));
        emp.setAadhar_number(request.getParameter("aadhar_number"));

        // Shift / Structure
        String shiftIdStr = request.getParameter("shift_id");
        if (shiftIdStr != null && !shiftIdStr.isEmpty()) {
            emp.setShift_id(Integer.parseInt(shiftIdStr));
        }
        String structIdStr = request.getParameter("structure_id");
        if (structIdStr != null && !structIdStr.isEmpty()) {
            emp.setStructure_id(Integer.parseInt(structIdStr));
        }

        // ✅ DAO call
        EmployeeDAOImpl dao = new EmployeeDAOImpl();
        empId = dao.onboardEmployee(emp);

        if (empId > 0) {
            message = "Employee Onboarded Successfully! New Employee ID: " + empId;
            status = "success";
            success = true;
        } else {
            message = "Failed to save employee!";
        }

    } catch (Exception e) {
        e.printStackTrace();
        message = "Error while processing request: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Employee Onboarding - Result</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
body { background: url("images/bg.jpg") no-repeat center center fixed; background-size: cover; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; position: relative; }
body::before { content: ""; position: absolute; inset: 0; background: rgba(230, 247, 247, 0.4); z-index: 0; }
.result-card { max-width: 700px; border-radius: 20px; overflow: hidden; box-shadow: 0 8px 25px rgba(0,0,0,0.15); z-index: 1; position: relative; background: #fff; padding: 40px; }
</style>
</head>
<body>

<div class="container d-flex align-items-center justify-content-center min-vh-100">
  <div class="result-card text-center">
    <h2 class="mb-4">Onboarding Result</h2>

    <% if (!message.isEmpty()) { %>
      <div class="alert alert-<%= status %>"><%= message %></div>
    <% } %>

    <!-- Back button always -->
    <a href="Onboarding.jsp" class="btn btn-primary mt-3">⬅ Back to Onboarding Form</a>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<% if (success) { %>
<!-- Auto redirect only if success -->
<script>
  setTimeout(() => {
    window.location.href = "Onboarding.jsp";
  }, 6000); // 3 seconds
</script>
<% } %>

</body>
</html>