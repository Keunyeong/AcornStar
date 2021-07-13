<%@page import="java.net.URLEncoder"%>
<%@page import="test.feed.dao.FeedCommentDao"%>
<%@page import="test.feed.dto.FeedCommentDto"%>
<%@page import="test.feed.dao.MainFeedDao"%>
<%@page import="test.feed.dto.MainFeedDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	
	// session scope에서 id 정보 불러오기
	String id=(String)session.getAttribute("id");	
	
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=6;
	//하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;
	
	//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
	int pageNum=1;
	//페이지 번호가 파라미터로 전달되는지 읽어와 본다.
	String strPageNum=request.getParameter("pageNum");
	//만일 페이지 번호가 파라미터로 넘어 온다면
	if(strPageNum != null){
		//숫자로 바꿔서 보여줄 페이지 번호로 지정한다.
		pageNum=Integer.parseInt(strPageNum);
	}
	
	//보여줄 페이지의 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT;
	
	/*
		[ 검색 키워드에 관련된 처리 ]
		-검색 키워드가 파라미터로 넘어올수도 있고 안넘어 올수도 있다.		
	*/
	String keyword=request.getParameter("keyword");
	String condition=request.getParameter("condition");
	//만일 키워드가 넘어오지 않는다면 
	if(keyword==null){
		//키워드와 검색 조건에 빈 문자열을 넣어준다. 
		//클라이언트 웹브라우저에 출력할때 "null" 을 출력되지 않게 하기 위해서  
		keyword="";
		condition=""; 
	}

	//특수기호를 인코딩한 키워드를 미리 준비한다. 
	String encodedK=URLEncoder.encode(keyword);
		
		
	//CafeDto 객체에 startRowNum 과 endRowNum 을 담는다.
	MainFeedDto dto=new MainFeedDto();
	dto.setStartRowNum(startRowNum);
	dto.setEndRowNum(endRowNum);
	
	//ArrayList 객체의 참조값을 담을 지역변수를 미리 만든다.
	
	List<MainFeedDto> list=null;
	
	//전체 row 의 갯수를 담을 지역변수를 미리 만든다.
	int totalRow=0;

	//만일 검색 키워드가 넘어온다면 
	if(!keyword.equals("")){
		dto.setTag(keyword);
		list=MainFeedDao.getInstance().getListT(dto);
		totalRow=MainFeedDao.getInstance().getCountT(dto);
	}else{//검색 키워드가 넘어오지 않는다면
		//키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다. 
		list=MainFeedDao.getInstance().getList(dto);
		//키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
		totalRow=MainFeedDao.getInstance().getCount();
	}

	//하단 시작 페이지 번호 
	int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	//하단 끝 페이지 번호
	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	

	//전체 페이지의 갯수
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	//끝 페이지 번호가 전체 페이지 갯수보다 크다면 잘못된 값이다.
	if(endPageNum > totalPageCount){
		endPageNum=totalPageCount; //보정해 준다.
	}

	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
	a{
		text-decoration: none;
	}
	#acornstar {
		color:indigo;
	}
	a.update {
		color: black; 
		text-decoration: none;
	}
	a.delete {
		color: black; 
		text-decoration: none;
	}
	a.comment {
		color: black; 
		text-decoration: none;
	}
	.drag-area,.updrag-area{
      width: 200px;
      height: 300px;
      border: 2px dashed gray;
      border-radius: 20px;
   }

   #acornstar {
   		cursor:pointer;
   }
   
   .comments .comment-form{
		display: none;
	}

   ul, li {
   	list-style:none;
   	}

</style>
</head>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>

<jsp:include page="../include/navbar.jsp"></jsp:include>

<div class="container">
	<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4" style="margin-top:10px;">
		<%for(MainFeedDto tmp:list){%>
			<div id="card_front<%=tmp.getNum() %>" class="col item front front_feed">
				<div class="card h-100" style="width: 18rem;">
					<ul class="list-group list-group-flush">
					    <li class="list-group-item">
					    	<%if(tmp.getProfile() == null){ %>
								<svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
									  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
									  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
								</svg>
							<%}else{ %>
								<img class="profile-image" src="<%=tmp.getProfile()%>" style="width:20px; rounded;"/>
							<%} %>
					    	<%=tmp.getWriter() %>님이 작성한 글. 
					    	<a data-num="<%=tmp.getNum() %>" class="likeBtn"  href="javascript:">
					    		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="indigo" class="bi bi-suit-heart" viewBox="0 0 16 16">
								  <path d="m8 6.236-.894-1.789c-.222-.443-.607-1.08-1.152-1.595C5.418 2.345 4.776 2 4 2 2.324 2 1 3.326 1 4.92c0 1.211.554 2.066 1.868 3.37.337.334.721.695 1.146 1.093C5.122 10.423 6.5 11.717 8 13.447c1.5-1.73 2.878-3.024 3.986-4.064.425-.398.81-.76 1.146-1.093C14.446 6.986 15 6.131 15 4.92 15 3.326 13.676 2 12 2c-.777 0-1.418.345-1.954.852-.545.515-.93 1.152-1.152 1.595L8 6.236zm.392 8.292a.513.513 0 0 1-.784 0c-1.601-1.902-3.05-3.262-4.243-4.381C1.3 8.208 0 6.989 0 4.92 0 2.755 1.79 1 4 1c1.6 0 2.719 1.05 3.404 2.008.26.365.458.716.596.992a7.55 7.55 0 0 1 .596-.992C9.281 2.049 10.4 1 12 1c2.21 0 4 1.755 4 3.92 0 2.069-1.3 3.288-3.365 5.227-1.193 1.12-2.642 2.48-4.243 4.38z"/>
								</svg>
								<%=tmp.getUpCount()%>
					    	</a>
					    </li>
					</ul>
				  <img id="img<%=tmp.getNum() %>" src="<%=tmp.getImage() %>" class="card-img-top" style="
				         width: 80%;
				         height: 80%;
				         object-fit: contain;
				         margin:25px;
				   " >
				  <div id="content<%=tmp.getNum() %>"class="card-body" >
				    <p class="card-text">
				    	<%=tmp.getContent() %>
				    </p>
				  </div>
				  <ul class="list-group list-group-flush">
				    <li id="tag<%=tmp.getNum() %>" class="list-group-item" style="text-margin-left:10px;"><%=tmp.getTag() %></li>
				    <%if(tmp.getWriter().equals(id)){ %>
				    <li id="update<%=tmp.getNum() %>" class="list-group-item" style="text-margin-left:10px;">
				    		<!-- 피드 수정 -->
							<a data-num="<%=tmp.getNum() %>" class="update" data-bs-toggle="modal" data-bs-target="#updateModal" href="javascript:">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-exclamation-circle" viewBox="0 0 16 16">
								  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
								  <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
								</svg>
							</a>

							<!-- 피드 삭제 -->
							<a data-num="<%=tmp.getNum() %>" class="delete" href="javascript:">
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x-circle" viewBox="0 0 16 16">
								  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
								  <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
								</svg>
							</a>
				    </li>
				    <%} %>
				    <li class="list-group-item" >
				    	<a  data-num="<%=tmp.getNum() %>" class="commentBtn" href="javascript:">댓글</a>
				    </li>
				  </ul>
				</div>
			</div>
			<div id="card_back<%=tmp.getNum() %>" class="col item front back_comment" style="display:none;">
				<div class="card h-100" style="width: 18rem;">
					<ul class="list-group list-group-flush">
					    <li class="list-group-item">
					    	<%if(tmp.getProfile() == null){ %>
								<svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
									  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
									  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
								</svg>
							<%}else{ %>
								<img class="profile-image" src="<%=tmp.getProfile()%>" style="width:20px; rounded;"/>
							<%} %>
					    	<%=tmp.getWriter() %>님이 작성한 글.
					    	<a data-num="<%=tmp.getNum() %>" class="likeBtn"  href="javascript:">
					    		<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="indigo" class="bi bi-suit-heart" viewBox="0 0 16 16">
								  <path d="m8 6.236-.894-1.789c-.222-.443-.607-1.08-1.152-1.595C5.418 2.345 4.776 2 4 2 2.324 2 1 3.326 1 4.92c0 1.211.554 2.066 1.868 3.37.337.334.721.695 1.146 1.093C5.122 10.423 6.5 11.717 8 13.447c1.5-1.73 2.878-3.024 3.986-4.064.425-.398.81-.76 1.146-1.093C14.446 6.986 15 6.131 15 4.92 15 3.326 13.676 2 12 2c-.777 0-1.418.345-1.954.852-.545.515-.93 1.152-1.152 1.595L8 6.236zm.392 8.292a.513.513 0 0 1-.784 0c-1.601-1.902-3.05-3.262-4.243-4.381C1.3 8.208 0 6.989 0 4.92 0 2.755 1.79 1 4 1c1.6 0 2.719 1.05 3.404 2.008.26.365.458.716.596.992a7.55 7.55 0 0 1 .596-.992C9.281 2.049 10.4 1 12 1c2.21 0 4 1.755 4 3.92 0 2.069-1.3 3.288-3.365 5.227-1.193 1.12-2.642 2.48-4.243 4.38z"/>
								</svg>
								<%=tmp.getUpCount()%>
					    	</a>
					    </li>
					</ul>
				  <div id="cardBody<%=tmp.getNum() %>" class="card-body" style="overflow:auto; height:300px;">
				  	<%  //한 페이지에 몇개씩 표시할 것인지
					    	final int PAGE_ROW_COUNT2=100;

					    	//detail.jsp 페이지에서는 항상 1페이지의 댓글 내용만 출력한다. 
					    	int pageNum2=1;

					    	//보여줄 페이지의 시작 ROWNUM
					    	int startRowNum2=1+(pageNum2-1)*PAGE_ROW_COUNT2;
					    	//보여줄 페이지의 끝 ROWNUM
					    	int endRowNum2=pageNum2*PAGE_ROW_COUNT2;

					    	//원글의 글번호를 이용해서 해당글에 달린 댓글 목록을 얻어온다.
							FeedCommentDto commentDto=new FeedCommentDto();
							commentDto.setRef_group(tmp.getNum());
							//1페이지에 해당하는 startRowNum 과 endRowNum 을 dto 에 담아서  
							commentDto.setStartRowNum(startRowNum2);
							commentDto.setEndRowNum(endRowNum2);
							
							//1페이지에 해당하는 댓글 목록만 select 되도록 한다. 
							List<FeedCommentDto> commentList=
								FeedCommentDao.getInstance().getList(commentDto);%>
				    	<%for(FeedCommentDto mp: commentList){ %>
							<%if(mp.getDeleted().equals("yes")){ %>
								<li>삭제된 댓글 입니다.</li>
							<% 
								// continue; 아래의 코드를 수행하지 않고 for 문으로 실행순서 다시 보내기 
								continue;
							}%>
						
							<%if(mp.getNum() == mp.getComment_group()){ %>
								<li id="reli<%=mp.getNum()%>">
							<%}else{ %>
								<li id="reli<%=mp.getNum()%>" style="padding-left:50px;">
									<svg class="reply-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
					  					<path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z"/>
									</svg>
							<%} %>
									<dl>
										<dt>
											<%if(mp.getProfile() == null){ %>
												<svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="20" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
													  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
													  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
												</svg>
											<%}else{ %>
												<img class="profile-image" src="<%=mp.getProfile()%>" style="width:20px;height:20px;rounded;"/>
											<%} %>
												<span><%=mp.getWriter() %></span>
											<%if(mp.getNum() != mp.getComment_group()){ %>
												@<i><%=mp.getTarget_id() %></i>
											<%} %>
												<span><%=mp.getRegdate() %></span>
												<a data-num="<%=mp.getNum() %>" class="reply-link" href="javascript:" >답글</a>
											<%if(id != null && mp.getWriter().equals(id)){ %>
												<a data-num="<%=mp.getNum() %>" class="update-link" href="javascript:">수정</a>
												<a data-num="<%=mp.getNum() %>" class="delete-link" href="javascript:">삭제</a>
											<%} %>
										</dt>
										<dd>
											<pre id="pre<%=mp.getNum()%>"><%=mp.getContent() %></pre>						
										</dd>
									</dl>	
									<form id="reForm<%=mp.getNum() %>" class="reComment animate__animated comment-form re-insert-form" 
										action="comment_insert.jsp" method="post" style="display:none;">
										<input type="hidden" name="ref_group"
											value="<%=tmp.getNum() %>"/>
										<input type="hidden" name="target_id"
											value="<%=mp.getWriter()%>"/>
										<input type="hidden" name="comment_group"
											value="<%=mp.getComment_group()%>"/>
										<textarea name="content"></textarea>
										<button type="submit">등록</button>
									</form>	
									<%if(mp.getWriter().equals(id)){ %>	
										<form id="updateForm<%=mp.getNum() %>" class="comment-form update-form" 
											action="comment_update.jsp" method="post" style="display:none;">
											<input type="hidden" name="num" value="<%=mp.getNum() %>" />
											<textarea name="content"><%=mp.getContent() %></textarea>
											<button type="submit">수정</button>
										</form>
									<%} %>						
							</li>
						<%} %>
				  </div>
				  <ul class="list-group list-group-flush">
				    <li class="list-group-item" >
					    <form class="comment-form insert-form comment" action="comment_insert.jsp" method="post">
							<!-- 원글의 글번호가 댓글의 ref_group 번호가 된다. -->
							<input type="hidden" name="ref_group" value="<%=tmp.getNum()%>"/>
							<!-- 원글의 작성자가 댓글의 대상자가 된다. -->
							<input type="hidden" name="target_id" value="<%=tmp.getWriter()%>"/>
							
							<textarea   name="content"></textarea>
							<button data-num="<%=tmp.getNum() %>" type="submit">등록</button>
						</form>
				    	<a  data-num="<%=tmp.getNum() %>" class="feedBtn" href="javascript:">피드</a>
				    </li>
				  </ul>
				</div>
			</div>
		<%} %>
	</div>
	<div style="display:flex; justify-content:center; margin-top:30px;">
		<nav aria-label="Page navigation example">
			<ul class="pagination">
				<%if(startPageNum != 1){ %>
					<li class="page-item">
						<a href="main.jsp?pageNum=<%=startPageNum-1 %>&condition=<%=condition %>&keyword=<%=encodedK %>">Prev</a>
					</li>	
				<%} %>
				
				<%for(int i=startPageNum; i<=endPageNum ; i++){ %>
					<li class="page-item">
						<%if(pageNum == i){ %>
							<a class="active page-link"  href="main.jsp?pageNum=<%=i %>&condition=<%=condition %>&keyword=<%=encodedK %>"><%=i %></a>
						<%}else{ %>
							<a class="page-link" href="main.jsp?pageNum=<%=i %>&condition=<%=condition %>&keyword=<%=encodedK %>"><%=i %></a>
						<%} %>
					</li>	
				<%} %>
				<%if(endPageNum < totalPageCount){ %>
					<li class="page-item">
						<a class="page-link" href="main.jsp?pageNum=<%=endPageNum+1 %>&condition=<%=condition %>&keyword=<%=encodedK %>">Next</a>
					</li>
				<%} %>
			</ul>
		</nav>
	</div>
	<div style="display:flex; justify-content:center; margin-bottom:50px;">
		<form action="main.jsp" method="get"> 
			<input type="text" id="keyword" name="keyword" placeholder="검색어..." value="<%=keyword%>"/>
			<button type="submit">검색</button>
		</form>	
		
		<%if(!keyword.equals("")){ %>
			<p>
				<strong><%=totalRow %></strong> 개의 글이 검색 되었습니다.
			</p>
		<%} %>
	</div>
</div>
	
	
	<!-- Button trigger modal -->
	<button style="display:none;" id="modalBtn" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal"></button>
	
	<!-- Modal -->
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">NEW CONTENTS</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        <form action="main_insert.jsp" method="post" id="insertForm">
	        	<div class="drag-area"><img id="myImage" style="
			         width: 100%;
			         height: 100%;
			         object-fit: contain;
			   "/></div>
	        	<label class="form-label" for="image">IMAGE</label>
				<textarea style="display:none;" class="form-control"  name="image" id="image"></textarea>

				<div class="mb-3">
					<label class="form-label" for="content">CONTENT</label>
					<textarea class="form-control"  name="content" id="content"></textarea>
				</div>
				
				<div class="mb-3">
					<label class="form-label" for="tag">TAG</label>
					<input class="form-control" type="text" name="tag" id="tag"/>
				</div>
				<button class="btn " style="color: #6610f2;" type="submit"><img style="width:50px; display:inline-block;" src="${pageContext.request.contextPath}/image/roket.gif" alt="" />SAVE</button>
			</form>
	      </div>
	    </div>
	  </div>
	</div>
		<!-- Button trigger modal -->
<button style="display:none;" id="modalUpdateBtn" type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#updateModal"></button>

<!-- Modal -->
<div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="updateModalLabel">UPDATE CONTENTS</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form action="update.jsp" method="post" id="insertForm">
        	<div style="width:200px;height:300px;radius:20px;"><img id="upImage" style="
		         width: 100%;
		         height: 100%;
		         object-fit: contain; 
		   "/></div>
		    <input type="hidden" name="num" id="num"/>
        	<label class="form-label" for="updateImage"></label>
			<textarea style="display:none;" class="form-control"  name="updateImage" id="updateImage"></textarea>
			<div class="mb-3">
				<label class="form-label" for="content">CONTENT</label>
				<textarea id="updateContent" class="form-control"  name="content" ></textarea>
			</div>
			<div class="mb-3">
				<label class="form-label" for="tag">TAG</label>
				<input id="updateTag" class="form-control" type="text" name="tag" />
			</div>
			<button class="btn " style="color: #6610f2;" type="submit">SAVE</button>
		</form>
      </div>
    </div>
  </div>
</div>
  	
<script>
		
		// 로그아웃 버튼을 눌렀을 때 수행되는 기능
		document.querySelector("#logout").addEventListener("click", function(e){
			let logout=confirm("정말로 로그아웃하시겠습니까?");
			if(!logout){
				e.preventDefault();
			}
		});
		
		// 글 삭제 버튼을 눌렀을 때 진행되는 ajax가 일어나는 event listener 달아주기
		let deleteLinks=document.querySelectorAll(".delete");
		for(let i=0; i<deleteLinks.length; i++){
			deleteLinks[i].addEventListener("click", function(){
				let num=this.getAttribute("data-num");
				let isdelete=confirm("정말로 이 게시글을 삭제하시겠습니까?");
				if(isdelete){
					ajaxPromise("delete.jsp", "post", "num="+num)
					.then(function(response){
						return response.json();
					}).then(function(data){
						console.log(data);
						if(data.isDeleted){
							alert("게시글을 삭제하였습니다.");
							location.href="${pageContext.request.contextPath}/main/main.jsp";
						} else {
							alert("게시글을 삭제하지 못했습니다.");
							location.href="${pageContext.request.contextPath}/main/main.jsp";
						}
					});
				}				
			});
		}
		
		//업데이트 폼 작성 하기위한 데이터 가져오기
		let updateLinks=document.querySelectorAll(".update");
		for(let i=0; i<updateLinks.length; i++){
			updateLinks[i].addEventListener("click", function(){
				let num=this.getAttribute("data-num");
				ajaxPromise("updateForm.jsp", "post", "num="+num)
				.then(function(response){
					return response.json();
				}).then(function(data){
					console.log(data);
					document.querySelector("#upImage").setAttribute("src", data.image);
					document.querySelector("#updateImage").value=data.image;
					document.querySelector("#updateContent").value=data.content;
					document.querySelector("#updateTag").value=data.tag;
					document.querySelector("#num").value=data.num;
				});				
			});
		}
		
		
		//네비바 새글 입력 누르면 modal 버튼 누르도록 이벤트 등록
		document.querySelector("#write").addEventListener("click",function(){
			document.querySelector("#modalBtn").click();
		});
		
		
		// dragenter 이벤트가 일어 났을때 실행할 함수 등록 
		   document.querySelector(".drag-area")
		      .addEventListener("dragenter", function(e){
		         // drop 이벤트까지 진행될수 있도록 기본 동작을 막는다.
		         e.preventDefault();
		      });
		   
		   // dragover 이벤트가 일어 났을때 실행할 함수 등록 
		   document.querySelector(".drag-area")
		   .addEventListener("dragover", function(e){
		      // drop 이벤트까지 진행될수 있도록 기본 동작을 막는다.
		      e.preventDefault();
		   });
		   
		   document.querySelector(".drag-area")
		   .addEventListener("drop", function(e){
		      
		      e.preventDefault();
		      //drop 된 파일의 여러가지 정보를 담고 있는 object 
		      const data = e.dataTransfer;
		      //drop 된 파일객체를 저장하고 있는 배열
		      const files = data.files;
		      
		      // input 요소에 drop 된 파일정보를 넣어준다. 
		      document.querySelector("#image").files = files;
		      // 한개만 drop 했다는 가정하에서 drop 된 파일이 이미지 파일인지 여부 알아내기
		      const reg=/image.*/;
		      const file = files[0];
		      //drop 된 파일의 mime type 확인해 보기
		      console.log(file.type);
		      if(file.type.match(reg)){
		         console.log("이미지 파일 이네요!");
		         readImageFile(file);
		      }else{
		         console.log("이미지 파일이 아니네요!");
		      }
		   });
		   
		   function readImageFile(file){
		      const reader=new FileReader();
		      //이미지 파일을 data url 형식으로 읽어들이기
		      reader.readAsDataURL(file);
		      //다 읽었을때 실행할 함수 등록 
		      reader.onload=function(e){
		         //읽은 이미지 데이터 ( img 요소의 src 속성의 value 로 지정하면 이미지가 나온다. )
		         console.log(e.target.result);
		         document.querySelector("#myImage")
		            .setAttribute("src", e.target.result);
		         
		         document.querySelector("#image").innerText=e.target.result;
		      };
		   }
	
	/* acronstar 클릭하면 music main 으로 이동*/
	document.querySelector("#acornstar").addEventListener("click",function(e){
		e.preventDefault();
		location.href="${pageContext.request.contextPath}/music/musicMain.jsp";
	});
	
	let comment_submitLinks=document.querySelectorAll(".comment");
	for(let i=0; i<comment_submitLinks.length; i++){
		comment_submitLinks[i].addEventListener("submit", function(e){
			e.preventDefault();
			ajaxFormPromise(this)
			.then(function(response){
				return response.json();
			})
			.then(function(data){
				if(data.isSuccess){
					alert("댓글이 등록되었습니다.");
					location.href="${pageContext.request.contextPath}/main/main.jsp";
				} else {
					alert("댓글이 등록이 실패 하였습니다.");
				}
			});
		});
	};
	
	let recomment_submitLinks=document.querySelectorAll(".reComment");
	for(let i=0; i<recomment_submitLinks.length; i++){
		recomment_submitLinks[i].addEventListener("submit", function(e){
			e.preventDefault();
			ajaxFormPromise(this)
			.then(function(response){
				return response.json();
			})
			.then(function(data){
				if(data.isSuccess){
					alert("댓글이 등록되었습니다.");
					location.href="${pageContext.request.contextPath}/main/main.jsp";
				} else {
					alert("댓글이 등록이 실패 하였습니다.");
				}
			});
		});
	};
	
	/*
	detail.jsp 페이지 로딩 시점에 만들어진 1 페이지에 해당하는 
	댓글에 이벤트 리스너 등록 하기 
	*/
	addUpdateFormListener(".update-form");
	addUpdateListener(".update-link");
	addDeleteListener(".delete-link");
	addReplyListener(".reply-link");
	
	//인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수 
	function addUpdateListener(sel){
		//댓글 수정 링크의 참조값을 배열에 담아오기 
		// sel 은  ".page-xxx  .update-link" 형식의 내용이다 
		let updateLinks=document.querySelectorAll(sel);
		for(let i=0; i<updateLinks.length; i++){
			updateLinks[i].addEventListener("click", function(){
				//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
				const num=this.getAttribute("data-num"); //댓글의 글번호
				document.querySelector("#updateForm"+num).style.display="block";
			});
		}
	}
	
	function addDeleteListener(sel){
		//댓글 삭제 링크의 참조값을 배열에 담아오기 
		let deleteLinks=document.querySelectorAll(sel);
		for(let i=0; i<deleteLinks.length; i++){
			deleteLinks[i].addEventListener("click", function(){
				//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
				const num=this.getAttribute("data-num"); //댓글의 글번호
				const isDelete=confirm("댓글을 삭제 하시겠습니까?");
				if(isDelete){
					// gura_util.js 에 있는 함수들 이용해서 ajax 요청
					ajaxPromise("comment_delete.jsp", "post", "num="+num)
					.then(function(response){
						return response.json();
					})
					.then(function(data){
						//만일 삭제 성공이면 
						if(data.isSuccess){
							//댓글이 있는 곳에 삭제된 댓글입니다를 출력해 준다. 
							document.querySelector("#reli"+num).innerText="삭제된 댓글입니다.";
						}
					});
				}
			});
		}
	}
	
	function addReplyListener(sel){
		//댓글 링크의 참조값을 배열에 담아오기 
		let replyLinks=document.querySelectorAll(sel);
		//반복문 돌면서 모든 링크에 이벤트 리스너 함수 등록하기
		for(let i=0; i<replyLinks.length; i++){
			replyLinks[i].addEventListener("click", function(){
				
				//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
				const num=this.getAttribute("data-num"); //댓글의 글번호
				
				const form=document.querySelector("#reForm"+num);
				
				//현재 문자열을 읽어온다 ( "답글" or "취소" )
				let current = this.innerText;
				
				if(current == "답글"){
					//번호를 이용해서 댓글의 댓글폼을 선택해서 보이게 한다. 
					form.style.display="block";
					form.classList.add("animate__flash");
					this.innerText="취소";	
					form.addEventListener("animationend", function(){
						form.classList.remove("animate__flash");
					}, {once:true});
				}else if(current == "취소"){
					form.classList.add("animate__fadeOut");
					this.innerText="답글";
					form.addEventListener("animationend", function(){
						form.classList.remove("animate__fadeOut");
						form.style.display="none";
					},{once:true});
				}
			});
		}
	}

	function addUpdateFormListener(sel){
		//댓글 수정 폼의 참조값을 배열에 담아오기
		let updateForms=document.querySelectorAll(sel);
		for(let i=0; i<updateForms.length; i++){
			//폼에 submit 이벤트가 일어 났을때 호출되는 함수 등록 
			updateForms[i].addEventListener("submit", function(e){
				//submit 이벤트가 일어난 form 의 참조값을 form 이라는 변수에 담기 
				const form=this;
				//폼 제출을 막은 다음 
				e.preventDefault();
				//이벤트가 일어난 폼을 ajax 전송하도록 한다.
				ajaxFormPromise(form)
				.then(function(response){
					return response.json();
				})
				.then(function(data){
					if(data.isSuccess){
						/*
							document.querySelector() 는 html 문서 전체에서 특정 요소의 
							참조값을 찾는 기능
							
							특정문서의 참조값.querySelector() 는 해당 문서 객체의 자손 요소 중에서
							특정 요소의 참조값을 찾는 기능
						*/
						const num=form.querySelector("input[name=num]").value;
						const content=form.querySelector("textarea[name=content]").value;
						//수정폼에 입력한 value 값을 pre 요소에도 출력하기 
						document.querySelector("#pre"+num).innerText=content;
						form.style.display="none";
					}
				});
			});
		}
	}
	
	let comment_btnLinks=document.querySelectorAll(".commentBtn");
	for(let i=0; i<comment_btnLinks.length; i++){
		comment_btnLinks[i].addEventListener("click", function(e){
			let num=this.getAttribute("data-num");
			document.querySelector("#card_front"+num).style.display="none";
			document.querySelector("#card_back"+num).style.display="block";
		});
	};
	
	let feed_btnLinks=document.querySelectorAll(".feedBtn");
	for(let i=0; i<feed_btnLinks.length; i++){
		feed_btnLinks[i].addEventListener("click", function(e){
			let num=this.getAttribute("data-num");
			document.querySelector("#card_front"+num).style.display="block";
			document.querySelector("#card_back"+num).style.display="none";
		});
	};
	
	let like_btnLinks=document.querySelectorAll(".likeBtn");
	for(let i=0; i<like_btnLinks.length; i++){
		like_btnLinks[i].addEventListener("click", function(e){
			//좋아요 클릭한 게시글의 글 넘버 가져오기
			//글 넘버를 넘겨주어 글에 해당하는 좋아요 누른 아이디 배열 가져오기
			//좋아요 아이디 배열에서 현재 좋아요 누른 아이디가 있는지 검사하여 있다면 카운트를 올리지않고
			//없다면 아이디를 배열에 넣고 upcount 올리기
			
			let num=this.getAttribute("data-num");
			ajaxPromise("upmember.jsp", "post", "num="+num)
			.then(function(response){
				return response.json();
			})
			.then(function(data){
				//게시글의 좋아요를 누른 아이디 문자열 가져오기
				let beforeMember = data.upMember; //좋아요 누른 아이디 문자열
				console.log(data.upMember);
				// 좋아요 누른 아이디가 하나도 없다면
				let num = data.num;
				if(data.upMember==""){
					// 배열 만들기
					beforMember = [];
					// 배열에 좋아요 누른 아이디 추가
					beforMember.push("<%=id%>");
					let member=beforMember.join();
					console.log(member);
					ajaxPromise("upcount.jsp","post","upmember="+member+"&num="+num)
					.then(function(response){
						return response.json();
					})
					.then(function(data){
						if(data.isSuccess){
							//댓글이 있는 곳에 삭제된 댓글입니다를 출력해 준다. 
							alert("좋아요.");
							location.href="${pageContext.request.contextPath}/main/main.jsp";
						}
					});
				} else {
					//배열로 만들기
					let member = beforeMember.split(",");
					console.log("else"+member);
					if(!member.includes("<%=id%>")){
						member.push("<%=id%>");
						let upmember=member.join();
						
						ajaxPromise("upcount.jsp","post","upmember="+upmember+"&num="+num)
						.then(function(response){
							return response.json();
						})
						.then(function(data){
							if(data.isSuccess){
								//댓글이 있는 곳에 삭제된 댓글입니다를 출력해 준다. 
								alert("좋아요.");
								location.href="${pageContext.request.contextPath}/main/main.jsp";
							}
						});
					}else{
						alert("중복할 수 없습니다.");
					}	
				};
			});
		});
	};
</script>
</body>
</html>