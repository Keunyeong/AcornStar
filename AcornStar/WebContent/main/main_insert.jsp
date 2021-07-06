<%@page import="test.feed.dao.MainFeedDao"%>
<%@page import="test.feed.dto.MainFeedDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
// 한글이 깨지지 않도록 encoding
request.setCharacterEncoding("utf-8");

// session scope 에 전달되는 id data를 받아서 writer에 넣어줌
String writer=(String)session.getAttribute("id");

// content parameter로 전달되는 data를 받아옴.
String content=request.getParameter("content");
String tag=request.getParameter("tag");
String image=request.getParameter("image");

// dto에 넣고
MainFeedDto dto=new MainFeedDto();
dto.setWriter(writer);
dto.setContent(content);
dto.setTag(tag);
dto.setImage(image);

// 추가
boolean isSuccess=MainFeedDao.getInstance().insert(dto);

// 응답
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/main/insert.jsp</title>
</head>
<body>
	<script>
		<%if(isSuccess){%>
			alert("성공적으로 글을 작성하였습니다.");
			location.href="${pageContext.request.contextPath}/main/main.jsp";
		<%} else {%>
			alert("글 작성에 실패하였습니다. 다시 작성해주세요.");
			location.href="${pageContext.request.contextPath}/main/main.jsp";
		<%} %>
	</script>
</body>
</html>