package time_table;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class ScheduleDAO {
	
	String driver="oracle.jdbc.driver.OracleDriver";
	String url="jdbc:oracle:thin:@localhost:1521:xe";
	String user="scott";
	String password="tiger";
	
	public Connection dbcon() {		
		Connection con=null;
		try {
			Class.forName(driver);
			con  =DriverManager.getConnection(url, user, password);
			if( con != null) System.out.println("db ok");
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return con;		
	}
	
	public void close( AutoCloseable ...a) {
		for( AutoCloseable  item : a) {
		   try {
			item.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

//// 쿼리문을 통해 테이블에 맞는 !!스케쥴용 SUBJECT 리스트!! 가져오기
	public ArrayList<Subject> loadSubjectList(String dbTableName) {
		
		String selectTable = dbTableName;
		
//		String scheduleSql = ""
		
		String sql = "S__Q__L" + dbTableName;	//입력값 활용 SQL문 작성
		Connection con = dbcon();
		PreparedStatement pst = null;
		ResultSet rs = null;
		
		ArrayList<Subject> list = new ArrayList<Subject>();
		
		// 구현중
		
		close(rs, pst, con);
		return list;
	}
	
	// STUDENT: 	STUDENT_ID, NAME, EMAIL, PASSWORD, GRADE, MAJOR, DEPARTMENT_ID
	// ENROLLMENT:	ENROLLMENT_ID, STUDENT_ID, CLASS_ID, COURSE_ID, GRADE
	// CLASS:		CLASS_ID, COURSE_ID, PROFESSOR_ID, SEMESTER, ROOM_NO, CAPACITY, ENROLLED, DAY_OF_WEEK, START_TIME, END_TIME
	// COURSE:		COURSE_ID, COURSE_NAME, DEPARTMENT_ID, CLASSIFICATION, SEMESTER, CREDIT
	// PROFESSOR:	PROFESSOR_ID, NAME, EMAIL, PASSWORD, DEPARTMENT_ID
	
	// SUBJECT
	// (ENROLLMENT.CLASS_ID):	COURSE_ID -> CLASSIFICATION	(EX. PHIL154 - 04)
	//							COURSE_ID -> COURSE_NAME	(EX. 동양철학입문)
	//							ROOM_NO						(EX. 교양관210)
	//							PROFESSOR_ID -> NAME		(EX. 김동진)
	//							DAY_OF_WEEK					(EX. 월)
	//							START_TIME					(EX. 11:00)
	//							END_TIME					(EX. 11:50)

}
