<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="payrollmanagement.EmployeeDAOImpl" %>
<jsp:useBean id="emp" class="payrollmanagement.EmployeeBean" scope="request">
    <jsp:setProperty name="emp" property="*"/>
</jsp:useBean>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Onboarding Employee</title>

  <!-- Bootstrap + FontAwesome -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <style>
    :root { --accent: #39bfbf; --danger: #dc3545; --light: #f8f9fa; }
    body { background: var(--light); font-family: "Segoe UI", Arial, sans-serif; margin:0; }
    .card { border-radius:12px; box-shadow:0 6px 18px rgba(0,0,0,0.08); border:0; }
    .card-header { background:var(--accent); color:#fff; font-weight:600; }
    .btn-accent { background:var(--accent); color:#fff; border:0; }
    .btn-accent:hover { background:#2ea1a1; }
    .accordion-button:not(.collapsed) { background: rgba(57,191,191,0.1); color: #0b3c3c; }
    .was-validated .form-control:invalid,
    .was-validated .form-select:invalid { border: 2px solid var(--danger); }
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
    .content.collapsed { margin-left: 70px; }
    /* Accordion header */
.accordion-toggle {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  font-weight: 400;
  font-size: 16px;
  text-decoration: none;
  color: #0b3c3c;

  border-radius: 6px;
  transition: background 0.2s ease, color 0.2s ease;
}

/* Hover effect */
.accordion-toggle:hover {
  background: rgba(57, 191, 191, 0.1);
  color: #39bfbf;
}

/* Arrow */
.accordion-arrow {
  transition: transform 0.3s ease;
  font-size: 14px;
}

/* Rotate arrow when expanded */
.accordion-toggle[aria-expanded="true"] .accordion-arrow {
  transform: rotate(180deg);
}

/* Accordion body styling */
.accordion-body {
  padding: 16px;
 
  border: 1px solid #eee;
  border-radius: 6px;
  margin-top: 6px;
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
  <!-- Main Content -->
  <main class="content" id="main">
    <div class="card">
      <div class="card-header"><i class="fa-solid fa-user-plus me-2"></i> Employee Onboarding</div>
      <div class="card-body">
        
        <!-- Employee Onboarding Form -->
        <form action="saveEmployee.jsp" method="post" id="employeeForm" novalidate>

          <!-- Login Credentials -->
          <h6 class="mb-2">Login Credentials</h6>
          <div class="row g-3 mb-4">
            <div class="col-md-4">
              <label class="form-label">Username *</label>
              <input type="text" name="username" class="form-control" required>
            </div>
            <div class="col-md-4">
              <label class="form-label">Password *</label>
              <input type="password" name="password_hash" class="form-control" required>
            </div>
            <div class="col-md-4">
		  <label class="form-label">Role *</label>
		  <select name="role" class="form-select">
		    <option value="">Select</option>
		    <option value="1">HR</option>
		    <option value="2">Employee</option>
		   
		  </select>
		</div>
		
          </div>

          <!-- Identity -->
          <h6 class="mb-2">Identity Information</h6>
          <div class="row g-3 mb-4">
            <div class="col-md-6"><label class="form-label">First Name *</label>
              <input type="text" name="first_name" class="form-control" required></div>
            <div class="col-md-6"><label class="form-label">Last Name *</label>
              <input type="text" name="last_name" class="form-control" required></div>
            <div class="col-md-4"><label class="form-label">Date of Birth *</label>
              <input type="date" name="dob" class="form-control" required></div>
            <div class="col-md-4"><label class="form-label">Gender *</label>
              <select name="gender" class="form-select" required>
                <option value="">Select</option><option>Male</option><option>Female</option><option>Other</option>
              </select></div>
            <div class="col-md-4"><label class="form-label">Marital Status *</label>
              <select name="marital_status" class="form-select" required>
                <option value="">Select</option><option>Single</option><option>Married</option><option>Other</option>
              </select></div>
          </div>
<!-- Accordion -->
<div class="accordion" id="employeeAccordion">

  <!-- Contact Info -->
  <div class="accordion-item">
    <h2 class="accordion-header" id="headingContact">
      <a class="accordion-toggle d-block py-6 px-6"
         data-bs-toggle="collapse"
         href="#contactInfo"
         role="button"
         aria-expanded="true"
         aria-controls="contactInfo">
        Contact Information
      </a>
    </h2>
    <div id="contactInfo" class="accordion-collapse collapse show"
         aria-labelledby="headingContact"
         data-bs-parent="#employeeAccordion">
      <div class="accordion-body">
                  <div class="row g-3">
                    <div class="col-md-6"><label class="form-label">Email *</label>
                      <input type="email" name="email" class="form-control" required></div>
                    <div class="col-md-6"><label class="form-label">Phone *</label>
                      <input type="tel" name="phone" class="form-control" pattern="[0-9]{10}" required></div>
                    <div class="col-md-6"><label class="form-label">Address Line 1 *</label>
                      <input type="text" name="address_line1" class="form-control"></div>
                    <div class="col-md-6"><label class="form-label">Address Line 2 *</label>
                      <input type="text" name="address_line2" class="form-control"></div>
                    <div class="col-md-4"><label class="form-label">City *</label>
                      <input type="text" name="city" class="form-control"></div>
                    <div class="col-md-4"><label class="form-label">State *</label>
                      <input type="text" name="state" class="form-control"></div>
                    <div class="col-md-2"><label class="form-label">Postal Code *</label>
                      <input type="text" name="postal_code" class="form-control"></div>
                    <div class="col-md-2"><label class="form-label">Country *</label>
                      <input type="text" name="country" class="form-control"></div>
                  </div>
                </div>
              </div>
            </div>

             <!-- Emergency Contact -->
  <div class="accordion-item">
    <h2 class="accordion-header" id="headingEmergency">
      <a class="accordion-toggle d-block py-6 px-6 collapsed"
         data-bs-toggle="collapse"
         href="#emergencyInfo"
         role="button"
         aria-expanded="false"
         aria-controls="emergencyInfo">
        Emergency Contact
      </a>
    </h2>
    <div id="emergencyInfo" class="accordion-collapse collapse"
         aria-labelledby="headingEmergency"
         data-bs-parent="#employeeAccordion">
      <div class="accordion-body">
                  <div class="row g-3">
                    <div class="col-md-4"><label class="form-label">Name *</label>
                      <input type="text" name="emergency_name" class="form-control"></div>
                    <div class="col-md-4"><label class="form-label">Relation *</label>
                      <input type="text" name="emergency_relation" class="form-control"></div>
                    <div class="col-md-4"><label class="form-label">Phone *</label>
                      <input type="tel" name="emergency_phone" class="form-control" pattern="[0-9]{10}"></div>
                  </div>
                </div>
              </div>
            </div>

           <!-- Employment Details -->
  <div class="accordion-item">
    <h2 class="accordion-header" id="headingEmployment">
      <a class="accordion-toggle d-block py-6 px-6 collapsed"
         data-bs-toggle="collapse"
         href="#employmentInfo"
         role="button"
         aria-expanded="false"
         aria-controls="employmentInfo">
        Employment Details
        
      </a>
    </h2>
    <div id="employmentInfo" class="accordion-collapse collapse"
         aria-labelledby="headingEmployment"
         data-bs-parent="#employeeAccordion">
      <div class="accordion-body">
                  <div class="row g-3">
                    <div class="col-md-4"><label class="form-label">Date of Joining *</label>
                      <input type="date" name="date_of_joining" class="form-control" required></div>
                    <div class="col-md-4"><label class="form-label">Employment Type *</label>
                      <select name="employment_type" class="form-select" required>
                        <option value="">Select</option><option>Permanent</option><option>Contract</option><option>Part-time</option>
                      </select></div>
                    
                      <div class="col-md-4">
		  <label class="form-label">Designation *</label>
		  <select name="designation" class="form-select">
		    <option>Select</option>
		    <option>Developer</option>
		    <option>Analyst</option>
		    <option>HR</option>
		    <option>Manager</option>
		    <option>Designer</option>
		    <option>Intern</option>
		  </select>
		</div>
                    <div class="col-md-4"><label class="form-label">Shift *</label>
                      <select name="shift_id" class="form-select">
                        <option value="">Select</option><option value="1">General</option><option value="2">Morning</option><option value="3">Night</option>
                      </select></div>
                    <div class="col-md-4"><label class="form-label">Salary Structure *</label>
                      <select name="structure_id" class="form-select">
                        <option value="">Select</option><option value="1">Developer</option><option value="2">Analyst</option><option value="3">HR</option><option value="4">Manager</option><option value="5">Designer</option><option value="6">Intern</option>
                      </select>
                     </div>
                     
					   <div class="col-md-4"><label class="form-label">Team ID *</label>
					   	<select name="team_id" class="form-select">
					   		<option value="">Select</option><option value="1">Software Development</option><option value="2">Quality Assurance</option><option value="3">Human Resources</option><option value="4">Finance & Accounts</option><option value="5">Operations</option><option value="6">Sales & Marketing</option>
                        </select>
                      </div>
					
                  </div>
                </div>
              </div>
            </div>

            <!-- Bank & Legal -->
             <div class="accordion-item">
    <h2 class="accordion-header" id="headingBank">
      <a class="accordion-toggle d-block py-6 px-6 collapsed"
         data-bs-toggle="collapse"
         href="#bankInfo"
         role="button"
         aria-expanded="false"
         aria-controls="bankInfo">
        Bank & Legal
      </a>
    </h2>
    <div id="bankInfo" class="accordion-collapse collapse"
         aria-labelledby="headingBank"
         data-bs-parent="#employeeAccordion">
      <div class="accordion-body">
                  <div class="row g-3">
                    <div class="col-md-6"><label class="form-label">Bank Name *</label>
                      <input type="text" name="bank_name" class="form-control"></div>
                    <div class="col-md-6"><label class="form-label">Account Number *</label>
                      <input type="text" name="account_number" class="form-control"></div>
                    <div class="col-md-6"><label class="form-label">IFSC Code *</label>
                      <input type="text" name="ifsc_code" class="form-control"></div>
                    <div class="col-md-6"><label class="form-label">UAN Number *</label>
                      <input type="text" name="uan_number" class="form-control" ></div>
                    <div class="col-md-6"><label class="form-label">PAN Number *</label>
                      <input type="text" name="pan_number" class="form-control"></div>
                    <div class="col-md-6"><label class="form-label">Aadhar Number *</label>
                      <input type="text" name="aadhar_number" class="form-control"></div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Buttons -->
          <div class="d-flex justify-content-end gap-2 mt-4">
            <button type="reset" class="btn btn-outline-secondary">Reset</button>
            <button type="submit" class="btn btn-primary"><i class="fa-solid fa-floppy-disk me-1"></i> Save</button>
          </div>

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

    // Bootstrap validation
    const form = document.getElementById('employeeForm');
    form.addEventListener("submit", function (event) {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
        form.classList.add("was-validated");
      }
    });
  </script>
</body>
</html>