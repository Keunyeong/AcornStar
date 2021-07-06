<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@page import="test.musicfeed.dto.MusicFeedDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// session scope 에 전달되는 id data를 받아서 writer에 넣어줌
	String writer=(String)session.getAttribute("id");
	
	// content parameter로 전달되는 data를 받아옴.
	String title=request.getParameter("title");
	String content=request.getParameter("content");
	String link=request.getParameter("link");
	
	// dto에 넣고
	MusicFeedDto dto=new MusicFeedDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setContent(content);
	dto.setLink(link);
	
	// 추가
	boolean beInserted=MusicFeedDao.getInstance().insert(dto);
	
	// 응답
%>
{"beInserted":<%=beInserted %>}