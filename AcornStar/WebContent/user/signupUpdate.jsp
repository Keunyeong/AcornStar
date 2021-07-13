<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	//폼 전송되는 가입할 회원의 정보를 읽어온다.
	String id=(String)session.getAttribute("id");
	String profile=request.getParameter("profile");
	String email=request.getParameter("email");
	String name=request.getParameter("name");
	String intro=request.getParameter("intro");
	//UsersDto 객체에 회원의 정보를 담고
	UsersDto dto=new UsersDto();
	dto.setId(id);
	dto.setName(name);
	dto.setIntro(intro);
	dto.setProfile(profile);
	dto.setEmail(email);
	//UsersDao 객체를 이용해서 DB 에 저장한다.
	boolean isSuccess=UsersDao.getInstance().update(dto);
	//응답하기 
%>    
{"isSuccess":<%=isSuccess%>}
