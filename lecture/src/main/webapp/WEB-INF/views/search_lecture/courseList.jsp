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

/* 콘텐츠 영역 스타일 */
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

/* 강의 목록 테이블을 스크롤리로 만들기 위한 스타일 */
#courseTableContainer {
    max-height: 300px; /* 스크롤 목록의 최대 높이 설정 */
    overflow: auto; /* 스크롤로의 평이 발생할 경우 실행 */
    border: 1px solid #ddd;
    margin-bottom: 40px;
}
</style>


<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>

$(document).ready(function() {
    // 필터링 버튼 클릭 시
    $("#filterButton").click(function() {
    	//필터의 value 가져옴
        var selectedDepartment = $("#departmentFilter").val();
        var selectedClassification = $("#classificationFilter").val();

        // "강의 목록" 테이블의 행만 필터링
        $("#courseTable tbody tr").each(function() {
            var deptCell = $(this).find("td:nth-child(4)").text(); // 4번째 컬럼: 학과 이름
            var classCell = $(this).find("td:nth-child(5)").text(); // 5번째 컬럼: 분류

            var showRow = true;
			
            //선택된 학과의 값과 4번째 컬럼(학과이름)의 값이 다르거나
            if (selectedDepartment && deptCell !== selectedDepartment) {
                showRow = false;
            }

            //선택된 분류의 값과 5번째 컬럼(분류)의 값이 다르면 return false;
            if (selectedClassification && classCell !== selectedClassification) {
                showRow = false;
            }

            //showRow가 true면 출력 false면 제거
            if (showRow) {
                $(this).show();
            } else {
                $(this).hide();
            }
        });
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

                    // "강의 목록" 테이블의 신청 인원 업데이트,EnrollAjaxServlet에서 property로 전달한 update인원수를 받아와 html로 응답
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
	
	
       <%@ include file="/WEB-INF/views/sidebar.jsp" %>
   
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
                Integer credits = (Integer) request.getAttribute("currentCredits");//CourseController에서 set currentCredits한 값 받아옴
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
              //학과 id,name으로 매핑되어 있는 departmentMap 불러움 
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
    </div>

    <!-- 전체 강의 목록 -->
    <div id="courseTableContainer">
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
