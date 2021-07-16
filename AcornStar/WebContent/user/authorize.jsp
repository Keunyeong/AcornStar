<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	String id = request.getParameter("id");
    String authority = request.getParameter("auth");
    UsersDto dto = new UsersDto();
    dto.setId(id);
    dto.setAutority(authority);
    boolean isSuccess = UsersDao.getInstance().update(dto);
%>    
{"isSuccess":<%=isSuccess%>}