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
	if(dbList==null){
  		dbList="0";
    }
	String[] array=dbList.split(",");
	boolean check=Arrays.asList(array).contains(str_num);
	//System.out.println(array[0]);
	//System.out.println(result);
	boolean beSuccess=false;
	boolean beUp=false;
	
	MusicFeedDto dto2=MusicFeedDao.getInstance().getData(num);
	int upCount=dto2.getUpCount();
	
	if(check){
		beSuccess=false;
	} else {
		List<String> upList=new ArrayList<>();
		for(int i=0; i<array.length; i++){
			upList.add(array[i]);
		}
		upList.add(str_num);
		String list=String.join(",", upList);
		//System.out.println(list);
		UsersDto dto=new UsersDto();
		dto.setId(id);
		dto.setUplist(list);
		
		beSuccess=UsersDao.getInstance().addUpList(dto);
		beUp=MusicFeedDao.getInstance().up(num);
		
		dto2=MusicFeedDao.getInstance().getData(num);
		upCount=dto2.getUpCount();
	}
%>
{"beSuccess":<%=beSuccess%>, "beUp":<%=beUp%>, "upCount":<%=upCount%>}