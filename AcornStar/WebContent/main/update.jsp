<%@page import="test.feed.dto.MainFeedDto"%>
<%@page import="test.feed.dao.MainFeedDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 수정할 게시글의 번호와 내용의 data를 받아와서
	int num=Integer.parseInt(request.getParameter("num"));
	String content=request.getParameter("content");
	String tag=request.getParameter("tag");
	
	// dto에 넣어서
	MainFeedDto dto=new MainFeedDto();
	dto.setNum(num);
	dto.setContent(content);
	dto.setTag(tag);
	
	// method를 이용해서 글 수정을 한 다음
	boolean isUpdated=MainFeedDao.getInstance().update(dto);
	
	// 응답
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/main/update.jsp</title>
</head>
<body>

	<script>
		<%if(isUpdated){%>
			alert("글을 성공적으로 수정했습니다.");
			location.href="${pageContext.request.contextPath}/main/main.jsp";
		<%} else {%>
			alert("글 수정에 실패했습니다. 다시 수정해주세요.");
			location.href="${pageContext.request.contextPath}/main/main.jsp";
		<%}%>
	</script>

</body>
</html>