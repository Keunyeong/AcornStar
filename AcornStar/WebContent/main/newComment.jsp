<%@page import="test.feed.dto.FeedDto"%>
<%@page import="test.feed.dao.FeedDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// session scope 에 전달되는 id data를 받아서 writer에 넣어줌
	String writer=(String)session.getAttribute("id");
	
	// content parameter로 전달되는 data를 받아옴.
	String content=request.getParameter("content");
	System.out.println(content);
	
	// dto에 넣고
	FeedDto dto=new FeedDto();
	dto.setWriter(writer);
	dto.setContent(content);
	
	// 추가
	boolean isSuccess=FeedDao.getInstance().insert(dto);
	
	// 응답
		
%>
{"isSuccess":<%=isSuccess %>}