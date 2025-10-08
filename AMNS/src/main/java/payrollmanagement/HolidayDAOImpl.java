package payrollmanagement;

import java.sql.*;
import java.util.*;

public class HolidayDAOImpl implements HolidayDAO {

    @Override
    public List<HolidayBean> getAllHolidays() {
        List<HolidayBean> list = new ArrayList<>();
        String sql = "SELECT * FROM holiday_master ORDER BY holiday_date";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                HolidayBean h = new HolidayBean();
                h.setHoliday_id(rs.getInt("holiday_id"));
                h.setHoliday_name(rs.getString("holiday_name"));
                h.setHoliday_date(rs.getDate("holiday_date"));
                h.setHoliday_type(rs.getString("holiday_type"));
                h.setIs_recurring(rs.getInt("is_recurring"));
                list.add(h);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public HolidayBean getHolidayById(int id) {
        HolidayBean h = null;
        String sql = "SELECT * FROM holiday_master WHERE holiday_id=?";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    h = new HolidayBean();
                    h.setHoliday_id(rs.getInt("holiday_id"));
                    h.setHoliday_name(rs.getString("holiday_name"));
                    h.setHoliday_date(rs.getDate("holiday_date"));
                    h.setHoliday_type(rs.getString("holiday_type"));
                    h.setIs_recurring(rs.getInt("is_recurring"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return h;
    }

    @Override
    public boolean addHoliday(HolidayBean holiday) {
        String sql = "INSERT INTO holiday_master (holiday_date, holiday_name, holiday_type, is_recurring, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, holiday.getHoliday_date());
            ps.setString(2, holiday.getHoliday_name());
            ps.setString(3, holiday.getHoliday_type());
            ps.setInt(4, holiday.getIs_recurring());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateHoliday(HolidayBean holiday) {
        String sql = "UPDATE holiday_master SET holiday_date=?, holiday_name=?, holiday_type=?, is_recurring=?, updated_at=NOW() WHERE holiday_id=?";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDate(1, holiday.getHoliday_date());
            ps.setString(2, holiday.getHoliday_name());
            ps.setString(3, holiday.getHoliday_type());
            ps.setInt(4, holiday.getIs_recurring());
            ps.setInt(5, holiday.getHoliday_id());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteHoliday(int id) {
        String sql = "DELETE FROM holiday_master WHERE holiday_id=?";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
