<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	text-decoration: none;
}



.header-wrap {
	height: 60px;
	padding: 0 30px;
	border-bottom: 1px solid #ccc;
}

.util-wrap {
	display: flex;
	justify-content: space-between;
	height: 60px;
}

.header-img {
	margin-right: 20px;
}

.header-img img {
	width: 120px;
	height: 100%;
}

.semester {
	margin-left: 12px;
	padding-left: 10px;
	border-left: 1px solid #ccc;
	font-size: 20px;
	font-weight: 600;
	letter-spacing: -1px;
	display: flex;
	align-items: center;
}

.logout {
	display: flex;
	align-items: center;
}
</style>
</head>
<body>
	<div class="header-wrap">
		<div class="util-wrap">
			<div style="display: flex; height: 60px">
				<div class="header-img">
					<img alt="" src="<%=request.getContextPath()%>/images/임시이미지.svg" />
				</div>
				<div class="semester">2024학년도 1학기</div>
			</div>
			<div class="logout">
				<a href="<%=request.getContextPath()%>/logout">로그아웃</a>
			</div>
		</div>
	</div>
</body>
</html>