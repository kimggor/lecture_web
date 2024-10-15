<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="time_table.Subject"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>시간표</title>
<link href="/lecture/css/schedule.css" rel="stylesheet" type="text/css">
<!-- 필요한 경우 sidebar.css를 추가로 링크하세요 -->
<!-- <link href="/lecture/css/sidebar.css" rel="stylesheet" type="text/css"> -->
<style type="text/css">/* 컨테이너를 Flex 컨테이너로 설정하여 사이드바와 콘텐츠를 나란히 배치 */

/* 콘텐츠 영역 스타일 */
#content {
	flex-grow: 1; /* 남은 공간을 모두 차지 */
	padding: 20px; /* 원하는 만큼 패딩 추가 */
}

/* 테이블 스타일 */
table {
	width: 100%;
	border-collapse: collapse;
}

thead {
	background-color: rgb(250, 243, 239);
	border-top: 2px solid rgb(160, 160, 160);
}

tbody tr {
	height: 30px;
}

tbody td {
	color: rgb(150, 150, 150);
	text-align: left;
	line-height: 1.2;
	padding: 5px;
}

th, td {
	text-align: center;
	font-size: small;
	border: 1px solid #ddd;
	padding: 5px;
}

.week {
	text-align: center;
}

.period {
	text-align: center;
	font-weight: bold;
}

tr:nth-child(even) {
	background-color: #f2f2f2;
}

tr:hover {
	background-color: #ededed;
}/* 콘텐츠 영역 스타일 */
#content {
    flex-grow: 1;
    padding:0 20px 20px 20px;
    margin-left: 250px; /* 사이드바의 너비와 동일하게 설정 */
    transition: margin-left 0.3s ease; /* 애니메이션을 위한 트랜지션 추가 */
}

/* 사이드바가 숨겨졌을 때 메인 콘텐츠 영역의 스타일 */
#content.sidebar-collapsed {
    margin-left: 0;
}

/* 추가적인 스타일이 필요하다면 여기에 작성하세요 */
</style>
<script type="text/javascript">
	function toggleSidebar() {
		const wrapper = document.querySelector(".wrapper");
		const menuControl = document.querySelector(".menu-control");
		const content = document.getElementById("content"); // 메인 콘텐츠 영역 선택

		wrapper.classList.toggle("hide"); // 사이드바 표시/숨김 토글
		content.classList.toggle("sidebar-collapsed"); // 메인 콘텐츠 영역에 클래스 토글

		if (wrapper.classList.contains("hide")) {
			menuControl.textContent = "▶"; // 사이드바 닫힘 상태
		} else {
			menuControl.textContent = "◀"; // 사이드바 열림 상태
		}
	}
</script>
</head>
<body>

	<%@ include file="/WEB-INF/views/sidebar.jsp"%>
	<div id="content">
		<%
		Subject[][] subjects = (Subject[][]) request.getAttribute("timeTable");
		int day = (int) request.getAttribute("day");
		int period = (int) request.getAttribute("period");
		%>
		<table>
			<thead>
				<tr>
					<td class="period">교시</td>
					<td class="week">월</td>
					<td class="week">화</td>
					<td class="week">수</td>
					<td class="week">목</td>
					<td class="week">금</td>
					<td class="week">토</td>
				</tr>
			</thead>
			<tbody>
				<%
				for (int j = 0; j < period; j++) {
				%>
				<tr>
					<td class="period"><%=j + 1%></td>
					<%
					for (int i = 0; i < day; i++) {
						if (subjects[i][j] == null) {
					%>
					<td style="background-color: pink"></td>
					<%
					} else {
					%>
					<td>
						<p><%=subjects[i][j].getClassfication()%></p>
						<p><%=subjects[i][j].getCourseName()%></p>
						<p><%=subjects[i][j].getRoomNumber()%></p>
						<p><%=subjects[i][j].getProffessorName()%></p>
					</td>
					<%
					}
					}
					%>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
	</div>

</body>
</html>
