<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 게시판 게시글 수정 페이지 -->
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

	.uploadResult {
		width: 100%;
		background-color: gray;
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
		<h1 class="page-header">게시글 수정</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-yellow">
			<div class="panel-heading">게시글 수정</div>
			<div class="panel-body">
					<!-- 게시글 수정 form -->
					<form role="form" method="post" action="/board/modify">
						<!-- 게시글을 읽기만 하기 때문에 readonly 속성 지정 -->				
						<!-- 작성자 수정 불가 -->
						<div class="form-group">
							<label>작성자</label><input class="form-control" name="writer" readonly="readonly" value="<c:out value='${board.writer }'/>">
						</div>
						<!-- 작성일 수정 불가 -->
						<div class="form-group">
							<label>작성일</label><input class="form-control" name="regDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy/MM/dd hh:mm:ss" value="${board.regDate }"/>'>
						</div>
						<!-- 수정일 직접 수정 불가 -->
						<div class="form-group">
							<label>수정일</label><input class="form-control" name="updateDate" readonly="readonly" value='<fmt:formatDate pattern="yyyy/MM/dd hh:mm:ss" value="${board.updateDate }"/>'>
						</div>
						<!-- 글 번호 수정 불가 -->
						<div class="form-group">
							<label>글 번호</label><input class="form-control" readonly="readonly" name="bno" value="<c:out value='${board.bno }'/>">
						</div>				
						<div class="form-group">
							<label>글 제목</label><input class="form-control" name="title" value="<c:out value='${board.title }'/>">
						</div>				
						<div class="form-group">
							<label>글 내용</label><textarea class="form-control" rows="3" name="content"><c:out value='${board.content }'/></textarea>
						</div>				
						
						<!-- 로그인한 사용자가 게시글의 작성자인 경우에만 수정/삭제(관리자인 경우 삭제만 가능) -->
						<sec:authentication property="principal" var="pinfo"/>
						<sec:authorize access="isAuthenticated()">
							<c:choose>
								<c:when test="${pinfo.username eq board.writer }">
									<!-- 수정 버튼 -->
									<button type="submit" data-oper="modify" class="btn btn-success">수정</button>
									
									<!-- 삭제 버튼 -->				
									<button type="submit" data-oper="remove" class="btn btn-danger pull-right">삭제</button>
								</c:when>
								<c:when test="${pinfo.username eq 'admin' }">
									<!-- 삭제 버튼 -->	
									<button type="submit" data-oper="remove" class="btn btn-danger pull-right">삭제</button>
								</c:when>
							</c:choose>
						</sec:authorize>
						
						<!-- 목록 버튼 -->				
						<input id="backBtn" type="button" class="btn btn-warning" value="취소">
						<button type="submit" data-oper="list" class="btn btn-default">목록</button>
						
						<!-- 수정과 삭제 시 페이지 번호 유지(form태그 전송에 pageNum과 amount를 포함) -->
						<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum }' />">
						<input type="hidden" name="amount" value="<c:out value='${cri.amount }' />">
						
						<!-- 수정/삭제 페이지에 진입했을 때에도 검색 조건과 키워드 유지 -->
						<input type="hidden" name="type" value="<c:out value='${cri.type }' />">
						<input type="hidden" name="keyword" value="<c:out value='${cri.keyword }' />">
						
						<!-- CSRF 토큰 설정 -->
						<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
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
				<!-- 새로운 첨부파일 추가 -->
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>
			
				<div class="uploadResult">
					<ul>
					<!-- 첨부파일 업로드 결과 -->
					</ul>				
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 수정/삭제 버튼 처리 -->
<script type="text/javascript">
$(document).ready(function() {
	
	var formObj = $("form");
	
	//취소 버튼 클릭시 이벤트 처리
	$("#backBtn").on("click", function(e) {
		
		e.preventDefault();
		history.back();
	});
	
	
	//버튼 삭제/목록/수정 버튼 클릭시 이벤트 처리
	$("button").on("click", function(e) {
		
		e.preventDefault();		//<form> 태그 안에 모든 버튼은 기본적으로 submit()으로 처리하기 때문에 기본 동작을 막음	
		
		var operation = $(this).data("oper");
		
		console.log(operation);
		
		// 삭제 처리와 목록 페이지 이동(페이지 번호 유지)
		if(operation == 'remove') {
			formObj.attr("action", "/board/remove");	//<form> 태그의 action 속성값을 remove로 변경
		} else if(operation == "list") {
			formObj.attr("action", "/board/list").attr("method", "get");	//action 속성값을 list로 변경하고 method 속성값을 POST방식에서 GET방식으로 변경
			
			//사용자가 수정(modify)페이지에서 '목록' 버튼을 클릭했을 때 input의 name 속성값이 pageNum과 amount인 태그의 데이터를 복사(clone)해서 보관
			var pageNumTag = $("input[name='pageNum']").clone();
			var amountTag = $("inputp[name='amount']").clone();
			
			//사용자가 수정(modify)페이지에서 '목록' 버튼을 클릭했을 때 input의 name 속성값이 type과 keyword태그의 데이터를 복사(clone)해서 보관			
			var typeTag = $("input[name='type']").clone();
			var keywordTag = $("input[name='keyword']").clone();
			
			formObj.empty();	//아무런 파라미터가 없기 때문에 <form> 태그의 모든 내용은 삭제	
			
			//form태그 내부가 삭제되었기 떄문에 복사(clone)해 둔 pageNum과 amount input태그를 다시 추가
			formObj.append(pageNumTag);
			formObj.append(amountTag);
			
			//form태그 내부가 삭제되었기 떄문에 복사(clone)해 둔 type과 keyword input태그를 다시 추가
			formObj.append(typeTag);
			formObj.append(keywordTag);
			
		} else if (operation == "modify") {
			
			if(!formObj.find("input[name='title']").val() || formObj.find("input[name='title']").val().length > 60) {
				alert("제목을 입력하세요.(60자 이내)");
				formObj.find("input[name='title']").focus();		//title 칸에 자동 포커스
				return false;
			}
			if(!formObj.find("textarea[name='content']").val() || formObj.find("textarea[name='content']").val().length > 1100) {
				alert("내용을 입력하세요.(1100자 이내)");
				formObj.find("textarea[name='content']").focus();	//content 칸에 자동 포커스
				return false;
			}
			
			console.log("submit clicked");
			
			var str = "";
			
			$(".uploadResult ul li").each(function(i, obj) {
				
				var jobj = $(obj);
				
				console.dir(jobj);
				
				//BoardVO에 attachList라는 이름의 변수로 첨부파일의 정보를 수집하기 때문에 name 속성값을 attachList[인덱스번호]의 형태로 작성
				str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
			});
			formObj.append(str).submit();
		}
		
		formObj.submit();
	});
	
	
	//첨부파일 삭제 버튼 이벤트 처리
	$(".uploadResult").on("click", "button", function(e) {	//button 태그가 존재할 경우에만 작동(이벤트 위임)
		
		console.log("delete file");
	
		if(confirm("이 파일을 삭제하시겠습니까?")) { //확인 메세지 확인버튼 클릭시
			var targetLi = $(this).closest("li");	//uploadResult에서 가장 가까운 li태그 지정
			targetLi.remove();
		}
	});
	
	
	//파일의 확장자나 크기의 사전 처리
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;	//5MB
	
	//파일의 확장자와 파일의 크기를 검사하는 함수
	function checkExtension(fileName, fileSize) {
		
		if(fileSize >= maxSize) {	//업로드하려는 파일의 크기가 5MB 이상일 경우
			alert("파일 사이즈 초과");
			return false;
		}
		if(regex.test(fileName)) {	//업로드하려는 파일의 확장자가 exe, sh, zip ,alz인 경우
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		
		return true;
	}
	
	
	//스프링 시큐리티 첨부파일 처리
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";	
	
	//<input type="file">의 내용이 변경되는 것을 감지해서 처리하는 함수
	$("input[type='file']").change(function(e) {
		
		var formData = new FormData();	//※Ajax를 이용하는 파일 업로드에서의 FormData는 가상의 <form> 태그로 필요한 파라미터를 담아서 전송하는 방식
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		
		//add File Data to formData
		for(var i=0; i<files.length; i++) {
			
			//파일의 확장자와 크기를 검사
			if(!checkExtension(files[i].name, files[i].size)) {
				return false;
			}
			formData.append("uploadFile", files[i]);	//formData를 이용하여 uploadFile에 파일들을 추가함		
		}
		
		$.ajax({
			url: "/uploadAjaxAction",
			processData: false,		//processDate는 반드시 false로 지정해야만 첨부파일 데이터를 전송할 수 있음
			contentType: false,		//contentType은 반드시 false로 지정해야만 첨부파일 데이터를 전송할 수 있음
			
			//스프링 시큐리티 처리
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			
			data: formData,
			type: "POST",
			dataType: "json",		//결과 타입을 json으로 변경
			success: function(result) {
				console.log(result);
				
				showUploadResult(result);	//업로드 결과 처리 함수
			}
		});
	});
	
	
	//업로드된 결과를 화면에 섬네일 등을 만들어서 처리
	function showUploadResult(uploadResultArr) {
		
		if(!uploadResultArr || uploadResultArr.length == 0) {
			return;
		}
		
		var uploadUL = $(".uploadResult ul");
		var str = "";
		
		$(uploadResultArr).each(function(i, obj) {
			
			//image type
			if(obj.image) {
				
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
				
				str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>";
				str += "<span> " + obj.fileName + "</span>";
				str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName=" + fileCallPath + "'>";
				str += "</div></li>";
				
			} else {
				
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "'><div>";
				str += "<span> " + obj.fileName + "</span>";
				str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file'  class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.png'>";
				str += "</div></li>";
			}
		});
		
		uploadUL.append(str);		
	}
	
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
					str += "<span> " + attach.fileName + "</span>";
					str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName=" + fileCallPath + "'></div></li>";				
				} else {	//일반 파일인 경우
					
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
					str += "<span> " + attach.fileName + "</span><br>";
					str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file'  class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
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