package cart_list;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Currency;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonObject;

import Model.Classes;
import lecture_list.ClassDAO;

@WebServlet("/cart/delete")
public class CartDeleteServlet extends HttpServlet {
	
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
		if(session == null || session.getAttribute("student_id") == null) {
			resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			return;
		}
		
		int studentId = (int)session.getAttribute("student_id");
		
		if(courseIdStr == null || classIdStr == null || courseIdStr.isEmpty() || classIdStr.isEmpty()) {
			resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		
		int courseId;
		int classId;
		try {
			courseId = Integer.parseInt(courseIdStr);
			classId = Integer.parseInt(classIdStr);
		} catch(NumberFormatException e) {
			resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}
		
		int result = cartDAO.deleteCart(studentId, courseId, classId);
		
		JsonObject jsonResponse = new JsonObject();
		switch(result) {
		case 0:
			jsonResponse.addProperty("status", "unenroll_success");
			
			Classes updatedClass = classDAO.getClassById(studentId, classId);
            if(updatedClass != null) {
                jsonResponse.addProperty("enrolled", updatedClass.getEnrolled());
                jsonResponse.addProperty("classId", updatedClass.getClassId());
                jsonResponse.addProperty("currentCredits", cartDAO.getCurrentCredits(studentId));
            } else {
                jsonResponse.addProperty("enrolled", "N/A");
                jsonResponse.addProperty("classId", classId);
                jsonResponse.addProperty("currentCredits", cartDAO.getCurrentCredits(studentId));
            }
            break;
		case 1:
            jsonResponse.addProperty("status", "unenroll_fail");
            jsonResponse.addProperty("currentCredits", cartDAO.getCurrentCredits(studentId));
            break;
        default:
        	jsonResponse.addProperty("status", "unenroll_fail");
        	jsonResponse.addProperty("currentCredits", cartDAO.getCurrentCredits(studentId));
        	break;
		}
		
		resp.setContentType("application/json; charset=UTF-8");
		resp.setCharacterEncoding("UTF-8");
		PrintWriter out = resp.getWriter();
		System.out.println("Cart Unenroll Response: " + jsonResponse.toString());
		out.print(jsonResponse.toString());
		out.flush();
		
	}

}
