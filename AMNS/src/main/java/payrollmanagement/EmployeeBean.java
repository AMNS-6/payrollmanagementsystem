package payrollmanagement;

import java.sql.Date;

public class EmployeeBean {
    private String username;
    private String password_hash;
    private String role;
    private int EmpId;

   
	// Identity
    private String first_name;
    private String last_name;
    private Date dob;
    private String gender;
    private String marital_status;

    // Contact
    private String email;
    private String phone;
    private String address_line1;
    private String address_line2;
    private String city;
    private String state;
    private String postal_code;
    private String country;

    // Emergency
    private String emergency_name;
    private String emergency_relation;
    private String emergency_phone;

    // Employment
    private Date date_of_joining;
    private String employment_type;
    private String designation;
    private int team_id;

    // Bank & IDs
    private String bank_name;
    private String account_number;
    private String ifsc_code;
    private String pan_number;
    private String aadhar_number;
    private String uan_number;

    // Links
    private int shift_id;
    private int structure_id;
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword_hash() {
		return password_hash;
	}
	public void setPassword_hash(String password_hash) {
		this.password_hash = password_hash;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	
	public int getEmpId() {
		return EmpId;
	}
	public void setEmpId(int empId) {
		EmpId = empId;
	}
	public String getFirst_name() {
		return first_name;
	}
	public void setFirst_name(String first_name) {
		this.first_name = first_name;
	}
	public String getLast_name() {
		return last_name;
	}
	public void setLast_name(String last_name) {
		this.last_name = last_name;
	}
	public Date getDob() {
		return dob;
	}
	public void setDob(Date dob) {
		this.dob = dob;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getMarital_status() {
		return marital_status;
	}
	public void setMarital_status(String marital_status) {
		this.marital_status = marital_status;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getAddress_line1() {
		return address_line1;
	}
	public void setAddress_line1(String address_line1) {
		this.address_line1 = address_line1;
	}
	public String getAddress_line2() {
		return address_line2;
	}
	public void setAddress_line2(String address_line2) {
		this.address_line2 = address_line2;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getPostal_code() {
		return postal_code;
	}
	public void setPostal_code(String postal_code) {
		this.postal_code = postal_code;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getEmergency_name() {
		return emergency_name;
	}
	public void setEmergency_name(String emergency_name) {
		this.emergency_name = emergency_name;
	}
	public String getEmergency_relation() {
		return emergency_relation;
	}
	public void setEmergency_relation(String emergency_relation) {
		this.emergency_relation = emergency_relation;
	}
	public String getEmergency_phone() {
		return emergency_phone;
	}
	public void setEmergency_phone(String emergency_phone) {
		this.emergency_phone = emergency_phone;
	}
	public Date getDate_of_joining() {
		return date_of_joining;
	}
	public void setDate_of_joining(Date date_of_joining) {
		this.date_of_joining = date_of_joining;
	}
	public String getEmployment_type() {
		return employment_type;
	}
	public void setEmployment_type(String employment_type) {
		this.employment_type = employment_type;
	}
	public String getDesignation() {
		return designation;
	}
	public void setDesignation(String designation) {
		this.designation = designation;
	}
	public int getTeam_id() {
		return team_id;
	}
	public void setTeam_id(int team_id) {
		this.team_id = team_id;
	}
	public String getBank_name() {
		return bank_name;
	}
	public void setBank_name(String bank_name) {
		this.bank_name = bank_name;
	}
	public String getAccount_number() {
		return account_number;
	}
	public void setAccount_number(String account_number) {
		this.account_number = account_number;
	}
	public String getIfsc_code() {
		return ifsc_code;
	}
	public void setIfsc_code(String ifsc_code) {
		this.ifsc_code = ifsc_code;
	}
	public String getPan_number() {
		return pan_number;
	}
	public void setPan_number(String pan_number) {
		this.pan_number = pan_number;
	}
	public String getAadhar_number() {
		return aadhar_number;
	}
	public void setAadhar_number(String aadhar_number) {
		this.aadhar_number = aadhar_number;
	}
	public String getUan_number() {
		return uan_number;
	}
	public void setUan_number(String uan_number) {
		this.uan_number = uan_number;
	}
	public int getShift_id() {
		return shift_id;
	}
	public void setShift_id(int shift_id) {
		this.shift_id = shift_id;
	}
	public int getStructure_id() {
		return structure_id;
	}
	public void setStructure_id(int structure_id) {
		this.structure_id = structure_id;
	}

}