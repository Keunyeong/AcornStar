<%@page import="test.feed.dao.FeedDao"%>
<%@page import="test.feed.dto.FeedDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 수정할 게시글의 번호와 내용의 data를 받아와서
	int num=Integer.parseInt(request.getParameter("num"));
	String content=request.getParameter("content");
	
	// dto에 넣어서
	FeedDto dto=new FeedDto();
	dto.setNum(num);
	dto.setContent(content);
	
	// method를 이용해서 글 수정을 한 다음
	boolean beUpdate=FeedDao.getInstance().update(dto);
	
	// 응답
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/main/update.jsp</title>
</head>
<body>
	<%if(beUpdate){ %>
		<script>
			alert("수정 되었습니다.");
			location.href="../main.jsp?num=<%=dto.getNum()%>";
		</script>
	<%}else{ %>
		<h1>알림</h1>
		<p>
			글 수정을 실패 하였습니다.
			<a href="updateform.jsp?num=<%=dto.getNum()%>">다시 시도</a>
		</p>
	<%} %>
</body>
</html>