package payrollmanagement;

import java.util.List;

public interface UserDAO {
    UserBean login(String username, String password, String role); // ✅ Added

    boolean validateUser(String username, String password, String role);
    UserBean getUserById(int userId);
    UserBean getUserById(int userId, String role);
    List<UserBean> getAllUsers(String role);
    boolean updateLastLogin(int userId);
}