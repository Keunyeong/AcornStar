<%@page import="test.suggest.dao.SuggestCommentDao"%>
<%@page import="test.suggest.dto.SuggestCommentDto"%>
<%@page import="test.suggest.dto.SuggestDto"%>
<%@page import="test.suggest.dao.SuggestDao"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//자세히 보여줄 글번호를 읽어온다. 
	int num=Integer.parseInt(request.getParameter("num"));
	//조회수 올리기
	SuggestDao.getInstance().addViewCount(num);
	
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
	//SuggestDto 객체를 생성해서 
	SuggestDto dto=new SuggestDto();
	//자세히 보여줄 글번호를 넣어준다. 
	dto.setNum(num);
	//만일 검색 키워드가 넘어온다면 
	if(!keyword.equals("")){
		//검색 조건이 무엇이냐에 따라 분기 하기
		if(condition.equals("title_content")){//제목 + 내용 검색인 경우
			//검색 키워드를 SuggestDto 에 담아서 전달한다.
			dto.setTitle(keyword);
			dto.setContent(keyword);
			dto=SuggestDao.getInstance().getDataTC(dto);
		}else if(condition.equals("title")){ //제목 검색인 경우
			dto.setTitle(keyword);
			dto=SuggestDao.getInstance().getDataT(dto);
		}else if(condition.equals("writer")){ //작성자 검색인 경우
			dto.setWriter(keyword);
			dto=SuggestDao.getInstance().getDataW(dto);
		} // 다른 검색 조건을 추가 하고 싶다면 아래에 else if() 를 계속 추가 하면 된다.
	}else{//검색 키워드가 넘어오지 않는다면
		dto=SuggestDao.getInstance().getData(dto);
	}
	//특수기호를 인코딩한 키워드를 미리 준비한다. 
	String encodedK=URLEncoder.encode(keyword);
	
	
	//로그인된 아이디 (로그인을 하지 않았으면 null 이다)
	String id=(String)session.getAttribute("id");
	//로그인 여부
	boolean isLogin=false;
	if(id != null){
		isLogin=true;
	}
	
	/*
		[ 댓글 페이징 처리에 관련된 로직 ]
	*/
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=10;
	
	//detail.jsp 페이지에서는 항상 1페이지의 댓글 내용만 출력한다. 
	int pageNum=1;
	
	//보여줄 페이지의 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT;
	
	//원글의 글번호를 이용해서 해당글에 달린 댓글 목록을 얻어온다.
	SuggestCommentDto commentDto=new SuggestCommentDto();
	commentDto.setRef_group(num);
	//1페이지에 해당하는 startRowNum 과 endRowNum 을 dto 에 담아서  
	commentDto.setStartRowNum(startRowNum);
	commentDto.setEndRowNum(endRowNum);
	
	//1페이지에 해당하는 댓글 목록만 select 되도록 한다. 
	List<SuggestCommentDto> commentList=
			SuggestCommentDao.getInstance().getList(commentDto);
	
	//원글의 글번호를 이용해서 댓글 전체의 갯수를 얻어낸다.
	int totalRow=SuggestCommentDao.getInstance().getCount(num);
	//댓글 전체 페이지의 갯수
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	
	//글정보를 응답한다.
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/suggest/detail.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700&display=swap" rel="stylesheet">
<style>	
	body {
		font-family: 'Nanum Gothic', sans-serif;
		font-size: 15px;
	}

	/* 스크롤 안보이게 */	
	::-webkit-scrollbar {
	  display: none;
	}
	
	/* 상단, 하단 나눠서 정렬하려고 감싼 태그 */
	.container {
		display: flex;
		flex-direction:column;
		align-items:center;
		width: 100vw;
	}
	
	/* 콘텐츠 박스*/
   .content{
      border-bottom: 1px solid gray;
      width:830px;
      height:300px;
      overflow:auto;
      padding: 10px;
      margin: 0 auto;
      padding-top: 30px;
      margin-bottom: 20px;
   }
   
   /* 댓글 프로필 이미지를 작은 원형으로 만든다. */
   .profile-image{
      width: 50px;
      height: 50px;
      border: 1px solid #cecece;
      border-radius: 50%;
   }
   /* ul 요소의 기본 스타일 제거 */
   .comments ul{
      padding: 0;
      margin: 0;
      list-style-type: none;
   }
   .comments dt{
      margin-top: 5px;
   }
   .comments dd{
      margin-left: 50px;
   }
   .comment-form textarea, .comment-form button{
      float: left;
   }
   .comments li{
      clear: left;
   }

   .comment-form textarea{
      width: 700px;
      height: 50px;
      border-radius: 5px;
      margin-bottom:20px;
   }
   .comment-form button{
      width: 50px;
      height: 50px;
      border-radius: 25px;
      border: none;
      outline: none;
      margin-left: 15px;
      transition: all 0.3s ease-out;
   }
   
   .comment-form button:hover{
   		background-color: #c465f0;
   		color: #fff;
   }
   
   /* 댓글에 댓글을 다는 폼과 수정폼은 일단 숨긴다. */
   .comments .comment-form{
      display: none;
   }
   /* .reply_icon 을 li 요소를 기준으로 배치 하기 */
   .comments li{
      position: relative;
   }
   .comments .reply-icon{
      position: absolute;
      top: 1em;
      left: 1em;
      color: red;
   }
   
   /* 댓글창 설정 */
   pre {
     display: block;
     padding: 9.5px;
     margin: 0 0 10px;
     font-size: 13px;
     line-height: 1.42857143;
     color: #333333;
     word-break: break-all;
     word-wrap: break-word;
     border: 2px solid #c465f0;
     border-radius: 4px;
   }   
   
   .loader{
      /* 로딩 이미지를 가운데 정렬하기 위해 */
      text-align: center;
      /* 일단 숨겨 놓기 */
      display: none;
   }   
   
   .loader svg{
      animation: rotateAni 1s ease-out infinite;
   }
   
	/* 상단 detail_contents(제목, 조회수 등) 감싸서 정렬한 태그*/
	.detail_box {
		display:flex;
		align-items: center;
		margin:0 auto;
		border-top: 2px solid gray;
		border-bottom: 1px solid gray;
		margin-top: 30px;
		width:830px;
		justify-content:space-around;
	}
	
	/* 상단 제목,작성자 등.. */
	.detail_contents {
		display:inline-block;
		padding: 5px 15px;
		font-size: 15px;
		align-items:center;
	}
	
	.detail_contents > td {
		font-size: 14px;
		color: gray;
	}
	
	/*상단 '제목'만 width 넓게 설정*/
	.contents_title {
		padding: 5px 30px;
	}
	
	/*콘텐츠 하단 글 수정, 삭제, 목록보기*/
	.detail_ul {
		list-style:none;
		display:flex;
		flex-direction:row;
		margin: 0px auto;
		color:#c465f0;
		padding-left: 820px;
	}
	
	.detail_ul > li {
		margin-left:10px;
	}
	
	.detail_ul > li > div {
		font-size: 13px;
		cursor: pointer;
	}
	
	.detail_ul > li > div:hover {
		font-size: 13px;
		cursor: pointer;
		font-weight:bold;
	}
	
	/* 하단 이전글, 다음글로 넘어가기 */
	.page_change > a > svg{
		margin:15px;
	}

	/* 댓글창 수정 답글 삭제 */
	.comments_dt > a {
		text-decoration: none;
		color: gray;
		margin-left:10px;
		font-size:13px;
	}
</style>
</head>
<body>
<jsp:include page="../include/navbar.jsp"></jsp:include>
 
 
<div class="container" style="width:950px; margin-top:20px;">

<!-- 글 상단 정보  -->
	<table class="detail_box" style="width:950px;">
      <tr class="detail_contents">
         <th>글번호</th> 
         <td><%=dto.getNum() %></td>
      </tr>
      <tr class="detail_contents">
         <th>작성자</th>
         <td><%=dto.getWriter() %></td>
      </tr>
      <tr class="detail_contents contents_title">
         <th>제목</th>
         <td><%=dto.getTitle() %></td>
      </tr>
      <tr class="detail_contents ">
         <th >조회수</th>
         <td><%=dto.getViewCount() %></td>
      </tr>
      <tr class="detail_contents">
         <th>등록일</th>
         <td><%=dto.getRegdate() %></td>
      </tr>
	</table>
	
<!-- 글 작성 컨텐츠 -->
	<div class="content" style="width:950px;"><%=dto.getContent() %></div>
	
<!-- 컨텐츠 박스 하단 리스트 -->
	   <ul class="detail_ul" style="width:950px;">
	      	<li><div onclick="location.href='list.jsp'">목록보기</a></li>
	      <%if(dto.getWriter().equals(id)){ %>
	         <li><div onclick="location.href='private/update_form.jsp?num=<%=dto.getNum()%>'">수정</a></li>
	         <li><div onclick="location.href='private/delete.jsp?num=<%=dto.getNum()%>'">삭제</a></li>
	      <%} %>
	   </ul>
</div>
   
<div class="container" >
<!-- 이전글, 다음글로 넘기는 아이콘 -->
	<div class="page_change" style="display:flex; flex-direction:row;">
	   <%if(dto.getPrevNum()!=0){ %>
	      <a  href="detail.jsp?num=<%=dto.getPrevNum() %>&keyword=<%=encodedK %>&condition=<%=condition%>">
	      	<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="gray" class="bi bi-chevron-left" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
			</svg>
	      </a>
	   <%} %>
	   <%if(dto.getNextNum()!=0){ %>
	      <a href="detail.jsp?num=<%=dto.getNextNum() %>&keyword=<%=encodedK %>&condition=<%=condition%>">
	      	<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="gray" class="bi bi-chevron-right" viewBox="0 0 16 16">
			  <path fill-rule="evenodd" d="M4.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L10.293 8 4.646 2.354a.5.5 0 0 1 0-.708z"/>
			</svg>
	      </a>
	   <%} %>
	</div>
   
<!-- 댓글 목록 -->
   <div class="comments" style="width:800px;">
      <ul>
         <%for(SuggestCommentDto tmp: commentList){ %>
            <%if(tmp.getDeleted().equals("yes")){ %>
               <li>삭제된 댓글 입니다.</li>
            <% 
               // continue; 아래의 코드를 수행하지 않고 for 문으로 실행순서 다시 보내기 
               continue;
            }%>
         
            <%if(tmp.getNum() == tmp.getComment_group()){ %>
            <li id="reli<%=tmp.getNum()%>">
            <%}else{ %>
            <li id="reli<%=tmp.getNum()%>" style="padding-left:50px;">
               <svg class="reply-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z"/>
               </svg>
            <%} %>
               <dl>
                  <dt class="comments_dt">
                  <%if(tmp.getProfile() == null){ %>
                     <svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
                          <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                          <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
                     </svg>
                  <%}else{ %>
                     <img class="profile-image" src="<%=tmp.getProfile()%>"/>
                  <%} %>
                     <span><%=tmp.getWriter() %></span>
                  <%if(tmp.getNum() != tmp.getComment_group()){ %>
                     <i><%=tmp.getTarget_id() %></i>
                  <%} %>
                     <a data-num="<%=tmp.getNum() %>" href="javascript:" class="reply-link">답글</a>
                  <%if(id != null && tmp.getWriter().equals(id)){ %>
                     <a data-num="<%=tmp.getNum() %>" class="update-link" href="javascript:">수정</a>
                     <a data-num="<%=tmp.getNum() %>" class="delete-link" href="javascript:">삭제</a>
                  <%} %>
                  </dt>
                  <dd>
                     <pre id="pre<%=tmp.getNum()%>"><%=tmp.getContent() %></pre>                  
                  </dd>
               </dl>   
               <form id="reForm<%=tmp.getNum() %>" class="animate__animated comment-form re-insert-form" 
                  action="private/comment_insert.jsp" method="post">
                  <input type="hidden" name="ref_group"
                     value="<%=dto.getNum()%>"/>
                  <input type="hidden" name="target_id"
                     value="<%=tmp.getWriter()%>"/>
                  <input type="hidden" name="comment_group"
                     value="<%=tmp.getComment_group()%>"/>
                  <textarea name="content"></textarea>
                  <button type="submit">등록</button>
               </form>   
               <%if(tmp.getWriter().equals(id)){ %>   
               <form id="updateForm<%=tmp.getNum() %>" class="comment-form update-form" 
                  action="private/comment_update.jsp" method="post">
                  <input type="hidden" name="num" value="<%=tmp.getNum() %>" />
                  <textarea name="content"><%=tmp.getContent() %></textarea>
                  <button type="submit">수정</button>
               </form>
               <%} %>                  
            </li>
         <%} %>
      </ul>
   </div>
   <div class="loader">
      <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" fill="currentColor" class="bi bi-arrow-clockwise" viewBox="0 0 16 16">
           <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/>
           <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/>
      </svg>
   </div>
   
<!-- 원글에 댓글을 작성할 폼 -->
   <form class="comment-form insert-form" action="private/comment_insert.jsp" method="post">
      <!-- 원글의 글번호가 댓글의 ref_group 번호가 된다. -->
      <input type="hidden" name="ref_group" value="<%=num%>"/>
      <!-- 원글의 작성자가 댓글의 대상자가 된다. -->
      <input type="hidden" name="target_id" value="<%=dto.getWriter()%>"/>
      
      <textarea name="content"><%if(!isLogin){%>댓글 작성을 위해 로그인이 필요 합니다.<%}%></textarea>
      <button type="submit">등록</button>
   </form>
</div>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
<script>
   //클라이언트가 로그인 했는지 여부
   let isLogin=<%=isLogin%>;
   
   document.querySelector(".insert-form")
      .addEventListener("submit", function(e){
         //만일 로그인 하지 않았으면 
         if(!isLogin){
            //폼 전송을 막고 
            e.preventDefault();
            //로그인 폼으로 이동 시킨다.
            location.href=
               "${pageContext.request.contextPath}/index.jsp?url=${pageContext.request.contextPath}/info/detail.jsp?num=<%=num%>";
         }
      });
   
   /*
      detail.jsp 페이지 로딩 시점에 만들어진 1 페이지에 해당하는 
      댓글에 이벤트 리스너 등록 하기 
   */
   addUpdateFormListener(".update-form");
   addUpdateListener(".update-link");
   addDeleteListener(".delete-link");
   addReplyListener(".reply-link");
   
   
   //댓글의 현재 페이지 번호를 관리할 변수를 만들고 초기값 1 대입하기
   let currentPage=1;
   //마지막 페이지는 totalPageCount 이다.  
   let lastPage=<%=totalPageCount%>;
   
   //추가로 댓글을 요청하고 그 작업이 끝났는지 여부를 관리할 변수 
   let isLoading=false; //현재 로딩중인지 여부 
   
   /*
      window.scrollY => 위쪽으로 스크롤된 길이
      window.innerHeight => 웹브라우저의 창의 높이
      document.body.offsetHeight => body 의 높이 (문서객체가 차지하는 높이)
   */
   window.addEventListener("scroll", function(){
      //바닥 까지 스크롤 했는지 여부 
      const isBottom = 
         window.innerHeight + window.scrollY  >= document.body.offsetHeight;
      //현재 페이지가 마지막 페이지인지 여부 알아내기
      let isLast = currentPage == lastPage;   
      //현재 바닥까지 스크롤 했고 로딩중이 아니고 현재 페이지가 마지막이 아니라면
      if(isBottom && !isLoading && !isLast){
         //로딩바 띄우기
         document.querySelector(".loader").style.display="block";
         
         //로딩 작업중이라고 표시
         isLoading=true;
         
         //현재 댓글 페이지를 1 증가 시키고 
         currentPage++;
         
         /*
            해당 페이지의 내용을 ajax 요청을 통해서 받아온다.
            "pageNum=xxx&num=xxx" 형식으로 GET 방식 파라미터를 전달한다. 
         */
         ajaxPromise("ajax_comment_suggest.jsp","get",
               "pageNum="+currentPage+"&num=<%=num%>")
         .then(function(response){
            //json 이 아닌 html 문자열을 응답받았기 때문에  return response.text() 해준다.
            return response.text();
         })
         .then(function(data){
            //data 는 html 형식의 문자열이다. 
            console.log(data);
            // beforebegin | afterbegin | beforeend | afterend
            document.querySelector(".comments ul")
               .insertAdjacentHTML("beforeend", data);
            //로딩이 끝났다고 표시한다.
            isLoading=false;
            //새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 이벤트 리스너 등록 하기 
            addUpdateListener(".page-"+currentPage+" .update-link");
            addDeleteListener(".page-"+currentPage+" .delete-link");
            addReplyListener(".page-"+currentPage+" .reply-link");
            //새로 추가된 댓글 li 요소 안에 있는 댓글 수정폼에 이벤트 리스너 등록하기
            addUpdateFormListener(".page-"+currentPage+" .update-form");
            
            //로딩바 숨기기
            document.querySelector(".loader").style.display="none";
         });
      }
   });
   
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
               ajaxPromise("private/comment_delete.jsp", "post", "num="+num)
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
            
            if(!isLogin){
               const isMove=confirm("로그인이 필요 합니다. 로그인 페이지로 이동 하시겠습니까?");
               if(isMove){
                  location.href=
                     "${pageContext.request.contextPath}/index.jsp?url=${pageContext.request.contextPath}/suggest/detail.jsp?num=<%=num%>";
               }
               return;
            }
            
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
   document.querySelector("#newWrite").style.display="none";
</script>
</body>
</html>