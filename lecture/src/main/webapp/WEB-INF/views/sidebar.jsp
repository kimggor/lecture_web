<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>


</head>
<body>
	<div class="wrapper">
    <ul>
        <li><a href="<%= request.getContextPath() %>/home">홈</a></li>
        <li><a href="<%= request.getContextPath() %>/courses">수강신청</a></li>
        <li><a href="<%= request.getContextPath() %>/cart">장바구니</a></li>
        <li><a href="<%= request.getContextPath() %>/wishlist">관심 목록</a></li>
        <li><a href="<%= request.getContextPath() %>/profile">프로필</a></li>
        <li><a href="<%= request.getContextPath() %>/logout">로그아웃</a></li>
    </ul>
</div>

</body>
</html>