<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    String currentURI = (String) request.getAttribute("javax.servlet.forward.request_uri");
    if (currentURI == null) {
        currentURI = request.getRequestURI();
    }

    String contextPath = (String) request.getAttribute("javax.servlet.forward.context_path");
    if (contextPath == null) {
        contextPath = request.getContextPath();
    }

    String path = currentURI.substring(contextPath.length());
    // 디버깅을 위해 출력
    // out.println("currentURI: " + currentURI);
    // out.println("contextPath: " + contextPath);
    // out.println("path: " + path);
%>
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
    list-style: none;
    text-decoration: none;
}

body {
    font-family: Arial, sans-serif;
    display: flex;
}

.wrapper {
    width: 250px;
    background-color: #e2e2e2;
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    transform: translateX(0);
    transition: transform 0.3s ease;
    overflow-y: auto;
    z-index: 1000;
}

.wrapper.hide {
    transform: translateX(-250px);
}

.menu-control {
    position: fixed;
    top: 20px;
    left: 250px;
    z-index: 1001;
    background-color: #a20131;
    color: white;
    border: none;
    padding: 10px 10px;
    cursor: pointer;
    font-size: 18px;
    border-radius: 0 5px 5px 0;
    transition: left 0.3s ease;
}

.wrapper.hide + .menu-control {
    left: 0;
}

.nav {
    padding: 0;
}

.nav-header {
    display: flex;
    background-color: #e0e0e0;
    color: white;
    margin-bottom: 0;
    padding: 20px 20px 5px;
}

.nav-header a {
    flex: 1;
    cursor: pointer;
    padding: 20px 0;
    text-align: center;
    background-color: #b3b3b3;
    text-decoration: none;
    color: black; /* 기본 링크 색상을 검정색으로 설정 */
    font-size: 14px;
    height: 50px;
}

.nav-header a.is-active {
    color: white; /* 활성화된 링크 색상 */
    background-color: #a20131;
    border-bottom: 1px solid #a20131;
}

.nav-main {
    padding: 0 20px 20px;
}

.nav-menu {
    list-style: none;
    padding: 0;
    margin: 0;
}

.nav-menu li {
    border-bottom: 1px solid #ccc;
}

.nav-menu li a {
    display: block;
    padding: 15px 0;
    cursor: pointer;
    border-radius: 0;
    transition: background 0.3s;
    text-decoration: none;
    color: black; /* 기본 링크 색상을 검정색으로 설정 */
    font-size: 15px;
}

.nav-menu li a:hover {
    background: #f5f5f5;
}

.nav-menu li:last-child {
    border-bottom: none;
}

.nav-menu > li > a {
    font-weight: bold;
}

.nav-menu li ul li a {
    font-size: 12px;
    font-weight: normal;
}

/* 활성화된 링크 스타일 */
.nav-menu li a.is-active {
    color: #a20131; /* 활성화된 링크 색상 */
    border-bottom: 1px solid #a20131;
}

.nav-footer {
    padding: 20px;
    background: #e0e0e0;
    position: absolute;
    bottom: 0;
    width: 100%;
}

.btn-footer {
    width: 100%;
    padding: 10px;
    margin-bottom: 10px;
    background: #a20131;
    color: white;
    border: none;
    cursor: pointer;
    font-size: 16px;
}

.copy {
    text-align: center;
    font-size: 12px;
    color: #666;
}
</style>
</head>
<body>
	 <div class="wrapper">
        <div class="nav">
            <div class="nav-header">
                <a href="#" class="is-active">KOREAN</a> 
                <a href="#">ENGLISH</a>
            </div>
            <div class="nav-main">
                <ul class="nav-menu">
                    <li id="menu_sugang">
                        <a href="<%=contextPath%>/courses"
                           class="<%=path.equals("/courses") ? "is-active" : ""%>">수강신청</a>
                    </li>
                    <li id="menu_basket">
                        <a href="<%=contextPath%>/wishlist"
                           class="<%=path.equals("/wishlist") ? "is-active" : ""%>">수강희망/관심과목 등록</a>
                    </li>
                    <li id="menu_basket">
                        <a href="<%=contextPath%>/cart"
                           class="<%=path.equals("/cart") ? "is-active" : ""%>">장바구니</a>
                    </li>
                    <li class="has-child">
                        <a href="#"
                           class="<%=(path.equals("/lectHakbu") || path.equals("/lectSimilar") || path.equals("/schedule")) ? "is-active" : ""%>">과목조회</a>
                        <ul style="padding-left: 20px; margin: 0">
                            <li>
                                <a href="<%=contextPath%>/lectHakbu"
                                   class="<%=path.equals("/lectHakbu") ? "is-active" : ""%>">학부 과목조회</a>
                            </li>
                            <li>
                                <a href="<%=contextPath%>/lectSimilar"
                                   class="<%=path.equals("/lectSimilar") ? "is-active" : ""%>">학부 유사과목</a>
                            </li>
                            <li>
                                <a href="<%=contextPath%>/schedule"
                                   class="<%=path.equals("/schedule") ? "is-active" : ""%>">시간표 보기</a>
                            </li>
                        </ul>
                    </li>
                    <!-- 추가적인 메뉴 항목들도 동일하게 수정 -->
                </ul>
            </div>
            <!-- nav-footer 등 기타 내용 -->
            <div class="nav-footer">
                <button type="button" class="btn-footer">사용자 매뉴얼 (PC)</button>
                <button type="button" class="btn-footer">사용자 매뉴얼 (모바일앱)</button>
                <div class="copy">
                    Copyright © 2020 Korea University.<br />
                    All Rights Reserved.
                </div>
            </div>
        </div>
    </div>

	<button class="menu-control" onclick="toggleSidebar()">◀</button>


</body>

</body>
</html>