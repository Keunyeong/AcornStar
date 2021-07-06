<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@page import="test.musicfeed.dto.MusicFeedDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 삭제하려는 게시물의 number data를 받아서
	int num=Integer.parseInt(request.getParameter("num"));

	// delete method를 이용해서 삭제
	boolean beDeleted=MusicFeedDao.getInstance().delete(num);
	
	// 응답
%>
{"beDeleted":<%=beDeleted %>}