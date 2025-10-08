<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="payrollmanagement.*" %>
<%@ page import="java.util.List" %>
<%
    UserBean user = (UserBean) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = user.getUserId();
    LeaveRequestDAO leaveRequestDAO = new LeaveRequestDAOImpl();
    int empId = leaveRequestDAO.getEmpIdByUserId(userId);
    String empName = user.getUsername();
    String message = null;

    if("POST".equalsIgnoreCase(request.getMethod())){
        String leaveType = request.getParameter("leaveType");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String fromHalf = request.getParameter("fromHalf");
        String toHalf = request.getParameter("toHalf");
        double totalDays = Double.parseDouble(request.getParameter("totalDays"));
        String reason = request.getParameter("reason");

        LeaveRequestBean leave = new LeaveRequestBean();
        leave.setEmpId(empId);
        leave.setName(empName);
        leave.setLeaveType(leaveType);
        leave.setFromDate(fromDate);
        leave.setToDate(toDate);
        leave.setFromHalf(fromHalf);
        leave.setToHalf(toHalf);
        leave.setNoOfDays(totalDays);
        leave.setCreditDays((int) totalDays);
        leave.setReason(reason);
        leave.setStatus("Pending");

        boolean success = leaveRequestDAO.applyLeave(leave);
        message = success ? "Leave Applied Successfully!" : "Failed to apply leave.";
    }

    List<LeaveRequestBean> appliedLeaves = leaveRequestDAO.getLeavesByEmpId(userId);
    int EL=10, CL=8, SL=7, OD=5, ML=12, PL=15;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>Employee Leave Request</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<style>
body {
  margin:0;
  font-family:Arial,sans-serif;
  background:#f9f9f9;
}

/* Sidebar */
.sidebar{
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
.sidebar.collapsed{width:70px;}
.logo-container{margin-bottom:20px;}
.logo-text img{width:120px;height:auto;}
.logo-tagline{font-size:12px;color:#fff;margin-top:6px;font-weight:400;line-height:1.3;}
.sidebar.collapsed .logo-text,.sidebar.collapsed .logo-tagline{display:none;}
.menu{flex-grow:1;text-align:left;}
.sidebar a{display:flex;align-items:center;gap:12px;color:#fff;padding:14px 20px;text-decoration:none;font-size:16px;margin:8px 0;border-radius:6px;transition:background 0.3s,padding 0.3s;}
.sidebar a i{font-size:18px;width:20px;text-align:center;}
.sidebar.collapsed a{justify-content:center;gap:0;padding:14px;}
.sidebar.collapsed a span{display:none;}
.sidebar a:hover{background:#12b5b5;color:#fff;}
.logout{background:#39bfbf;color:#fff !important;font-size:14px;padding:10px 16px;margin:15px;border-radius:6px;text-align:center;}
.logout:hover{background:#1a252f;}
.toggle-btn{position:absolute;top:15px;left:15px;background:#39bfbf;border-radius:50%;width:40px;height:40px;border:none;color:#fff;font-size:18px;cursor:pointer;display:flex;align-items:center;justify-content:center;box-shadow:0 2px 6px rgba(0,0,0,0.2);transition:background 0.3s;z-index:10;}
.toggle-btn:hover{background:#39bfbf;}
.main-content{margin-left:300px;padding:20px;transition:margin-left 0.3s ease;}
.main-content.collapsed{margin-left:70px;}

/* Leave Container */
.leave-container{
  max-width:850px;
  margin:40px auto;
  background:#fff;
  padding:25px;
  border-radius:10px;
  box-shadow:0 0 10px rgba(0,0,0,0.1);
}
.leave-header{
  display:flex;
  justify-content:center;
  margin-bottom:20px;
}
.leave-header button{
  width:50%;
  font-weight:bold;
  border-radius:0;
}
.leave-header .active{
  background-color:#39bfbf;
  color:white;
}
.apply-btn{
  background-color:#39bfbf;
  color:white;
  font-weight:bold;
  border-radius:50px;
  padding:10px 25px;
  border:none;
}
.head{
  background-color:#39bfbf!important;
  color:white !important;
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
<div class="main-content" id="main">
<div class="leave-container">

<% if(message != null){ %>
    <div class="alert alert-info text-center"><%= message %></div>
<% } %>

<div class="leave-header">
    <button id="btnNewLeave" class="btn btn-light active">New Leave</button>
    <button id="btnAppliedLeaves" class="btn btn-light">Applied Leaves</button>
</div>

<!-- New Leave Form -->
<div id="newLeaveSection">
<form method="post">

    <!-- Leave Type -->
    <div class="mb-3">
        <label class="form-label fw-bold">Leave Type:</label><br>
        <% String[][] leaveTypes = {{"EL",""+EL},{"CL",""+CL},{"SL",""+SL},{"OD",""+OD},{"ML",""+ML},{"PL",""+PL}}; %>
        <% for(String[] lt : leaveTypes){ %>
            <div class="form-check form-check-inline">
                <input class="form-check-input leave-radio" type="radio" name="leaveType" value="<%=lt[0]%>" required data-credit="<%=lt[1]%>">
                <label class="form-check-label"><%= lt[0] %></label>
            </div>
        <% } %>
        <div class="mt-2">
           
            <small>Available Credit: <span id="leaveCredit">NA</span></small>
        </div>
    </div>

    <!-- Dates -->
    <div class="row mb-3">
        <div class="col-md-6">
            <label class="form-label fw-bold">From:</label>
            <div class="d-flex">
                <input type="date" class="form-control me-2" name="fromDate" id="fromDate" required />
                <select class="form-select" id="fromHalf" name="fromHalf">
                    <option>First Half</option>
                    <option>Second Half</option>
                </select>
            </div>
        </div>
        <div class="col-md-6">
            <label class="form-label fw-bold">To:</label>
            <div class="d-flex">
                <input type="date" class="form-control me-2" name="toDate" id="toDate" required />
                <select class="form-select" id="toHalf" name="toHalf">
                    <option>First Half</option>
                    <option selected>Second Half</option>
                </select>
            </div>
        </div>
    </div>

    <!-- Total Days -->
    <div class="mb-3">
        <label class="fw-bold">Total Days:</label>
        <span id="totalDays" class="ms-2">0</span>
        <input type="hidden" name="totalDays" id="hiddenTotalDays" />
    </div>

    <!-- Reason -->
    <div class="mb-3">
        <label class="form-label fw-bold">Reason:</label>
        <textarea class="form-control" name="reason" placeholder="Enter reason" required></textarea>
    </div>

    <div class="text-center">
        <button type="submit" class="apply-btn">Apply</button>
    </div>

</form>
</div>

<!-- Applied Leaves -->
<div id="appliedLeavesSection" class="d-none">
<h5 class="fw-bold mb-3">Previously Applied Leaves</h5>
<table class="table table-bordered table-striped">
<thead class="head">
<tr>
<th>Emp ID</th><th>Name</th><th>Leave Type</th><th>From</th><th>F/S half</th>
<th>To</th><th>F/S half</th><th>No of days</th><th>Credit days</th>
<th>Reason</th><th>Status</th>
</tr>
</thead>
<tbody>
<% if(appliedLeaves != null && !appliedLeaves.isEmpty()){
    for(LeaveRequestBean l : appliedLeaves){ %>
<tr>
<td><%= l.getEmpId() %></td>
<td><%= l.getName() %></td>
<td><%= l.getLeaveType() %></td>
<td><%= l.getFromDate() %></td>
<td><%= l.getFromHalf() %></td>
<td><%= l.getToDate() %></td>
<td><%= l.getToHalf() %></td>
<td><%= l.getNoOfDays() %></td>
<td><%= l.getCreditDays() %></td>
<td><%= l.getReason() %></td>
<td><%= l.getStatus() %></td>
</tr>
<% }} else { %>
<tr><td colspan="11" class="text-center">No applied leaves found.</td></tr>
<% } %>
</tbody>
</table>
</div>

</div>

<script>
// Sidebar toggle
const sidebar = document.getElementById('sidebar');
const main = document.getElementById('main');
const toggleBtn = document.getElementById('toggle-btn');
const toggleIcon = toggleBtn.querySelector('i');

toggleBtn.addEventListener('click', () => {
  sidebar.classList.toggle('collapsed');
  main.classList.toggle('collapsed');

  if(sidebar.classList.contains('collapsed')){
    toggleIcon.classList.remove('fa-arrow-left');
    toggleIcon.classList.add('fa-bars');
  } else {
    toggleIcon.classList.remove('fa-bars');
    toggleIcon.classList.add('fa-arrow-left');
  }
});

// Toggle New Leave / Applied Leaves
const btnNew = document.getElementById("btnNewLeave");
const btnApplied = document.getElementById("btnAppliedLeaves");
const newSection = document.getElementById("newLeaveSection");
const appliedSection = document.getElementById("appliedLeavesSection");

btnNew.addEventListener("click", () => {
    btnNew.classList.add("active");
    btnApplied.classList.remove("active");
    newSection.classList.remove("d-none");
    appliedSection.classList.add("d-none");
});

btnApplied.addEventListener("click", () => {
    btnApplied.classList.add("active");
    btnNew.classList.remove("active");
    appliedSection.classList.remove("d-none");
    newSection.classList.add("d-none");
});

// Total days calculation
function calculateDays(){
    let from = document.getElementById("fromDate").value;
    let to = document.getElementById("toDate").value;
    let fromHalf = document.getElementById("fromHalf").value;
    let toHalf = document.getElementById("toHalf").value;

    if(!from || !to) {
        document.getElementById("totalDays").textContent = 0;
        document.getElementById("hiddenTotalDays").value = 0;
        return;
    }

    let start = new Date(from);
    let end = new Date(to);
    if(end < start){
        alert("To Date cannot be before From Date");
        document.getElementById("toDate").value = "";
        document.getElementById("totalDays").textContent = 0;
        document.getElementById("hiddenTotalDays").value = 0;
        return;
    }

    let diff = (end - start) / (1000*60*60*24) + 1;

    if(diff === 1){
        if(fromHalf === "Second Half" && toHalf === "First Half") diff = 0;
        else if(fromHalf === "Second Half" && toHalf === "Second Half") diff = 0.5;
        else if(fromHalf === "First Half" && toHalf === "First Half") diff = 0.5;
    } else {
        if(fromHalf === "Second Half") diff -= 0.5;
        if(toHalf === "First Half") diff -= 0.5;
    }

    document.getElementById("totalDays").textContent = diff;
    document.getElementById("hiddenTotalDays").value = diff;
}

["fromDate", "toDate", "fromHalf", "toHalf"].forEach(id => {
    document.getElementById(id).addEventListener("change", calculateDays);
});

// Show Available Credit dynamically
const leaveRadios = document.querySelectorAll('.leave-radio');
const creditSpan = document.getElementById('leaveCredit');

leaveRadios.forEach(radio => {
    radio.addEventListener('change', () => {
        creditSpan.textContent = radio.getAttribute('data-credit');
    });
});
</script>
</body>
</html>
