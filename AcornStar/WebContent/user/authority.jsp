<%@page import="java.util.List"%>
<%@page import="test.users.dto.UsersDto"%>
<%@page import="test.users.dao.UsersDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	List<UsersDto> list = UsersDao.getInstance().getList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<div class="container">
	<table>
		<tr>
			<th>아이디</th>
			<th>이름</th>
			<th>권한</th>
		</tr>
	<%for(UsersDto tmp:list){%>
		<tr>
			<td><%=tmp.getId()%></td>
			<td><%=tmp.getName()%></td>
			<td><%=tmp.getAutority()%></td>
		</tr>
	<%} %>
	</table>
</div>
</body>
</html>