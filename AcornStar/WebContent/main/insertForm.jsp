<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/main/insertForm.jsp</title>
</head>
<body>
	<h1>새 글을 작성하는 form</h1>
	<div class="container">
		<form action="insert.jsp" method="post">
			<div>
				<label for="content">내용</label>
				<textarea name="content" id="content"></textarea>
				<button type="submit">등록</button>
			</div>
		</form>
	</div>
</body>
</html>