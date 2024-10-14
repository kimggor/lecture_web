package time_table;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/schedule")
public class ScheduleServlet extends HttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		//// 스케쥴 표를 그리기 위한 데이터(MODEL) 불러오기 (Service > DAO)
		ScheduleService service = new ScheduleService();
		
//// 리스트종류 구분을 위한 현재 페이지를 가져오는 기능 추가
		
		String enrollDbName = "ENROLLMENT";
		String cartDbName = "COURSE_CART";
		String wishDbName = "WISHLIST";
		
		String dbName = enrollDbName;
		ArrayList<Subject> list = new ArrayList<>();
		list = service.loadSubjectList(dbName);	// 서비스구동(MODEL값)
		
		
		
		
		
		// 스케쥴 표 렌더링을 위한 데이터 저장 - 렌더용 2차원배열 저장
		int totalDays = 6;                                 
		int totalPeriods = 13;
		Subject subjects[][] = new Subject[totalDays][totalPeriods];
		
		for(Subject subject : list) {
			
			// ENROLL리스트의 DAY값과 PERIOD값을 불러와서
			// 해당 2중배열 위치에 SUBJECT값을 넣기.
			int day = subject.day;
			int period = subject.period;
			
			subjects[day][period] = subject;	// 스케쥴표 렌더링용 데이터
		}
		
		//test
		for(int i=0; i<totalDays; i++) {
			for(int j=0; j<totalPeriods; j++) {
				subjects[i][j] = new Subject(Integer.toString(i)
											, Integer.toString(j)
											, "33"
											, "33");
			}
		}
		//test
		subjects[1][1] = null;
		subjects[2][2] = null;
		
		// 메모리 저장
		req.setAttribute("timeTable", subjects);
		req.setAttribute("day", totalDays);
		req.setAttribute("period", totalPeriods);
		
		// JSP 호출
		RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/timetable/schedule.jsp");
		dispatcher.forward(req, resp);
		
	}

}
