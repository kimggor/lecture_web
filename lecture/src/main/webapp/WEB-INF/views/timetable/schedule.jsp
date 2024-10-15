<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="time_table.Subject"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="/lecture/css/schedule.css" rel="stylesheet" type="text/css">
</head>

<body>
	<%
	Subject[][] subjects = (Subject[][]) request.getAttribute("timeTable");
	int day = (int) request.getAttribute("day");
	int period = (int) request.getAttribute("period");
	%>
	<div>
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

				<% for (int j = 0; j < period; j++) { %>
				<tr>
					<td class="period"><%= j + 1 %></td>
					<% for (int i = 0; i < day; i++) { %>
					<% if (subjects[i][j] == null) { %>
					<td>
						<%
						continue;
						} else {
						%>
						<td>
							<p><%=subjects[i][j].getClassfication()%></p>
							<p><%=subjects[i][j].getCourseName()%></p>
							<p><%=subjects[i][j].getRoomNumber()%></p>
							<p><%=subjects[i][j].getProffessorName()%></p> 
						<% } %>
					</td>
					<% } %>
				</tr>
				<% } %>
			</tbody>
		</table>
	</div>
</body>
</html>