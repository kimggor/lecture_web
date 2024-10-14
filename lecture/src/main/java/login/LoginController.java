// src/controller/LoginController.java
package login;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import DBConnection.DBConnection;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

 
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 로그인 페이지로 포워딩
		request.getRequestDispatcher("/WEB-INF/views/login/login.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		String sql = "SELECT student_id FROM Student WHERE email = ? AND password = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, email);
			pstmt.setString(2, password); // 실제 환경에서는 비밀번호는 해시화하여 비교해야 함
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					int studentId = rs.getInt("student_id");
					HttpSession session = request.getSession();
					session.setAttribute("student_id", studentId);
					response.sendRedirect("courses");
				} else {
					response.sendRedirect("login?error=invalid");
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
			response.sendRedirect("login?error=invalid");
		}
	}
}
