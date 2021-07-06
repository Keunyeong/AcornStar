<%@page import="test.musicfeed.dto.MusicFeedDto"%>
<%@page import="java.util.List"%>
<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// session scope의 data를 가져온다.
	String id=(String)session.getAttribute("id");
	
	// db music feed data를 불러온다.
	List<MusicFeedDto> list=MusicFeedDao.getInstance().getList();
	
	// 글 하나의 data를 불러온다.
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/music/musicMain.jsp</title>
<style>
	.iframeBox{
		position: relative;
	}
	.iframeBox iframe{
		position: absolute;
		width: 100%;
		height: 100%;
	}
</style>
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
	<div class="container">
		<h1>list page</h1>
		<h2>css 장인님들 navbar 작품 넣을 곳</h2>
		<a href="${pageContext.request.contextPath}/index.jsp">home</a>
		<div>
			<!-- Button trigger modal -->
			<button id="writeBtn" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#insertModal">
			  	새 글 작성
			</button>
		</div>
		
		<!-- 새 글 작성 modal -->
		<div class="modal fade" id="insertModal" tabindex="-1" aria-labelledby="insertModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
				  	<div class="modal-header">
				    	<h5 class="modal-title" id="insertModalLabel">새 글 작성 form</h5>
				  	</div>
				  	<form id="insertForm" method="post" action="${pageContext.request.contextPath}/music/insert.jsp">
					  	<div class="modal-body">
					  		<div>
					  			<label for="title">제목</label>
					  			<input type="text" name="title" id=""/>
					  		</div>
					    	<div>
					    		<label for="content">내용</label>
					    		<textarea name="content" id="content"></textarea>
					    	</div>
					    	<div>
					  			<label for="link">링크</label>
					  			<input type="url" name="link" id=""/>
					  		</div>
					  	</div>
					  	<div class="modal-footer">
					  		<button type="submit">작성</button>
					    	<button id="insertCancelBtn" type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					  	</div>
				  	</form>
				</div>
			</div>
		</div>
		
		<!-- 글 수정 modal -->
		<div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
				  	<div class="modal-header">
				    	<h5 class="modal-title" id="updateModalLabel">새 글 작성 form</h5>
				  	</div>
				  	<form id="updateForm" method="post" action="${pageContext.request.contextPath}/music/update.jsp">
					  	<div class="modal-body">
					  		<input type="hidden" name="num" id="updateNum"/>
					  		<div>
					  			<label for="update_title">제목</label>
					  			<input type="text" name="update_title" id="update_title"/>
					  		</div>
					    	<div>
					    		<label for="update_content">내용</label>
					    		<textarea name="update_content" id="update_content"></textarea>
					    	</div>
					    	<div>
					  			<label for="update_link">링크</label>
					  			<input type="url" name="update_link" id="update_link"/>
					  		</div>
					  	</div>
					  	<div class="modal-footer">
					  		<button type="submit">수정</button>
					    	<button id="updateCancelBtn" type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					  	</div>
				  	</form>
				</div>
			</div>
		</div>
		
		<!-- card 게시글 list -->
		<%for(MusicFeedDto tmp:list) {%>
			<div class="card mb-3" style="max-width: 540px;">
			  	<div class="row g-0">
			    	<div class="col-md-4 iframeBox">
			      		<iframe class="" src="<%=tmp.getLink()%>"></iframe>
			    	</div>
			    	<div class="col-md-8">
			      		<div class="card-body">
			        		<h5 class="card-title"><%=tmp.getTitle() %></h5>
			        		<p class="card-text">작성자 : <%=tmp.getWriter() %></p>
			        		<p class="card-text"><%=tmp.getContent() %></p>
			        		<p class="card-text"><small class="text-muted">to be continued</small></p>
			      		</div>
			      		<a data-num="<%=tmp.getNum() %>" class="comment-link" href="javascript:">댓글</a>
			      		<%if(tmp.getWriter().equals(id)){ %>
				      		<a data-num="<%=tmp.getNum() %>" class="update-link" data-bs-toggle="modal" data-bs-target="#updateModal" href="javascript:">수정</a>
				      		<a data-num="<%=tmp.getNum() %>" class="delete-link" href="javascript:">삭제</a>
			      		<%} %>
			    	</div>
			  	</div>
			</div>
			<!-- card 게시글 댓글 list -->
			<div>
			</div>
			<div>
				<form id="commentForm<%=tmp.getNum() %>" class="comment" style="display:none;" action="insert_comment.jsp" method="post">
					<textarea name="" id=""></textarea>
					<button type="submit">댓글 달기</button>
				</form>
			</div>				
		<%} %>
	</div>
	
	<script>
		// insert modal 에서 글 작성 버튼을 눌렀을 때 작동하는 곳
		document.querySelector("#insertForm").addEventListener("submit", function(e){
			// 일단 form 제출을 막고
			e.preventDefault();
			// ajax로 응답
			ajaxFormPromise(this)
			.then(function(response){
				return response.json();
			}).then(function(data){
				if(data.beInserted){
					alert("글이 성공적으로 작성되었습니다.");
					location.href="${pageContext.request.contextPath}/music/musicMain.jsp"
				} else {
					alert("글 작성에 실패하였습니다. 글을 다시 작성해주세요.");
					document.querySelector("#writeBtn").click();
				}
			});
		});
		
		// 글 삭제 링크를 눌렀을 때 작동하는 곳
		let deleteLinks=document.querySelectorAll(".delete-link");
		for(let i=0; i<deleteLinks.length; i++){
			deleteLinks[i].addEventListener("click", function(e){
				// 링크 이동을 막고
				e.preventDefault();
				
				let num=this.getAttribute("data-num");
				
				// 삭제 여부를 확인하고
				let wantDelete=confirm("정말 이 게시글을 삭제하시겠습니까?");
				// 맞다면 ajax로 응답
				if(wantDelete){
					ajaxPromise("delete.jsp", "post", "num="+num)
					.then(function(response){
						return response.json();
					}).then(function(data){
						if(data.beDeleted){
							alert("게시글을 성공적으로 삭제하였습니다.");
							location.href="${pageContext.request.contextPath}/music/musicMain.jsp"
						} else {
							alert("게시글을 삭제하지 못했습니다.");
							location.href="${pageContext.request.contextPath}/music/musicMain.jsp"
						}
					});
				}
			});
		}
		
		// 글 수정 링크(update modal을 띄운다)를 눌렀을 때 작동하는 곳
		let updateLinks=document.querySelectorAll(".update-link");
		for(let i=0; i<updateLinks.length; i++){
			updateLinks[i].addEventListener("click", function(e){
				// 링크 이동을 막고
				//e.preventDefault();
				
				let num=this.getAttribute("data-num");
				
				//ajax 응답
				ajaxPromise("updateForm.jsp", "post", "num="+num)
				.then(function(response){
					return response.json();
				}).then(function(data){
					// update modal form 수정
					document.querySelector("#updateNum").value=num;
					document.querySelector("#update_title").value=data.title;
					document.querySelector("#update_content").value=data.content;
					document.querySelector("#update_link").value=data.link;
				});
			});	
		}
		
		// update modal에서 글 수정을 눌렀을 때 작동하는 곳
		document.querySelector("#updateForm").addEventListener("submit", function(e){
			// 일단 form 제출을 막고
			e.preventDefault();
			
			// ajax로 응답
			ajaxFormPromise(this)
			.then(function(response){
				return response.json();
			}).then(function(data){
				if(data.beUpdated){
					alert("게시글을 성공적으로 수정하였습니다.");
					location.href="${pageContext.request.contextPath}/music/musicMain.jsp";
				} else {
					alert("게시글을 수정에 실패하였습니다. 다시 수정해주세요.");
					location.href="${pageContext.request.contextPath}/music/musicMain.jsp";
				}
			});
		});
		
		// 댓글 버튼을 눌렀을 때 작동하는 곳
		let commentLinks=document.querySelectorAll(".comment-link");
		for(let i=0; i<commentLinks.length; i++){
			commentLinks[i].addEventListener("click", function(e){
				// 일단 막고
				e.preventDefault();
				
				let num=this.getAttribute("data-num");
				let commentForm=document.querySelector("#commentForm"+num);
				if(commentForm.style.display=="none"){
					commentForm.style.display="block";
				} else if(commentForm.style.display=="block"){
					commentForm.style.display="none";
				}				
			});
		}
		
		// 댓글 달기 버튼을 눌렀을 때 작동하는 곳
		
	</script>
</body>
</html>