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
	String tag=request.getParameter("tag");
	String link=request.getParameter("link");
	if(link.length()<=30){
		link="https://www.youtube.com/embed/"+link.substring(16);
	} else if(link.length()>30){
		link="https://www.youtube.com/embed/"+link.substring(32);
	}

	// dto에 넣고
	MusicFeedDto dto=new MusicFeedDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setContent(content);
	dto.setTag(tag);
	dto.setLink(link);
	System.out.println(writer + title + content + tag + link);
	// 추가
	boolean beInserted=MusicFeedDao.getInstance().insert(dto);
	
	// 응답
%>
{"beInserted":<%=beInserted %>}