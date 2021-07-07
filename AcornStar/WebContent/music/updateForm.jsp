<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@page import="test.musicfeed.dto.MusicFeedDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 전달되는 게시글 번호 data를 받아서
	int num=Integer.parseInt(request.getParameter("num"));

	// dto에 넣고
	MusicFeedDto dto2=new MusicFeedDto();
	dto2.setNum(num);
	
	// method를 이용해서 해당 data를 가져온다.
	MusicFeedDto dto=MusicFeedDao.getInstance().getData(dto2);
%>
{"title":"<%=dto.getTitle() %>", "content":"<%=dto.getContent() %>", "link":"<%=dto.getLink() %>"}