// src/controller/EnrollAjaxServlet.java
package lecture_list;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

import com.google.gson.JsonObject;


import Model.Classes;

@WebServlet("/enrollAjax")
public class EnrollAjaxServlet extends HttpServlet {
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

        // 현재 수강 학점 가져오기
        int currentCredits = enrollmentDAO.getCurrentCredits(studentId);

        // 신청하려는 강의의 학점 가져오기
        Classes selectedClass = classDAO.getClassById(studentId, classId); // 수정된 메소드 호출
        if (selectedClass == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        int courseCredits = selectedClass.getCredit();

        // 학점 제한 체크
        if (currentCredits + courseCredits > 18) {
            // 최대 학점 초과
            JsonObject jsonResponse = new JsonObject();
            jsonResponse.addProperty("status", "exceed_max_credit");
            jsonResponse.addProperty("currentCredits", currentCredits);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }

        // 강의 신청 처리
        int result = enrollmentDAO.enrollCourse(studentId, courseId, classId);

        // JSON 응답 생성
        JsonObject jsonResponse = new JsonObject();
        switch(result) {
            case 0:
                jsonResponse.addProperty("status", "success");
                // 신청된 강좌의 세부 정보 가져오기
                Classes updatedClass = classDAO.getClassById(studentId, classId);
                if(updatedClass != null) {
                    jsonResponse.addProperty("enrolled", updatedClass.getEnrolled());
                    jsonResponse.addProperty("classId", updatedClass.getClassId());
                    jsonResponse.addProperty("courseId", updatedClass.getCourseId());
                    jsonResponse.addProperty("courseName", updatedClass.getCourseName());
                    jsonResponse.addProperty("departmentName", updatedClass.getDepartmentName());
                    jsonResponse.addProperty("classification", updatedClass.getClassification());
                    jsonResponse.addProperty("courseSemester", updatedClass.getCourseSemester());
                    jsonResponse.addProperty("credit", updatedClass.getCredit());
                    jsonResponse.addProperty("professorName", updatedClass.getProfessorName());
                    jsonResponse.addProperty("roomNo", updatedClass.getRoomNo());
                    jsonResponse.addProperty("dayOfWeek", updatedClass.getDayOfWeek());
                    jsonResponse.addProperty("startTime", updatedClass.getStartTime());
                    jsonResponse.addProperty("endTime", updatedClass.getEndTime());
                    jsonResponse.addProperty("capacity", updatedClass.getCapacity());
                    jsonResponse.addProperty("isRetake", updatedClass.getIsRetake());
                }
                jsonResponse.addProperty("currentCredits", currentCredits + courseCredits);
                break;
            case 1:
                jsonResponse.addProperty("status", "already_enrolled");
                // 이미 신청된 경우에도 현재 신청 인원 반환
                Classes existingClass = classDAO.getClassById(studentId, classId);
                if(existingClass != null) {
                    jsonResponse.addProperty("enrolled", existingClass.getEnrolled());
                    jsonResponse.addProperty("currentCredits", currentCredits);
                } else {
                    jsonResponse.addProperty("enrolled", "N/A");
                    jsonResponse.addProperty("currentCredits", currentCredits);
                }
                break;
            case 2:
                jsonResponse.addProperty("status", "class_full");
                jsonResponse.addProperty("currentCredits", currentCredits);
                break;
            default:
                jsonResponse.addProperty("status", "fail");
                jsonResponse.addProperty("currentCredits", currentCredits);
                break;
        }

        // 응답 설정
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        System.out.println("Enroll Response: " + jsonResponse.toString()); // 서버 로그용
        out.print(jsonResponse.toString());
        out.flush();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
