package payrollmanagement;

import java.util.List;

public interface HolidayDAO {
    List<HolidayBean> getAllHolidays();
    HolidayBean getHolidayById(int id);
    boolean addHoliday(HolidayBean holiday);
    boolean updateHoliday(HolidayBean holiday);
    boolean deleteHoliday(int id);
}
