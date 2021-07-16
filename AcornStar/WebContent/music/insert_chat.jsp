<%@page import="test.chat.dto.ChatDto"%>
<%@page import="test.chat.dao.ChatDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	String writer=(String)session.getAttribute("id");
	String content=request.getParameter("chat_content");
	
	ChatDto dto=new ChatDto();
	dto.setWriter(writer);
	dto.setContent(content);
	
	boolean beInserted=ChatDao.getInstance().insert(dto);
%>
{"beInserted":<%=beInserted %>}