<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
						<!-- 페이지 상단 include -->
<!-- ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">

<title>JK community</title>

<!-- Bootstrap Core CSS -->
<link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- MetisMenu CSS -->
<link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

<!-- DataTables CSS -->
<link href="/resources/vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">

<!-- DataTables Responsive CSS -->
<link href="/resources/vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">

<!-- Custom CSS -->
<link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

<!-- Custom Fonts -->
<link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
</head>

<body>
	<div id="wrapper">
		<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
			
			<!-- 사이트 이름(클릭시 게시판으로 이동) -->
			<div class="navbar-header">
				<a class="navbar-brand" href="/board/list">JK community</a>
			</div>
			
			<!-- 로그인된 사용자면 로그아웃 표시 -->
			<sec:authorize access="isAuthenticated()">
				<a class="navbar-brand3 logout" href="/customLogout">로그아웃</a>
			</sec:authorize>
			
			<!-- 로그인되지 않은 방문자면 로그인 표시 -->
			<sec:authorize access="isAnonymous()">
				<a class="navbar-brand3" href="/customLogin">로그인</a>
			</sec:authorize>
			
			<!-- 회원 정보 조회 및 수정 -->
			<sec:authorize access="hasRole('ROLE_MEMBER')">
				<a class="navbar-brand3" href="/memberProfile">회원 정보</a>
			</sec:authorize>
			
			<!-- 현재 로그인한 아이디 표시 -->
			<sec:authorize access="isAuthenticated()">
				<span class="navbar-brand3"><sec:authentication property="principal.username"/>님 로그인중</span>
			</sec:authorize>

			<!-- 관리자 전용 메뉴 -->
			<sec:authorize access="hasRole('ROLE_ADMIN')">
				<a class="navbar-brand2" href="/memberManage">회원 조회</a>
			</sec:authorize>
		</nav>
	</div>

<!-- JQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		