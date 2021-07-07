<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@page import="test.musicfeed.dto.MusicFeedDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// updateForm modal에서 넘어오는 data 받기
	int num=Integer.parseInt(request.getParameter("num"));
	String title=request.getParameter("update_title");
	String content=request.getParameter("update_content");
	String link=request.getParameter("update_link");

	// dto에 담아서
	MusicFeedDto dto=new MusicFeedDto();
	dto.setNum(num);
	dto.setTitle(title);
	dto.setContent(content);
	dto.setLink(link);
	
	// method를 이용하여 update
	boolean beUpdated=MusicFeedDao.getInstance().update(dto);
%>
{"beUpdated":<%=beUpdated %>}