package time_table;

// 스케쥴표를 그리기용 과목정보
public class Subject {
	
	public String classfication;		// 분류
	public String courseName;			// 과정이름
	public String roomNumber;			// 강의실
	public String proffessorName;		// 교수이름
	public int startTime;
	public int endTime;
	
	public int day;				// 2차원배열 구분용: 0 -> MONDAY
	public int period;			// 2차원배열 구분용: 0 -> 1교시
	
	
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
		
	
	public int getDay() {
		return day;
	}

	public void setDay(int day) {
		this.day = day;
	}

	public int getPeriod() {
		return period;
	}

	public void setPeriod(int period) {
		this.period = period;
	}

	public int setDayInteger(String dayOfWeek) {
		switch(dayOfWeek) {
		case "MON":
			return 0;
		case "TUE":
			return 1;
		case "WED":
			return 2;
		case "THU":
			return 3;
		case "FRI":
			return 4;
		case "SAT":
			return 5;
		case "SUN":
			return 6;
		default:
			return 999;
		}
	}
	
	@Override
	public String toString() {			//스케쥻 1칸 렌더링
		String result = classfication 
				+ courseName 
				+ roomNumber
				+ proffessorName;
		
		return result;
	}

	public Subject() {
		
	}
	
	public Subject(String classfication, String courseName, String roomNumber, String proffessorName) {
		this.classfication = classfication;
		this.courseName = courseName;
		this.roomNumber = roomNumber;
		this.proffessorName = proffessorName;
	}

	public String getClassfication() {
		return classfication;
	}

	public void setClassfication(String classfication) {
		this.classfication = classfication;
	}

	public String getCourseName() {
		return courseName;
	}

	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}

	public String getRoomNumber() {
		return roomNumber;
	}

	public void setRoomNumber(String roomNumber) {
		this.roomNumber = roomNumber;
	}

	public String getProffessorName() {
		return proffessorName;
	}

	public void setProffessorName(String proffessorName) {
		this.proffessorName = proffessorName;
	}
	
}
