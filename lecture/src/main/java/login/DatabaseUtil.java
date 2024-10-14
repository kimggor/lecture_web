package login;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {

	static String driver = "oracle.jdbc.driver.OracleDriver";
	static String url = "jdbc:oracle:thin:@localhost:1521:testdb";
	static String user = "scott";
	static String password = "tiger";

	public static Connection getConnection() {
	    Connection conn = null;
	    try {
	        Class.forName(driver);
	        conn = DriverManager.getConnection(url, user, password);
	    } catch (ClassNotFoundException e) {
	        System.out.println("JDBC 드라이버를 찾을 수 없습니다.");
	        e.printStackTrace();
	    } catch (SQLException e) {
	        System.out.println("데이터베이스 연결에 실패했습니다.");
	        System.out.println("오류 코드: " + e.getErrorCode());
	        System.out.println("SQL 상태: " + e.getSQLState());
	        e.printStackTrace();
	    }
	    return conn;
	}
}