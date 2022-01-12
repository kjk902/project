<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 회원 정보 조회 페이지 -->
<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- header.jsp include 처리 -->
<%@ include file="../views/includes/header.jsp" %>

<div class="container">
	<div class="row">
		<div class="col-md-4 col-md-offset-4">
			<div class="login-panel panel panel-yellow">
				<div class="panel-heading">
					<h3 class="panel-title">회원정보</h3>
				</div>
				<div class="panel-body">
					<form role="form" method='post' action="/profileModify">
						<fieldset>
							<div class="form-group">
								<label>아이디</label><input class="form-control" type="text" name="memberId" value="<sec:authentication property="principal.username"/>" readonly>
							</div>
							<div class="form-group">
								<label>비밀번호</label><input class="form-control" type="password" name="pw">
							</div>
							<div class="form-group">
								<label>비밀번호 재입력</label><input class="form-control" type="password" name="pwRe">
							</div>
							<div class="form-group">
								<label>이름</label><input class="form-control" type="text" name="memberName" value="<sec:authentication property="principal.member.memberName"/>" readonly>
							</div>
							<div class="form-group">
								<label>휴대폰 번호</label><input class="form-control" type="text" name="phone" value="<sec:authentication property="principal.member.phone"/>">
							</div>
							<hr>
							<button id="modifyBtn" type="submit" class="btn btn-lg btn-warning btn-block">수정</button>
							<button id="backBtn" type="button" class="btn btn-lg btn-default btn-block">뒤로 가기</button>
							<button id="resignBtn" type="submit" class="btn btn-lg btn-danger btn-block">회원 탈퇴</button>
						</fieldset>
						
						<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
$(document).ready(function() {
	
	var formObj = $("form[role='form']");
	
	//정규표현식 유효성검사
	var checkPw = RegExp(/(?=.*[a-zA-ZS])(?=.*?[#?!@$%^&*-]).{8,24}/);	//패스워드 검사(문자와 특수문자 조합, 8~24자)
	var checkName = RegExp(/^[가-힣]{1,20}$/);							//이름 검사(한글, 1~20자)
	var checkPhone = RegExp(/^[a-z0-9]{11,12}$/);						//핸드폰 번호 검사(숫자, 11~12자)
	
	
	//수정 버튼 클릭시 이벤트 처리
	$("#modifyBtn").on("click", function(e) {
		
		e.preventDefault();
		
		var inputPw = formObj.find("input[name='pw']").val();
		var inputPwRe = formObj.find("input[name='pwRe']").val();
		var inputPhone = formObj.find("input[name='phone']").val();
		
	
		if(!checkPw.test(inputPw)) {
			alert("비밀번호를 영문과 특수문자를 포함한 8~24자로 입력해주세요.");
			formObj.find("input[name='pw']").focus();
			return false;
		}
		if(inputPw != inputPwRe) {
			alert("비밀번호를 일치하게 입력해주세요.");
			formObj.find("input[name='pwRe']").focus();
			return false;
		}
		if(!checkPhone.test(inputPhone)) {
			alert("휴대폰 번호를 숫자로만 입력해주세요.");
			formObj.find("input[name='phone']").focus();
			return false;
		}
		
		formObj.submit();
	});
	
	
	//취소 버튼 클릭시 이벤트 처리
	$("#backBtn").on("click", function(e) {
		
		e.preventDefault();
		history.back();
	});
	
	
	//회원탈퇴 버튼 클릭시 이벤트 처리
	$("#resignBtn").on("click", function(e) {
		
		e.preventDefault();
		
		formObj.attr("action", "/resign");
		
		//확인 메시지
		if(!confirm("회원탈퇴를 하시겠습니까?")) {
			return;
		} else {
			alert("회원탈퇴가 완료되었습니다.");
		}
		
		formObj.submit();
	});
});
</script>

<!-- footer.jsp include 처리 -->
<%@ include file="../views/includes/footer.jsp" %>