package login;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/login")
public class LogInServlet extends HttpServlet {

    private static final String SQL_SELECT_USER = "SELECT * FROM Student WHERE student_id = ? AND password = ?";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/views/login/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setCharacterEncoding("utf-8");
        response.setContentType("text/html;charset=utf-8");

        int studentId;
        String password = request.getParameter("password");

        try {
            studentId = Integer.parseInt(request.getParameter("student_id"));
        } catch (NumberFormatException e) {
            request.setAttribute("error", "유효한 학번을 입력해 주세요.");
            request.getRequestDispatcher("WEB-INF/views/login/index.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement pst = conn.prepareStatement(SQL_SELECT_USER)) {

            pst.setInt(1, studentId);  //testID: 2024120004
            pst.setString(2, password);  //testPW: kims0004

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("student_id", rs.getInt("student_id"));
                    session.setAttribute("name", rs.getString("name"));

                    // 로그인 성공 시: 수강신청 페이지로 이동
                    request.setAttribute("success", "수강신청 페이지로 이동합니다.");
                    request.getRequestDispatcher("WEB-INF/views/login/index.jsp").forward(request, response);
                    //수강신청 페이지로 경로 수정
                    
                } else {
                    request.setAttribute("error", "학번 또는 비밀번호가 일치하지 않습니다.");
                    request.getRequestDispatcher("WEB-INF/views/login/index.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "로그인 중 오류가 발생했습니다. 다시 시도해 주세요.");
            request.getRequestDispatcher("WEB-INF/views/login/index.jsp").forward(request, response);
        }
    }
}