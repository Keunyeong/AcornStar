<%@page import="java.util.Arrays"%>
<%@page import="test.users.dao.UsersDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="test.musicfeed.dao.MusicCommentDao"%>
<%@page import="test.musicfeed.dto.MusicCommentDto"%>
<%@page import="test.musicfeed.dto.MusicFeedDto"%>
<%@page import="java.util.List"%>
<%@page import="test.musicfeed.dao.MusicFeedDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page buffer="8192kb" autoFlush="true" %>    
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
	
	/*
		[검색 keyword에 대한 처리]
		- 검색 keyword가 parameter로 넘어올 수도 있고 안 넘어올 수도 있다.
	*/
	String keyword=request.getParameter("keyword");
	String condition=request.getParameter("condition");
	// 만약 keyword가 넘어오지 않는다면
	if(keyword==null){
		// keyword와 condion에 빈 문자열을 넣어준다.
		// client web browser에 출력할 때, null을 출력시키지 않기 위해서
		keyword="";
		condition="";
	}
	
	// 특수기호를 encoding한 keyword를 미리 준비한다.
	String encodedK=URLEncoder.encode(keyword);
		
	MusicFeedDto dto=new MusicFeedDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
	
	// db에서 music feed data를 불러온다.
	List<MusicFeedDto> list=null;
	// 전체 게시글 개수
	int totalRow=0;
	
	//만일 검색 키워드가 넘어온다면 
	if(!keyword.equals("")){
	   	//검색 조건이 무엇이냐에 따라 분기 하기
	   	if(condition.equals("title_content")){//제목 + 내용 검색인 경우
			//검색 키워드를 CafeDto 에 담아서 전달한다.
			dto.setTitle(keyword);
			dto.setContent(keyword);
			//제목+내용 검색일때 호출하는 메소드를 이용해서 목록 얻어오기 
			list=MusicFeedDao.getInstance().getListTC(dto);
			//제목+내용 검색일때 호출하는 메소드를 이용해서 row  의 갯수 얻어오기
			totalRow=MusicFeedDao.getInstance().getCountTC(dto);
	   	}else if(condition.equals("title")){ //제목 검색인 경우
	      	dto.setTitle(keyword);
	      	list=MusicFeedDao.getInstance().getListT(dto);
	      	totalRow=MusicFeedDao.getInstance().getCountT(dto);
	  	}else if(condition.equals("writer")){ //작성자 검색인 경우
	      	dto.setWriter(keyword);
	      	list=MusicFeedDao.getInstance().getListW(dto);
	      	totalRow=MusicFeedDao.getInstance().getCountW(dto);
	   	}else if(condition.equals("tag")){
	   		dto.setTitle(keyword);
			dto.setContent(keyword);
			dto.setWriter(keyword);
			dto.setTag(keyword);
			list=MusicFeedDao.getInstance().getListTotal(dto);
			totalRow=MusicFeedDao.getInstance().getCountTotal(dto);
	   	} // 다른 검색 조건을 추가 하고 싶다면 아래에 else if() 를 계속 추가 하면 된다.
	} else { //검색 키워드가 넘어오지 않는다면
	   	//키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다. 
	   	list=MusicFeedDao.getInstance().getList(dto);
	   	//키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
	   	totalRow=MusicFeedDao.getInstance().getCount();
	}
	
	
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
	.iframeBox {
		position: relative;
		/*padding-bottom: 56.25%; /* 16:9 비율인 경우 */
		/* padding-bottom값은 4:3 비율인 경우 75%로 설정합니다 */
	}
	.iframeBox iframe{
		position: absolute;
		width: 100%;
		height: 100%;
		overflow: hidden;
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
	
	.cardlist{
		padding: 0;
	}
	
	.cardlist li{
		list-style-type: none;
		padding: 0;
		margin: 0 auto;
	}
	
	.wrapper{
	   perspective: 500px;
	   perspective-origin: 50% 20%;
	   margin-top: 30px;
	}
	.cube{
	   transform-style: preserve-3d;
	   transform-origin: 50% 50%;
	   position: relative;
	   width: 400px;
	   height: 400px;
	   margin: 0 auto; /* 가운데 정렬 */
	   transition: all 0.5s ease-out;
	}
	.cube > .iframeBox{
	   position: absolute;
	   width: 400px;
	   height: 400px;
	   opacity: 1; /* 투명도 */
	   background-color: #5d16a2;
	}
	
	<!-- pentagon 돌리는 화살표 설정 -->
	.arrow{
		color: #fff;
		background-color: #8b00ff;
		border-color: #8b00ff;
	}
	.arrow:hover{
		color: #fff;
		background-color: #8b00ff;
		border-color: #8b00ff;
	}
	.arrow path{
		color: #8b00ff;
	}
	.arrow:hover path{
		color: #fff;
	}
	
	<!-- 버튼 통일 -->
	.btnK:hover{
		color: #fff;
		background-color: #f1dcff;
		border-color: #f1dcff;
	}
	
	#insertModal, #updateModal{
		background-color: #f1dcff;
	}
	.heart{
		text-decoration:none;
		color: #8b00ff;
	}

	.control{
	   /* 인라인 요소의 가운데 정렬 */
	   text-align: center;
	}  
@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
</style>
</head>
<jsp:include page="../include/resource.jsp"></jsp:include>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
<jsp:include page="../include/navbar.jsp"></jsp:include>
	<div class="container">
		<div>
			<!-- Button trigger modal -->
			<button id="writeBtn" type="button" class="btn btn-primary" style="display:none;" data-bs-toggle="modal" data-bs-target="#insertModal">
			  	새 글 작성
			</button>
			<%if(keyword!=""){%>
				<a href="${pageContext.request.contextPath}/music/musicMain.jsp">글 전체 보기</a>
			<%} %>
			<a id="empty" style="display:none;" href="">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart" viewBox="0 0 16 16">
					<path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
				</svg>
			</a>
			<a id="fill" style="display:none;" href="">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
					<path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
				</svg>
			</a>
		</div>
		
		<!-- 새 글 작성 modal -->
		<div class="modal fade" id="insertModal" tabindex="-1" aria-labelledby="insertModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
				  	<div class="modal-header">
				    	<h5 class="modal-title" id="insertModalLabel">새 게시글을 작성해보세요!.!</h5>
				  	</div>
				  	<form id="insertForm" method="post" action="${pageContext.request.contextPath}/music/insert.jsp">
					  	<div class="modal-body">
					  		<div>
					  			<label class="form-label" for="title">제목</label>
					  			<input class="form-control" type="text" name="title" id=""/>
					  		</div>
					  		<br>
					    	<div>
					    		<label class="form-label" for="content">내용</label>
					    		<textarea class="form-control" name="content" id="content"></textarea>
					    	</div>
					    	<br>
					    	<div>
					  			<label class="form-label" for="tag">태그</label>
					  			<input class="form-control" type=text name="tag" id=""/>
					  		</div>
					  		<br>
					    	<div>
					  			<label class="form-label" for="link">링크</label>
					  			<input class="form-control" type="url" name="link" id=""/>
					  		</div>
					  	</div>
					  	<div class="modal-footer">
					  		<button class="btn btnK" type="submit">작성</button>
					    	<button id="insertCancelBtn" type="button" class="btn btnK" data-bs-dismiss="modal">취소</button>
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
				    	<h5 class="modal-title" id="updateModalLabel">어떻게 수정하시겠어요?.?</h5>
				  	</div>
				  	<form id="updateForm" method="post" action="${pageContext.request.contextPath}/music/update.jsp">
					  	<div class="modal-body">
					  		<input type="hidden" name="num" id="updateNum"/>
					  		<div>
					  			<label class="form-label" for="update_title">제목</label>
					  			<input class="form-control" type="text" name="update_title" id="update_title"/>
					  		</div>
					    	<div>
					    		<label class="form-label" for="update_content">내용</label>
					    		<textarea class="form-control" name="update_content" id="update_content"></textarea>
					    	</div>
					    	<div>
					    		<label class="form-label" for="tag">태그</label>
					    		<input class="form-control" type="text" name="update_tag" id="update_tag"/>
					    	</div>
					    	<div>
					  			<label class="form-label" for="update_link">링크</label>
					  			<input class="form-control" type="url" name="update_link" id="update_link"/>
					  		</div>
					  	</div>
					  	<div class="modal-footer">
					  		<button class="btn btnK" type="submit">수정</button>
					    	<button id="updateCancelBtn" type="button" class="btn btnK" data-bs-dismiss="modal">취소</button>
					  	</div>
				  	</form>
				</div>
			</div>
		</div>
		
		<!-- top six cube -->
		<%
			// top six list
			List<MusicFeedDto> topSix=MusicFeedDao.getInstance().getTopSix();
		%>
		<div class="wrapper">
			<div class="cube">
				<%for(MusicFeedDto tmp3:topSix){ %>
					<div class="iframeBox">
						<iframe class="" src="<%=tmp3.getLink()%>"></iframe>
					</div>
				<%} %>
			</div>
		</div>		
		<br>		
		<div class="control">
			<button class="btn arrow" id="prevBtn">
				<svg xmlns="http://www.w3.org/2000/svg" width="29" height="29" fill="currentColor" class="bi bi-arrow-left" viewBox="0 0 16 16">
  					<path fill-rule="evenodd" d="M15 8a.5.5 0 0 0-.5-.5H2.707l3.147-3.146a.5.5 0 1 0-.708-.708l-4 4a.5.5 0 0 0 0 .708l4 4a.5.5 0 0 0 .708-.708L2.707 8.5H14.5A.5.5 0 0 0 15 8z"/>
				</svg>
			</button>
			<button class="btn arrow" id="nextBtn">
				<svg xmlns="http://www.w3.org/2000/svg" width="29" height="29" fill="currentColor" class="bi bi-arrow-right" viewBox="0 0 16 16">
  					<path fill-rule="evenodd" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z"/>
				</svg>
			</button>
		</div>
		<br>

		<!-- card 게시글 list -->
		<ul class="cardlist">
			<%for(MusicFeedDto tmp:list) {%>
				<li class="mb-3 col-md-9">
					<div class="card mb-3">
					  	<div class="row g-0">
					    	<div class="col col-md-4 iframeBox">
					      		<iframe class="" src="<%=tmp.getLink()%>"></iframe>
					    	</div>
					    	<div class="col col-md-8" style="background-color: #f1dcff; color:black; font-weight: 600;">
					      		<div class="card-body">
					        		<h5 class="card-title"><%=tmp.getTitle() %></h5>
					        		<p class="card-text">작성자 : <%=tmp.getWriter() %></p>
					        		<p class="card-text"><%=tmp.getContent() %></p>
					        		<%if(tmp.getTag()==null){ %>
					        			<p class="card-text"><small class="text-muted">tag : </small></p>
					        		<%} else if(tmp.getTag()!=null){ %>
					        			<p class="card-text"><small class="text-muted">tag : #<%=tmp.getTag() %></small></p>
					        		<%} %>
					        		<p class="card-text"><small class="text-muted">작성 시간 : <%=tmp.getRegdate() %></small></p>
					        		<p class="card-text"><small class="text-muted">
					        			<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
  											<path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
										</svg> : <span class="upCount"><%=tmp.getUpCount() %></span></small></p>
					      		</div>
					      		<%
					      			String dbList=UsersDao.getInstance().getUpList(id);
					      			System.out.println(dbList);
					      			if(dbList==null){
					      		  		dbList="0";
					      		    }
					      			String[] array=dbList.split(",");
					      			boolean check=Arrays.asList(array).contains(Integer.toString(tmp.getNum()));
					      			System.out.println(check);
					      		%>
					      		<%if(check) {%>
					      			<a data-num0="1" data-num="<%=tmp.getNum() %>" class="up-link heart ms-3" href="javascript:">
					      				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
  											<path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
										</svg>
					      			</a>
					      		<%} else { %>
					      			<a data-num0="0" data-num="<%=tmp.getNum() %>" class="up-link heart ms-3" href="javascript:">
					      				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart" viewBox="0 0 16 16">
  											<path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
										</svg>
					      			</a>
					      		<%} %>
					      		<a data-num="<%=tmp.getNum() %>" class="comment-link ms-3 mb-2 btn btn-light" href="javascript:">댓글</a>
					      		<%if(tmp.getWriter().equals(id)){ %>
					      			<a data-num="<%=tmp.getNum() %>" class="delete-link float-end me-2 mb-2 btn btn-light" href="javascript:">삭제</a>
						      		<a data-num="<%=tmp.getNum() %>" class="update-link float-end me-2 mb-2 btn btn-light" data-bs-toggle="modal" data-bs-target="#updateModal" href="javascript:">수정</a>
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
						<ul style="padding-left:0px;">
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
											<small>@<%=tmp2.getTarget_id() %> //  </small><span><%=tmp2.getWriter() %></span>
											<a data-num="<%=tmp2.getNum() %>" class="recomment-link mb-2 btn btn-light btn-sm" href="javascript;">댓글</a>
											<%if(tmp2.getWriter().equals(id)){ %>
												<a data-num="<%=tmp2.getNum() %>" class="comment-delete-link float-end me-2 mb-2 btn btn-light btn-sm" href="javascript:">삭제</a>
												<a data-num="<%=tmp2.getNum() %>" class="comment-update-link float-end me-2 mb-2 btn btn-light btn-sm" href="javascript:">수정</a>
											<%} %>
											<span><%=tmp2.getRegdate() %></span>
										</dt>
										<dd>
											<pre class="form-control"><%=tmp2.getContent() %></pre>
										</dd>
									</dl>
									<!-- 댓글 수정하는 form(hidden) -->
									<%if(tmp2.getWriter().equals(id)){ %>
										<form data-num="<%=tmp2.getNum() %>" id="commentUpdateForm<%=tmp2.getNum() %>" class="commentUpdate" style="display:none;" action="update_comment.jsp" method="post">
											<input class="form-label" type="hidden" name="num" value="<%=tmp2.getNum() %>"/>
											<textarea class="form-control" name="commentUpdate" id="commentUpdate"><%=tmp2.getContent() %></textarea>
											<button type="submit">수정하기</button>
										</form>
									<%} %>
									<!-- 대댓글 form(hidden) -->
									<form data-num="<%=tmp2.getNum() %>" data-num3="80" id="recommentForm<%=tmp2.getNum() %>" class="comment" style="display:none;" action="insert_comment.jsp" method="post">
										<input type="hidden" name="currentPage" value="80"/>
										<input type="hidden" name="num" value="<%=tmp.getNum()%>"/>
										<input type="hidden" name="target_id" value="<%=tmp2.getWriter() %>"/>
										<input type="hidden" name="ref_group" value="<%=tmp.getNum() %>"/>
										<input type="hidden" name="comment_group" value="<%=tmp2.getComment_group()%>"/>
										<textarea class="form-control" name="comment" id="recomment"></textarea>
										<button type="submit">댓글 달기</button>
									</form>
								</li>
							<%} %>
						</ul>
						<%if(comment_totalPageCount > 1){ %>
							<a data-num="<%=tmp.getNum() %>" data-num2="<%=comment_totalPageCount %>" data-num3="1" class="moreComment btn" href="javascript:">더보기</a>
						<%} %>
							
						<!-- 댓글 작성하는 form(hidden) -->
						<div>
							<form data-num="<%=tmp.getNum() %>" data-num3="80" id="commentForm<%=tmp.getNum() %>" class="comment" action="insert_comment.jsp" method="post">
								<input type="hidden" name="currentPage" value="80"/>
								<input type="hidden" name="num" value="<%=tmp.getNum()%>"/>
								<input type="hidden" name="target_id" value="<%=tmp.getWriter() %>"/>
								<input type="hidden" name="ref_group" value="<%=tmp.getNum() %>"/>
								<textarea class="form-control" name="comment" id="comment"></textarea>
								<button type="submit">댓글 달기</button>
							</form>
						</div>
					</div>
				</li>				
			<%} %>
		</ul>
		<!-- page 넘길 수 있는 부분 -->
		<div class="page-ui pagination justify-content-center">
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
	<!--
	<form id="searchForm" action="musicMain.jsp" method="get">
		<label for="condition">검색 조건</label>
		<select name="condition" id="condition">
			<option value="title_content" <%=condition.equals("title_content") ? "selected" : ""%>>제목+내용</option>
			<option value="title" <%=condition.equals("title") ? "selected" : ""%>>제목</option>
			<option value="writer" <%=condition.equals("writer") ? "selected" : ""%>>작성자</option>
		</select>
		<input id="keyword" type="text" name="keyword" placeholder="검색어..." value="<%=keyword%>"/>
		<button type="submit">검색</button>
	</form>
	<%if(!condition.equals("")){ %>
		<p>
			<strong><%=totalRow %></strong> 개의 글이 검색되습니다.
		</p>
	<%} else {%>
		<p>
			<strong><%=totalRow %></strong> 개의 글이 있습니다.
		</p>
	<%} %>
	-->
	<script>
		// 로고
		document.querySelector("#acornstar").addEventListener("click",function(){
			location.href="${pageContext.request.contextPath}/main/main.jsp";
		});
		
		/*
			test
		*/
		
		function getAngleNtz(n, width) {
			let angle = (360 / n);
			let tz = ((width/2)/Math.tan((angle*Math.PI)/(2*180)));
			let obj = {
				angle: angle,
				tz: tz
			};
			return obj;
		}
		
		let cube=document.querySelector(".cube");
		let cubelist=cube.children;
		
		let obj=getAngleNtz(cubelist.length, 400);
		for(let i=0; i<cubelist.length; i++){
			//cubelist[i].style.transform=`rotateY(${obj.angle*i}deg) translateZ(${obj.tz}px)`;
			cubelist[i].style.transform="rotateY("+(obj.angle*i)+"deg) translateZ("+(obj.tz)+"px)";
		}
		//cube.style.transform=`translateZ(-${obj.tz}px)`;
		cube.style.transform="translateZ("+(-obj.tz)+"px)";
		
		let angle=0;
		document.querySelector("#prevBtn").addEventListener("click", function(){
			angle -= obj.angle;
			//cube.style.transform=`translateZ(${-obj.tz}px) rotateY(${angle}deg)`;
			cube.style.transform="translateZ("+(-obj.tz)+"px) rotateY("+(angle)+"deg)";
		});
		document.querySelector("#nextBtn").addEventListener("click", function(){
			angle += obj.angle;
			//cube.style.transform=`translateZ(${-obj.tz}px) rotateY(${angle}deg)`;
			cube.style.transform="translateZ("+(-obj.tz)+"px) rotateY("+(angle)+"deg)";
		});
		
		/*
		// 검색 관련 : 입력값이 없으면 제출하지 않는다.")
		document.querySelector("#searchForm").addEventListener("submit", function(e){
			if(document.querySelector("#keyword").value==""){
				e.preventDefault();
			}
		});
		*/
		document.querySelector(".searchForm").setAttribute("action", "musicMain.jsp");
		document.querySelector(".searchForm").setAttribute("method", "get");
		document.querySelector(".searchForm").addEventListener("submit", function(e){
			if(document.querySelector(".keyword").value==""){
				e.preventDefault();
			}
		});
		
		/*
			좋아요 관련
		*/
		let fill=document.querySelector("#fill").getInnerHTML();
		let empty=document.querySelector("#empty").getInnerHTML();
		
		let upLinks=document.querySelectorAll(".up-link");
		let upCounts=document.querySelectorAll(".upCount");
		for(let i=0; i<upLinks.length; i++){
			upLinks[i].addEventListener("click", function(e){
				e.preventDefault();
				
				let num=this.getAttribute("data-num");
				let up=this.getAttribute("data-num0");
				
				if(up=="1"){
					ajaxPromise("down.jsp", "post", "num="+num)
					.then(function(response){
						return response.json();
					}).then(function(data){
						if(data.beSuccess){
							upLinks[i].innerHTML=empty;
							upLinks[i].setAttribute("data-num0", "0");
							upCounts[i].innerText=data.upCount;
						}
					});	
				} else if(up=="0"){
					ajaxPromise("up.jsp", "post", "num="+num)
					.then(function(response){
						return response.json();
					}).then(function(data){
						if(data.beSuccess){
							upLinks[i].innerHTML=fill;
							upLinks[i].setAttribute("data-num0", "1");
							upCounts[i].innerText=data.upCount;
						}
					});	
				}
			});
		}
		
		/*
			게시글 기능 관련
		*/
		
		// 글쓰기 기호를 눌렀을 때 작동하는 곳
		document.querySelector("#write").addEventListener("click", function(){
			document.querySelector("#writeBtn").click();
		});
		
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
				e.preventDefault();
				
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
					document.querySelector("#update_tag").value=data.tag;
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
		
		/*
		let tcurrentPage=80;
		function commentAddListener(sel){
			let commentForms=document.querySelectorAll(sel);
			for(let i=0; i<commentForms.length; i++){
				commentForms[i].addEventListener("submit", function(e){
					// 일단 form 제출을 막고
					e.preventDefault();
					
					// 대댓글일 경우
					if(commentForms[i].getAttribute("id").includes("re")){
						let num=this.getAttribute("data-num");
						
						//tcurrentPage=this.getAttribute("data-num3");
						
						tcurrentPage++;
						
						// ajax로 응답
						ajaxFormPromise(this)
						.then(function(response){
							return response.text();
						}).then(function(data){
							document.querySelector(".commentList[id=commentList"+num+"]"+" ul").insertAdjacentHTML("beforeend", data);
													
							// 새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 event listener를 등록하기
							recommentBtnAddListener(".page-"+tcurrentPage+" .recomment-link");
							commentAddListener(".page-"+tcurrentPage+" .comment");
							commentDeleteBtnAddListener(".page-"+tcurrentPage+" .comment-delete-link");
							commentUpdateBtnAddListener(".page-"+tcurrentPage+" .comment-update-link");
							commentUpdateAddListener(".page-"+tcurrentPage+" .commentUpdate");
							moreComment(".moreComment");
						});
					} else { // 댓글일 경우
						let num=this.getAttribute("data-num");
						
						//tcurrentPage=this.getAttribute("data-num3");
						
						tcurrentPage++;
						
						// ajax로 응답
						ajaxFormPromise(this)
						.then(function(response){
							return response.text();
						}).then(function(data){
							document.querySelector(".commentList[id=commentList"+num+"]"+" ul").insertAdjacentHTML("beforeend", data);
													
							// 새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 event listener를 등록하기
							recommentBtnAddListener(".page-"+tcurrentPage+" .recomment-link");
							commentAddListener(".page-"+tcurrentPage+" .comment");
							commentDeleteBtnAddListener(".page-"+tcurrentPage+" .comment-delete-link");
							commentUpdateBtnAddListener(".page-"+tcurrentPage+" .comment-update-link");
							commentUpdateAddListener(".page-"+tcurrentPage+" .commentUpdate");
							moreComment(".moreComment");
						});
					}
				});
			}
		}
		*/
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
					
					currentPage=this.getAttribute("data-num3");
					
					let beLast= currentPage==lastPage;
					
					if(!beLoading && !beLast){
						beLoading = true;
						
						currentPage++;
						
						// ajax로 응답
						ajaxPromise("comment_list.jsp", "post",
								"comment_pageNum="+currentPage+"&num="+num)
						.then(function(response){
							return response.text();
						}).then(function(data){
							document.querySelector(".commentList[id=commentList"+num+"]"+" ul").insertAdjacentHTML("beforeend", data);
							morelinks[i].style.display="none";
							
							// 새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 event listener를 등록하기
							recommentBtnAddListener(".page-"+currentPage+" .recomment-link");
							commentAddListener(".page-"+currentPage+" .comment");
							commentDeleteBtnAddListener(".page-"+currentPage+" .comment-delete-link");
							commentUpdateBtnAddListener(".page-"+currentPage+" .comment-update-link");
							commentUpdateAddListener(".page-"+currentPage+" .commentUpdate");
							moreComment(".moreComment");
							
							beLoading = false;
						});					
					}
				});
			}
		}
		
	</script>
</body>
</html>