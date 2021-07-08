<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="test.info.dao.InfoDao"%>
<%@page import="test.info.dto.InfoDto"%>
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
      
   //InfoDto 객체에 startRowNum 과 endRowNum 을 담는다.
   InfoDto dto=new InfoDto();
   dto.setStartRowNum(startRowNum);
   dto.setEndRowNum(endRowNum);

   //ArrayList 객체의 참조값을 담을 지역변수를 미리 만든다.
   List<InfoDto> list=null;
   //전체 row 의 갯수를 담을 지역변수를 미리 만든다.
   int totalRow=0;
   //만일 검색 키워드가 넘어온다면 
   if(!keyword.equals("")){
      //검색 조건이 무엇이냐에 따라 분기 하기
      if(condition.equals("title_content")){//제목 + 내용 검색인 경우
         //검색 키워드를 FeedDto 에 담아서 전달한다.
         dto.setTitle(keyword);
         dto.setContent(keyword);
         //제목+내용 검색일때 호출하는 메소드를 이용해서 목록 얻어오기 
         list=InfoDao.getInstance().getListTC(dto);
         //제목+내용 검색일때 호출하는 메소드를 이용해서 row  의 갯수 얻어오기
         totalRow=InfoDao.getInstance().getCountTC(dto);
      }else if(condition.equals("title")){ //제목 검색인 경우
         dto.setTitle(keyword);
         list=InfoDao.getInstance().getListT(dto);
         totalRow=InfoDao.getInstance().getCountT(dto);
      }else if(condition.equals("writer")){ //작성자 검색인 경우
         dto.setWriter(keyword);
         list=InfoDao.getInstance().getListW(dto);
         totalRow=InfoDao.getInstance().getCountW(dto);
      } // 다른 검색 조건을 추가 하고 싶다면 아래에 else if() 를 계속 추가 하면 된다.
   }else{//검색 키워드가 넘어오지 않는다면
      //키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다. 
      list=InfoDao.getInstance().getList(dto);
      //키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
      totalRow=InfoDao.getInstance().getCount();
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
<title>/main/info.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
	a{
		text-decoration: none;
		color: black;
	}
   .container{
   	  text-align: right;
   }
   table{
   	  width: 70%;
   	  margin-top: 50px;
   	  margin-left: 15%;
   	  margin-light: 15%;
   	  text-align: center;
   }
   .pagination{
   	  margin-top: 50px;
   }
</style>
</head>
<body>
<jsp:include page="../include/navbar.jsp"></jsp:include>
<div class="container">
   <a href="private/insert_form.jsp">새 글 작성하러 GO!</a>
   <br/>
   <%if(id==null){ %>
	   <a href="${pageContext.request.contextPath}/index.jsp">로그인</a>
   <%}else{ %>
	   <a href="${pageContext.request.contextPath}/main/myProfile.jsp"><%=id %></a> 로그인 중...
	   <a href="${pageContext.request.contextPath}/user/logout.jsp">로그아웃</a>
   <%} %>
   <h1 style="text-align: center;"><img src="images/info.jpg" width="60" height="50"/>Info</h1>
   <table>
      <thead>
         <tr>
            <th>글번호</th>
            <th>작성자</th>
            <th>제목</th>
            <th>조회수</th>
            <th>등록일</th>
         </tr>
      </thead>
      <tbody>
      <%for(InfoDto tmp:list){%>
         <tr>
            <td><%=tmp.getNum() %></td>
            <td><%=tmp.getWriter() %></td>
            <td>
               <a href="detail.jsp?num=<%=tmp.getNum()%>&keyword=<%=encodedK %>&condition=<%=condition%>"><%=tmp.getTitle() %></a>
            </td>
            <td><%=tmp.getUpCount() %></td>
            <td><%=tmp.getRegdate() %></td>
         </tr>
      <%} %>
      </tbody>
   </table>
      <ul class="pagination justify-content-center">
         <%if(startPageNum != 1){ %>
            <li class="page-item">
               <a class="page-link" href="info.jsp?pageNum=<%=startPageNum-1 %>">Prev</a>
            </li>
         <%}else{ %>
            <li class="page-item disabled">
               <a class="page-link" href="javascript:">Prev</a>
            </li>
         <%} %>
         <%for(int i=startPageNum; i<=endPageNum; i++) {%>
            <%if(i==pageNum){ %>
               <li class="page-item active">
                  <a class="page-link" href="info.jsp?pageNum=<%=i %>"><%=i %></a>
               </li>
            <%}else{ %>
               <li class="page-item">
                  <a class="page-link" href="info.jsp?pageNum=<%=i %>"><%=i %></a>
               </li>
            <%} %>
         <%} %>
         <%if(endPageNum < totalPageCount){ %>
            <li class="page-item">
               <a class="page-link" href="info.jsp?pageNum=<%=endPageNum+1 %>">Next</a>
            </li>
         <%}else{ %>
            <li class="page-item disabled">
               <a class="page-link" href="javascript:">Next</a>
            </li>
         <%} %>
      </ul>
   <div style="clear:both;"></div>
   
   <form action="info.jsp" method="get"> 
      <label for="condition">검색조건</label>
      <select name="condition" id="condition">
         <option value="title_content" <%=condition.equals("title_content") ? "selected" : ""%>>제목+내용</option>
         <option value="title" <%=condition.equals("title") ? "selected" : ""%>>제목</option>
         <option value="writer" <%=condition.equals("writer") ? "selected" : ""%>>작성자</option>
      </select>
      <input type="text" id="keyword" name="keyword" placeholder="검색어..." value="<%=keyword%>"/>
      <button type="submit">검색</button>
   </form>   
   
   <%if(!condition.equals("")){ %>
      <p>
         <strong><%=totalRow %></strong> 개의 글이 검색 되었습니다.
      </p>
   <%} %>
</div>
</body>
</html>