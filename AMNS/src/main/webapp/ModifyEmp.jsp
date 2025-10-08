<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="payrollmanagement.EmployeeBean, payrollmanagement.EmployeeDAOImpl" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<%@ page import="java.sql.Date" %>
<%
    request.setCharacterEncoding("UTF-8");
    String message = "";
    String status = "danger"; 

    int empId = Integer.parseInt(request.getParameter("empId"));
    EmployeeDAOImpl empDao = new EmployeeDAOImpl();
    EmployeeBean emp = empDao.getEmployeeById(empId);
    Map<Integer, String> teamList = empDao.getAllTeams();
    Map<Integer, String> shiftList = empDao.getAllShifts();
    Map<Integer, String> structureList = empDao.getAllStructures();
    List<String> designationList = empDao.getAllDesignations();
    List<String> empTypeList = empDao.getAllEmploymentTypes();

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            EmployeeBean updatedEmp = new EmployeeBean();
            updatedEmp.setEmpId(empId);

            // Identity & contact info
            updatedEmp.setFirst_name(request.getParameter("first_name"));
            updatedEmp.setLast_name(request.getParameter("last_name"));
            updatedEmp.setDob(Date.valueOf(request.getParameter("dob")));
            updatedEmp.setGender(request.getParameter("gender"));
            updatedEmp.setMarital_status(request.getParameter("marital_status"));

            updatedEmp.setEmail(request.getParameter("email"));
            updatedEmp.setPhone(request.getParameter("phone"));
            updatedEmp.setAddress_line1(request.getParameter("address_line1"));
            updatedEmp.setAddress_line2(request.getParameter("address_line2"));
            updatedEmp.setCity(request.getParameter("city"));
            updatedEmp.setState(request.getParameter("state"));
            updatedEmp.setPostal_code(request.getParameter("postal_code"));
            updatedEmp.setCountry(request.getParameter("country"));

            updatedEmp.setEmergency_name(request.getParameter("emergency_name"));
            updatedEmp.setEmergency_relation(request.getParameter("emergency_relation"));
            updatedEmp.setEmergency_phone(request.getParameter("emergency_phone"));

            updatedEmp.setDate_of_joining(Date.valueOf(request.getParameter("date_of_joining")));
            updatedEmp.setEmployment_type(request.getParameter("employment_type"));
            updatedEmp.setDesignation(request.getParameter("designation"));
            updatedEmp.setTeam_id(Integer.parseInt(request.getParameter("team_id")));

            updatedEmp.setBank_name(request.getParameter("bank_name"));
            updatedEmp.setAccount_number(request.getParameter("account_number"));
            updatedEmp.setIfsc_code(request.getParameter("ifsc_code"));
            updatedEmp.setPan_number(request.getParameter("pan_number"));
            updatedEmp.setAadhar_number(request.getParameter("aadhar_number"));
            updatedEmp.setUan_number(request.getParameter("uan_number"));

            updatedEmp.setShift_id(Integer.parseInt(request.getParameter("shift_id")));
            updatedEmp.setStructure_id(Integer.parseInt(request.getParameter("structure_id")));

            int rows = empDao.updateEmployee(updatedEmp);
            if (rows > 0) {
                message = "Employee updated successfully!";
                status = "success";
            } else {
                message = "Failed to update employee.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Modify Employee</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    
  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    
    <style>
         /* Sidebar */
    .sidebar {
      height:100vh; background:#39bfbf; color:white;
      position:fixed; top:0; left:0; width:300px;
      padding-top:30px; box-sizing:border-box;
      display:flex; flex-direction:column; justify-content:space-between;
      transition:width 0.3s ease; overflow:hidden; text-align:center;
    }
    .sidebar.collapsed { width:70px; }
    .logo-text img { width:120px; height:auto; }
    .logo-tagline { font-size:12px; color:#fff; margin-top:6px; font-weight:400; }
    .sidebar.collapsed .logo-text, .sidebar.collapsed .logo-tagline { display:none; }
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
        .logout { background: #39bfbf; margin: 15px; border-radius: 6px; text-align: center; padding: 10px 16px; }
    .logout:hover { background: #1a252f; }
    .toggle-btn { position: absolute; top: 15px; left: 15px; background: #39bfbf; border-radius: 50%; width: 40px; 
      height: 40px; border: none; color: #fff; font-size: 18px; cursor: pointer; display: flex; align-items: center; 
      justify-content: center; }
    .content { margin-left: 300px; padding: 20px; transition: margin-left 0.3s ease; }
    .content.collapsed { margin-left: 70px; }</style>
</head>
<body class="container mt-4">
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

      <a href="LeaveApproval.jsp"><i class="fa-solid fa-user-check"></i> <span>Leave Approval</span></a>
      <a href="PayRoll.html"><i class="fa-solid fa-money-check-dollar"></i> <span>Payroll</span></a>
      <a href="OtApproval.jsp"><i class="fa-solid fa-stopwatch me-2"></i> <span>Overtime Approval</span></a>
      <a href="Holiday.jsp"><i class="fa-solid fa-calendar-days"></i> <span>Holidays</span></a>
    </div>

    <!-- Logout Button -->
   <a href="#" class="logout" id="logoutBtn">
  <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
</a>
  </div>
  

<% if (!message.isEmpty()) { %>
    <div class="alert alert-<%=status%>"><%=message%></div>
<% } %>

 <!-- Main Content -->
  <main class="content" id="main">
    <div class="card">
      <div class="card-header"><i class="fa-solid fa-pen-to-square  me-2"></i> Updating Employee Details</div>
      <div class="card-body">
        
<form method="post" class="mb-5">
    <input type="hidden" name="empId" value="<%=emp.getEmpId()%>">

    <!-- Login Info -->
    <h5 class="mb-3">Login Information</h5>
    <div class="row mb-3">
        <div class="col-md-4">
            <label class="form-label">Username</label>
            <input type="text" name="username" value="<%=emp.getUsername()%>" class="form-control" readonly>
        </div>
        <div class="col-md-4">
            <label class="form-label">Password</label>
            <input type="password" name="password_hash" value="<%=emp.getPassword_hash()%>" class="form-control" readonly>
        </div>
        <div class="col-md-4">
            <label class="form-label">Role</label>
            <input type="text" name="role" value="<%=emp.getRole()%>" class="form-control" >
        </div>
    </div>

    <!-- Identity -->
    <h5 class="mb-3">Identity Information</h5>
    <div class="row mb-3">
        <div class="col-md-6">
            <label class="form-label">First Name</label>
            <input type="text" name="first_name" value="<%=emp.getFirst_name()%>" class="form-control">
        </div>
        <div class="col-md-6">
            <label class="form-label">Last Name</label>
            <input type="text" name="last_name" value="<%=emp.getLast_name()%>" class="form-control">
        </div>
        <div class="col-md-4">
            <label class="form-label">Date of Birth</label>
            <input type="date" name="dob" value="<%=emp.getDob()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">Gender</label>
        	<select name="gender" class="form-select">
  			<option value="Male" <%= "Male".equals(emp.getGender()) ? "selected" : "" %>>Male</option>
  			<option value="Female" <%= "Female".equals(emp.getGender()) ? "selected" : "" %>>Female</option>
  			<option value="Other" <%= "Other".equals(emp.getGender()) ? "selected" : "" %>>Other</option>
			</select>
 		</div>

        <div class="col-md-4 mt-2">
            <label class="form-label">Marital Status</label>
            <input type="text" name="marital_status" value="<%=emp.getMarital_status()%>" class="form-control">
        </div>
    </div>

    <!-- Contact -->
    <h5 class="mb-3">Contact Information</h5>
    <div class="row mb-3">
        <div class="col-md-4">
            <label class="form-label">Email</label>
            <input type="email" name="email" value="<%=emp.getEmail()%>" class="form-control">
        </div>
        <div class="col-md-4">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" value="<%=emp.getPhone()%>" class="form-control">
        </div>
        <div class="col-md-4">
            <label class="form-label">Address Line 1</label>
            <input type="text" name="address_line1" value="<%=emp.getAddress_line1()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">Address Line 2</label>
            <input type="text" name="address_line2" value="<%=emp.getAddress_line2()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">City</label>
            <input type="text" name="city" value="<%=emp.getCity()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">State</label>
            <input type="text" name="state" value="<%=emp.getState()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">Postal Code</label>
            <input type="text" name="postal_code" value="<%=emp.getPostal_code()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">Country</label>
            <input type="text" name="country" value="<%=emp.getCountry()%>" class="form-control">
        </div>
    </div>

    <!-- Emergency -->
    <h5 class="mb-3">Emergency Contact</h5>
    <div class="row mb-3">
        <div class="col-md-4">
            <label class="form-label">Contact Name</label>
            <input type="text" name="emergency_name" value="<%=emp.getEmergency_name()%>" class="form-control">
        </div>
        <div class="col-md-4">
            <label class="form-label">Relation</label>
            <input type="text" name="emergency_relation" value="<%=emp.getEmergency_relation()%>" class="form-control">
        </div>
        <div class="col-md-4">
            <label class="form-label">Phone</label>
            <input type="text" name="emergency_phone" value="<%=emp.getEmergency_phone()%>" class="form-control">
        </div>
    </div>

    <!-- Employment -->
    <h5 class="mb-3">Employment</h5>
    <div class="row mb-3">
        <div class="col-md-4">
            <label class="form-label">Date of Joining</label>
            <input type="date" name="date_of_joining" value="<%=emp.getDate_of_joining()%>" class="form-control">
        </div>
		       <div class="col-md-4">
		  <label class="form-label">Employment Type</label>
		  <select name="employment_type" class="form-select">
		    <% for (String type : empTypeList) { %>
		      <option value="<%=type%>" <%= (type.equals(emp.getEmployment_type()) ? "selected" : "") %>>
		        <%=type%>
		      </option>
		    <% } %>
		  </select>
		</div>
		        <div class="col-md-4">
		  <label class="form-label">Designation</label>
		  <select name="designation" class="form-select">
		    <% for (String d : designationList) { %>
		      <option value="<%=d%>" <%= (d.equals(emp.getDesignation()) ? "selected" : "") %>>
		        <%=d%>
		      </option>
		    <% } %>
		  </select>
		</div>
		
		        <div class="col-md-4 mt-2">
		  <label class="form-label">Team</label>
		  <select name="team_id" class="form-select">
		    <% for (Map.Entry<Integer, String> t : teamList.entrySet()) { %>
		      <option value="<%=t.getKey()%>" <%= (t.getKey() == emp.getTeam_id() ? "selected" : "") %>>
		        <%=t.getValue()%>
		      </option>
		    <% } %>
		  </select>
		</div>

    </div>

    <!-- Bank & IDs -->
    <h5 class="mb-3">Bank & IDs</h5>
    <div class="row mb-3">
        <div class="col-md-4">
            <label class="form-label">Bank Name</label>
            <input type="text" name="bank_name" value="<%=emp.getBank_name()%>" class="form-control">
        </div>
        <div class="col-md-4">
            <label class="form-label">Account Number</label>
            <input type="text" name="account_number" value="<%=emp.getAccount_number()%>" class="form-control">
        </div>
        <div class="col-md-4">
            <label class="form-label">IFSC Code</label>
            <input type="text" name="ifsc_code" value="<%=emp.getIfsc_code()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">PAN Number</label>
            <input type="text" name="pan_number" value="<%=emp.getPan_number()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">Aadhar Number</label>
            <input type="text" name="aadhar_number" value="<%=emp.getAadhar_number()%>" class="form-control">
        </div>
        <div class="col-md-4 mt-2">
            <label class="form-label">UAN Number</label>
            <input type="text" name="uan_number" value="<%=emp.getUan_number()%>" class="form-control">
        </div>
    </div>

    <!-- Links -->
    <h5 class="mb-3">Links</h5>
    <div class="row mb-4">
	        <div class="col-md-4">
	  <label class="form-label">Shift</label>
	  <select name="shift_id" class="form-select">
	    <% for (Map.Entry<Integer, String> s : shiftList.entrySet()) { %>
	      <option value="<%=s.getKey()%>" <%= (s.getKey() == emp.getShift_id() ? "selected" : "") %>>
	        <%=s.getValue()%>
	      </option>
	    <% } %>
	  </select>
	</div>
	
	       <div class="col-md-4">
	  <label class="form-label">Salary Structure</label>
	  <select name="structure_id" class="form-select">
	    <% for (Map.Entry<Integer, String> st : structureList.entrySet()) { %>
	      <option value="<%=st.getKey()%>" <%= (st.getKey() == emp.getStructure_id() ? "selected" : "") %>>
	        <%=st.getValue()%>
	      </option>
	    <% } %>
	  </select>
	</div>

    </div>

    <button type="submit" class="btn btn-primary">Update Employee</button>
</form>

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
