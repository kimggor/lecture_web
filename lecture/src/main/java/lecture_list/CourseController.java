// src/controller/CourseController.java
package lecture_list;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;


import Model.Classes;
import Model.Course;
import Model.Department;
import cart_list.CartDAO;
import wish_list.WishlistDAO;

@WebServlet("/courses")
public class CourseController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;
    private ClassDAO classDAO;
    private EnrollmentDAO enrollmentDAO;
    private DepartmentDAO departmentDAO;
    private CartDAO cartDAO;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        classDAO = new ClassDAO();
        enrollmentDAO = new EnrollmentDAO();
        departmentDAO = new DepartmentDAO();
        cartDAO = new CartDAO();
        wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 세션에서 student_id 가져오기 (로그인 구현 필요)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student_id") == null) {
            // 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = (int) session.getAttribute("student_id");

        // 모든 강의 목록 조회
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("allCourses", courses);//jsp의 allCourses 파라미터로 getAllCourse한 값을 전달
        
        // 학생이 이미 신청한 강의의 course_id와 class_id 목록 조회
        Map<Integer, Integer> enrolledCourses = enrollmentDAO.getEnrolledCourses(studentId);
        request.setAttribute("enrolledCourses", enrolledCourses);
        
        // 모든 클래스 조회
        List<Classes> allClasses = classDAO.getAllClasses(studentId);
        request.setAttribute("allClasses", allClasses);
        
        // 장바구니 course_id, class_id 목록 조회
        Map<Integer, Integer> cartListMap = cartDAO.getCartList(studentId);
        List<Classes> cartList = new ArrayList<>();
        if(cartListMap != null && !cartListMap.isEmpty()) {
        	for(Map.Entry<Integer, Integer> entry : cartListMap.entrySet()) {
        		int courseId = entry.getKey();
        		int classId = entry.getValue();
        		Classes cartClass = null;
        		
        		for(Classes classEntity : allClasses) {
        			if(classEntity.getCourseId() == courseId && classEntity.getClassId() == classId) {
        				cartClass = classEntity;
        				cartList.add(cartClass);
        				break;
        			}
        		}
        	}
        }
        request.setAttribute("cartList", cartList);
    
        // 관심 목록 course_id, class_id 목록 조회
        Map<Integer, Integer> wishListMap = wishlistDAO.getWishList(studentId);
        List<Classes> wishList = new ArrayList<>();
        if(wishListMap != null && !wishListMap.isEmpty()) {
        	for(Map.Entry<Integer, Integer> entry : wishListMap.entrySet()) {
        		// wishList는 classId가 key
        		int classId = entry.getKey();
        		int courseId = entry.getValue();
        		Classes wishClass = null;
        		
        		for(Classes classEntity : allClasses) {
        			if(classEntity.getClassId() == classId && classEntity.getCourseId() == courseId) {
        				wishClass = classEntity;
        				wishList.add(wishClass);
        				break;
        			}
        		}
        	}
        }
        request.setAttribute("wishList", wishList);
        
        // 모든 학과 조회 및 맵 생성
        List<Department> departments = departmentDAO.getAllDepartments();
        Map<Integer, String> departmentsMap = new HashMap<>();
        for (Department dept : departments) {
            departmentsMap.put(dept.getDepartmentId(), dept.getDepartmentName());
        }
        request.setAttribute("departmentsMap", departmentsMap);
        // 학생의 현재 수강 학점 조회
        int currentCredits = enrollmentDAO.getCurrentCredits(studentId);
        System.out.println("CourseController - Current Credits: " + currentCredits); // 로그 추가
        request.setAttribute("currentCredits", currentCredits);

        request.getRequestDispatcher("/WEB-INF/views/search_lecture/courseList.jsp").forward(request, response);
    }
}
