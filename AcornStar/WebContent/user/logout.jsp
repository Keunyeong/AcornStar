<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// session scope에서 id parameter에 저장된 기록 없애기
	session.removeAttribute("id");

	response.sendRedirect("../index.jsp");
%>