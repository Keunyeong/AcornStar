<%@page import="test.users.dto.UsersDto"%>
<%@page import="test.users.dao.UsersDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 아이디와 비밀번호 정보를 가져옴
	String id=request.getParameter("id");
	String pwd=request.getParameter("pwd");
	
	// DB와 비교해서
	UsersDto dto=new UsersDto();
	dto.setId(id);
	dto.setPwd(pwd);
	boolean beSuccess=UsersDao.getInstance().isValid(dto);
	
	// 응답
	
%>
{"isSuccess":isSuccess}