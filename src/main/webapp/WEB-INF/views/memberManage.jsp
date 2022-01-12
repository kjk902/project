<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 회원 목록 조회 페이지 -->
<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>	<!-- JSTL core 태그라이브러리 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>	<!-- JSTL format 태그라이브러리 -->
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>	<!-- 스프링 시큐리티 태그라이브러리 -->

<!-- header.jsp include 처리 -->
<%@ include file="../views/includes/header.jsp" %>

<!-- 게시판 제목 시작 -->
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">회원 목록</h1>
	</div>
</div>
<!-- 게시판 제목 끝 -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-info">
			<!-- 게시글 등록 버튼 -->
			<div class="panel-heading">회원 목록</div>
			<div class="panel-body">
				<!-- 게시판 테이블 시작 -->
				<table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">
					<thead>
						<tr>
							<th>아이디</th>
							<th>이름</th>
							<th>핸드폰 번호</th>
							<th>가입일</th>
						</tr>
					</thead>
					
					<!-- MemberController의 addAttribute로 지정한 "list" -->
					<c:forEach items="${memberList }" var="member">
						<tr>
							<td><c:out value="${member.memberId }"/></td>		
							<td><c:out value="${member.memberName }"/></td>
							<td><c:out value="${member.phone }"/></td>		
							<td><fmt:formatDate pattern="yyyy/MM/dd" value="${member.joinDate }"/></td>
						</tr>
					</c:forEach>
						
				</table>
				<!-- 게시판 테이블 끝 -->
				
				<!-- 게시글 검색 시작 -->
				<div class="row">
					<div class="col-lg-12">
						<form id="searchForm" method="get" action="/memberManage">
							<select name='type'>
								<option value="">-</option>
								<option value="I">아이디</option>
								<option value="N">이름</option>
								<option value="P">휴대폰 번호</option>
							</select>
							<input type="text" name="keyword" placeholder="검색어 입력">
							<input type="hidden" name="pageNum" value="<c:out value='${memberPageMaker.cri.pageNum }' />">
							<input type="hidden" name="amount" value="<c:out value='${memberPageMaker.cri.amount }' />">
							<button class="btn btn-xs">검색</button>
						</form>
					</div>				
				</div>				
				<!-- 게시글 검색 끝 -->
				
				
				<!-- 페이징 시작 -->
				<div class="pageBtn">
					<ul class="pagination">
						<!-- pageMaker는 MemberController에서 PageDTO 클래스를 addAttribute로 지정한 객체 -->
						<!-- 이전(prev) 페이지 -->					
						<!-- 이전 페이지가 존재하면 표시됨 -->
						<c:if test="${memberPageMaker.prev }">
							<li class="paginate_button previous"><a href="<c:out value='${memberPageMaker.startPage - 1 }' />">이전</a>
							</li>
						</c:if>
						<!-- 시작 페이지 번호(startPage)와 끝 번호(endPage) -->	
						<c:forEach var="num" begin="${memberPageMaker.startPage }" end="${memberPageMaker.endPage }">
							<li class="paginate_button ${memberPageMaker.cri.pageNum == num ? 'active' : '' }"><a href="<c:out value='${num }' />"><c:out value='${num }' /></a>
							</li>
						</c:forEach>					
						<!-- 다음(next) 페이지 -->						
						<!-- 다음 페이지가 존재하면 표시됨 -->
						<c:if test="${memberPageMaker.next }">
							<li class="paginate_button next"><a href="<c:out value='${memberPageMaker.endPage + 1 }' />">다음</a>
							</li>
						</c:if>
					</ul>
					
					<!-- <a> 태그의 동작을 별도의 <form> 태그를 이용해서 처리 -->
					<form id="actionForm" method="get" action="/memberManage">
						<input type="hidden" name="pageNum" value="<c:out value='${memberPageMaker.cri.pageNum }' />">
						<input type="hidden" name="amount" value="<c:out value='${memberPageMaker.cri.amount }' />">
						
						<!-- 검색 타입과 키워드를 같이 전달-->
						<input type="hidden" name="type" value="<c:out value='${memberPageMaker.cri.type }' />">
						<input type="hidden" name="keyword" value="<c:out value='${memberPageMaker.cri.keyword }' />">
					</form>
				</div>
				<!-- 페이징 끝 -->
				
			</div>
		</div>
	</div>
</div>

<script>
//목록에서 관리자 아이디 버튼 제거
$(document).ready(function() {
	
	var loginUser = "<sec:authentication property='principal.username'/>"
	var admin = "<c:out value='${member.memberId }'/>";
	
	if(loginUser = admin) {
		
		$("#btnBR").hide();
	}
	
});
</script>




<script>
$(document).ready(function() {
	
	//페이징 actionForm 처리
	var actionForm = $("#actionForm");
	
	$(".paginate_button a").on("click", function(e) {
		
		e.preventDefault();
		
		console.log("click");
		
		//actionForm 태그 내부에서 pageNum이라는 이름의 input 태그의 속성의 값을 href로 가져와서 클릭시 페이지가 이동하게 함
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});	
		
	//검색 버튼 이벤트 처리
	var searchForm = $("#searchForm");
	
	$("#searchForm button").on("click", function(e) {
		
		//검색 종류 미선택시 알림
		if(!searchForm.find("option:selected").val()) {	//option이 selected되지 않아서 값이 null이면
			alert("검색종류를 선택하세요.");
			return false;
		}
		
		//검색 종류 미선택시 알림
		if(!searchForm.find("input[name='keyword']").val()) { //keyword라는 이름의 input 태그의 값이 null이면
			alert("검색 키워드를 입력하세요.");
			return false;
		}
		
		//페이지 번호를 1로 설정
		searchForm.find("input[name='pageNum']").val("1");	//pageNum이라는 이름의 input 태그의 값을 "1"로 지정
		
		//기존 searchForm 태그의 버튼 동작을 막음
		e.preventDefault();
		searchForm.submit();
	});	
	
	
	//회원 계정 블락/복구 처리
	$("#btnBR").on("click",function(e) {
		
		e.preventDefault();
		
		//클릭시 get방식으로 memberId 전달
		
		
		
		
	});
	
	
	
	
	
	
});
</script>


<!-- footer.jsp include 처리 -->
<%@ include file="../views/includes/footer.jsp" %>