package wish_list;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Model.Classes;
import Model.Course;
import Model.Department;
import lecture_list.ClassDAO;
import lecture_list.CourseDAO;
import lecture_list.DepartmentDAO;

@WebServlet("/wishlist")
public class WishlistController extends HttpServlet {
	
	private CourseDAO courseDAO;
	private ClassDAO classDAO;
	private DepartmentDAO departmentDAO;
	private WishlistDAO wishlistDAO;
	
	@Override
	public void init() throws ServletException {
		
		courseDAO = new CourseDAO();
		classDAO = new ClassDAO();
		departmentDAO = new DepartmentDAO();
		wishlistDAO = new WishlistDAO();
		
	}
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		if(session == null || session.getAttribute("student_id") == null) {
			resp.sendRedirect(req.getContextPath() + "/login");
			return;
		}
		
		int studentId = (int)session.getAttribute("student_id");
		
		List<Course> courses = courseDAO.getAllCourses();
		req.setAttribute("allCourses", courses);
		
		Map<Integer, Integer> wishList = wishlistDAO.getWishList(studentId);
		req.setAttribute("wishList", wishList);
		
		List<Classes> allClasses = classDAO.getAllClasses(studentId);
		req.setAttribute("allClasses", allClasses);
		
		List<Department> departments = departmentDAO.getAllDepartments();
		Map<Integer, String> departmentsMap = new HashMap<>();
		for(Department dept : departments) {
			departmentsMap.put(dept.getDepartmentId(), dept.getDepartmentName());
		}
		req.setAttribute("departmentsMap", departmentsMap);
		
		int currentCredits = wishlistDAO.getCurrentCredits(studentId);
		System.out.println("WishlistController - Current Credits: " + currentCredits);
		req.setAttribute("currentCredits", currentCredits);
		
		req.getRequestDispatcher("WEB-INF/views/wishlist/wishlist.jsp").forward(req, resp);
		
	}

}
