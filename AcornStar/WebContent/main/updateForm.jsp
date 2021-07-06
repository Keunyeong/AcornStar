<%@page import="test.feed.dao.MainFeedDao"%>
<%@page import="test.feed.dto.MainFeedDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 수정할 글의 번호를 가져와서
	int num=Integer.parseInt(request.getParameter("num"));

	// method를 이용해서 data를 가져옴
	MainFeedDto dto=MainFeedDao.getInstance().getData(num);
%>
{ "image":"<%=dto.getImage()%>","content":"<%=dto.getContent()%>","tag":"<%=dto.getTag()%>" }