<%@page import="test.musicfeed.dto.MusicCommentDto"%>
<%@page import="test.musicfeed.dao.MusicCommentDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 수정하려는 댓글의 번호 정보, 수정된 댓글의 data를 받아서
	int num=Integer.parseInt(request.getParameter("num"));
	String newContent=request.getParameter("commentUpdate");	

	// dto에 넣고
	MusicCommentDto dto=new MusicCommentDto();
	dto.setNum(num);
	dto.setContent(newContent);

	// method를 이용해서 update하고
	boolean beUpdated=MusicCommentDao.getInstance().update(dto);
	
	// 응답
%>
{"beUpdated":<%=beUpdated %>, "newContent":"<%=newContent %>"}