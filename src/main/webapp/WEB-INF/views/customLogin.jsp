<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 로그인 페이지 -->
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
			<div class="login-panel panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title">로그인</h3>
				</div>
				<div class="panel-body">
					<form role="form" method='post' action="/login">
						<fieldset>
							<div class="form-group">
								<input class="form-control" placeholder="아이디" name="username" type="text" autofocus>
							</div>
							<div class="form-group">
								<input class="form-control" placeholder="비밀번호" name="password" type="password" value="">
							</div>
							<div class="checkbox">
								<label> <input name="remember" type="checkbox" value="Remember Me">자동 로그인
								</label>
							</div>
							
							<a href="index.html" class="btn btn-lg btn-success btn-block">로그인</a>
						</fieldset>
						<br>
						<fieldset>
							<a href="/join" class="btn btn-lg btn-default btn-block">회원가입</a>
						</fieldset>
						<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }">
					</form>
				</div>
			</div>
		</div>
	</div>
</div>

<script>
$(document).ready(function () {

	var formObj = $("form[role='form']");
	
	//로그인 버튼 클릭시 이벤트 처리
	$(".btn-success").on("click", function(e) {
		
		e.preventDefault();
		
		//!formObj.find("input[name='title']").val()
		if(!$("input[name='username']").val()) {
			alert("아이디를 입력해주세요.");
			return false;
		}
		if(!$("input[name='password']").val()) {
			alert("비밀번호를 입력해주세요.");
			return false;
		}
		
		$("form").submit();
	});
});
</script>

<!-- footer.jsp include 처리 -->
<%@ include file="../views/includes/footer.jsp" %>