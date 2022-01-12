<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 회원가입 페이지 -->
<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>

<!-- header.jsp include 처리 -->
<%@ include file="../views/includes/header.jsp" %>

<div class="container">
	<div class="row">
		<div class="col-md-4 col-md-offset-4">
			<div class="login-panel panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">회원가입</h3>
				</div>
				<div class="panel-body">
					<form role="form" method='post' action="/memberJoin">
						<fieldset>
							<div class="form-group">
								<label>아이디</label><input id="inputId" class="form-control" type="text" name="memberId">
							</div>
							<div class="form-group">
								<label>비밀번호</label><input class="form-control" type="password" name="pw">
							</div>
							<div class="form-group">
								<label>비밀번호 재입력</label><input class="form-control" type="password" name="pwRe">
							</div>
							<div class="form-group">
								<label>이름</label><input class="form-control" type="text" name="memberName">
							</div>
							<div class="form-group">
								<label>휴대폰 번호</label><input class="form-control" type="text" name="phone">
							</div>
							<hr>
							<button id="joinBtn" type="submit" class="btn btn-lg btn-info btn-block">가입</button>
							<button type="reset" class="btn btn-lg btn-default btn-block">다시 쓰기</button>
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
	var checkId = RegExp(/^[a-z0-9]{5,15}$/);							//아이디 검사(영문, 숫자, 5~15자)
	var checkPw = RegExp(/(?=.*[a-zA-ZS])(?=.*?[#?!@$%^&*-]).{8,24}/);	//패스워드 검사(문자와 특수문자 조합, 8~24자)
	var checkName = RegExp(/^[가-힣]{1,20}$/);							//이름 검사(한글, 1~20자)
	var checkPhone = RegExp(/^[a-z0-9]{11,12}$/);						//핸드폰 번호 검사(숫자, 11~12자)
	
	
	//가입 버튼 클릭시 이벤트 처리
	$("#joinBtn").on("click", function(e) {
		
		e.preventDefault();
		
		var inputMemberId = formObj.find("input[name='memberId']").val();
		var inputPw = formObj.find("input[name='pw']").val();
		var inputPwRe = formObj.find("input[name='pwRe']").val();
		var inputMemberName = formObj.find("input[name='memberName']").val();
		var inputPhone = formObj.find("input[name='phone']").val();
		
		
		if(!checkId.test(inputMemberId)) {
			alert("아이디를 5~15자로 입력해주세요.(영문, 숫자만 입력)");
			formObj.find("input[name='memberId']").focus();
			return false;
		}
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
		if(!checkName.test(inputMemberName)) {
			alert("이름을 한글로만 입력해주세요.");
			formObj.find("input[name='memberName']").focus();
			return false;
		}
		if(!checkPhone.test(inputPhone)) {
			alert("휴대폰 번호를 숫자로만 입력해주세요.");
			formObj.find("input[name='phone']").focus();
			return false;
		}
		
		formObj.submit();
	});
});
</script>

<!-- footer.jsp include 처리 -->
<%@ include file="../views/includes/footer.jsp" %>