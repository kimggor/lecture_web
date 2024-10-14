// src/controller/UnenrollAjaxServlet.java
package lecture_list;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

import com.google.gson.JsonObject;

import Model.Classes;

@WebServlet("/unenrollAjax")
public class UnenrollAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EnrollmentDAO enrollmentDAO;
    private ClassDAO classDAO;

    @Override
    public void init() throws ServletException {
        enrollmentDAO = new EnrollmentDAO();
        classDAO = new ClassDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 요청 파라미터 가져오기
        String courseIdStr = request.getParameter("courseId");
        String classIdStr = request.getParameter("classId");

        // 세션에서 student_id 가져오기
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student_id") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int studentId = (int) session.getAttribute("student_id");

        // 파라미터 유효성 검사
        if (courseIdStr == null || classIdStr == null || courseIdStr.isEmpty() || classIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int courseId;
        int classId;
        try {
            courseId = Integer.parseInt(courseIdStr);
            classId = Integer.parseInt(classIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 강의 취소 처리
        int result = enrollmentDAO.unenrollCourse(studentId, courseId, classId);

        // JSON 응답 생성
        JsonObject jsonResponse = new JsonObject();
        switch(result) {
            case 0:
                jsonResponse.addProperty("status", "unenroll_success");
                // 취소된 강좌의 세부 정보 가져오기
                Classes updatedClass = classDAO.getClassById(studentId, classId);
                if(updatedClass != null) {
                    jsonResponse.addProperty("enrolled", updatedClass.getEnrolled());
                    jsonResponse.addProperty("classId", updatedClass.getClassId());
                    jsonResponse.addProperty("currentCredits", enrollmentDAO.getCurrentCredits(studentId));
                } else {
                    jsonResponse.addProperty("enrolled", "N/A");
                    jsonResponse.addProperty("classId", classId);
                    jsonResponse.addProperty("currentCredits", enrollmentDAO.getCurrentCredits(studentId));
                }
                break;
            case 1:
                jsonResponse.addProperty("status", "unenroll_fail");
                jsonResponse.addProperty("currentCredits", enrollmentDAO.getCurrentCredits(studentId));
                break;
            default:
                jsonResponse.addProperty("status", "unenroll_fail");
                jsonResponse.addProperty("currentCredits", enrollmentDAO.getCurrentCredits(studentId));
                break;
        }

        // 응답 설정
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        System.out.println("Unenroll Response: " + jsonResponse.toString()); // 서버 로그용
        out.print(jsonResponse.toString());
        out.flush();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
