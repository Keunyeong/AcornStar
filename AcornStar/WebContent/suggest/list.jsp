<%@page import="test.suggest.dao.SuggestDao"%>
<%@page import="test.suggest.dto.SuggestDto"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   //한 페이지에 몇개씩 표시할 것인지
   final int PAGE_ROW_COUNT=5;
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
      
   //SuggestDto 객체에 startRowNum 과 endRowNum 을 담는다.
   SuggestDto dto=new SuggestDto();
   dto.setStartRowNum(startRowNum);
   dto.setEndRowNum(endRowNum);

   //ArrayList 객체의 참조값을 담을 지역변수를 미리 만든다.
   List<SuggestDto> list=null;
   //전체 row 의 갯수를 담을 지역변수를 미리 만든다.
   int totalRow=0;
   //만일 검색 키워드가 넘어온다면 
   if(!keyword.equals("")){
      //검색 조건이 무엇이냐에 따라 분기 하기
      if(condition.equals("title_content")){//제목 + 내용 검색인 경우
         //검색 키워드를 SuggestDto 에 담아서 전달한다.
         dto.setTitle(keyword);
         dto.setContent(keyword);
         //제목+내용 검색일때 호출하는 메소드를 이용해서 목록 얻어오기 
         list=SuggestDao.getInstance().getListTC(dto);
         //제목+내용 검색일때 호출하는 메소드를 이용해서 row  의 갯수 얻어오기
         totalRow=SuggestDao.getInstance().getCountTC(dto);
      }else if(condition.equals("title")){ //제목 검색인 경우
         dto.setTitle(keyword);
         list=SuggestDao.getInstance().getListT(dto);
         totalRow=SuggestDao.getInstance().getCountT(dto);
      }else if(condition.equals("writer")){ //작성자 검색인 경우
         dto.setWriter(keyword);
         list=SuggestDao.getInstance().getListW(dto);
         totalRow=SuggestDao.getInstance().getCountW(dto);

      } // 다른 검색 조건을 추가 하고 싶다면 아래에 else if() 를 계속 추가 하면 된다.
   }else{//검색 키워드가 넘어오지 않는다면
      //키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다. 
      list=SuggestDao.getInstance().getList(dto);
      //키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
      totalRow=SuggestDao.getInstance().getCount();
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
   
   // thisPage 라는 파라미터명으로 전달되는 문자열을 얻어와 본다. 
   // null or "member" or "todo"
   String thisPage=request.getParameter("thisPage");
   // thisPage 가 null 이면 index.jsp 페이지에 포함된 것이다. 
   //System.out.println(thisPage);
   //만일 null 이면 
   if(thisPage==null){
      //빈 문자열을 대입한다. (NullPointerException 방지용)
      thisPage="";
   }
   //로그인 된 아이디 읽어오기 
   String id=(String)session.getAttribute("id");
%>        
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>suggest/list.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<link
    rel="stylesheet"
    href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
  />
  
 <!-- 기본폰트 : 나눔고딕 폰트 적용 -->
 
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700&display=swap" rel="stylesheet">
<style>

/* body 전체에 나눔고딕 폰트 15px 적용*/
	body {
		font-family: 'Nanum Gothic', sans-serif;
		font-size: 15px;
	}

	/*Navbar 가로 정렬*/
	.navbar_ul {
		display:flex;
		flex-direction: row;
		justify-content:space-around;
		align-items:center;
	}

/* page-ui 게시판 하단 페이지번호 */
   .page-ui a{
      text-decoration: none;
      color: #000;
   }
   
   .page-ui a:hover{
      text-decoration: underline;
   }
   
   .page-ui a.active{
      color: purple;
      font-weight: 700;
   }
   
   .page-ui ul{
      list-style-type: none;
      padding: 0;
      margin: 0;
      display: flex;
      justify-content:center;
   }
   
   .page-ui ul > li{
   	display: inline;
   	padding: 5px;
   }
   
	.page-ui {
		margin: 10px 0;
	}
	
/* 상단 Q&A title 및 subtitle 정렬*/
   .suggest_header {
   		display: flex;
   		align-items:center;
   		flex-direction:column;
   		justify-content:center;
   		margin : 50px 20px 40px 30px;
   }
   
   .suggest_title {
   		font-weight:700;
   }
   
   .suggest_subtitle {
   		padding-left: 20px;
   		font-size: 12px;
   		color:gray;
   }
   
/* header, form을 감싼 box*/
   .suggest_box {
   		display: flex;
   		justify-content:center;
   		flex-direction:column;
   		margin-left : 20px;
   		width:70vw;
   }
   
	.suggest_box {
		margin: 0 auto;
	}
	
/* form title 정렬 */
	.suggest_row {
		text-align:center;
	}
	
	.suggest_row .col {
		text-align:center;
		padding:15px;
	}
	
	.suggest_row .col_content {
		text-align:left;
	}
	
	.suggest_row_space {
		border-bottom: 15px solid #fff;
		border-top: 15px solid #fff;
		border-left: 3px solid #fff;
	}

	.suggest_row_effect {
		border-bottom: 1px solid #c465f0;
	}
	
	.suggest_row_effect:hover {
		border-left: 3px solid gray;
		background-color: #c465f0;
		color: #fff;
		font-weight: 700;
	}
	
/*링크 포함 된 div에 포인터 커서 등록*/
	.content_effect:hover {
		cursor:pointer;
	}
	
/*하단 검색창*/	
	.suggest_form {
		display:flex;
		justify-content: center;
		margin-right:40px;
		margin-bottom:30px;
	}
	
	.form_input {
		border:none;
		border-bottom:2px solid gray;
		margin: 0px 4px;
	}
	
	.form_input:focus {
		outline:none;
	}
	
	.form_search {
		border:none;
	}
	
	.form_search svg:hover {
		color:purple;
		font-weight:700;
		width:20px;
		height:20px;
	}
	
	.form_search svg {
		transition: all 0.1s ease-in;
	}
	
/* 하단 문의하기 버튼 + 아이콘 감싼 태그*/
	.suggest_btn {
		display:flex;
		justify-content: flex-end;
	}
	
/*문의하기 버튼*/	
	.btn_color {
		background-color: #fff;
		border-radius: 10px;
		padding:8px 10px;
	}
	
	.btn_color:hover {
		background-color: #c465f0;
		color:white;
	}
	
</style>
</head>
<body>
<jsp:include page="../include/navbar.jsp"></jsp:include>	
   <section class="container-fluid">
   	<article class="suggest_box">
   	<div class="suggest_header animate__animated animate__fadeInDown">
	   <h2 class="suggest_title">Q&A</h2>
	   <span class="suggest_subtitle">궁금한 점이 있다면 하단의 검색창을 이용해 보세요.</span>   	
   	</div>
   	
  	<!-- 게시판 타이틀과 내용 -->
	   <table>
	      <thead>
	         <tr class="suggest_row suggest_row_space">
	            <th class="col">NO.</th>
	            <th class="col">작성자</th>
	            <th class="col">제목</th>
	            <th class="col">조회수</th>
	            <th class="col">등록일</th>
	         </tr>
	      </thead>
	      <tbody>
	      <%for(SuggestDto tmp:list){%>
	         <tr class="suggest_row suggest_row_effect">
	            <td class="col"><%=tmp.getNum() %></td>
	            <td class="col"><%=tmp.getWriter() %></td>
	            <td class="col col_content">
	               <div class="content_effect" Onclick="location.href='detail.jsp?num=<%=tmp.getNum()%>&keyword=<%=encodedK %>&condition=<%=condition%>'"><%=tmp.getTitle() %></div>
	            </td>
	            <td class="col"><%=tmp.getViewCount() %></td>
	            <td class="col"><%=tmp.getRegdate() %></td>
	         </tr>
	      <%} %>
	      </tbody>
	   </table>
	   
	   <!-- 페이지 번호  -->
	   <div class="page-ui clearfix">
	      <ul>
	         <%if(startPageNum != 1){ %>
	            <li>
	               <a href="list.jsp?pageNum=<%=startPageNum-1 %>&condition=<%=condition %>&keyword=<%=encodedK %>">Prev</a>
	            </li>   
	         <%} %>
	         
	         <%for(int i=startPageNum; i<=endPageNum ; i++){ %>
	            <li>
	               <%if(pageNum == i){ %>
	                  <a class="active" href="list.jsp?pageNum=<%=i %>&condition=<%=condition %>&keyword=<%=encodedK %>"><%=i %></a>
	               <%}else{ %>
	                  <a href="list.jsp?pageNum=<%=i %>&condition=<%=condition %>&keyword=<%=encodedK %>"><%=i %></a>
	               <%} %>
	            </li>   
	         <%} %>
	         <%if(endPageNum < totalPageCount){ %>
	            <li>
	               <a href="list.jsp?pageNum=<%=endPageNum+1 %>&condition=<%=condition %>&keyword=<%=encodedK %>">Next</a>
	            </li>
	         <%} %>
	      </ul>
	   </div>
	   
	 <!-- 하단 문의하기 버튼 -->
	   <div class="suggest_btn">
		   <a class="btn btn_color" href="private/insert_form.jsp">
		   	문의하기
		   	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil" viewBox="0 0 16 16">
	  			<path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/>
			</svg>
		   </a>
	   </div>
	   
	   <div style="clear:both;"></div>
	   
	<!-- 하단 검색창 -->
	   <form class="suggest_form" action="list.jsp" method="get"> 
	      <label style="visibility:hidden;" for="condition">검색조건</label>
	      <select name="condition" id="condition">
	         <option value="title_content" <%=condition.equals("title_content") ? "selected" : ""%>>제목+내용</option>
	         <option value="title" <%=condition.equals("title") ? "selected" : ""%>>제목</option>
	         <option value="writer" <%=condition.equals("writer") ? "selected" : ""%>>작성자</option>
	      </select>
	      <input class="form_input" type="text" id="keyword" name="keyword" placeholder="검색어..." value="<%=keyword%>"/>
	      <button class="form_search" type="submit">
	      	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
			  <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
			</svg>
	      </button>
	   </form>   
	   
	  <!-- 검색 결과 출력 -->
	   <%if(!condition.equals("")){ %>
	      <p>
	         <strong><%=totalRow %></strong> 개의 글이 검색 되었습니다.
	      </p>
	   <%} %>
   	</article>
   </section> 
</body>
</html>