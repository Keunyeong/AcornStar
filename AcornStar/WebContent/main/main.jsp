<%@page import="test.feed.dto.FeedDto"%>
<%@page import="java.util.List"%>
<%@page import="test.feed.dao.FeedDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// method를 이용, DB에서 data를 불러온다.
	List<FeedDto> list=FeedDao.getInstance().getList();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
	<h1>로그인 후 main page 입니다.</h1>
	<a href="${pageContext.request.contextPath}/user/logout.jsp">로그아웃</a>
	<div class="container">
		<form action="">
			<button type="button" class="btn" style="color: #6610f2" data-bs-toggle="modal" data-bs-target="#writeModal">
        		새 글 작성
      		</button>
		</form>
	</div>
	
	<div id="feed" class="container">
		<ul>
			<%for(FeedDto tmp:list){%>
				<li>
					<%=tmp.getContent() %>
				</li>
			<%} %>
		</ul>
	</div>
	
	<!-- Modal -->
	<div class="modal fade" id="writeModal" tabindex="-1" aria-labelledby="writeModalLabel" aria-hidden="true">
	  	<div class="modal-dialog">
	    	<div class="modal-content">
	      		<div class="modal-header">
	        		<h5 class="modal-title" id="writeModalLabel">새 글 작성하기</h5>
	        		<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      		</div>
		      	<div class="modal-body">
		        	<form action="${pageContext.request.contextPath}/main/newComment.jsp" method="post" id="insertForm" class="row">		    
			      		<div class="container">
	      					<textarea name="content" id="content"></textarea>
	      				</div>
			      		<div class="col-12">
				    		<button class="btn btn-primary mt-2 float-end" type="submit">새 글 등록</button>
				  		</div>
			   		</form>
		      	</div>
	    	</div>
	  	</div>
	</div>
	
	<script>
		document.querySelector("#insertForm").addEventListener("submit", function(e){
			e.preventDefault();
			ajaxFormPromise(this)
			.then(function(response){
				return response.json();
			}).then(function(data){
				if(data.isSuccess){
					alert("새 글을 성공적으로 등록했습니다.");
					location.href="${pageContext.request.contextPath}/main/main.jsp"
				} else {
					alert("새 글 등록에 실패했습니다. 다시 작성해주세요.");
					location.href="${pageContext.request.contextPath}/main/main.jsp"
				}
			});
			
		});
	</script>
</body>
</html>