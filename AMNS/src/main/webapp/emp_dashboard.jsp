<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="payrollmanagement.UserBean, payrollmanagement.AttendanceDAO, payrollmanagement.AttendanceDAOImpl" %>
<%
    UserBean user = (UserBean) session.getAttribute("user");
    if (user == null || !"EMPLOYEE".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    
    
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        AttendanceDAO dao = new AttendanceDAOImpl();
        String action = request.getParameter("action");
        try {
            if ("punchIn".equals(action)) {
                boolean ok = dao.punchIn(user.getUserId());
                if (ok) {
                    dao.processAttendance(user.getUserId(), new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
                    message = "✅ Punch In recorded successfully!";
                } else {
                    message = "❌ Failed to record Punch In!";
                }
            } else if ("punchOut".equals(action)) {
                boolean ok = dao.punchOut(user.getUserId());
                if (ok) {
                    dao.processAttendance(user.getUserId(), new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
                    message = "✅ Punch Out recorded successfully!";
                } else {
                    message = "❌ Failed to record Punch Out!";
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            message = "❌ Server error while recording attendance.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
      margin: 0;
      font-family: Arial, sans-serif;
      background: #f4f6f9;
      color: #333;
      transition: all 0.3s ease;
    }
    body.dark-mode { background:#1e1e2f; color:#e5e5e5; }
    body.dark-mode .card { background:#2b2b3c; color:#fff; }
    body.dark-mode .table th { background:#39bfbf !important; }
    body.dark-mode .sidebar { background:#252537; }
    body.dark-mode .sidebar a:hover { background:#39bfbf; }

    /* Sidebar */
    .sidebar {
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
    .sidebar.collapsed { 
    width:70px;
     }
      /* Logo */
    .logo-container {
      margin-bottom: 20px;
    }
     
    .logo-text img { 
    width:120px; 
    height:auto;
     }
    .logo-tagline { 
    font-size:12px; 
    color:#fff; 
    margin-top:6px; 
    font-weight:400;
    line-weight:1.3;
     }
    .sidebar.collapsed .logo-text,
     .sidebar.collapsed .logo-tagline { 
     display:none; 
     }
     .menu {
      flex-grow: 1;
      text-align: left;
    }
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

    /* Toggle Button */
    .toggle-btn {
      position:absolute; top:15px; left:15px;
      background:#39bfbf; border-radius:50%; width:40px; height:40px;
      border:none; color:#fff; font-size:18px; cursor:pointer;
      display:flex; align-items:center; justify-content:center;
      z-index:10;
    }

    /* Main */
    .main { margin-left:300px; padding:20px; transition:margin-left 0.3s; }
    .main.collapsed { margin-left:70px; }

    /* Cards */
    .dashboard-card { border-radius:15px; }
    .dashboard-card:hover { transform:scale(1.05); box-shadow:0px 8px 20px rgba(0,0,0,0.15); }
    .card-icon { font-size:2rem; }
    .table th { background:#39bfbf; color:#fff; }
    .top-btn { width:40px; height:40px; border-radius:50%; background:#e5e7eb;
      display:flex; align-items:center; justify-content:center; margin-left:10px; cursor:pointer; }
    body.dark-mode .top-btn { background:#444; }
    .recent-activity {
            max-height: 250px;
            overflow-y: auto;
        }
        #recentActivity td {
  color: #333; /* Dark text for visibility */
  background-color: #fff; /* White background for rows */
  padding: 8px;
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
  <a href="EmpProfile.html"><i class="fa-solid fa-user"></i> <span>Profile</span></a>
  <a href="attendance.jsp"><i class="fa-solid fa-calendar-check"></i> <span>Attendance</span></a>
  <a href="LeaveRequest.html"><i class="fa-solid fa-plane-departure"></i> <span>Leave Request</span></a>
  <a href="EmpPaySlip.html"><i class="fa-solid fa-file-invoice-dollar"></i> <span>My Payslips</span></a>
  <a href="OtRequest.jsp"><i class="fa-solid fa-stopwatch me-2"></i> <span>OT Request</span></a>
</div>


    <a href="#" class="logout" id="logoutBtn">
  <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
</a>
  </div>
  <!-- Main -->
  <div class="main" id="main">
    <!-- Top Navbar -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2>Welcome Employee!!</h2>
      <div class="d-flex align-items-center">
        <div class="top-btn" id="theme-toggle"><i class="fa-solid fa-moon"></i></div>
        <div class="top-btn"><i class="fa-solid fa-bell"></i></div>
        <div class="top-btn"><i class="fa-solid fa-user"></i></div>
      </div>
    </div>

    <!-- Dynamic Date & Time -->
    <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap">
      <div id="dateBox" class="p-3 rounded shadow-sm">
        <span>Today is <strong id="dayName"></strong></span><br>
        <span id="fullDate" style="font-weight:bold;"></span>
      </div>
      <div class="text-center my-2">
        <h3 id="clock" style="font-weight:bold;"></h3>
      </div>
    </div>
    
    <!-- Dashboard Cards -->
    <div class="row g-4">
      <div class="col-md-3">
        <div class="card dashboard-card shadow-sm p-3">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h6>Attendance</h6>
              <h3>95%</h3>
            </div>
            <i class="fa-solid fa-calendar-day card-icon" style="color:#0077b6;"></i>
          </div>
        </div>
      </div>
      <div class="col-md-3">
        <div class="card dashboard-card shadow-sm p-3">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h6>Pending Leaves</h6>
              <h3>2</h3>
            </div>
            <i class="fa-solid fa-suitcase-rolling fa-2x" style="color:#0077b6;"></i>
          </div>
        </div>
      </div>
          <div class="col-md-3">
    <div class="card dashboard-card shadow-sm p-3">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h6>Upcoming Holidays</h6>
          <h3>3 Days</h3>
        </div>
        <i class="fa-solid fa-face-smile-beam card-icon" style="color:#f59e0b;"></i>
      </div>
    </div>
  </div>
     <div class="col-md-3">
    <div class="card dashboard-card shadow-sm p-3">
      <div class="d-flex justify-content-between align-items-center">
        <div>
          <h6>Next Meet</h6>
          <h3>2</h3>
        </div>
        <img src="images/meeting.logo.png" alt="Meeting Icon" style="width:60px; height:60px;">

      </div>
    </div>
  </div>
  </div>
  <br>
<div class="container dashboard-container">

    <% if (message != null && !message.isEmpty()) { %>
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <%= message %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <!-- Welcome Card -->
    <div class="card p-4 d-flex justify-content-center align-items-center text-center">
        <h5><i class="fa-solid fa-user"></i> Welcome, <%= user.getUsername() %></h5>
        <p class="text-muted mb-0">Employee ID: <%= user.getUserId() %></p>
    </div>

    <!-- Timer Card -->
    <div class="card p-4 d-flex justify-content-center align-items-center text-center">
        <div class="timer-section">
            <h5>Work Timer</h5>
            <h2 id="work-timer">00:00:00</h2>

            <div class="timer-buttons">
                <form method="post" id="punchInForm" style="display:inline;">
                    <input type="hidden" name="action" value="punchIn">
                    <button type="button" id="punchInBtn" class="btn btn-success btn-lg">
                        <i class="fa-solid fa-play"></i> Punch In
                    </button>
                </form>

                <form method="post" id="punchOutForm" style="display:inline;">
                    <input type="hidden" name="action" value="punchOut">
                    <button type="button" id="punchOutBtn" class="btn btn-danger btn-lg">
                        <i class="fa-solid fa-stop"></i> Punch Out
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Recent Activity Card -->
    <div class="card p-4">
        <h5><i class="fa-solid fa-clock-rotate-left"></i> Recent Activity</h5>
        <div class="recent-activity">
            <table class="table table-sm table-hover mt-3">
                <thead class="table-light">
                    <tr>
                        <th>Activity</th>
                        <th>Status</th>
                        <th>Time</th>
                    </tr>
                </thead>
                <tbody id="recentActivity">
                    <tr><td colspan="3" class="text-center text-muted">No activity yet</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>
</div>
<!-- Logout Confirmation Modal -->
<div class="modal fade" id="logoutModal" tabindex="-1" aria-labelledby="logoutModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-danger text-white">
        <h5 class="modal-title" id="logoutModalLabel"><i class="fa-solid fa-right-from-bracket"></i> Confirm Logout</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        Are you sure you want to logout?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">No</button>
        <button type="button" class="btn btn-danger" id="confirmLogoutBtn">Yes, Logout</button>
      </div>
    </div>
  </div>
</div>


<script>


//logout 
document.addEventListener("DOMContentLoaded", function () {
	  const logoutBtn = document.getElementById("logoutBtn");
	  const confirmLogoutBtn = document.getElementById("confirmLogoutBtn");

	  if (logoutBtn) {
	    logoutBtn.addEventListener("click", function (e) {
	      e.preventDefault();
	      const modal = new bootstrap.Modal(document.getElementById("logoutModal"));
	      modal.show();
	    });
	  }

	  if (confirmLogoutBtn) {
	    confirmLogoutBtn.addEventListener("click", function () {
	      window.location.href = "login.jsp"; // ✅ Redirect to login page
	    });
	  }
	});

/* Sidebar, date/time, theme toggle (unchanged) */
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

// Date & Time
function updateDateTime() {
  const now=new Date();
  const days=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
  document.getElementById("dayName").textContent=days[now.getDay()];
  document.getElementById("fullDate").textContent=now.toLocaleDateString("en-US",{year:'numeric',month:'long',day:'numeric'});
  document.getElementById("clock").textContent=now.toLocaleTimeString("en-US",{hour12:true});
}
setInterval(updateDateTime,1000);
updateDateTime();

// Theme Toggle
const themeToggle=document.getElementById("theme-toggle");
themeToggle.addEventListener("click",()=>{
  document.body.classList.toggle("dark-mode");
  const icon=themeToggle.querySelector("i");
  icon.classList.toggle("fa-moon");
  icon.classList.toggle("fa-sun");
});


document.addEventListener('DOMContentLoaded', function () {
	  const workTimerEl = document.getElementById('work-timer');
	  const punchInBtn = document.getElementById('punchInBtn');
	  const punchOutBtn = document.getElementById('punchOutBtn');
	  const punchInForm = document.getElementById('punchInForm');
	  const punchOutForm = document.getElementById('punchOutForm');
	  const recentActivityEl = document.getElementById('recentActivity');

	  // ✅ get unique key per user
	  const userId = "<%= user.getUserId() %>";
	  const logsKey = "activityLogs_" + userId;
	  const punchInKey = "punchInTime_" + userId;
	  const punchOutKey = "punchOutFrozen_" + userId;

	  let timerInterval = null;
	  function updateButtonStates() {
		  const punchedIn = localStorage.getItem(punchInKey);
		  const punchedOut = localStorage.getItem(punchOutKey);

		  if (punchedIn && !punchedOut) {
		    // ⏱ user is currently punched in
		    punchInBtn.disabled = true;
		    punchOutBtn.disabled = false;
		  } else {
		    // 🛑 user not punched in (either never punched in or already punched out)
		    punchInBtn.disabled = false;
		    punchOutBtn.disabled = true;
		  }
		}

		// run on page load
		updateButtonStates();


	  function pad(v) { return String(v).padStart(2, '0'); }

	  function createCell(text) {
	    const td = document.createElement('td');
	    td.textContent = (text === null || text === undefined) ? '' : String(text);
	    td.style.color = '#333';
	    td.style.backgroundColor = '#fff';
	    td.style.padding = '8px';
	    return td;
	  }

	  function renderDurationFrom(startTs) {
	    const now = Date.now();
	    let diff = Math.floor((now - startTs) / 1000);
	    if (!isFinite(diff) || diff < 0) diff = 0;
	    const hrs = Math.floor(diff / 3600);
	    const mins = Math.floor((diff % 3600) / 60);
	    const secs = diff % 60;
	    const text = pad(hrs) + ":" + pad(mins) + ":" + pad(secs);
	    workTimerEl.textContent = text;
	    return text;
	  }

	  function startTimerFrom(startTs) {
	    if (timerInterval) clearInterval(timerInterval);
	    renderDurationFrom(startTs);
	    timerInterval = setInterval(() => renderDurationFrom(startTs), 1000);
	  }

	  function stopTimer() {
	    if (timerInterval) {
	      clearInterval(timerInterval);
	      timerInterval = null;
	    }
	  }

	  function safeParseLogs() {
	    try {
	      const raw = localStorage.getItem(logsKey);
	      if (!raw) return [];
	      const parsed = JSON.parse(raw);
	      if (!Array.isArray(parsed)) {
	        localStorage.removeItem(logsKey);
	        return [];
	      }
	      return parsed.map(item => ({
	        activity: String(item.activity || '').trim(),
	        status: String(item.status || '').trim(),
	        time: String(item.time || '').trim()
	      }));
	    } catch (e) {
	      localStorage.removeItem(logsKey);
	      return [];
	    }
	  }

	  function saveLogs(logs) {
	    try {
	      localStorage.setItem(logsKey, JSON.stringify(logs));
	    } catch (e) {
	      console.error('Could not save activity logs', e);
	    }
	  }

	  function clearPlaceholderIfNeeded() {
	    const placeholder = recentActivityEl.querySelector('td.text-muted');
	    if (placeholder) recentActivityEl.innerHTML = '';
	  }

	  function addActivity(activity, status, time) {
	    activity = (activity === undefined || activity === null) ? '' : String(activity).trim();
	    status = (status === undefined || status === null) ? '' : String(status).trim();
	    time = (time === undefined || time === null) ? new Date().toLocaleTimeString() : String(time).trim();

	    clearPlaceholderIfNeeded();

	    const row = document.createElement('tr');
	    row.appendChild(createCell(activity || '(no activity)'));
	    row.appendChild(createCell(status || '(no status)'));
	    row.appendChild(createCell(time || new Date().toLocaleTimeString()));

	    recentActivityEl.prepend(row);

	    while (recentActivityEl.rows.length > 5) {
	      recentActivityEl.deleteRow(recentActivityEl.rows.length - 1);
	    }

	    const logs = safeParseLogs();
	    logs.unshift({ activity, status, time });
	    saveLogs(logs);
	  }

	  function loadActivities() {
	    const logs = safeParseLogs();
	    if (logs.length === 0) return;

	    recentActivityEl.innerHTML = '';
	    logs.forEach((log, index) => {
	      if (index < 5) {
	        const row = document.createElement('tr');
	        row.appendChild(createCell(log.activity || '(no activity)'));
	        row.appendChild(createCell(log.status || '(no status)'));
	        row.appendChild(createCell(log.time || ''));
	        recentActivityEl.appendChild(row);
	      }
	    });
	  }

	  // init
	  loadActivities();

	  const saved = localStorage.getItem(punchInKey);
	  const punchedOut = localStorage.getItem(punchOutKey);
	  if (punchedOut) {
	    workTimerEl.textContent = punchedOut;
	  } else if (saved) {
	    const num = parseInt(saved, 10);
	    if (!isNaN(num) && num > 0) startTimerFrom(num);
	  } else {
	    workTimerEl.textContent = "00:00:00";
	  }

	  if (punchInBtn) {
		  punchInBtn.addEventListener('click', function () {
		    const now = Date.now();
		    localStorage.setItem(punchInKey, String(now));
		    localStorage.removeItem(punchOutKey);
		    startTimerFrom(now);
		    addActivity('Work Timer', 'Punched In', new Date().toLocaleTimeString());
		    updateButtonStates();   // ✅ update state
		    setTimeout(() => { if (punchInForm) punchInForm.submit(); }, 250);
		  });
		}

		if (punchOutBtn) {
		  punchOutBtn.addEventListener('click', function () {
		    stopTimer();
		    const frozen = workTimerEl.textContent || "00:00:00";
		    localStorage.setItem(punchOutKey, frozen);
		    localStorage.removeItem(punchInKey);
		    addActivity('Work Timer', 'Punched Out', new Date().toLocaleTimeString());
		    updateButtonStates();   // ✅ update state
		    setTimeout(() => { if (punchOutForm) punchOutForm.submit(); }, 250);
		  });
		}

	});

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>