<%@page import="test.suggest.dao.SuggestDao"%>
<%@page import="test.suggest.dto.SuggestDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인된 아이디를 session 영역에서 얻어내기
	String writer=(String)session.getAttribute("writer");

	//1. 폼 전송되는 글제목과 내용을 읽어와서
	String title=request.getParameter("title");
	String content=request.getParameter("content");
	String regdate=request.getParameter("regdate");
	
	//2. DB 에 저장하고
	SuggestDto dto=new SuggestDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setContent(content);
	dto.setRegdate(regdate);
	
	boolean isSuccess=SuggestDao.getInstance().insert(dto);
	//3. 응답하기 
%>    
{"isSuccess":<%=isSuccess %>};
