<%@page import="test.feed.dao.FeedDao"%>
<%@page import="test.feed.dto.FeedDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 수정할 글의 번호를 가져와서
	int num=Integer.parseInt(request.getParameter("num"));

	// method를 이용해서 data를 가져옴
	FeedDto dto=FeedDao.getInstance().getData(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/main/updateForm.jsp</title>
</head>
<body>
	<h1>글 수정 form</h1>
	<div class="container">
		<form action="${pageContext.request.contextPath}/main/update.jsp">
			<div>
				<input type="hidden" name="num" value="<%=dto.getNum()%>"/>
				<label for="content">내용</label>
				<textarea name="content" id="content"><%=dto.getContent() %></textarea>
				<button type="submit">수정</button>
			</div>
		</form>
	</div>
</body>
</html>