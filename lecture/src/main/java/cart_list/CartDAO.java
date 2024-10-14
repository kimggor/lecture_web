package cart_list;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import DBConnection.DBConnection;

public class CartDAO {
	
	public Map<Integer, Integer> getCartList(int studentId) {
		
		Map<Integer, Integer> cartList = new HashMap<>();
        String sql = "select course_id, class_id from course_cart where student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    int courseId = rs.getInt("course_id");
                    int classId = rs.getInt("class_id");
                    cartList.put(courseId, classId);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace(); 
        }

        return cartList;
		
	}
	
    // 학생이 강의를 신청하는 메소드
    // 반환 값:
    // 0: 성공
    // 1: 이미 신청한 강좌
    // -1: 기타 오류
	public int addCart(int studentId, int courseId, int classId) {
		
		String checkSQL = "select count(*) from course_cart where student_id = ? and course_id = ?";
		String insertSQL = "insert into course_cart(student_id, course_id, class_id, added_date) values(?, ?, ?, to_date(?, 'YYYY-MM-DD HH24:MI:SS'))";
		
		Connection conn = null;
		PreparedStatement pstmtCheck = null;
		PreparedStatement pstmtInsert = null;
		ResultSet rs = null;
		
		Date now = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String addedDate = format.format(now);
		
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			pstmtCheck = conn.prepareStatement(checkSQL);
			pstmtCheck.setInt(1, studentId);
			pstmtCheck.setInt(2, courseId);
			rs = pstmtCheck.executeQuery();
			if(rs.next()) {
				int count = rs.getInt(1);
				if(count > 0) {
					conn.rollback();
					return 1;
				}
			}
			
			pstmtInsert = conn.prepareStatement(insertSQL);
			pstmtInsert.setInt(1, studentId);
			pstmtInsert.setInt(2, courseId);
			pstmtInsert.setInt(3, classId);
			pstmtInsert.setString(4, addedDate);
			int insertedRows = pstmtInsert.executeUpdate();
			if (insertedRows == 0) {
				conn.rollback();
				return -1;
			}
			
			conn.commit();
			return 0;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
            try {
                if (conn != null)
                    conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace(); 
            }
            return -1;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmtCheck != null)
					pstmtCheck.close();
				if (pstmtInsert != null)
					pstmtInsert.close();
				if (conn != null) {
					conn.setAutoCommit(true);
					conn.close();
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
	}
	
	public int deleteCart(int studentId, int courseId, int classId) {
		
		String checkSQL = "select count(*) from course_cart where student_id = ? and course_id = ?";
		String deleteSQL = "delete from course_cart where student_id = ? and course_id = ?";
		
		Connection conn = null;
		PreparedStatement pstmtCheck = null;
		PreparedStatement pstmtDelete = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			pstmtCheck = conn.prepareStatement(checkSQL);
			pstmtCheck.setInt(1, studentId);
			pstmtCheck.setInt(2, courseId);
			rs = pstmtCheck.executeQuery();
			if(rs.next()) {
				int count = rs.getInt(1);
				if(count == 0) {
					conn.rollback();
					return 1;
				}
			}
			
			pstmtDelete = conn.prepareStatement(deleteSQL);
			pstmtDelete.setInt(1, studentId);
			pstmtDelete.setInt(2, courseId);
			int deletedRows = pstmtDelete.executeUpdate();
			if(deletedRows == 0) {
				conn.rollback();
				return -1;
			}
			
			conn.commit();
			return 0;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
            try {
                if (conn != null)
                    conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace(); 
            }
            return -1;
		} finally {
			try {
				if(rs != null)
					rs.close();
				if(pstmtCheck != null)
					pstmtCheck.close();
				if(pstmtDelete != null)
					pstmtDelete.close();
				if(conn != null) {
					conn.setAutoCommit(true);
					conn.close();
				}
			} catch(SQLException e) {
				e.printStackTrace();
			}
		}
		
	}
	
	public int getCurrentCredits(int studentId) {
		
		String sql = " select sum(co.credit) "
				+ " from course_cart cc "
				+ " join course co "
				+ " on cc.course_id = co.course_id "
				+ " where cc.student_id = ? ";
		
		int totalCredits = 0;
		
		try(Connection conn = DBConnection.getConnection();
				PreparedStatement pst = conn.prepareStatement(sql)){
			pst.setInt(1, studentId);
			try(ResultSet rs = pst.executeQuery()){
				if(rs.next()) {
					totalCredits = rs.getInt(1);
				}
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return totalCredits;
		
	}

}
