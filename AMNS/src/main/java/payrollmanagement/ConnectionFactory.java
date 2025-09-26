package payrollmanagement;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionFactory {
	private static final String url = "jdbc:mysql://localhost:3306/amns";
    private static final String user = "root";
    private static final String password = "gniharika@4";
    static {
    	try {
    		Class.forName("com.mysql.cj.jdbc.Driver");
    	}catch(ClassNotFoundException e) {
            throw new ExceptionInInitializerError("Error loading JDBC Driver: " + e);
        }
    	
    }
	public static Connection getConnection() throws SQLException{
		return DriverManager.getConnection(url,user,password);
		

	
	}

}