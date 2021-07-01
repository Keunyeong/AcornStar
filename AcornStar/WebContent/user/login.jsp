<%@page import="java.net.URLEncoder"%>
<%@page import="test.users.dto.UsersDto"%>
<%@page import="test.users.dao.UsersDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%

	//1. 폼 전송되는 아이디와 비밀번호를 읽어온다.
	String id=request.getParameter("loginId");
	String pwd=request.getParameter("loginPwd");
	UsersDto dto=new UsersDto();
	dto.setId(id);
	dto.setPwd(pwd);
	//2. DB 에 실제로 존재하는 정보인지 확인한다.
	boolean isValid=UsersDao.getInstance().isValid(dto);
	//3. 유효한 정보이면 로그인 처리를 하고 응답, 그렇지 않다면 아이디 혹은 비밀 번호가 틀렸다고 응답
%>    
{"isValid":<%=isValid %>}
