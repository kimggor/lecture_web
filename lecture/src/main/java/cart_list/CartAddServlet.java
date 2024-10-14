package cart_list;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonObject;

import Model.Classes;
import lecture_list.ClassDAO;

@WebServlet("/cart/add")
public class CartAddServlet extends HttpServlet {
	
	private CartDAO cartDAO;
	private ClassDAO classDAO;
	
	@Override
	public void init() throws ServletException {
		
		cartDAO = new CartDAO();
		classDAO = new ClassDAO();
		
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String courseIdStr = req.getParameter("courseId");
		String classIdStr = req.getParameter("classId");
		
		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("student_id") == null) {
			resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			return;
		}
		
		int studentId = (int)session.getAttribute("student_id");
		
		if (courseIdStr == null || classIdStr == null || courseIdStr.isEmpty() || classIdStr.isEmpty()) {
			resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		
		int courseId;
		int classId;
		try {
			courseId = Integer.parseInt(courseIdStr);
			classId = Integer.parseInt(classIdStr);
		} catch (NumberFormatException e) {
			resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		
		int currentCredits = cartDAO.getCurrentCredits(studentId);
		
		Classes selectedClass = classDAO.getClassById(studentId, classId);
		if(selectedClass == null) {
			resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		int courseCredits = selectedClass.getCredit();
		
		if(currentCredits + courseCredits > 18) {
			JsonObject jsonResponse = new JsonObject();
			jsonResponse.addProperty("status", "exceed_max_credit");
			jsonResponse.addProperty("currentCredits", currentCredits);
			resp.setContentType("application/json; charset=UTF-8");
			resp.setCharacterEncoding("UTF-8");
			PrintWriter out = resp.getWriter();
			out.print(jsonResponse.toString());
			out.flush();
			return;
		}
		
		// 시간 중복 확인
		// 학생이 등록한 모든 과목 조회
		Map<Integer, Integer> cartList =  cartDAO.getCartList(studentId);
		if(cartList != null && !cartList.isEmpty()) {
			for(Map.Entry<Integer, Integer> entry : cartList.entrySet()) {
				int cartClassId = entry.getValue();
				Classes cartClass = classDAO.getClassById(studentId, cartClassId);
				if(selectedClass.getDayOfWeek().equals(cartClass.getDayOfWeek())) {
					if(!(Integer.parseInt(selectedClass.getEndTime()) < Integer.parseInt(cartClass.getStartTime()) || Integer.parseInt(selectedClass.getStartTime()) > Integer.parseInt(cartClass.getEndTime()))) {
						JsonObject jsonResponse = new JsonObject();
						jsonResponse.addProperty("status", "time_conflict");
						jsonResponse.addProperty("currentCredits", currentCredits);
						resp.setContentType("application/json; charset=UTF-8");
						resp.setCharacterEncoding("UTF-8");
						PrintWriter out = resp.getWriter();
						out.print(jsonResponse.toString());
						out.flush();
						return;
					}
				}
			}
		}
		
		int result = cartDAO.addCart(studentId, courseId, classId);
		
		JsonObject jsonResponse = new JsonObject();
		switch(result) {
		case 0:
			jsonResponse.addProperty("status", "success");
			
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
			
			Classes existingClass = classDAO.getClassById(studentId, classId);
            if(existingClass != null) {
                jsonResponse.addProperty("enrolled", existingClass.getEnrolled());
                jsonResponse.addProperty("currentCredits", currentCredits);
            } else {
                jsonResponse.addProperty("enrolled", "N/A");
                jsonResponse.addProperty("currentCredits", currentCredits);
            }
            break;
        default:
        	jsonResponse.addProperty("status", "fail");
        	jsonResponse.addProperty("currentCredits", currentCredits);
        	break;
		}
		
		resp.setContentType("application/json; charset=UTF-8");
		resp.setCharacterEncoding("UTF-8");
		PrintWriter out = resp.getWriter();
		System.out.println("Cart Enroll Response: " + jsonResponse.toString());
		out.print(jsonResponse.toString());
		out.flush();
		
	}

}
