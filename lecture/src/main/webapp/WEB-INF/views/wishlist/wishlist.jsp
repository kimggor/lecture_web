<%@page import="java.util.Map"%>
<%@page import="Model.Classes"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관심 목록</title>
<style type="text/css">


/* 기본 버튼 스타일 */
.btn {
    padding: 5px 10px;
    cursor: pointer;
    border: none;
    color: white;
    border-radius: 4px;
    font-size: 14px;
}

/* 공통 버튼 액션 클래스 */
.btn-action {
    background-color: #007BFF; /* 파란색, 필요에 따라 변경 가능 */
}

/* 비활성화된 버튼 스타일 */
.btn-disabled {
    background-color: #ccc;
    color: #666;
    cursor: not-allowed;
}

/* 삭제 버튼 스타일 */
.btn-delete {
    background-color: #FF5733; /* 번개색 */
}

/* 메시지 스타일 */
.message {
    text-align: center;
    font-size: 16px;
    margin-bottom: 20px;
}

.message.success {
    color: green;
}

.message.error {
    color: red;
}

/* 로그아웃 링크 스타일 */
.logout a {
    text-decoration: none;
    color: #007BFF;
}

.logout a:hover {
    text-decoration: underline;
}

/* 테이블 스타일 */
table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 40px;
}

th, td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: center;
}

th {
    background-color: #f2f2f2;
}
/* 사이드바 스타일 */
/* #sidebar {
    width: 200px;
    float: left;
    border: 1px solid #ddd;
    padding: 10px;
    box-sizing: border-box;
}
 */
/* 콘텐츠 영역 스타일 */
#content {
    flex-grow: 1;
    padding: 0 20px 20px 20px;
    margin-left: 220px;
}

/* 강의 목록 테이블을 스크롤리로 만들기 위한 스타일 */
#courseTableContainer {
    max-height: 300px; /* 스크롤 목록의 최대 높이 설정 */
    overflow: auto; /* 스크롤로의 평이 발생할 경우 실행 */
    border: 1px solid #ddd;
    margin-bottom: 40px;
}
</style>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/sidebar.css">
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/header.css"> <!-- CSS 파일 분리 권장 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script>

$(document).ready(function(){
	
    // 필터링 버튼 클릭 시
    $("#filterButton").click(function() {
        var selectedDepartment = $("#departmentFilter").val();
        var selectedClassification = $("#classificationFilter").val();

        // "강의 목록" 테이블의 행만 필터링
        $("#courseTable tbody tr").each(function() {
            var deptCell = $(this).find("td:nth-child(4)").text(); // 4번째 컬럼: 학과 이름
            var classCell = $(this).find("td:nth-child(5)").text(); // 5번째 컬럼: 분류

            var showRow = true;

            if (selectedDepartment && deptCell !== selectedDepartment) {
                showRow = false;
            }

            if (selectedClassification && classCell !== selectedClassification) {
                showRow = false;
            }

            if (showRow) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
    });
	
	$("#courseTable").on("click", ".btn-action", function(){
		var courseId = $(this).data("course-id");
		var classId = $(this).data("class-id");
		var button = $(this);
		var row = button.closest("tr");
		
		if($(this).hasClass("btn-disabled")){
			return;
		}
		
		$.ajax({
			url: "<%= request.getContextPath() %>/wishlist/add",
			type: "post",
			data: { courseId: courseId, classId: classId },
			dataType: "json",
			success: function(response){
				console.log("Wishlist Enroll Response: ", response);
				if(response.status === "success"){
					alert("강의 등록이 완료되었습니다.");
					
					var newRow = '<tr id="enrolled-row-' + response.classId + '">'
							   + '<td><button type="button" class="btn btn-delete btn-action" data-class-id="' + response.classId + '" data-course-id="' + response.courseId + '">삭제</button></td>'
							   + '<td>' + response.courseId + '</td>'
                               + '<td>' + response.courseName + '</td>'
                               + '<td>' + response.departmentName + '</td>'
                               + '<td>' + response.classification + '</td>'
                               + '<td>' + response.courseSemester + '</td>'
                               + '<td>' + response.credit + '</td>'
                               + '<td>' + response.professorName + ' 교수</td>'
                               + '<td>' + response.roomNo + '</td>'
                               + '<td>' + response.dayOfWeek + '(' + (response.startTime == response.endTime ? response.startTime : response.startTime + '-' + response.endTime) + ')' + '</td>'
                               + '<td>' + response.capacity + '</td>'
                               + '<td>' + response.enrolled + '</td>'
                               + '<td>' + (response.isRetake ? '예' : '아니오') + '</td>'
							   + '</tr>';
					$("#wishListTable tbody").append(newRow);
					
					button.addClass("btn-disabled");
					button.attr("disabled", true);
					button.text("등록 완료");
					
					$("#currentCredits").text("현재 등록 학점: " + response.currentCredits + " 학점");
				} else if(response.status === "already_enrolled"){
					alert("이미 등록한 강의입니다.");
				} else{
					alert("강의 등록에 실패했습니다. 다시 시도해주세요.");
				}
			},
			error: function(xhr, status, error){
				consle.log("AJAX Error:", status, error);
				alert("강의 등록 중 오류가 발생했습니다.");
			}
		});
	});
	
	$("#wishListTable").on("click", ".btn-delete", function(){
		var courseId = $(this).data("course-id");
		var classId = $(this).data("class-id");
		var button = $(this);
		var row = button.closest("tr");
		
		if(!confirm("정말로 등록을 취소하시겠습니까?")){
			return;
		}
		
		$.ajax({
			url: "<%= request.getContextPath() %>/wishlist/delete",
			type: "post",
			data: { courseId: courseId, classId: classId },
			dataType: "json",
			success: function(response){
				console.log("Wishlist Unroll Response:", response);
				if(response.status === "unenroll_success"){
					alert("강의 등록이 취소되었습니다.");
					
					$("#enrolled-row-" + response.classId).remove();
					
					$('button.btn-action[data-class-id="' + classId + '"][data-course-id="' + courseId + '"]')
						.removeClass("btn-disabled")
						.attr("disabled", false)
						.text("등록");
					
					$("#currentCredits").text("현재 등록 학점: " + response.currentCredits + " 학점");
				} else if(response.status === "unenroll_fail"){
					alert("강의 취소에 실패했습니다. 다시 시도해주세요.");
				} else{
					alert("강의 취소 중 오류가 발생했습니다.");
				}
			},
			error: function(xhr, status, error){
				console.log("AJAX Error:", status, error);
				alert("강의 취소 중 오류가 발생했습니다.");
			}
		});
	});
	
});

</script>
</head>
<body>

	<div id="sidebar">
        <%@ include file="/WEB-INF/views/sidebar.jsp" %>
    </div>
    <div id="content">
  
	<div>
		<%@ include file="/WEB-INF/views/header.jsp" %>
	</div>

    <h1 style="text-align: center;">강의 목록</h1>

<!-- 현재 수강 학점 표시 -->
<div style="text-align: center; margin-bottom: 20px;">
<span id="currentCredits">
현재 등록 학점: 
<%
Integer credits = (Integer)request.getAttribute("currentCredits");
if (credits != null){
	out.print(credits);
} else{
	out.print("0");
}
%>
학점
</span>
</div>

    <!-- 필터링 세션 추가 -->
    <div style="text-align: center; margin-bottom: 20px;">
        <form id="filterForm">
            <!-- 학과 이름 필터 -->
            <label for="departmentFilter">학과:</label>
            <select id="departmentFilter" name="department">
                <option value="">전체</option>
                <%
                    Map<Integer, String> departmentsMap = (Map<Integer, String>) request.getAttribute("departmentsMap");
                    if (departmentsMap != null) {
                        for (Map.Entry<Integer, String> entry : departmentsMap.entrySet()) {
                %>
                    <option value="<%= entry.getValue() %>"><%= entry.getValue() %></option>
                <%
                        }
                    }
                %>
            </select>

            <!-- 분류 필터 -->
            <label for="classificationFilter">분류:</label>
            <select id="classificationFilter" name="classification">
                <option value="">전체</option>
                <option value="전공필수">전공필수</option>
                <option value="전공선택">전공선택</option>
                <option value="교양">교양</option>
            </select>

            <!-- 필터링 버튼 -->
            <button type="button" id="filterButton">필터링</button>
        </form>
    </div>
    
    <!-- 알림 메시지 표시 -->
    <div class="message">
        <%-- 메시지는 AJAX 작업 후에 클라이언트 컨셉에서 처리하는 것으로 여기서는 필요 없음 --%>
    </div>

<!-- 전체 강의 목록 -->
<div id="courseTableContainer">
<table id="courseTable">

<thead>
<tr>
<th>관심등록</th>
<th>Course ID</th>
<th>강의명</th>
<th>학과 이름</th>
<th>분류</th>
<th>학기</th>
<th>학점</th>
<th>교수명</th>
<th>강의실</th>
<th>시간</th>
<th>정원</th>
<th>신청 인원</th>
<th>재수강 여부</th>
</tr>
</thead>

<tbody>
<%
List<Classes> allClasses = (List<Classes>)request.getAttribute("allClasses");
Map<Integer, Integer> wishList = (Map<Integer, Integer>)request.getAttribute("wishList");

if (allClasses != null && !allClasses.isEmpty()) {
	for (Classes classEntity : allClasses) {
		int classId = classEntity.getClassId();
		int courseId = classEntity.getCourseId();
%>
<tr>
<td>
<%		if (wishList.containsKey(classId) && wishList.get(classId) == courseId) { %>
<button type="button" class="btn btn-action btn-disabled" data-class-id="<%= classId %>" data-course-id="<%= courseId %>" disabled>등록 완료</button>
<%		} else { %>
<button type="button" class="btn btn-action" data-class-id="<%= classId %>" data-course-id="<%= courseId %>">등록</button>
<%		} %>
</td>
<td><%= courseId %></td>
<td><%= classEntity.getCourseName() %></td>
<td><%= classEntity.getDepartmentName() %></td>
<td><%= classEntity.getClassification() %></td>
<td><%= classEntity.getCourseSemester() %></td>
<td><%= classEntity.getCredit() %></td>
<td><%= classEntity.getProfessorName() %></td>
<td><%= classEntity.getRoomNo() %></td>
<td>
<%
String dayOfWeek = classEntity.getDayOfWeek();
String startTime = classEntity.getStartTime();
String endTime = classEntity.getEndTime();
%>
<%= startTime.equals(endTime) ? dayOfWeek + "(" + startTime + ")" : dayOfWeek + "(" + startTime + "-" + endTime + ")" %>
</td>
<td><%= classEntity.getCapacity() %></td>
<td><%= classEntity.getEnrolled() %></td>
<td><%= classEntity.getIsRetake() ? "예" : "아니오" %></td>
</tr>
<%
	}
} else {
%>
<tr>
<td colspan="13">조회된 강의가 없습니다.</td>
</tr>
<%
}
%>
</tbody>

</table>
</div>

<!-- 신청된 강의를 별도로 표시 -->
<h2 style="text-align: center; margin-top: 40px;">관심 목록</h2>
<table id="wishListTable">

<thead>
<tr>
<th>삭제</th>
<th>Course ID</th>
<th>강의명</th>
<th>학과 이름</th>
<th>분류</th>
<th>학기</th>
<th>학점</th>
<th>교수명</th>
<th>강의실</th>
<th>시간</th>
<th>정원</th>
<th>신청 인원</th>
<th>재수강 여부</th>
</tr>
</thead>

<tbody>
<%
if (wishList != null && !wishList.isEmpty()) {
	for (Map.Entry<Integer, Integer> entry : wishList.entrySet()) {
		int classId = entry.getKey();
		int courseId = entry.getValue();
		Classes wishClass = null;
		
		for (Classes classEntity : allClasses) {
			if (classEntity.getClassId() == classId && classEntity.getCourseId() == courseId) {
				wishClass = classEntity;
				break;
			}
		}
		
		if (wishClass != null) {
%>
<tr id="enrolled-row-<%= wishClass.getClassId() %>">
<td>
<button type="button" class="btn btn-delete btn-action" data-class-id="<%= classId %>" data-course-id="<%= courseId %>">삭제</button>
</td>
<td><%= wishClass.getCourseId() %></td>
<td><%= wishClass.getCourseName() %></td>
<td><%= wishClass.getDepartmentName() %></td>
<td><%= wishClass.getClassification() %></td>
<td><%= wishClass.getCourseSemester() %></td>
<td><%= wishClass.getCredit() %></td>
<td><%= wishClass.getProfessorName() %></td>
<td><%= wishClass.getRoomNo() %></td>
<td>
<%
String dayOfWeek = wishClass.getDayOfWeek();
String startTime = wishClass.getStartTime();
String endTime = wishClass.getEndTime();
%>
<%= startTime.equals(endTime) ? dayOfWeek + "(" + startTime + ")" : dayOfWeek + "(" + startTime + "-" + endTime + ")" %>
</td>
<td><%= wishClass.getCapacity() %></td>
<td><%= wishClass.getEnrolled() %></td>
<td><%= wishClass.getIsRetake() ? "예" : "아니오" %></td>
</tr>
<%
		}
	}
} else {
%>
<tr>
<td conspan="13">등록된 강의가 없습니다.</td>
</tr>
<%
}
%>
</tbody>

</table>

</body>
</html>