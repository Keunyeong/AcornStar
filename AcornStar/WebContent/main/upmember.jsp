<%@page import="test.feed.dao.MainFeedDao"%>
<%@page import="test.feed.dto.MainFeedDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num=Integer.parseInt(request.getParameter("num"));
	MainFeedDto dto=MainFeedDao.getInstance().getData(num);
%>
{"upMember":"<%=dto.getUpMember() %>","num":"<%=num%>"}