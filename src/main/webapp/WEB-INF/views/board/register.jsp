<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 게시판 게시글 등록 페이지 -->
<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>										<!-- '페이지 소스 보기'시에 공백 코드 줄 제거 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>				<!-- JSTL core 태그라이브러리 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>				<!-- JSTL format 태그라이브러리 -->
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>	<!-- 스프링 시큐리티 태그라이브러리 -->

<!-- header.jsp include 처리 -->
<%@ include file="../includes/header.jsp" %>

<!-- 게시판 제목 -->
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 등록</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-primary">
			<div class="panel-heading">게시글 등록</div>
			<div class="panel-body">
				<!-- 게시글 등록 form -->				
				<form role="form" method="post" action="/board/register">				<!-- action 속성을 BoardController의 register로 지정하여 처리 유도 -->
					<div class="form-group">
						<label>글 제목</label><input class="form-control" name="title">
					</div>				
					<div class="form-group">
						<label>글 내용</label><textarea class="form-control" rows="3" name="content"></textarea>
					</div>				
					<div class="form-group">
						<label>작성자</label><input class="form-control" name="writer" readonly="readonly" value="<sec:authentication property='principal.username' />">
					</div>				
					<button id="registBtn" type="submit" class="btn btn-primary">등록</button>				
					<button type="reset" class="btn btn-default">모두 지우기</button>	
					<button id="backBtn" type="submit" class="btn btn-warning pull-right">취소</button>	
					<!-- CSRF 토큰 설정 -->
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }">
				</form>
			</div>
		</div>
	</div>
</div>

<!-- 첨부파일 등록 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-primary">
			<div class="panel-heading">첨부파일 등록</div>
			<div class="panel-body">
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

<!-- jQuery -->
<script type="text/javascript">
$(document).ready(function() {
	
	var formObj = $("form[role='form']");
	
	//등록 버튼 눌렀을 때 제목, 내용, 작성 미입력시 처리
	$("#registBtn").on("click", function(e) {
		
		e.preventDefault();	//기본 submit 동작을 막음
		
		console.log("submit clicked");
	
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
	
		//formObj.submit();
		formObj.append(str).submit();	
	});
	
	
	//취소 버튼 눌렀을 때 뒤로가기 처리
	$("#backBtn").on("click", function(e) {
		e.preventDefault();
		history.back();
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

	
	//첨부파일 삭제 버튼 이벤트 처리
	$(".uploadResult").on("click", "button", function(e) {	//button 태그가 존재할 경우에만 작동(이벤트 위임)
		
		console.log("delete file");
	
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			
			url: "/deleteFile",
			data: {fileName: targetFile, type: type},
			
			//스프링 시큐리티 처리
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			
			dataType: "text",
			type: "POST",
			success: function(result) {
				alert(result);
				targetLi.remove();
			}
		});
	});
});
</script>

<!-- footer.jsp include 처리 -->
<%@ include file="../includes/footer.jsp" %>