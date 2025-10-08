package payrollmanagement;

public class UserBean {
    private int userId;
    private int empId;
    private String username;
    private String passwordHash;
    private String role;      // "HR" or "EMPLOYEE"
    private int isActive;
    private String lastLogin;
    

    // --- Getters & Setters ---
    public int getUserId() {
    	return userId; 
    	}
    public void setUserId(int userId) {
    	this.userId = userId; 
    	}
    

    public int getEmpId() {
		return empId;
	}
	public void setEmpId(int empId) {
		this.empId = empId;
	}
	public String getUsername() {
    	return username; 
    	}
    public void setUsername(String username) {
    	this.username = username; 
    	}

    public String getPasswordHash() {
    	return passwordHash; 
    	}
    public void setPasswordHash(String passwordHash) {
    	this.passwordHash = passwordHash; 
    	}

    public String getRole() { 
    	return role; 
    	}
    public void setRole(String role) {
    	this.role = role;
    	}

    public int getIsActive() {
    	return isActive; 
    	}
    public void setIsActive(int isActive) {
    	this.isActive = isActive; 
    	}

    public String getLastLogin() { 
    	return lastLogin; 
    	}
    public void setLastLogin(String lastLogin) {
    	this.lastLogin = lastLogin; 
    	}
}