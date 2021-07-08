<%@page import="test.musicfeed.dao.MusicCommentDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 해당 댓글의 번호를 불러와서
	int num=Integer.parseInt(request.getParameter("num"));

	// method를 이용하여 삭제
	boolean beDeleted=MusicCommentDao.getInstance().delete(num);
%>
{"beDeleted":<%=beDeleted %>}