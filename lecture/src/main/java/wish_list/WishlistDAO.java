package wish_list;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import DBConnection.DBConnection;

public class WishlistDAO {
	
	public Map<Integer, Integer> getWishList(int studentId){
		
		Map<Integer, Integer> wishList = new HashMap<>();
		String sql = "select class_id, course_id from wishlist where student_id = ?";
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pst = conn.prepareStatement(sql)) {
			
			pst.setInt(1, studentId);
			try (ResultSet rs = pst.executeQuery()){
				while(rs.next()) {
					wishList.put(rs.getInt(1), rs.getInt(2));
				}
			}
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return wishList;
		
	}
	
	// wishlist 총 학점
	public int getCurrentCredits(int studentId) {
		
		String sql = " select sum(co.credit) "
				+ " from wishlist w "
				+ " join course co "
				+ " on w.course_id = co.course_id "
				+ " where w.student_id = ? ";
		
		int totalCredits = 0;
		
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pst = conn.prepareStatement(sql)) {
			pst.setInt(1, studentId);
			try (ResultSet rs = pst.executeQuery()){
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
	
    // 관심 목록 등록 메소드
    // 반환 값:
    // 0: 성공
    // 1: 이미 신청한 강좌
    // -1: 기타 오류
	public int addWish(int studentId, int courseId, int classId) {
		
		String checkSQL = "select count(*) from wishlist where student_id = ? and class_id = ?";
		String insertSQL = "insert into wishlist(student_id, course_id, class_id, added_date) values(?, ?, ?, to_date(?, 'YYYY-MM-DD HH24:MI:SS'))";
		
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
				pstmtCheck.setInt(2, classId);
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
	
    // 학생이 강의를 취소하는 메소드
    // 반환 값:
    // 0: 취소 성공
    // 1: 신청하지 않은 강좌
    // -1: 취소 실패 (기타 오류)
	public int deleteWish(int studentId, int courseId, int classId) {
		
		String checkSQL = "select count(*) from wishlist where student_id = ? and class_id = ?";
		String deleteSQL = "delete from wishlist where student_id = ? and class_id = ?";
		
		Connection conn = null;
		PreparedStatement pstmtCheck = null;
		PreparedStatement pstmtDelete = null;
		ResultSet rs = null;
		
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			pstmtCheck = conn.prepareStatement(checkSQL);
			pstmtCheck.setInt(1, studentId);
			pstmtCheck.setInt(2, classId);
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
			pstmtDelete.setInt(2, classId);
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
				if(conn != null)
					conn.rollback();
			} catch(SQLException ex) {
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
	
}
