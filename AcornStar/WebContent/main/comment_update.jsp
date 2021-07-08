
<%@page import="test.feed.dao.FeedCommentDao"%>
<%@page import="test.feed.dto.FeedCommentDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//ajax 전송되는 수정할 댓글의 번호와 내용을 읽어온다.
	int num=Integer.parseInt(request.getParameter("num"));
	String content=request.getParameter("content");
	//dto 에 담는다.
	FeedCommentDto dto=new FeedCommentDto();
	dto.setNum(num);
	dto.setContent(content);
	//DB 에 수정 반영한다.
	boolean isSuccess=FeedCommentDao.getInstance().update(dto);
	//json 으로 응답한다. 
%>    
{"isSuccess":<%=isSuccess %>} 