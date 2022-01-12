<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 게시판 메인 목록 페이지 -->
<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>										<!-- '페이지 소스 보기'시에 공백 코드 줄 제거 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>				<!-- JSTL core 태그라이브러리 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>				<!-- JSTL format 태그라이브러리 -->

<!-- header.jsp include 처리 -->
<%@ include file="../includes/header.jsp" %>

<!-- 게시판 제목 -->
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">자유게시판</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-info">
			<!-- 게시글 등록 버튼 -->
			<div class="panel-heading">게시글 목록
				<button id="regBtn" type="button" class="btn btn-primary btn-xs pull-right">게시글 등록</button>
			</div>
			<div class="panel-body">
				<!-- 게시판 테이블 시작 -->
				<table width="100%" class="table table-striped table-bordered table-hover" id="dataTables-example">
					<thead>
						<tr>
							<th>글번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<!-- <th>수정일</th> -->
							<th>댓글수</th>
						</tr>
					</thead>
					
					<!-- BoardController의 addAttribute로 지정한 "list" -->
					<c:forEach items="${list }" var="board">
						<tr>
							<td><c:out value="${board.bno }"/></td>		
							<!-- 제목을 누르면 해당 게시글을 읽기(해당 페이지 번호 유지) -->
							<td><a class="move" href="<c:out value='${board.bno }'/>"><c:out value="${board.title }"/></a></td>
							<td><c:out value="${board.writer }"/></td>		
							<td><fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate }"/></td>		
							<%-- <td><fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate }"/></td> --%>
							<td><c:out value="${board.replyCnt }" /></td>		
						</tr>
					</c:forEach>
				</table>
				
				<!-- 게시글 검색 -->
				<div class="row">
					<div class="col-lg-12">
						<form id="searchForm" method="get" action="/board/list">
							<select name='type'>
								<option value="">-</option>
								<option value="T">제목</option>
								<option value="C">내용</option>
								<option value="W">작성자</option>
								<option value="TC">제목/내용</option>
								<option value="TW">제목/작성자</option>
								<option value="TWC">제목/작성자/내용</option>
							</select>
							<input type="text" name="keyword" placeholder="검색어 입력">
							<input type="hidden" name="pageNum" value="<c:out value='${pageMaker.cri.pageNum }' />">
							<input type="hidden" name="amount" value="<c:out value='${pageMaker.cri.amount }' />">
							<button class="btn btn-xs">검색</button>
						</form>
					</div>				
				</div>				
				
				<!-- 페이징 -->
				<div class="pageBtn">
					<ul class="pagination">
						<!-- pageMaker는 BoardController에서 PageDTO 클래스를 addAttribute로 지정한 객체 -->
						<!-- 이전(prev) 페이지 -->					
						<!-- 이전 페이지가 존재하면 표시됨 -->
						<c:if test="${pageMaker.prev }">
							<li class="paginate_button previous"><a href="<c:out value='${pageMaker.startPage - 1 }' />">이전</a>
							</li>
						</c:if>
						<!-- 시작 페이지 번호(startPage)와 끝 번호(endPage) -->	
						<c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }">
							<li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' : '' }"><a href="<c:out value='${num }' />"><c:out value='${num }' /></a>
							</li>
						</c:forEach>					
						<!-- 다음(next) 페이지 -->						
						<!-- 다음 페이지가 존재하면 표시됨 -->
						<c:if test="${pageMaker.next }">
							<li class="paginate_button next"><a href="<c:out value='${pageMaker.endPage + 1 }' />">다음</a>
							</li>
						</c:if>
					</ul>
					
					<!-- <a> 태그의 동작을 별도의 <form> 태그를 이용해서 처리 -->
					<form id="actionForm" method="get" action="/board/list">
						<input type="hidden" name="pageNum" value="<c:out value='${pageMaker.cri.pageNum }' />">
						<input type="hidden" name="amount" value="<c:out value='${pageMaker.cri.amount }' />">
						
						<!-- 검색 타입과 키워드를 같이 전달-->
						<input type="hidden" name="type" value="<c:out value='${pageMaker.cri.type }' />">
						<input type="hidden" name="keyword" value="<c:out value='${pageMaker.cri.keyword }' />">
					</form>
				</div>
				
				<!-- 모달창 -->
				<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>					
								<h4 class="modal-title" id="myModalLabel">알림창</h4>
								<div class="modal-body">처리가 완료되었습니다.</div>
								<div class="modal-footer">
									<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
								</div>
							</div>
						</div>
					</div>	
				</div>
				
			</div>
		</div>
	</div>
</div>

<!-- jQeury 처리 -->
<script type="text/javascript">
$(document).ready(function() {
	
	var result = '<c:out value="${result}"/>';	//BoardController에서 addFlashAttribute로 지정한 result
	
	checkModal(result);
	
	
	//모달창 처리(게시물 등록 후 뒤로 가기 시 계속 모달창이 뜨는 문제 해결)
	history.replaceState({}, null, null);
	
	function checkModal(result) {
		if(result == "" || history.state) {	//과거에 등록이 게시글 등록이 완료 되었다면 모달창을 보여줄 필요가 없다.
			return;
		}
		if(parseInt(result) > 0) {
			$(".modal-body").html("게시글 " + parseInt(result) + "번이 등록되었습니다.");	//BoardController에서는 addFlashAttribute로 result를 bno로 지정한다.
		}
		$("#myModal").modal("show");
	}	
	
	//게시글 등록 버튼 처리
	$("#regBtn").on("click", function() {
		self.location = "/board/register";	//	board/register로 이동
	});
	
	
	//페이징 actionForm 처리
	var actionForm = $("#actionForm");
	
	$(".paginate_button a").on("click", function(e) {
		
		e.preventDefault();
		
		console.log("click");
		
		//actionForm 태그 내부에서 pageNum이라는 이름의 input 태그의 속성의 값을 href로 가져와서 클릭시 페이지가 이동하게 함
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});
	
	
	//게시물의 제목(title)을 클릭했을 때 이벤트 처리(조회 페이지(get.jsp)로 이동)
	$(".move").on("click", function(e) {
		
		e.preventDefault();
		
		//게시물 제목 클릭시 hidden 타입의 input 태그를 추가하여 href 속성값을 가져옴
		actionForm.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'> ");
		actionForm.attr("action", "/board/get");	//action 속성을 추가하고 속성값으로 '/board/get'으로 지정하여 조회 페이지로 이동하게 함
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
});
</script>

<!-- footer.jsp include 처리 -->
<%@ include file="../includes/footer.jsp" %>