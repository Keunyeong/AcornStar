<%@page import="test.users.dao.UsersDao"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String id=(String)session.getAttribute("id");
	int num=Integer.parseInt(request.getParameter("num"));
	
	List<Integer> upList=new ArrayList<>();
	upList.add(num);
	
	//boolean beSuccess=UsersDao.getInstance().insertUpList();
	
	boolean beUp=MusicFeedDao.getInstance().up(num);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>