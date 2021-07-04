<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// session scope에서 id parameter에 저장된 기록 없애기
	session.removeAttribute("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>user/logout.jsp</title>
</head>
<body>
	<script>
		alert("성공적으로 로그아웃했습니다.");
		location.href="${pageContext.request.contextPath}/index.jsp";
	</script>
</body>
</html>