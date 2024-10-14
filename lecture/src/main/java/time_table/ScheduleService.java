package time_table;

import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;

public class ScheduleService {
	
	ScheduleDAO dao = new ScheduleDAO();
	
	public ArrayList<Subject> loadSubjectList(String dbTableName) {
		
		ArrayList<Subject> list = new ArrayList<>();
		dao.loadSubjectList(dbTableName);
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
		
//// TIME자료형을 PERIOD 구간용 INT로 계산
	public int calcPeriod(Date startTime, Date endTime) {
		
		int startHour = startTime.getHours();	// 시작시간(Hour)
		int endHour = endTime.getHours();		// 종료시간(Hour)
		
		switch(startHour) {
		case 9: return 0;	// 1교시
		case 10: return 1;
		case 11: return 2;
		case 12: return 3;
		case 13: return 4;
		case 14: return 5;
		case 15: return 6;
		case 16: return 7;
		case 17: return 8;
		case 18: return 9;	// 10교시
		default:
			return 999;
		}
	}
	

}
