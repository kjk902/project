<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>

<p>페이지 연결중..</p>
<br>
<P>${serverTime}</P>

<!-- 페이지 이동 처리 -->
<script type="text/javascript">
	self.location = "/board/list";
</script>

</body>
</html>
