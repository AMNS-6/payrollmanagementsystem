package payrollmanagement;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    // ✅ Login method (used in login.jsp)
    @Override
    public UserBean login(String username, String password, String role) {
        UserBean user = null;
        String sql = "SELECT * FROM users WHERE username=? AND password_hash=? AND role=? AND is_active=1";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new UserBean();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setRole(rs.getString("role"));
                    user.setIsActive(rs.getInt("is_active"));
                    user.setLastLogin(rs.getString("last_login"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // ✅ Only true/false check (optional, but kept for reuse)
    @Override
    public boolean validateUser(String username, String password, String role) {
        boolean status = false;
        String sql = "SELECT * FROM users WHERE username=? AND password_hash=? AND role=? AND is_active=1";
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();
            status = rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    // ✅ Get user by ID + role
    @Override
    public UserBean getUserById(int userId, String role) {
        UserBean user = null;
        String sql = "SELECT * FROM users WHERE user_id=? AND role=?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, role);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new UserBean();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setRole(rs.getString("role"));
                    user.setIsActive(rs.getInt("is_active"));
                    user.setLastLogin(rs.getString("last_login"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // ✅ Get user by ID (role not required)
    @Override
    public UserBean getUserById(int userId) {
        UserBean user = null;
        try (Connection con = ConnectionFactory.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE user_id=?")) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new UserBean();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setRole(rs.getString("role"));
                user.setIsActive(rs.getInt("is_active"));
                user.setLastLogin(rs.getString("last_login"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    // ✅ Get all users by role (HR or EMPLOYEE)
    @Override
    public List<UserBean> getAllUsers(String role) {
        List<UserBean> userList = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role=?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserBean user = new UserBean();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setRole(rs.getString("role"));
                    user.setIsActive(rs.getInt("is_active"));
                    user.setLastLogin(rs.getString("last_login"));
                    userList.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }

    // ✅ Update last login timestamp
    @Override
    public boolean updateLastLogin(int userId) {
        boolean updated = false;
        String sql = "UPDATE users SET last_login=NOW() WHERE user_id=?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            int rows = ps.executeUpdate();
            updated = rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return updated;
    }
}