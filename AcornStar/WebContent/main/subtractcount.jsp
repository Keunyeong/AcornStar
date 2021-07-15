<%@page import="test.feed.dao.MainFeedDao"%>
<%@page import="test.feed.dto.MainFeedDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num=Integer.parseInt(request.getParameter("num"));
	String upMember = request.getParameter("upmember");
	MainFeedDto dto=new MainFeedDto();
	dto.setNum(num);
	dto.setUpMember(upMember);
	boolean isSuccess = MainFeedDao.getInstance().subtractCount(dto);
%>
{"isSuccess":"<%=isSuccess%>"}