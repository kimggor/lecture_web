package time_table;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;



public class ScheduleDAO {
	
//	String driver="oracle.jdbc.driver.OracleDriver";
//	String url="jdbc:oracle:thin:@localhost:1521:xe";
//	String username="scott";
//	String password="tiger";
	
	
	private static String driver = "oracle.jdbc.driver.OracleDriver";
	private static String url = "jdbc:oracle:thin:@localhost:1521:testdb";
	private static String username = "scott";
	private static String password = "tiger";
	
	
	public Connection dbcon() {		
		Connection con=null;
		try {
			Class.forName(driver);
			con  =DriverManager.getConnection(url, username, password);
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
	public ArrayList<Subject> loadSubjectList(String dbTableName, int studentId) {
		
		String selectTable = dbTableName;
		
		String sql = "SELECT " 
		           + "c.day_of_week AS 요일, "
		           + "c.start_time AS 시작시간, "
		           + "c.end_time AS 종료시간, "
		           + "p.name AS 교수명, "
		           + "co.course_name AS 강의명, "
		           + "co.classification AS 분류, "
		           + "c.room_no AS 강의실번호 "
		           + "FROM Enrollment e "
		           + "JOIN Class c ON e.class_id = c.class_id "
		           + "JOIN Professor p ON c.professor_id = p.professor_id "
		           + "JOIN Course co ON e.course_id = co.course_id "
		           + "WHERE e.class_id = c.class_id "
		           + "AND e.course_id = co.course_id "
		           + "AND e.student_id = ?";
		
		ArrayList<Subject> list = new ArrayList<Subject>();
		
		Connection con = null; 
		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			con = dbcon();
			pst = con.prepareStatement(sql);
			pst.setInt(1, studentId);
			rs = pst.executeQuery();
			
			while(rs.next()) {
				Subject subject = new Subject();
				// 결과 집합에서 값 추출
                subject.day = getDayOfWeek(rs.getString("요일"));
                // 시작시간과 종료시간을 문자열로 가져오기
                subject.startTime = rs.getString("시작시간"); // CHAR(24)로 그대로 가져옴
                subject.endTime = rs.getString("종료시간");   // CHAR(24)로 그대로 가져옴
                subject.proffessorName = rs.getString("교수명");
                subject.courseName = rs.getString("강의명");
                subject.classfication = rs.getString("분류");
                subject.roomNumber = rs.getString("강의실번호");
                System.out.println(subject.roomNumber);
                
                list.add(subject);
            }
			
		} catch (SQLException e) {
			e.printStackTrace();
		}

		close(rs, pst, con);
		System.out.println("Loaded subjects count: " + list.size() );
		return list;
	}



//요일 문자열을 정수로 변환하는 메서드 (예: MONDAY -> 0)
private int getDayOfWeek(String day) {
    switch (day.toUpperCase()) {
        case "월": return 0;
        case "화": return 1;
        case "수": return 2;
        case "목": return 3;
        case "금": return 4;
        case "토": return 5;
        case "일": return 6;
        default: return -1; // 잘못된 값에 대한 처리
    }
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

//public static void main(String[] args) {
//	ScheduleDAO dao = new ScheduleDAO();
//	dao.loadSubjectList("ENROLLMENT", 1);
//}

}