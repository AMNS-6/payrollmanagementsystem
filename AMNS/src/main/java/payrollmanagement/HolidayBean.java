package payrollmanagement;

import java.sql.Date;

public class HolidayBean {
    private int holiday_id;
    private String holiday_name;
    private Date holiday_date;
    private String holiday_type;
    private int is_recurring; // ✅ using int to match DB (0/1)

    // Getters and setters
    public int getHoliday_id() {
        return holiday_id;
    }
    public void setHoliday_id(int holiday_id) {
        this.holiday_id = holiday_id;
    }

    public String getHoliday_name() {
        return holiday_name;
    }
    public void setHoliday_name(String holiday_name) {
        this.holiday_name = holiday_name;
    }

    public Date getHoliday_date() {
        return holiday_date;
    }
    public void setHoliday_date(Date holiday_date) {
        this.holiday_date = holiday_date;
    }

    public String getHoliday_type() {
        return holiday_type;
    }
    public void setHoliday_type(String holiday_type) {
        this.holiday_type = holiday_type;
    }

    public int getIs_recurring() {
        return is_recurring;
    }
    public void setIs_recurring(int is_recurring) {
        this.is_recurring = is_recurring;
    }
}
