// src/model/ClassDAO.java
package lecture_list;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DBConnection;
import Model.Classes;

public class ClassDAO {

    // 모든 강의 조회 메소드
    public List<Classes> getAllClasses(int studentId) {
        List<Classes> classList = new ArrayList<>();
        String sql = "SELECT cl.class_id, cl.course_id, p.name AS professor_name, cl.room_no, cl.capacity, "
                + "cl.enrolled, cl.day_of_week, cl.start_time, cl.end_time, "
                + "c.course_name, c.department_id, d.department_name, c.classification, c.semester AS course_semester, c.credit, "
                + "CASE WHEN ch.is_retake IS NOT NULL THEN 1 ELSE 0 END AS is_retake "
                + "FROM Class cl "
                + "JOIN Professor p ON cl.professor_id = p.professor_id "
                + "JOIN Course c ON cl.course_id = c.course_id "
                + "JOIN Department d ON c.department_id = d.department_id "
                + "LEFT JOIN Course_History ch ON cl.course_id = ch.course_id AND ch.student_id = ? "
                + "ORDER BY cl.class_id";
        //class의 속성 조회 쿼리

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, studentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Classes classEntity = new Classes();
                    classEntity.setClassId(rs.getInt("class_id"));
                    classEntity.setCourseId(rs.getInt("course_id"));
                    classEntity.setCourseName(rs.getString("course_name"));
                    classEntity.setDepartmentId(rs.getInt("department_id"));
                    classEntity.setDepartmentName(rs.getString("department_name"));
                    classEntity.setClassification(rs.getString("classification"));
                    classEntity.setCourseSemester(rs.getString("course_semester"));
                    classEntity.setCredit(rs.getInt("credit"));
                    classEntity.setProfessorName(rs.getString("professor_name"));
                    classEntity.setRoomNo(rs.getString("room_no"));
                    classEntity.setCapacity(rs.getInt("capacity"));
                    classEntity.setEnrolled(rs.getInt("enrolled"));
                    classEntity.setDayOfWeek(rs.getString("day_of_week"));
                    classEntity.setStartTime(rs.getString("start_time"));
                    classEntity.setEndTime(rs.getString("end_time"));
                    classEntity.setIsRetake(rs.getInt("is_retake") == 1);

                    classList.add(classEntity);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return classList;
    }

    // 클래스 ID로 특정 강의 조회 메소드
    public Classes getClassById(int studentId, int classId) {
        Classes classEntity = null;
        String sql = "SELECT cl.class_id, cl.course_id, p.name AS professor_name, cl.room_no, cl.capacity, "
                   + "cl.enrolled, cl.day_of_week, cl.start_time, cl.end_time, "
                   + "c.course_name, c.department_id, d.department_name, c.classification, c.semester AS course_semester, c.credit, "
                   + "CASE WHEN ch.is_retake IS NOT NULL THEN 1 ELSE 0 END AS is_retake "
                   + "FROM Class cl "
                   + "JOIN Professor p ON cl.professor_id = p.professor_id "
                   + "JOIN Course c ON cl.course_id = c.course_id "
                   + "JOIN Department d ON c.department_id = d.department_id "
                   + "LEFT JOIN Course_History ch ON cl.course_id = ch.course_id AND ch.student_id = ? "
                   + "WHERE cl.class_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
            pstmt.setInt(1, studentId); // 실제 studentId 설정
            pstmt.setInt(2, classId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    classEntity = new Classes();
                    classEntity.setClassId(rs.getInt("class_id"));
                    classEntity.setCourseId(rs.getInt("course_id"));
                    classEntity.setCourseName(rs.getString("course_name"));
                    classEntity.setDepartmentId(rs.getInt("department_id"));
                    classEntity.setDepartmentName(rs.getString("department_name"));
                    classEntity.setClassification(rs.getString("classification"));
                    classEntity.setCourseSemester(rs.getString("course_semester"));
                    classEntity.setCredit(rs.getInt("credit"));
                    classEntity.setProfessorName(rs.getString("professor_name"));
                    classEntity.setRoomNo(rs.getString("room_no"));
                    classEntity.setCapacity(rs.getInt("capacity"));
                    classEntity.setEnrolled(rs.getInt("enrolled"));
                    classEntity.setDayOfWeek(rs.getString("day_of_week"));
                    classEntity.setStartTime(rs.getString("start_time"));
                    classEntity.setEndTime(rs.getString("end_time"));
                    classEntity.setIsRetake(rs.getInt("is_retake") == 1);
                }
            }
        
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return classEntity;
    }

    // enrolled 값 증가 메소드
    public boolean incrementEnrolled(int classId) {
        String sql = "UPDATE Class SET enrolled = enrolled + 1 WHERE class_id = ? AND enrolled < capacity";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, classId);
            int updatedRows = pstmt.executeUpdate();
            return updatedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // enrolled 값 감소 메소드
    public boolean decrementEnrolled(int classId) {
        String sql = "UPDATE Class SET enrolled = enrolled - 1 WHERE class_id = ? AND enrolled > 0";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, classId);
            int updatedRows = pstmt.executeUpdate();
            return updatedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }// 강좌의 학점 가져오기
    public int getClassCredit(int classId) {
        int credit = 0;
        String sql = "SELECT credit FROM Classes WHERE class_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, classId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    credit = rs.getInt("credit");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return credit;
    }
}
