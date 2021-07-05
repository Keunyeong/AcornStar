<%@page import="test.feed.dao.FeedDao"%>
<%@page import="test.feed.dto.FeedDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 해당 글 번호에 대한 data를 들고와서
	int num=Integer.parseInt(request.getParameter("num"));
	
	// dto에 넣고 number 정보를 담는다.
	FeedDto dto=new FeedDto();
	dto.setNum(num);
	
	// method를 이용해서 해당 번호에 대한 글을 삭제
	boolean isDeleted=FeedDao.getInstance().delete(dto);
	
	// 응답
	
%>
{"isDeleted":<%=isDeleted %>}