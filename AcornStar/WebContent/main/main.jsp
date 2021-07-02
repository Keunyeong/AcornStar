<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
	<h1>로그인 후 main page 입니다.</h1>
	<div class="container">
		<form action="">
			<button type="button" class="btn" style="color: #6610f2" data-bs-toggle="modal" data-bs-target="#writeModal">
        		새 글 작성
      		</button>
		</form>
	</div>
	<!-- Modal -->
	<div class="modal fade" id="writeModal" tabindex="-1" aria-labelledby="writeModalLabel" aria-hidden="true">
	  	<div class="modal-dialog">
	    	<div class="modal-content">
	      		<div class="modal-header">
	        		<h5 class="modal-title" id="writeModalLabel">새 글 작성하기</h5>
	        		<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      		</div>
	      		<div class="container">
	      			<textarea name="content" id="content"></textarea>
	      		</div>
		      	<div class="modal-body">
		        	<form action="${pageContext.request.contextPath}/main/newComment.jsp" method="post" id="myForm" class="row">		    
			      		<div class="col-12">
				    		<button class="btn btn-primary mt-2 float-end" type="submit">새 글 등록</button>
				  		</div>
			   		</form>
		      	</div>
	    	</div>
	  	</div>
	</div>
</body>
</html>