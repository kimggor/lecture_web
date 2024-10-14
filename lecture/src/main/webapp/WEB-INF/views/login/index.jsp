<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>고려대학교 수강신청시스템</title>
    <link href="/lecture/css/index.css" rel="stylesheet">
     <script src="/lecture/js/index.js"></script>
     
<script>
	window.onload = function() {
	    const errorMessage = '<c:out value="${error}" escapeXml="true" />';
	    const successMessage = '<c:out value="${success}" escapeXml="true" />';
	
	    if (errorMessage) {
	        alert(errorMessage);
	    }
	    
	    if (successMessage) {
	        alert(successMessage);
	    }
	}
</script>

</head>
<body class="login" >

     <header class="index-header">
        <div class="header-logo"></div>
    </header>

<!--  tt -->

    <div class="wrap-login">
        <div class="wrap-login-wrap">
            <div class="login-box">
                <form action="/lecture/login" method="post" autoComplete="off" id="loginForm" onsubmit="return validateForm()">
                    <div class="wrap-lang">                    
                        <input type="radio" name="lang" value="KOR" id="kor" checked onclick="showDiv()">
                        <label for="kor">KOREAN</label>
                        <input type="radio" name="lang" value="ENG" id="eng" onclick="showDiv()">
                        <label for="eng">ENGLISH</label>
                    </div>
                    <input type="text" id="id" name="student_id" class="input-id" placeholder="학번 ( Student ID )"
                           oninput="validateStudentId(event)">
                    <input type="password" id="pwd" name="password" class="input-pw" placeholder="비밀번호 ( Password )">
                    <button type="submit" id="btn-login" class="btn-login">로그인<small>Login</small></button>
                </form>        
            </div>
        </div>
    </div>
	
	<div class="wrap-contents">
		<div class="wrap-contents-wrap">
			<h1 id="boxENG2" style="display:none;">Course Registration Notice<small>수강신청 유의사항</small></h1>
			<div class="info-box" id="boxENG" style="display:none;">
				<ul class="list-bullet">
					<li>
						Before registering for courses, you are kindly asked to review the course registration instructions provided by the <br>
						relevant college/division. You can find the menu on the left side of the screen.
					</li> <br>
					<li><a>When log in fails, how to change Internet Explore setting</a></li> <br>
					<li>Please use Chrome, Firefox, and Edge browsers according to Microsoft's Internet Explorer termination policy.</li>  <br>
					<li class="highlight"><ins>Q&A about Revised Course Registration System from 2nd Semester, 2018 (Important!!)</ins></li> <br>
					<li class="highlight">You can register for courses restricted by certain departments during the course change period (Add/Drop period) in the first week of the semester. (March or September)</li>  <br>
					<li>The College of Life and Environmental Sciences and the College of Life Sciences and Biotechnology have been <br>
						merged into the College of Life Sciences and Biotechnology since March 2006. Undergraduate students admitted to <br>
						either college should register for courses offered by the College of Life Sciences and Biotechnology.
					</li> <br> 
					<li>Password : New students/non-KU students: Input the last 7 digits of your resident registration number. <br>
						KU portal users: Input your KUPID Password.<br>
						Non-KU portal users: Input your existing intranet password. <br>
					</li> <br> 
					<li>Student number for non-Korea University student <br>
						If you are a non-Korea University student (undergraduate only), please refer to Korea University Home page->academic <br>
						exchange->domestic student exchange site for your student number at Korea University.	
					</li> <br>
					<li><b>If you have forgotten your password </b>, you may find your password at the log-in page of <br>
						<a>KU portal (http://portal.korea.ac.kr) </a> site. Use the 'PW inquiry' button.
					</li> <br>
				</ul>	
			</div>
			
			<h1 id="boxKOR2">수강신청 유의사항<small>Course Registration Notice</small></h1>
			<div class="info-box" id="boxKOR">
				<ul class="list-bullet">
					<li>
						<a href="javascript:fnNotice()">수강신청시스템 중복로그인/매크로 제한 기능 도입 안내</a>
						<div id="notiMacro" style="display:none; padding-top: 10px;">
							2013학년도 2학기 수강신청부터(2013학년도 여름계절수업 시범 운영) 모든 사용자에게 공정하고 원활한 수강신청 서비스를 제공하고자<br>
							아래와 같은 제한 기능을 도입하오니 학생 여러분께서는 수강신청 시 아래 내용을 필히 숙지하여 주시기 바랍니다.<br>
							아래 기능 도입으로 인하여 본인의 아이디와 패스워드를 타인에게 빌려주면 원치 않게 로그아웃이 될 수 있으니, 본인 계정 관리에 신중을 기하여 주시기 바랍니다.
						<p>&nbsp;</p>
						<ul class="list-num">
							<li>중복로그인 방지 기능</li>
							<ul class="list-dot">
								<li>동일 아이디로 두 명 이상이 로그인하면 가장 마지막에 로그인 한 사용자만 수강신청이 가능합니다.</li>
							</ul>
							<li>매크로 방지 기능</li>
							<ul class="list-dot">
								<li>수강신청저장을 일정횟수를 초과하여 시도 할 때마다 임의의 문자열 이미지를 무작위로 화면에 표시하고 문자열을 올바르게 입력 했을 경우 수강신청 저장이 가능합니다.</li>
							</ul>
						</ul>
						</div>
					</li> <br>
					
					<li>Microsoft의 Internet Explorer 지원 종료에 따라 Chrome, Firefox, Edge 브라우저를 이용하시기 바랍니다.</li> <br>
					<li class="highlight">장애학생 수강신청 - 8. 1(목) 10:00 - 8. 2(금) 09:00</li>  <br>
					<li class="highlight">수강희망과목 등록기간 - 8. 2(금) 13:00 - 8. 5(월) 12:00</li> <br>
					<li class="highlight">신입생 수강신청 기간 - 8. 21(수) 10:00 - 8. 22(목) 12:00</li>  <br>
					<li class="highlight">수강신청 기간 - 8. 12(월) 10:00부터 시작, 4학년을 시작으로 학년별로 수강신청을 진행함.</li> <br> 
					<li class="highlight">수강신청 정정 기간 - 9. 4(수) 18:30부터 시작, 4학년을 시작으로 학년별로 한 시간 간격으로 시작시간을 달리함.</li> <br> 
					<li class="highlight">수강 및 성적평가 공정성 제고 관련 교육부 권고에 따라, 부모 중 1인 이상이 강의를 담당하는 과목의 경우 자녀의 수강이 제한될 수 있습니다.</li> <br>
					<li>학사관련 주요사항 안내는 교육정보 홈페이지를 참조하세요. <a href="#">교육정보 바로가기</a>   </li> <br>
					<li>단과대학별 수강신청 유의사항은 교육정보 홈페이지를 참조하세요.  <a href="#">교육정보 바로가기</a>  </li> <br>
					<li><b>암호</b>
						<ul class="list-dot">
							<li>포털(KUPID)사용자 : 포털비밀번호</li> <br>
							<li>포털(KUPID)미사용자 : '포털미사용자 비밀번호변경'에서 설정한 비밀번호(설정전: 주민번호뒷자리)</li>  <br>
							<li>(포털사용중인 신입생도 개강전에는 포털미사용자에 해당하는 비밀번호 사용)</li>
						</ul>
					</li> <br>
					<li><b>암호 분실시</b>	
						<ul class="list-dot">
							<li>포털 사용자 : <a href="#">포털(http://portal.korea.ac.kr)</a> 로그인 화면의 <strong>'비밀번호찾기'</strong>에서 비밀번호 재발급</li>
							<li>포털(KUPID)미사용자 : <span class="txt-blue">수강신청(https://sugang.korea.ac.kr)</span> <strong>'포털미사용자 비밀번호변경'</strong> 메뉴에서 비밀번호 재발급</li>
							<li class="highlight">포털에서 비밀번호를 변경 또는 재발급 받은 경우는 10분후에 로그인 하기 바랍니다.</li> <br>
						</ul>
					<li> <a href="#"> 국내 교류 학생의 학번 확인 </a> </li> <br>
					<li>Internet Explorer 10 이상의 버전, 화면 해상도 1920*1080에 최적화 되어 있습니다.</li>
					</li> <br>
				</ul>	
			</div>	
		</div>
	</div>
		
		
	<footer class="index-footer">
		<div>
			02841 서울특별시 성북구 안암로 145 <br>Copyright ⓒ 2020 Korea University. All Rights Reserved
		</div>
	</footer>
	
</body>

</html>