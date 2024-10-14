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
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script>

$(document).ready(function(){
	
	$("#classTable").on("click", ".btn-action", function(){
		var courseId = $(this).data("course-id");
		var classId = $(this).data("class-id");
		var button = $(this);
		var row = button.closest("tr");
		
		if($(this).hasClass("btn-disabled")){
			return;
		}
		
		$.ajax({
			url: "<%= request.getContextPath() %>/cart/add",
			type: "post",
			data: { courseId: courseId, classId: classId },
			dataType: "json",
			success: function(response){
				console.log("Cart Enroll Response: ", response);
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
					$("#cartListTable tbody").append(newRow);
					
					button.addClass("btn-disabled");
					button.attr("disabled", true);
					button.text("등록 완료");
					
					$("#currentCredits").text("현재 등록 학점: " + response.currentCredits + " 학점");
				} else if(response.status === "already_enrolled"){
					alert("이미 등록한 강좌입니다.");
				} else if(response.status === "exceed_max_credit"){
					alert("최대 수강 가능 학점인 18학점을 초과할 수 없습니다.");
				} else if(response.status === "time_conflict"){
					alert("강의 시간이 중복되어 신청할 수 없습니다.");
				} else{
					alert("강의 신청에 실패했습니다. 다시 시도해주세요.");
				}
			},
			error: function(xhr, status, error){
				consle.log("AJAX Error:", status, error);
				alert("강의 등록 중 오류가 발생했습니다.");
			}
		});
	});
	
	$("#cartListTable").on("click", ".btn-delete", function(){
		var courseId = $(this).data("course-id");
		var classId = $(this).data("class-id");
		var button = $(this);
		var row = button.closest("tr");
		
		if(!confirm("정말로 등록을 취소하시겠습니까?")){
			return;
		}
		
		$.ajax({
			url: "<%= request.getContextPath() %>/cart/delete",
			type: "post",
			data: { courseId: courseId, classId: classId },
			dataType: "json",
			success: function(response){
				console.log("Cart Unroll Response:", response);
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
<style>
table{
border: 1px solid black;
border-collapse: collapse;
text-align: center;
}
th{
border: 1px solid black;
}
td{
border: 1px solid black;
}
</style>
</head>
<body>

<h1>강의 목록</h1>
<div>
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

<div>
<table id="classTable">

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
Map<Integer, Integer> cartList = (Map<Integer, Integer>)request.getAttribute("cartList");

if (allClasses != null && !allClasses.isEmpty()) {
	for (Classes classEntity : allClasses) {
		int courseId = classEntity.getCourseId();
		int classId = classEntity.getClassId();
%>
<tr>
<td>
<%		if (cartList.containsKey(courseId) && cartList.get(courseId) == classId) { %>
<button type="button" class="btn btn-action btn-disabled" data-course-id="<%= courseId %>" data-class-id="<%= classId %>" disabled>등록 완료</button>
<%		} else { %>
<button type="button" class="btn btn-action" data-course-id="<%= courseId %>" data-class-id="<%= classId %>">등록</button>
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
<td>조회된 강의가 없습니다.</td>
</tr>
<%
}
%>
</tbody>

</table>
</div>

<h2>장바구니</h2>
<table id="cartListTable">

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
if (cartList != null && !cartList.isEmpty()) {
	for (Map.Entry<Integer, Integer> entry : cartList.entrySet()) {
		int courseId = entry.getKey();
		int classId = entry.getValue();
		Classes cartClass = null;
		
		for (Classes classEntity : allClasses) {
			if (classEntity.getCourseId() == courseId && classEntity.getClassId() == classId) {
				cartClass = classEntity;
				break;
			}
		}
		
		if (cartClass != null) {
%>
<tr id="enrolled-row-<%= cartClass.getClassId() %>">
<td>
<button type="button" class="btn btn-delete btn-action" data-course-id="<%= courseId %>" data-class-id="<%= classId %>">삭제</button>
</td>
<td><%= cartClass.getCourseId() %></td>
<td><%= cartClass.getCourseName() %></td>
<td><%= cartClass.getDepartmentName() %></td>
<td><%= cartClass.getClassification() %></td>
<td><%= cartClass.getCourseSemester() %></td>
<td><%= cartClass.getCredit() %></td>
<td><%= cartClass.getProfessorName() %></td>
<td><%= cartClass.getRoomNo() %></td>
<td>
<%
String dayOfWeek = cartClass.getDayOfWeek();
String startTime = cartClass.getStartTime();
String endTime = cartClass.getEndTime();
%>
<%= startTime.equals(endTime) ? dayOfWeek + "(" + startTime + ")" : dayOfWeek + "(" + startTime + "-" + endTime + ")" %>
</td>
<td><%= cartClass.getCapacity() %></td>
<td><%= cartClass.getEnrolled() %></td>
<td><%= cartClass.getIsRetake() ? "예" : "아니오" %></td>
</tr>
<%
		}
	}
} else {
%>
<tr>
<td>등록된 강의가 없습니다.</td>
</tr>
<%
}
%>
</tbody>

</table>

</body>
</html>