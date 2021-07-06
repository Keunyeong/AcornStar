<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/myProfile.jsp</title>
</head>
<body>
<div class="container">
	<button id="PFupdate"> 프로필 수정</button>
	<button id="PFdelete">회원탈퇴</button>
	<button id="logout">로그아웃</button>
	<br />
	<button id="info">공지사항</button>
	<button id="suggest">건의사항</button>
</div>
<script>
	document.querySelector("#PFupdate").addEventListener("click",function(){
		location.href="${pageContext.request.contextPath}/user/update_form.jsp";
	});
	document.querySelector("#PFdelete").addEventListener("click",function(){
		location.href="${pageContext.request.contextPath}/user/delete.jsp";
	});
	document.querySelector("#logout").addEventListener("click",function(){
		location.href="${pageContext.request.contextPath}/index.jsp";
	});
	document.querySelector("#info").addEventListener("click",function(){
		location.href="${pageContext.request.contextPath}/info/info.jsp";
	});
	document.querySelector("#suggest").addEventListener("click",function(){
		location.href="${pageContext.request.contextPath}/suggest/suggest.jsp";
	});

</script>
</body>
</html>