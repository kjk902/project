<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 게시판 게시글 조회 페이지 -->
<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>										<!-- '페이지 소스 보기'시에 공백 코드 줄 제거 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>				<!-- JSTL core 태그라이브러리 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>				<!-- JSTL format 태그라이브러리 -->
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>	<!-- 스프링 시큐리티 태그라이브러리 -->

<!-- header.jsp include 처리 -->
<%@ include file="../includes/header.jsp" %>

<!-- 첨부파일 영역 스타일 처리 -->
<style>
	/* 텍스트 줄바꿈 처리 */
	#content {
		white-space: normal;
		word-break:break-word;
		text-overflow: clip;
	}
	.uploadResult {
		width: 100%;
		/*background-color: gray;*/
	}
	.uploadResult ul {
		display: flex;	
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
		align-content: center;
		text-align: center;
	}
	.uploadResult ul li img {
		width: 100px;
	}
	.uploadResult ul li span {
		color: white;
	}
	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background: rgba(255, 255, 255, 0.5);
	}
	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.bigPicture img {
		width: 600px;
	}
</style>


<!-- 게시판 제목 -->
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-info">
			<div class="panel-heading">게시글</div>
			<div class="panel-body">
					<!-- 게시글 조회 -->
					<!-- 게시글을 읽기만 하기 때문에 readonly 속성 지정 -->				
					<label>작성자</label>&nbsp;:&nbsp;<c:out value='${board.writer }'/>&nbsp;&nbsp;&nbsp;
					<label>작성일</label>&nbsp;:&nbsp;<fmt:formatDate pattern="yyyy/MM/dd hh:mm:ss" value="${board.regDate }"/>&nbsp;&nbsp;&nbsp;
					<label>수정일</label>&nbsp;:&nbsp;<fmt:formatDate pattern="yyyy/MM/dd hh:mm:ss" value="${board.updateDate }"/>&nbsp;&nbsp;&nbsp;
					<label>글 번호</label>&nbsp;:&nbsp;<c:out value='${board.bno }'/>
					<hr>
					<label>글 제목</label>&nbsp;:&nbsp;<c:out value='${board.title }'/>
					<hr>
					<p id="content"><c:out value='${board.content }'/></p>
					<br>
					<hr>
					
					<!-- 로그인한 사용자가 게시글의 작성자인 경우에만 수정(관리자인 경우 삭제만 가능) -->		
					<sec:authentication property="principal" var="pinfo"/>
					<sec:authorize access="isAuthenticated()">
						<c:choose>
							<c:when test="${pinfo.username eq board.writer }">
								<!-- 수정 버튼 -->
								<button id="userBtn" data-oper="modify" class="btn btn-success">수정/삭제</button>
							</c:when>
							<c:when test="${pinfo.username eq 'admin' }">
								<!-- 수정 버튼 -->
								<button id="userBtn" data-oper="modify" class="btn btn-success">삭제</button>
							</c:when>
						</c:choose>
					</sec:authorize>
				
					<!-- 목록 버튼 -->				
					<button data-oper="list" class="btn btn-warning">목록</button>
					
					<!-- 바깥에서 form 처리 -->
					<form id="operForm" method="get" action="/board/modify">
						<!-- 수정을 위해 글번호(bno)를 전달 -->
						<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno }"/>'>
						<!-- 조회 페이지에서 다시 목록 페이지로 이동했을 때 페이지 번호 유지 -->						
						<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }"/>'>
						<input type="hidden" name="amount" value='<c:out value="${cri.amount }"/>'>
						
						<!-- 조회 페이지에서 검색 처리 -->
						<input type="hidden" name="type" value='<c:out value="${cri.type }"/>'>
						<input type="hidden" name="keyword" value='<c:out value="${cri.keyword }"/>'>
					</form>
			</div>
		</div>
	</div>
</div>

<!-- 이미지 원본을 보여주기 위한 div -->
<div class="bigPictureWrapper">
	<div class="bigPicture">
	</div>
</div>

<!-- 첨부파일 목록 조회 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">첨부파일</div>
			<div class="panel-body">
				<div class="uploadResult">
					<ul>
					<!-- 첨부파일 업로드 결과 -->
					</ul>				
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 댓글 목록 조회 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>댓글
				<!-- 로그인한 사용자만 댓글 등록 -->
				<sec:authorize access="isAuthenticated()">
					<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>댓글 등록</button>
				</sec:authorize>
			</div>
			<!-- 댓글 목록 -->
			<ul class="chat">
				<li class="left clearfix" data-rno="#">
				</li>
			</ul>
		</div>
		<!-- 댓글 페이지 번호 -->
		<div class="panel-footer"></div>
	</div>
</div>

<!-- 댓글 작성 모달창 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">댓글창</h4>
			</div>
			<div class="modal-body">
				<div id="replyContent" class="form-group">
					<label>댓글</label>
					<input class="form-control" name="reply" value="">
				</div>
				<div class="form-group">
					<label>작성자</label>
					<sec:authorize access="isAuthenticated()">
						<input class="form-control" name="replyer" value="" readonly="readonly">
					</sec:authorize>
				</div>
				<div class="form-group">
					<label>작성일</label>
					<input class="form-control" name="replyDate" value="" readonly="readonly">
				</div>
			</div>
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">수정</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">삭제</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-success">등록</button>
				<button id="modalCloseBtn" type="button" class="btn btn-dismiss">닫기</button>
			</div>
		</div>
	</div>
</div>

<!-- 자바스크립트 모듈 -->
<script type="text/javascript" src="/resources/js/reply.js"></script>



<!-- 자바스크립트 모듈 처리-->
<script type="text/javascript">
$(document).ready(function() {
	
	//수정/목록 버튼 이벤트 처리 관련 변수
	var operForm = $("#operForm");

	//댓글 목록 조회 이벤트 처리 관련 변수
	var bnoValue = "<c:out value='${board.bno }' />";
	var replyUL = $(".chat");
	
	//댓글 작성 이벤트 처리 관련 변수
	var modal = $(".modal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $("#modalModBtn");
	var modalRemoveBtn = $("#modalRemoveBtn");
	var modalRegisterBtn = $("#modalRegisterBtn");
	
	//댓글 페이지 번호 출력 관련 변수
	var pageNum = 1;	//현재 페이지
	var replyPageFooter = $(".panel-footer");
	
	//댓글 스프링 시큐리티 처리 관련 변수(username을 replyer 처리)
	var replyer = null;
	
	<sec:authorize access="isAuthenticated()">
		replyer = "<sec:authentication property='principal.username'/>";
	</sec:authorize>
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";

	
	
	
	//Ajax 스프링 시큐리티 헤더
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	
	//수정 버튼 클릭시 이벤트 처리
	$("button[data-oper='modify']").on("click", function(e) {	
		operForm.attr("action", "/board/modify");
		operForm.submit();
	});
	
	
	//목록 버튼 클릭시 이벤트 처리
	$("button[data-oper='list']").on("click", function(e) {		
		operForm.find("#bno").remove();		//<form>태그 내의 id가 bno인 태그를 지움(목록페이지 이동은 글번호(bno)가 필요하지 않음)
		operForm.attr("action", "/board/list");
		operForm.submit();
	});
	
	
	//댓글 등록 버튼 클릭시 이벤트 처리
	$("#addReplyBtn").on("click", function(e) {
		
		modal.find("input").val("");							//input태그의 value 값을 ""로 지정
		
		modal.find("input[name='replyer']").val(replyer);		//스프링 시큐리티를 이용하여 현재 로그인한 사용자 출력
		
		modalInputReplyDate.closest("div").hide();				//작성일 부분 숨김
		modal.find("button[id != 'modalCloseBtn']").hide();		//닫기 버튼을 제외한 버튼 숨김
		
		modalRegisterBtn.show();		//hide된 등록 버튼 활성화
		
		$(".modal").modal("show");		//모달창 띄움
	});
	
	
	//모달창 닫기 버튼 클릭시 이벤트 처리
	$("#modalCloseBtn").on("click", function(e) {
		
		modal.find("input").val("");	//작성하던 내용 삭제	
		modal.modal("hide");			//모달창 숨김
	});
	
	
	//페이지 번호 클릭시 이벤트 처리
	replyPageFooter.on("click", "li a", function(e) {	//li와 a 태그가 존재할 경우에만 이벤트 처리
		
		e.preventDefault();	//href의 속성값이 for반복문의 i변수로 된 처리를 막음
		console.log("페이지 클릭");
		
		var targetPageNum = $(this).attr("href");	//href 새로 지정
		
		console.log("클릭한 페이지 번호: " + targetPageNum);
		
		pageNum = targetPageNum;	//현재 페이지를 클릭한 페이지로 변경
		showList(pageNum);			//페이지 번호 갱신
	});
	
	
	//댓글 관련====================================================================
	//C
	//댓글의 등록
	modalRegisterBtn.on("click", function(e) {
		
		var reply = {
				reply: modalInputReply.val(),
				replyer: modalInputReplyer.val(),
				bno: bnoValue
		};
		
		
		//댓글 내용 미입력시
		if(!$("#replyContent").find("input[name='reply']").val() || $("#replyContent").find("input[name='reply']").val().length > 300 ) {
			alert("댓글을 300자 이내로 입력하세요.");
			$("#replyContent").find("input[name='reply']").focus();		//reply 칸에 자동 포커스
			return false;
		}
		
		replyService.add(reply, function(result) {
			alert("댓글이 등록되었습니다.");
			
			modal.find("input").val("");	//등록이 완료되면 input 태그의 값들을 비워냄
			modal.modal("hide");			//모달창 숨김
			
			//댓글 목록 갱신
			//showList(1);
			
			//replyService.getList()에서 댓글 개수를 파악하게함
			showList(-1);
		});
	});
	
	
	//R
	//특정 댓글의 조회
	//이벤트 위임(delegation) 방식으로 .on()을 통해 li태그를 파라미터로 받아서 li 태그가 존재할 때만 이벤트 처리하게함
	$(".chat").on("click", "li", function(e) {
		
		
		
		var rno = $(this).data("rno");
		
		replyService.get(rno, function(reply) {
			
			modalInputReply.val(reply.reply);
			modalInputReplyer.val(reply.replyer);
			modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");	//작성일은 수정이 안되도록 readonly 처리
			modal.data("rno", reply.rno);
			
			modal.find("button[id != 'modalCloseBtn']").hide();	//닫기 버튼을 제외한 버튼 숨김
			modalModBtn.show();			//hide된 수정 버튼 활성화
			modalRemoveBtn.show();		//hide된 삭제 버튼 활성화
			
			$(".modal").modal("show");
		});
	});
	
	//자바스크립트 모듈(reply.js)을 이용한 댓글 목록 조회 처리
	function showList(page) {
		
		console.log("댓글 목록 조회" + page);
		
		replyService.getList({ bno: bnoValue, page: page || 1 },
				function(replyCnt, list) {
					
					console.log("댓글 개수: " + replyCnt);
					console.log("댓글 목록: " + list);
			
					//댓글 개수 파악
					if(page == -1) {
						pageNum = Math.ceil(replyCnt / 10.0);	
						showList(pageNum);
						return;
					}
					
					var str = "";
					
					if(list == null || list.length == 0) {
						//replyUL.html("");
						return;
					}
					//반복문을 통해 댓글이 존재하면 <li>태그를 추가하여 댓글이 목록에 추가됨
					//'str +='부분 작성시 한줄에 작성할 것
					for(var i=0, len=list.length || 0; i<len; i++) {
						str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
						str += "<div><div class='header'><strong class='primary-font'>" + list[i].replyer + "</strong>";
						str += "<small class='pull-right text-muted'>" + "작성일시: " + replyService.displayTime(list[i].replyDate) + "</small></div>";
						str += "<p>" + list[i].reply + "</p></div></li>";
					}
					replyUL.html(str);
					
					showReplyPage(replyCnt);
			});
	}
	//댓글 기본 페이지(1번) 호출
	showList(1);
	
	//댓글 페이지 번호 출력
	function showReplyPage(replyCnt) {
		
		var endNum = Math.ceil(pageNum / 10.0) * 10;	//pageNum=1, 0.1의 올림(1) * 10 = 10
		var startNum = endNum - 9;						//시작 페이지 번호 = 10 - 9 = 1
		var prev = startNum != 1;						//이전 페이지는 시작 페이지가 1이 아니면 true
		var next = false;
		
		if(endNum * 10 >= replyCnt) {	//댓글 개수가 100보다 작거나 같으면
			endNum = Math.ceil(replyCnt / 10.0);	//ex.댓글개수 8개면, 끝 페이지 번호 = 8/10(0.8의 올림 1) = 1 
		}
		if(endNum * 10 < replyCnt) {	//댓글 개수가 100보다 크면 다음 페이지 활성
			next = true;
		}
		
		var str = "<ul class='pagination pull-right'>";
		
		if(prev) {
			str += "<li class='page-item'><a class='page-link' href='" + (startNum - 1) + "'>이전</a></li>"
		}		
		
		for(var i = startNum; i <= endNum; i++) {
			var active = pageNum == i ? "active":"";			
			
			str += "<li class='page-item " + active + "'><a class='page-link' href='" + i + "'>" + i + "</a></li>";
		}
		
		if(next) {
			str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>다음</a></li>";
		}
		
		str += "</ul>";
		
		console.log(str);
		replyPageFooter.html(str);	//페이지 하단에 삽입
	}
	
	
	//U
	//댓글의 수정 
	modalModBtn.on("click", function(e) {
		
		//스프링 시큐리티 처리(댓글의 작성자 함께 전송)
		var originalReplyer = modalInputReplyer.val();	
		
		var reply = {
				rno: modal.data("rno"),
				reply: modalInputReply.val(),
				replyer: originalReplyer
		};
		
		
		if(!replyer) {
			alert("로그인후 수정이 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		console.log("Original Replyer: " + originalReplyer);		
		
		if(replyer != originalReplyer) {
			alert("자신이 작성한 댓글만 수정이 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		//댓글 수정 내용을 공백으로 입력시
		if(!$("#replyContent").find("input[name='reply']").val() || $("#replyContent").find("input[name='reply']").val().length > 300) {
			alert("수정할 내용을 입력해주세요.(300자 이내)");
			$("#replyContent").find("input[name='reply']").focus();		//수정할 reply 칸에 자동 포커스 
			return false;
		}
		
		replyService.update(reply, function(result) {
			alert("댓글이 수정되었습니다.");
			modal.modal("hide");
			
			//댓글 목록 갱신
			//showList(1);
			
			//댓글 수정후에도 수정했던 댓글이 있던 페이지를 표시
			showList(pageNum);
		});
	});
	
	
	//D
	//댓글의 삭제 
	modalRemoveBtn.on("click", function(e) {
		
		var rno = modal.data("rno");
		var originalReplyer = modalInputReplyer.val();
		
		//스프링 시큐리티 처리(댓글 번호, 작성자 전송)
		console.log("RNO: " + rno);
		console.log("REPLYER: " + replyer);
		
		if(!replyer) {
			alert("로그인후 삭제가 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		console.log("Original Replyer: " + originalReplyer);	//댓글의 원래 작성자
		
		//작성자와 관리자만 댓글 삭제 가능
		switch(replyer) {
			case originalReplyer: break;
			case "admin": break;
			default : alert("자신이 작성한 댓글만 삭제가 가능합니다.");
						break;
		}
		
		replyService.remove(rno, originalReplyer, function(result) {
			
			alert("댓글이 삭제되었습니다.");
			modal.modal("hide");
			
			//댓글 목록 갱신
			//showList(1);
			
			//댓글 삭제후에도 삭제했던 댓글이 있던 페이지를 표시
			showList(pageNum);
		});
	});
	//댓글 관련====================================================================
		
	
	//첨부 파일관련=================================================================
	//첨부파일 클릭 시 이벤트 처리
	$(".uploadResult").on("click", "li", function(e) {	//li 태그가 존재하는 경우에 작동(이벤트 위임)
		
		console.log("view image");
		
		var liObj = $(this);
		var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
		
		if(liObj.data("type")) {
			showImage(path.replace(new RegExp(/\\/g), "/"));
		} else {
			//download
			self.location = "/download?fileName=" + path;
		}
	});
	
	//원본 이미지를 보여주는 함수
	function showImage(fileCallPath) {
		
		//alert(fileCallPath);
		
		$(".bigPictureWrapper").css("display", "flex").show();
		
		$(".bigPicture").html("<img src='/display?fileName=" + fileCallPath + "'>").animate({width: "100%", height: "100%"}, 1000);
		
	}
	
	//원본 이미지 창 닫기
	$(".bigPictureWrapper").on("click", function(e) {
		
		$(".bigPicture").animate({width: "0%", height: "0%"}, 1000);
		setTimeout(function() {
			$(".bigPictureWrapper").hide();
		}, 1000);
	});
	//첨부 파일관련=================================================================
	
});
</script>

<!-- 첨부파일의 데이터를 즉시 실행 함수로 처리하여 자동적으로 가져옴 -->
<script>
$(document).ready(function() {

	(function() {
		
		var bno = "<c:out value='${board.bno}'/>";
		
		$.getJSON("/board/getAttachList", {bno: bno}, function(arr) {
			
			console.log(arr);
			
			var str = "";
			
			$(arr).each(function(i, attach) {
				
				if(attach.fileType) {	//이미지 파일인 경우
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
					
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
					str += "<img src='/display?fileName=" + fileCallPath + "'></div></li>";				
				} else {	//일반 파일인 경우
					
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
					str += "<span> " + attach.fileName + "</span><br>";
					str += "<img src='/resources/img/attach.png'></div></li>";
				}
			});
			
			$(".uploadResult ul").html(str);
		});
	})();
});
</script>

<!-- footer.jsp include 처리 -->
<%@ include file="../includes/footer.jsp" %>