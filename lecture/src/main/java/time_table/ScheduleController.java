package time_table;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/schedule")
public class ScheduleController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ScheduleService service = new ScheduleService();

        String enrollDbName = "ENROLLMENT";
        String dbName = enrollDbName; // 가데이터

        // 세션에서 student_id 가져오기 (로그인 구현 필요)
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("student_id") == null) {
            // 로그인 페이지로 리다이렉트
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int studentId = (int) session.getAttribute("student_id");

        ArrayList<Subject> list = service.loadSubjectList(dbName, studentId);
        System.out.println("Loaded subjects count: " + list.size());

        // 스케쥴 표 렌더링을 위한 데이터 저장 - 렌더용 2차원배열 저장
        int totalDays = 6;
        int totalPeriods = 13;
        Subject subjects[][] = new Subject[totalDays][totalPeriods];

        for (Subject subject : list) {
            int day = subject.day;

            // 시작시간에서 시간 부분만 추출하여 정수로 변환
            String startTime = subject.startTime;
            int startHour = Integer.parseInt(startTime) - 1;
            
            String endTime = subject.endTime;
            int endHour = Integer.parseInt(endTime) - 1;

            // 필요에 따라 period 계산 방식 조정
//            int period = subject.period = startHour - 9; // 9시부터 시작하면 0번째 인덱스
//            
//            int endPeriod = endHour - 9;

            System.out.println("day: " + day);
            System.out.println("period: " + startHour);
            System.out.println("end period: " + endHour);

            if (day < 0 || day >= totalDays || startHour < 0 || startHour >= totalPeriods || endHour < 0 || endHour >= totalPeriods) {
                System.out.println("Invalid day/period: " + day + "/" + startHour);
                continue; // 잘못된 인덱스일 경우 skip
            }

            // subjects[day][period] = subject; // 스케쥴표 렌더링용 데이터
            for(int i=startHour; i<=endHour; i++) {
            	subjects[day][i] = subject;
            }
        }

        // 메모리 저장
        req.setAttribute("timeTable", subjects);
        req.setAttribute("day", totalDays);
        req.setAttribute("period", totalPeriods);

        // JSP 호출
        RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/timetable/schedule.jsp");
        dispatcher.forward(req, resp);
    }
}
