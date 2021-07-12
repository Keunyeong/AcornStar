<%@page import="test.musicfeed.dao.MusicCommentDao"%>
<%@page import="test.musicfeed.dto.MusicCommentDto"%>
<%@page import="test.musicfeed.dto.MusicFeedDto"%>
<%@page import="java.util.List"%>
<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// session scope의 data를 가져온다.
	String id=(String)session.getAttribute("id");
	
	/*
		게시글 paging 처리
	*/

	// 한 페이지에 표시할 게시물 수
	final int page_row_count=5;
	// 하단 페이지를 표시할 수
	final int page_display_count=5;
	
	// 보여줄 페이지의 번호를 초기값으로 1로 지정
	int pageNum=1;
	
	// page 번호가 parameter로 전달되는지 확인
	String strPageNum=request.getParameter("pageNum");
	// 넘어온다면
	if(strPageNum!=null){
		// String을 숫자로 바꿔서 page 번호로 저장한다.
		pageNum=Integer.parseInt(strPageNum);
	}
	
	// 보여줄 page의 시작 rownum
	int startRowNum=1+(pageNum-1)*page_row_count;
	// 보여줄 page의 끝 rownum
	int endRowNum=pageNum*page_row_count;
	
	MusicFeedDto dto=new MusicFeedDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
	
	// db에서 music feed data를 불러온다.
	List<MusicFeedDto> list=MusicFeedDao.getInstance().getList(dto);
	// 전체 게시글 개수
	int totalRow=MusicFeedDao.getInstance().getCount();
	
	
	// 하단의 시작 page 번호
	int startPageNum=1+((pageNum-1)/page_display_count)*page_display_count;
	int endPageNum=startPageNum+page_display_count-1;
	
	// 전체 page의 수
	int totalPageCount=(int)Math.ceil(totalRow/(double)page_row_count);
	// 끝 page의 번호가 전체 page 수 보다 크다면 잘못된 값
	if(endPageNum > totalPageCount){
		endPageNum=totalPageCount; // 보정
	}
	
	// 댓글의 data를 불러온다.
	
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
	.page-ui a{
		text-decoration: none;
		color: #000;
	}
	.page-ui a:hover{
		text-decoration: underline;
	}
	
	.page-ui a.active{
		color: red;
		font-weight: bold;
		text-decoration: underline;
	}
	
	.page-ui ul{
		list-style-type: none;
		padding: 0;
	}
	.page-ui li{
		float: left;
		padding: 10px;
	}
@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
</style>
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
<jsp:include page="../include/navbar.jsp"></jsp:include>
	<div class="container">
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
		<ul>
			<%for(MusicFeedDto tmp:list) {%>
				<li>
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
					<%
						/*
							댓글 paging 처리
						*/
						
						// 한 번에 몇 개 씩 보이게 할 것인지
						final int comment_row_count=5;
						
						// 보여줄 댓글 page의 번호에 초기값 1 부여
						int comment_pageNum=1;
						
						// 보여줄 댓글 page의 시작 rownum
						int comment_startRowNum=1+(comment_pageNum-1)*comment_row_count;
						// 보여줄 댓글 page의 끝 rownum
						int comment_endRowNum=comment_pageNum*comment_row_count;
						
						MusicCommentDto comment_dto=new MusicCommentDto();
						comment_dto.setNum(tmp.getNum());
						comment_dto.setStartRowNum(comment_startRowNum);
						comment_dto.setEndRowNum(comment_endRowNum);
						
						// 댓글 전체의 개수 얻어내기
						int comment_totalRow=MusicCommentDao.getInstance().getCount(tmp.getNum());
						
						// 전체 page의 수
						int comment_totalPageCount=(int)Math.ceil(comment_totalRow/(double)comment_row_count);
					%>
					<!-- card 게시글 댓글 list -->
					<div data-num="<%=tmp.getNum() %>" id="commentList<%=tmp.getNum() %>" class="commentList" style="display: none;">
						<ul>
							<!-- 댓글의 data를 불러온다. -->
							<%List<MusicCommentDto> commentList=MusicCommentDao.getInstance().getList(comment_dto); %>
							<%for(MusicCommentDto tmp2:commentList) {%>
								<%if(tmp2.getDeleted().equals("yes")){ %>
									<li>삭제된 댓글입니다.</li>
								<% // continue; 아래의 코드를 수행하지 않고 for문으로 실행 순서를 다시 보내기
									continue;
								}%>
								<%if(tmp2.getComment_group()==tmp2.getNum()) {%>
									<li id="comment<%=tmp2.getNum()%>">
								<%} else {%>
									<li id="comment<%=tmp2.getNum()%>" style="padding-left:50px;">
								<%} %>
									<dl>
										<dt>
											<span><%=tmp2.getWriter() %></span>
											<a data-num="<%=tmp2.getNum() %>" class="recomment-link" href="javascript;">댓글</a>
											<%if(tmp2.getWriter().equals(id)){ %>
												<a data-num="<%=tmp2.getNum() %>" class="comment-update-link" href="javascript:">수정</a>
												<a data-num="<%=tmp2.getNum() %>" class="comment-delete-link" href="javascript:">삭제</a>
											<%} %>
											<span><%=tmp2.getRegdate() %></span>
										</dt>
										<dd>
											<pre><%=tmp2.getContent() %></pre>
										</dd>
									</dl>
									<!-- 댓글 수정하는 form(hidden) -->
									<%if(tmp2.getWriter().equals(id)){ %>
										<form data-num="<%=tmp2.getNum() %>" id="commentUpdateForm<%=tmp2.getNum() %>" class="commentUpdate" style="display:none;" action="update_comment.jsp" method="post">
											<input type="hidden" name="num" value="<%=tmp2.getNum() %>"/>
											<textarea name="commentUpdate" id="commentUpdate"><%=tmp2.getContent() %></textarea>
											<button type="submit">수정하기</button>
										</form>
									<%} %>
									<!-- 대댓글 form(hidden) -->
									<form data-num="<%=tmp2.getNum() %>" id="recommentForm<%=tmp2.getNum() %>" class="comment" style="display:none;" action="insert_comment.jsp" method="post">
										<input type="hidden" name="target_id" value="<%=tmp2.getWriter() %>"/>
										<input type="hidden" name="ref_group" value="<%=tmp.getNum() %>"/>
										<input type="hidden" name="comment_group" value="<%=tmp2.getComment_group()%>"/>
										<textarea name="comment" id="recomment"></textarea>
										<button type="submit">댓글 달기</button>
									</form>
								</li>
							<%} %>
						</ul>
						<%if(comment_totalPageCount > 1){ %>
							<a data-num="<%=tmp.getNum() %>" data-num2="<%=comment_totalPageCount %>" class="moreComment" href="javascript:">더보기</a>
						<%} %>
						<!-- 댓글 작성하는 form(hidden) -->
						<div>
							<form data-num="<%=tmp.getNum() %>" id="commentForm<%=tmp.getNum() %>" class="comment" action="insert_comment.jsp" method="post">
								<input type="hidden" name="target_id" value="<%=tmp.getWriter() %>"/>
								<input type="hidden" name="ref_group" value="<%=tmp.getNum() %>"/>
								<textarea name="comment" id="comment"></textarea>
								<button type="submit">댓글 달기</button>
							</form>
						</div>
					</div>
				</li>					
			<%} %>
		</ul>
		<!-- page 넘길 수 있는 부분 -->
		<div class="page-ui clearfix">
			<ul>
				<!-- 이전 묶음 -->
				<%if(startPageNum>1) {%>
					<li>
						<a href="${pageContext.request.contextPath}/music/musicMain.jsp?pageNum=<%=startPageNum-1%>">prev</a>
					</li>
				<%} %>
				<!-- 각 page -->
				<%for(int i=startPageNum; i<=endPageNum; i++){ %>
					<%if(pageNum==i){ %>
						<li>
							<a class="active" href="${pageContext.request.contextPath}/music/musicMain.jsp?pageNum=<%=i%>"><%=i %></a>
						</li>
					<%} else { %>
						<li>
							<a href="${pageContext.request.contextPath}/music/musicMain.jsp?pageNum=<%=i%>"><%=i %></a>
						</li>
					<%} %>
				<%} %>
				<!-- 다음 묶음 -->
				<%if(endPageNum<totalPageCount){ %>
					<li>
						<a href="${pageContext.request.contextPath}/music/musicMain.jsp?pageNum=<%=endPageNum+1%>">next</a>
					</li>
				<%} %>
			</ul>
		</div>
	</div>
	
	<script>
		document.querySelector("#acornstar").addEventListener("click",function(){
			location.href="${pageContext.request.contextPath}/main/main.jsp";
			let star = document.querySelector("#star");
			let music = document.querySelector("#music");
			document.getElementById("#star").style.display = "none";
		});
		
		/*
			게시글 관련
		*/
		
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
		
		/*
			댓글 관련
		*/
		
		commentBtnAddListener(".comment-link");
		// 댓글 버튼을 눌렀을 때 작동하는 곳
		function commentBtnAddListener(sel){
			let commentLinks=document.querySelectorAll(sel);
			for(let i=0; i<commentLinks.length; i++){
				commentLinks[i].addEventListener("click", function(e){
					// 일단 막고
					e.preventDefault();
					
					let num=this.getAttribute("data-num");
					
					let commentForm=document.querySelector("#commentList"+num);
					if(commentForm.style.display=="none"){
						commentForm.style.display="block";
					} else if(commentForm.style.display=="block"){
						commentForm.style.display="none";
					}				
				});
			}
		}
		
		commentAddListener(".comment");
		// 댓글 달기 버튼을 눌렀을 때 작동하는 곳
		function commentAddListener(sel){
			let commentForms=document.querySelectorAll(sel);
			for(let i=0; i<commentForms.length; i++){
				commentForms[i].addEventListener("submit", function(e){
					// 일단 form 제출을 막고
					e.preventDefault();
					
					let num=this.getAttribute("data-num");
					
					// ajax로 응답
					ajaxFormPromise(this)
					.then(function(response){
						return response.json();
					}).then(function(data){
						if(data.beInserted){
							let path="${pageContext.request.contextPath}/music/musicMain.jsp?pageNum=<%=pageNum%>";
							location.href=path;
						} else {
							console.log("댓글 등록 실패");
						}
					});
				});
			}
		}
		
		commentDeleteBtnAddListener(".comment-delete-link");
		function commentDeleteBtnAddListener(sel){
			// 댓글 삭제 버튼을 눌렀을 때 작동하는 곳
			let commentDeleteLinks=document.querySelectorAll(sel);
			for(let i=0; i<commentDeleteLinks.length; i++){
				commentDeleteLinks[i].addEventListener("click", function(e){
					e.preventDefault();
					
					let num=this.getAttribute("data-num");
					
					let wantDelete=confirm("이 댓글을 삭제하시겠습니까?");
					if(wantDelete){
						// ajax로 응답
						ajaxPromise("delete_comment.jsp", "post", "num="+num)
						.then(function(response){
							return response.json();
						}).then(function(data){
							if(data.beDeleted){
								document.querySelector("#comment"+num).innerText="삭제된 댓글입니다.";
							} else {
								alert("삭제에 실패했습니다.");
							}
						});	
					}
				});
			}
		}
	
		commentUpdateBtnAddListener(".comment-update-link");
		// 댓글 수정 버튼을 눌렀을 때 작동하는 곳
		function commentUpdateBtnAddListener(sel){
			let commentUpdateLinks=document.querySelectorAll(sel);
			for(let i=0; i<commentUpdateLinks.length; i++){
				commentUpdateLinks[i].addEventListener("click", function(e){
					// 일단 막고
					e.preventDefault();
					
					let num=this.getAttribute("data-num");
					let commentForm=document.querySelector("#commentUpdateForm"+num);
					
					if(commentForm.style.display=="none"){
						commentForm.style.display="block";
					} else if(commentForm.style.display=="block"){
						commentForm.style.display="none";
					}				
				});
			}	
		}
		
		commentUpdateAddListener(".commentUpdate");
		// 수정하기 버튼을 눌렀을 때 작동하는 곳
		function commentUpdateAddListener(sel){
			let commentUpdateForms=document.querySelectorAll(sel);
			for(let i=0; i<commentUpdateForms.length; i++){
				commentUpdateForms[i].addEventListener("submit", function(e){
					// 일단 form 제출을 막고
					e.preventDefault();
					
					let num=this.getAttribute("data-num");
					let commentForm=document.querySelector("#commentUpdateForm"+num);
					
					// ajax로 응답
					ajaxFormPromise(this)
					.then(function(response){
						return response.json();
					}).then(function(data){
						if(data.beUpdated){
							document.querySelector("#comment"+num+" pre").innerText=data.newContent;
							commentForm.style.display="none";
						} else {
							alert("수정에 실패하였습니다. 다시 수정해주세요.");
						}
					});
				});
			}
		}
		
		recommentBtnAddListener(".recomment-link");
		// 대댓글 버튼 눌렀을 때 작동하는 곳
		function recommentBtnAddListener(sel){
			let recommentLinks=document.querySelectorAll(sel);
			for(let i=0; i<recommentLinks.length; i++){
				recommentLinks[i].addEventListener("click", function(e){
					// 일단 막고
					e.preventDefault();
					
					let num=this.getAttribute("data-num");
					let recommentForm=document.querySelector("#recommentForm"+num);
					
					if(recommentForm.style.display=="none"){
						recommentForm.style.display="block";
					} else if(recommentForm.style.display=="block"){
						recommentForm.style.display="none";
					}				
				});
			}
		}
	
		/*
			댓글 더보기
		*/
		
		// 댓글의 현재 page를 관리할 variable. 초기값=1
		let currentPage=1;
		
		// 마지막 page는 for문 안에다가
		
		// 추가로 댓글을 요청하고 그 작업이 끝났는지 여부를 관리할 변수
		let beLoading=false; // 현재 loading 중인지 여부
		
		moreComment(".moreComment");
		// 댓글 더 보기를 눌렀을 때 작동하는 곳
		function moreComment(sel){
			let morelinks=document.querySelectorAll(sel);
			for(let i=0; i<morelinks.length; i++){
				morelinks[i].addEventListener("click", function(e){
					// 링크 이동을 막고
					e.preventDefault();
					
					let num=this.getAttribute("data-num");
					// 마지막 page는 for문 안에다가
					let lastPage=this.getAttribute("data-num2");
					
					let beLast= currentPage==lastPage;
					
					if(!beLoading && !beLast){
						beLoading = true;
						
						currentPage++;
						
						// ajax로 응답
						ajaxPromise("comment_list.jsp", "get",
								"pageNum="+currentPage+"&num="+num)
						.then(function(response){
							return response.text();
						}).then(function(data){
							document.querySelector(".commentList ul").insertAdjacentHTML("beforeend", data);
							morelinks[i].style.display="none";
							beLoading = false;
							
							// 새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 event listener를 등록하기
							recommentBtnAddListener(".page-"+currentPage+" .recomment-link");
							commentAddListener(".page-"+currentPage+" .comment");
							commentDeleteBtnAddListener(".page-"+currentPage+" .comment-delete-link");
							commentUpdateBtnAddListener(".page-"+currentPage+" .comment-update-link");
							commentUpdateAddListener(".page-"+currentPage+" .commentUpdate");
							moreComment(".moreComment");
						});					
					}
				});
			}
		}
	</script>
</body>
</html>