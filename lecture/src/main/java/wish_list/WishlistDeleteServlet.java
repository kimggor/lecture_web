package wish_list;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonObject;

import Model.Classes;
import lecture_list.ClassDAO;

@WebServlet("/wishlist/delete")
public class WishlistDeleteServlet extends HttpServlet {
	
	private WishlistDAO wishlistDAO;
	private ClassDAO classDAO;
	
	@Override
	public void init() throws ServletException {
		
		wishlistDAO = new WishlistDAO();
		classDAO = new ClassDAO();
		
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		String courseIdStr = req.getParameter("courseId");
		String classIdStr = req.getParameter("classId");
		
		HttpSession session = req.getSession();
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
		
		int result = wishlistDAO.deleteWish(studentId, courseId, classId);
		
		JsonObject jsonResponse = new JsonObject();
		switch(result) {
		case 0:
			jsonResponse.addProperty("status", "unenroll_success");
			
			Classes updatedClass = classDAO.getClassById(studentId, classId);
			if(updatedClass != null) {
                jsonResponse.addProperty("enrolled", updatedClass.getEnrolled());
                jsonResponse.addProperty("classId", updatedClass.getClassId());
                jsonResponse.addProperty("currentCredits", wishlistDAO.getTotalCredits(studentId));
            } else {
                jsonResponse.addProperty("enrolled", "N/A");
                jsonResponse.addProperty("classId", classId);
                jsonResponse.addProperty("currentCredits", wishlistDAO.getTotalCredits(studentId));
            }
            break;
		case 1:
			jsonResponse.addProperty("status", "unenroll_fail");
			jsonResponse.addProperty("currentCredits", wishlistDAO.getTotalCredits(studentId));
			break;
		}
		
		resp.setContentType("application/json; charset=UTF-8");
		resp.setCharacterEncoding("UTF-8");
		PrintWriter out = resp.getWriter();
		System.out.println("Wishlist Unenroll Response: " + jsonResponse.toString());
		out.print(jsonResponse.toString());
		out.flush();
		
	}

}
