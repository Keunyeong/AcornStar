<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//폼 전송되는 가입할 회원의 정보를 읽어온다.
	String id=request.getParameter("id");
	String pwd=request.getParameter("pwd");
	String email=request.getParameter("email");
	//UsersDto 객체에 회원의 정보를 담고
	UsersDto dto=new UsersDto();
	dto.setId(id);
	dto.setPwd(pwd);
	dto.setEmail(email);
	//UsersDao 객체를 이용해서 DB 에 저장한다.
	boolean isSuccess=UsersDao.getInstance().insert(dto);
	//응답하기 
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/signup.jsp</title>
</head>
<body>
<div class="container">
	<%if(isSuccess){ %>
		<p> 
			<strong><%=id %></strong> 회원님 가입 되었습니다.
			<a href="../index.jsp">로그인 하러가기</a>
		</p>
	<%}else{ %>
		<p>
			가입 실패!
			<a href="../index.jsp">다시 작성하러 가기</a>
		</p>
	<%} %>
</div>	
</body>
</html>







