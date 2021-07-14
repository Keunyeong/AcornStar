<%@page import="test.musicfeed.dto.MusicFeedDto"%>
<%@page import="java.util.Arrays"%>
<%@page import="test.users.dto.UsersDto"%>
<%@page import="test.users.dao.UsersDao"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	String id=(String)session.getAttribute("id");
	int num=Integer.parseInt(request.getParameter("num"));
	
	String str_num=Integer.toString(num);
	
	String dbList=UsersDao.getInstance().getUpList(id);
	//System.out.println(dbList);
	String[] array=dbList.split(",");
	boolean check=Arrays.asList(array).contains(str_num);
	//System.out.println(array[0]);
	//System.out.println(result);
	boolean beSuccess=false;
	boolean beDown=false;
	
	MusicFeedDto dto2=MusicFeedDao.getInstance().getData(num);
	int upCount=dto2.getUpCount();
	
	if(!check){
		beSuccess=false;
	} else {
		List<String> alist = new ArrayList<String>(Arrays.asList(array));
		alist.remove(str_num);
		//System.out.println(result);
		String list=String.join(",", alist);
		//System.out.println(list);
		UsersDto dto=new UsersDto();
		dto.setId(id);
		dto.setUplist(list);
		
		beSuccess=UsersDao.getInstance().addUpList(dto);
		beDown=MusicFeedDao.getInstance().down(num);
		
		dto2=MusicFeedDao.getInstance().getData(num);
		upCount=dto2.getUpCount();
	}
	
%>
{"beSuccess":<%=beSuccess%>, "beDown":<%=beDown%>, "upCount":<%=upCount%>}