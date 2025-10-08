<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.Date, payrollmanagement.*" %>
<%
    HolidayDAO dao = new HolidayDAOImpl();

    String action = request.getParameter("action");
    if ("add".equals(action)) {
        String name = request.getParameter("holiday_name");
        String type = request.getParameter("holiday_type");
        String date = request.getParameter("holiday_date");
        int recurring = "1".equals(request.getParameter("is_recurring")) ? 1 : 0;

        HolidayBean bean = new HolidayBean();
        bean.setHoliday_name(name);
        bean.setHoliday_date(Date.valueOf(date));
        bean.setHoliday_type(type);
        bean.setIs_recurring(recurring);
        dao.addHoliday(bean);

    } else if ("update".equals(action)) {
        int id = Integer.parseInt(request.getParameter("holiday_id"));
        String name = request.getParameter("holiday_name");
        String type = request.getParameter("holiday_type");
        String date = request.getParameter("holiday_date");
        int recurring = "1".equals(request.getParameter("is_recurring")) ? 1 : 0;

        HolidayBean bean = new HolidayBean();
        bean.setHoliday_id(id);
        bean.setHoliday_name(name);
        bean.setHoliday_date(Date.valueOf(date));
        bean.setHoliday_type(type);
        bean.setIs_recurring(recurring);
        dao.updateHoliday(bean);

    } else if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("holiday_id"));
        dao.deleteHoliday(id);
    }

    List<HolidayBean> holidays = dao.getAllHolidays();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Holiday Calendar</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.css" rel="stylesheet">
<style>
  body{background:#f0fafa;font-family:Arial,sans-serif;margin:0;padding:0;}
  .sidebar{height:100vh;width:300px;position:fixed;background:#39bfbf;color:#fff;padding-top:30px;display:flex;flex-direction:column;justify-content:space-between;overflow:hidden;transition:width 0.3s;text-align:center;}
  .sidebar.collapsed{width:70px;}
  .logo-container{margin-bottom:20px;}
  .logo-text img{width:120px;height:auto;}
  .logo-tagline{font-size:12px;margin-top:6px;line-height:1.3;}
  .menu{flex-grow:1;text-align:left;}
  .sidebar a{display:flex;align-items:center;gap:12px;color:#fff;padding:14px 20px;text-decoration:none;font-size:16px;margin:8px 0;border-radius:6px;transition:0.3s;}
  .sidebar a:hover{background:#12b5b5;}
  .sidebar a.active{background:#1a7c7c;font-weight:600;}
  .logout{background:#39bfbf;color:#fff;font-size:14px;padding:10px 16px;margin:15px;border-radius:6px;text-align:center;}
  .logout:hover{background:#1a252f;}
  .toggle-btn{position:absolute;top:15px;left:15px;background:#39bfbf;border-radius:50%;width:40px;height:40px;border:none;color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;}
  .main-content{margin-left:300px;padding:20px;transition:margin-left 0.3s ease;}
  .sidebar.collapsed ~ .main-content{margin-left:70px;}
  #calendar{background:#fff;padding:20px;border-radius:15px;border:2px solid #39bfbf;box-shadow:0 4px 15px rgba(0,0,0,0.08);}
  .fc-daygrid-event{background:#39bfbf !important;color:#fff !important;border-radius:8px !important;}
  .fc-day-today{background:#e6fafa !important;border:2px solid #39bfbf !important;}
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
      <a href="loginReport.jsp"><i class="fa-solid fa-clipboard-check"></i> <span>Login Report</span></a>

      <!-- Employee Management with Submenu -->
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

    <!-- Logout Button -->
   <a href="#" class="logout" id="logoutBtn">
  <i class="fa-solid fa-right-from-bracket"></i> <span>Logout</span>
</a>
  </div>

<div class="main-content">
  <h2 class="text-center mb-4">📅 Holiday Calendar</h2>
  <div id="calendar"></div>
</div>

<!-- Modal for Add/Edit/Delete -->
<div class="modal fade" id="holidayModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" action="Holiday.jsp">
        <input type="hidden" name="holiday_id" id="holidayId">
        <input type="hidden" name="action" id="holidayAction">
        <div class="modal-header" style="background:#39bfbf;color:#fff;">
          <h5 class="modal-title">Holiday</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label>Holiday Name</label>
            <input type="text" name="holiday_name" id="holidayName" class="form-control" required>
          </div>
          <div class="mb-3">
            <label>Date</label>
            <input type="date" name="holiday_date" id="holidayDate" class="form-control" required>
          </div>
          <div class="mb-3">
            <label>Type</label>
            <select name="holiday_type" id="holidayType" class="form-select">
              <option value="Public">Public</option>
              <option value="Company">Company</option>
            </select>
          </div>
          <div class="mb-3 form-check">
            <input type="checkbox" name="is_recurring" value="1" id="holidayRecurring" class="form-check-input">
            <label class="form-check-label">Recurring</label>
          </div>
        </div>
        <div class="modal-footer d-flex justify-content-between">
          <button type="submit" class="btn btn-success">Save</button>
          <button type="button" id="deleteHolidayBtn" class="btn btn-danger">Delete</button>
        </div>
      </form>
    </div>
  </div>
</div>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js"></script>
<script>
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
  const sidebar = document.getElementById('sidebar');
  const main = document.getElementById('main');
  const toggleBtn = document.getElementById('toggle-btn');
  const toggleIcon = toggleBtn.querySelector('i');

  toggleBtn.addEventListener('click', () => {
    sidebar.classList.toggle('collapsed');
    main.classList.toggle('collapsed');
    if (sidebar.classList.contains('collapsed')) {
      toggleIcon.classList.replace('fa-arrow-left', 'fa-bars');
    } else {
      toggleIcon.classList.replace('fa-bars', 'fa-arrow-left');
    }
  });

document.addEventListener('DOMContentLoaded', function(){
  const calendarEl = document.getElementById('calendar');
  const modalEl = document.getElementById('holidayModal');
  const holidayModal = new bootstrap.Modal(modalEl);
  const holidayId = document.getElementById('holidayId');
  const holidayAction = document.getElementById('holidayAction');
  const holidayName = document.getElementById('holidayName');
  const holidayDate = document.getElementById('holidayDate');
  const holidayType = document.getElementById('holidayType');
  const holidayRecurring = document.getElementById('holidayRecurring');
  const deleteBtn = document.getElementById('deleteHolidayBtn');

  const calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'dayGridMonth',
    selectable: true,
    events: [
      <% for(HolidayBean h : holidays){ %>
        { id: "<%=h.getHoliday_id()%>", title: "<%=h.getHoliday_name()%>", start: "<%=h.getHoliday_date()%>" },
      <% } %>
    ],
    select: function(info){
      holidayId.value = "";
      holidayAction.value = "add";
      holidayName.value = "";
      holidayDate.value = info.startStr;
      holidayType.value = "Public";
      holidayRecurring.checked = false;
      deleteBtn.style.display = "none";
      holidayModal.show();
    },
    eventClick: function(info){
      holidayId.value = info.event.id;
      holidayAction.value = "update";
      holidayName.value = info.event.title;
      holidayDate.value = info.event.startStr;
      // Match type and recurring from JSP holidays
      <% for(HolidayBean h : holidays){ %>
        if(info.event.id == "<%=h.getHoliday_id()%>"){
          holidayType.value = "<%=h.getHoliday_type()%>";
          holidayRecurring.checked = <%=h.getIs_recurring() == 1 ? "true" : "false" %>;
        }
      <% } %>
      deleteBtn.style.display = "inline-block";
      holidayModal.show();
    }
  });

  calendar.render();

  deleteBtn.addEventListener('click', function(){
    if(confirm("Are you sure you want to delete this holiday?")){
      holidayAction.value = "delete";
      modalEl.querySelector('form').submit();
    }
  });
});
</script>

</body>
</html>
