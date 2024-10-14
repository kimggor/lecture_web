<!-- WebContent/WEB-INF/views/search_lecture/courseList.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="Model.Classes"%>
<%@ page import="Model.Course"%>
<%@ page import="Model.Department"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>강의 목록</title>
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
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
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
    
    // 탭 버튼 클릭 시 출력 내용 변경
    $(".tab-button").click(function(){
    	var selectedTab = $(this).data("tab");
    	
    	// 모든 탭 내용을 숨김
    	$(".tab-content").hide();
    	
    	// 선택한 탭만 보임
    	$('div[data-tab="' + selectedTab + '"]').show();
    	
    	// 버튼 상태 업데이트
    	$(".tab-button").removeClass("active");
    	$(this).addClass("active");
    });

    // 강의 신청 버튼 클릭 시 AJAX 요청
    $(".btn-action").click(function() {
        var courseId = $(this).data("course-id");
        var classId = $(this).data("class-id");
        var button = $(this);
        var row = button.closest('tr');

        // 비활성화된 버튼은 클릭하지 않도록 추가
        if ($(this).hasClass('btn-disabled')) {
            return;
        }

        $.ajax({
            url: '<%=request.getContextPath()%>/enrollAjax',
            type: 'POST',
            data: {
                courseId: courseId,
                classId: classId
            },
            dataType: 'json',
            success: function(response) {
                console.log("Enroll Response:", response); // 디버깅용 로그
                if(response.status === 'success') {
                    // 신청 완료 메시지 표시 (alert 대신 메시지 영역 활용 권장)
                    alert('강의 신청이 완료되었습니다.');

                    // "신청된 강의" 테이블에 추가
                    var newRow = '<tr id="enrolled-row-' + response.classId + '">'
                               + '<td><button type="button" class="btn btn-delete btn-action" data-course-id="' + response.courseId + '" data-class-id="' + response.classId + '">삭제</button></td>'
                               + '<td>' + response.courseId + '</td>'
                               + '<td>' + response.courseName + '</td>'
                               + '<td>' + response.departmentName + '</td>'
                               + '<td>' + response.classification + '</td>'
                               + '<td>' + response.courseSemester + '</td>'
                               + '<td>' + response.credit + '</td>'
                               + '<td>' + response.professorName + ' 교수</td>'
                               + '<td>' + response.roomNo + '</td>'
                               + '<td>' + response.dayOfWeek + ' ' + response.startTime + ' ~ ' + response.endTime + '</td>'
                               + '<td>' + (response.isRetake ? '예' : '아니오') + '</td>'
                               + '<td>' + response.capacity + '</td>'
                               + '<td>' + response.enrolled + '</td>'
                               + '</tr>';
                    $("#enrolledTable tbody").append(newRow);

                    // "강의 목록" 테이블의 신청 인원 업데이트
                    row.find('td:nth-child(12)').text(response.enrolled); // 12번째 컬럼: 신청 인원

                    // 신청 버튼 비활성화 및 텍스트 변경
                    button.addClass('btn-disabled');
                    button.attr('disabled', true);
                    button.text('신청 완료');

                    // 현재 수강 학점 업데이트
                    $("#currentCredits").text("현재 수강 학점: " + response.currentCredits + "학점");
                } else if(response.status === 'already_enrolled') {
                    alert('이미 신청한 강주입니다.');
                } else if(response.status === 'class_full') {
                    alert('해당 강주는 마감되었습니다.');
                } else if(response.status === 'exceed_max_credit') {
                    alert('최대 수강 가능 학점인 18학점을 초과할 수 없습니다.');
                } else {
                    alert('강의 신청에 실패했습니다. 다시 시도해주세요.');
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error:", status, error);
                alert('강의 신청 중 오류가 발생했습니다.');
            }
        });
    });

    // "신청된 강의" 테이블의 삭제 버튼 클릭 시 AJAX 요청
    $("#enrolledTable").on("click", ".btn-delete", function() {
        var courseId = $(this).data("course-id");
        var classId = $(this).data("class-id");
        var button = $(this);
        var row = button.closest('tr');

        if(!confirm('정말로 신청을 취소하시겠습니까?')) {
            return;
        }

        $.ajax({
            url: '<%=request.getContextPath()%>/unenrollAjax',
            type: 'POST',
            data: {
                courseId: courseId,
                classId: classId
            },
            dataType: 'json',
            success: function(response) {
                console.log("Unenroll Response:", response); // 디버깅용 로그
                if(response.status === 'unenroll_success') {
                    // 취소 완료 메시지 표시 (alert 대신 메시지 영역 활용 권장)
                    alert('강의 신청이 취소되었습니다.');

                    // "신청된 강의" 테이블에서 해당 행 제거
                    $("#enrolled-row-" + response.classId).remove();

                    // "강의 목록" 테이블의 신청 인원 업데이트
                    $('button.btn-action[data-course-id="' + courseId + '"][data-class-id="' + classId + '"]')
                        .closest('tr')
                        .find('td:nth-child(12)') // 12번째 컬럼: 신청 인원
                        .text(response.enrolled);

                    // "강의 목록" 테이블의 신청 버튼 활성화 및 텍스트 변경
                    $('button.btn-action[data-course-id="' + courseId + '"][data-class-id="' + classId + '"]')
                        .removeClass('btn-disabled')
                        .attr('disabled', false)
                        .text('신청');

                    // 현재 수강 학점 업데이트
                    $("#currentCredits").text("현재 수강 학점: " + response.currentCredits + "학점");
                } else if(response.status === 'unenroll_fail') {
                    alert('강의 취소에 실패했습니다. 다시 시도해주세요.');
                } else {
                    alert('강의 취소 중 오류가 발생했습니다.');
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX Error:", status, error);
                alert('강의 취소 중 오류가 발생했습니다.');
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
            현재 수강 학점: 
            <%
                Integer credits = (Integer) request.getAttribute("currentCredits");
                if (credits != null) {
                    out.print(credits);
                } else {
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
    
    <div style="text-align: center; margin-bottom: 20px;">
	    <button class="tab-button" data-tab="allClasses">전체 강의</button>
	    <button class="tab-button" data-tab="cartList">장바구니</button>
	    <button class="tab-button" data-tab="wishList">관심 목록</button>
	</div>

    <!-- 전체 강의 목록 -->
    <div id="courseTableContainer" class="tab-content" data-tab="allClasses">
        <table id="courseTable">
            <thead>
                <tr>
                    <th>신청</th>
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
                    List<Classes> allClasses = (List<Classes>) request.getAttribute("allClasses");
                    Map<Integer, Integer> enrolledCourses = (Map<Integer, Integer>) request.getAttribute("enrolledCourses");

                    if (allClasses != null && !allClasses.isEmpty()) {
                        for (Classes classEntity : allClasses) {
                            int courseId = classEntity.getCourseId();
                            int classId = classEntity.getClassId();
                %>
                <tr>
                    <td>
                        <% if (enrolledCourses.containsKey(courseId) && enrolledCourses.get(courseId) == classId) { %>
                            <!-- 신청 완료된 강주의 신청 버튼 (비활성화) -->
                            <button type="button" class="btn btn-action btn-disabled" data-course-id="<%=courseId%>" data-class-id="<%=classId%>" disabled>신청 완료</button>
                        <% } else if (classEntity.getEnrolled() < classEntity.getCapacity()) { %>
                            <!-- 신청 가능한 강주의 신청 버튼 -->
                            <button type="button" class="btn btn-action" data-course-id="<%=courseId%>" data-class-id="<%=classId%>">신청</button>
                        <% } else { %>
                            <!-- 마감된 강주의 신청 버튼 (비활성화) -->
                            <button type="button" class="btn btn-action btn-disabled" data-course-id="<%=courseId%>" data-class-id="<%=classId%>" disabled>마감</button>
                        <% } %>
                    </td>
                    <td><%=courseId%></td>
                    <td><%=classEntity.getCourseName()%></td>
                    <td><%=classEntity.getDepartmentName()%></td>
                    <td><%=classEntity.getClassification()%></td>
                    <td><%=classEntity.getCourseSemester()%></td>
                    <td><%=classEntity.getCredit()%></td>
                    <td><%=classEntity.getProfessorName()%> 교수</td>
                    <td><%=classEntity.getRoomNo()%></td>
                    <td><%=classEntity.getDayOfWeek()%> <%=classEntity.getStartTime()%> ~ <%=classEntity.getEndTime()%></td>
                    <td><%=classEntity.getCapacity()%></td>
                    <td><%=classEntity.getEnrolled()%></td>
                    <td><%=classEntity.getIsRetake() ? "예" : "아니오"%></td>
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
    
    <!-- 장바구니 강의 목록 -->
    <div id="cartTableContainer" class="tab-content" data-tab="cartList">
        <table id="cartTable">
            <thead>
                <tr>
                    <th>신청</th>
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
                    List<Classes> cartList = (List<Classes>) request.getAttribute("cartList");

                    if (cartList != null && !cartList.isEmpty()) {
                        for (Classes classEntity : cartList) {
                            int courseId = classEntity.getCourseId();
                            int classId = classEntity.getClassId();
                %>
                <tr>
                    <td>
                        <% if (enrolledCourses.containsKey(courseId) && enrolledCourses.get(courseId) == classId) { %>
                            <!-- 신청 완료된 강주의 신청 버튼 (비활성화) -->
                            <button type="button" class="btn btn-action btn-disabled" data-course-id="<%=courseId%>" data-class-id="<%=classId%>" disabled>신청 완료</button>
                        <% } else if (classEntity.getEnrolled() < classEntity.getCapacity()) { %>
                            <!-- 신청 가능한 강주의 신청 버튼 -->
                            <button type="button" class="btn btn-action" data-course-id="<%=courseId%>" data-class-id="<%=classId%>">신청</button>
                        <% } else { %>
                            <!-- 마감된 강주의 신청 버튼 (비활성화) -->
                            <button type="button" class="btn btn-action btn-disabled" data-course-id="<%=courseId%>" data-class-id="<%=classId%>" disabled>마감</button>
                        <% } %>
                    </td>
                    <td><%=courseId%></td>
                    <td><%=classEntity.getCourseName()%></td>
                    <td><%=classEntity.getDepartmentName()%></td>
                    <td><%=classEntity.getClassification()%></td>
                    <td><%=classEntity.getCourseSemester()%></td>
                    <td><%=classEntity.getCredit()%></td>
                    <td><%=classEntity.getProfessorName()%> 교수</td>
                    <td><%=classEntity.getRoomNo()%></td>
                    <td><%=classEntity.getDayOfWeek()%> <%=classEntity.getStartTime()%> ~ <%=classEntity.getEndTime()%></td>
                    <td><%=classEntity.getCapacity()%></td>
                    <td><%=classEntity.getEnrolled()%></td>
                    <td><%=classEntity.getIsRetake() ? "예" : "아니오"%></td>
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
    
    <!-- 관심 강의 목록 -->
    <div id="wishTableContainer" class="tab-content" data-tab="wishList">
        <table id="wishTable">
            <thead>
                <tr>
                    <th>신청</th>
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
                    List<Classes> wishList = (List<Classes>) request.getAttribute("wishList");

                    if (wishList != null && !wishList.isEmpty()) {
                        for (Classes classEntity : wishList) {
                            int classId = classEntity.getClassId();
                            int courseId = classEntity.getCourseId();
                %>
                <tr>
                    <td>
                        <% if (enrolledCourses.containsKey(courseId) && enrolledCourses.get(courseId) == classId) { %>
                            <!-- 신청 완료된 강주의 신청 버튼 (비활성화) -->
                            <button type="button" class="btn btn-action btn-disabled" data-course-id="<%=courseId%>" data-class-id="<%=classId%>" disabled>신청 완료</button>
                        <% } else if (classEntity.getEnrolled() < classEntity.getCapacity()) { %>
                            <!-- 신청 가능한 강주의 신청 버튼 -->
                            <button type="button" class="btn btn-action" data-course-id="<%=courseId%>" data-class-id="<%=classId%>">신청</button>
                        <% } else { %>
                            <!-- 마감된 강주의 신청 버튼 (비활성화) -->
                            <button type="button" class="btn btn-action btn-disabled" data-course-id="<%=courseId%>" data-class-id="<%=classId%>" disabled>마감</button>
                        <% } %>
                    </td>
                    <td><%=courseId%></td>
                    <td><%=classEntity.getCourseName()%></td>
                    <td><%=classEntity.getDepartmentName()%></td>
                    <td><%=classEntity.getClassification()%></td>
                    <td><%=classEntity.getCourseSemester()%></td>
                    <td><%=classEntity.getCredit()%></td>
                    <td><%=classEntity.getProfessorName()%> 교수</td>
                    <td><%=classEntity.getRoomNo()%></td>
                    <td><%=classEntity.getDayOfWeek()%> <%=classEntity.getStartTime()%> ~ <%=classEntity.getEndTime()%></td>
                    <td><%=classEntity.getCapacity()%></td>
                    <td><%=classEntity.getEnrolled()%></td>
                    <td><%=classEntity.getIsRetake() ? "예" : "아니오"%></td>
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
    <h2 style="text-align: center; margin-top: 40px;">신청된 강의</h2>
    <table id="enrolledTable">
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
                <th>재수강 여부</th>
                <th>정원</th>
                <th>신청 인원</th>
            </tr>
        </thead>
        <tbody>
            <%
                if (enrolledCourses != null && !enrolledCourses.isEmpty()) {
                    for (Map.Entry<Integer, Integer> entry : enrolledCourses.entrySet()) {
                        int courseId = entry.getKey();
                        int classId = entry.getValue();
                        Classes enrolledClass = null;

                        // enrolledCourses는 courseId와 classId의 맵
                        for (Classes classEntity : allClasses) {
                            if (classEntity.getCourseId() == courseId && classEntity.getClassId() == classId) {
                                enrolledClass = classEntity;
                                break;
                            }
                        }

                        if (enrolledClass != null) {
            %>
            <tr id="enrolled-row-<%=enrolledClass.getClassId()%>">
                <td>
                    <!-- 삭제 버튼 -->
                    <button type="button" class="btn btn-delete btn-action" data-course-id="<%=enrolledClass.getCourseId()%>" data-class-id="<%=enrolledClass.getClassId()%>">삭제</button>
                </td>
                <td><%=enrolledClass.getCourseId()%></td>
                <td><%=enrolledClass.getCourseName()%></td>
                <td><%=enrolledClass.getDepartmentName()%></td>
                <td><%=enrolledClass.getClassification()%></td>
                <td><%=enrolledClass.getCourseSemester()%></td>
                <td><%=enrolledClass.getCredit()%></td>
                <td><%=enrolledClass.getProfessorName()%> 교수</td>
                <td><%=enrolledClass.getRoomNo()%></td>
                <td><%=enrolledClass.getDayOfWeek()%> <%=enrolledClass.getStartTime()%> ~ <%=enrolledClass.getEndTime()%></td>
                <td><%=enrolledClass.getIsRetake() ? "예" : "아니오" %></td>
                <td><%=enrolledClass.getCapacity()%></td>
                <td><%=enrolledClass.getEnrolled()%></td>
            </tr>
            <%
                        }
                    }
                } else {
            %>
            <tr>
                <td colspan="13">신청된 강의가 없습니다.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    </div>
</body>
</html>
