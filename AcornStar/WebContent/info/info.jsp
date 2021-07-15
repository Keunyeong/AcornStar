<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="test.info.dao.InfoDao"%>
<%@page import="test.info.dto.InfoDto"%>
<%@page import="test.users.dto.UsersDto"%>
<%@page import="test.users.dao.UsersDao"%>
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
   UsersDto usersdto=UsersDao.getInstance().getData(id);
%>        
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/info/info.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<!-- 외부 css 로딩하기  -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
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
   	  margin-left: auto;
   	  margin-light: auto;
   	  text-align: center;
   }
   .pagination{
   	  margin-top: 50px;
   }
   .pagination a{
      color: indigo;
      line-height:28px;
      margin:0 5px;
      border:1px solid #ccc;
   }
   .pagination a .page-link.active{
	background-color: #a385cf;
	color: #fff;
	}
	
    select{
   	  border-radius: 10px;
   	  border: solid 2px #a385cf;
   	  color: gray;
   }
   select:focus{
   	  outline: none;
   }
   input{
   	  border: none;
   	  border-bottom: solid 2px #a385cf;
   }
   input:focus{
   	  outline:none;
   }
   .btn-gradient {
		text-decoration: none;
		background-color: #a385cf;
		color: white;
		padding: 10px 30px;
		display: inline-block;
		position: relative;
		top: 100px;
		border: 1px solid rgba(0,0,0,0.21);
		border-bottom: 5px solid rgba(0,0,0,0.21);
		border-radius: 10px;
		text-shadow: 0 1px 0 rgba(0,0,0,0.15);
	}
	#searchBtn{
     	border: none;
     	background-color: white;
	}
</style>
</head>
<body>
<jsp:include page="../include/navbar.jsp"></jsp:include>
<div class="container">
<%if((usersdto.getAutority()).equals("yes")){%>
   <button class="btn-gradient purple" style="margin-top: 30px;" onclick="location.href='private/insert_form.jsp'">공지하기</button>
<%}%>

   <h1 style="text-align: center;">
   		<svg version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="50" height="50"
	 	fill="#652dc1" viewBox="0 0 493.546 493.546" style="enable-background:new 0 0 493.546 493.546;" xml:space="preserve">
			<path d="M226.078,157.206c26.286,0,47.604-21.314,47.604-47.609s-21.317-47.611-47.604-47.611
				c-26.303,0-47.618,21.316-47.618,47.611S199.775,157.206,226.078,157.206z"/>
			<path d="M271.949,69.824c1.192,1.191,2.764,1.787,4.32,1.787c1.558,0,3.129-0.596,4.305-1.787l47.937-47.92
				c2.383-2.383,2.398-6.242,0.016-8.625c-2.382-2.382-6.274-2.382-8.624,0L271.966,61.2
				C269.583,63.582,269.567,67.442,271.949,69.824z"/>
			<path d="M261.959,59.421c0.89,0.469,1.858,0.691,2.812,0.691c2.192,0,4.32-1.199,5.417-3.288l24.92-47.921
				c1.557-2.986,0.382-6.671-2.604-8.219c-2.906-1.541-6.64-0.397-8.228,2.597l-24.921,47.92
				C257.798,54.188,258.973,57.872,261.959,59.421z"/>
			<path d="M282.353,79.823c1.096,2.088,3.225,3.288,5.416,3.288c0.953,0,1.922-0.223,2.812-0.691l47.936-24.921
				c2.986-1.549,4.161-5.233,2.604-8.22c-1.572-3.002-5.289-4.153-8.228-2.597l-47.936,24.921
				C281.972,73.152,280.797,76.837,282.353,79.823z"/>
			<path d="M396.061,88.515l-78.192,12.148c-5.178,0.801-9.006,5.265-9.006,10.513v15.472c0,5.249,3.828,9.713,9.006,10.515
				l7.449,1.157v21.644c0,3.104,1.08,5.852,2.56,8.348l-18.809,26.373l-22.459-15.145c-7.577-5.099-16.884-7.14-25.524-7.712
				l-72.698,0.389l-48.365-22.142l-31.465-67.211c-4.749-10.189-16.837-14.549-27.034-9.8c-10.165,4.765-14.549,16.868-9.783,27.034
				l34.625,73.969c2.033,4.368,5.56,7.862,9.943,9.871l57.369,26.27v261.458c0,12.087,9.802,21.879,21.874,21.879
				c12.085,0,21.887-9.792,21.887-21.879V340.922h17.28v130.745c0,12.08,9.801,21.871,21.872,21.871
				c12.088,0,21.871-9.791,21.871-21.871V223.09l24.286,16.377c3.494,2.351,7.449,3.479,11.356,3.479
				c6.354,0,12.611-2.97,16.566-8.529l35.88-50.318c1.882-2.634,2.849-5.567,3.332-8.558c6.381-2.364,10.995-8.385,10.995-15.577
				v-13.012l15.185,2.359c-4.206-10.775-4.859-24.383-4.859-30.399C391.203,112.897,391.855,99.29,396.061,88.515z M368.679,159.963
				c0,0.98-0.512,1.774-1.043,2.518c-1.424-2.566-3.284-4.917-5.834-6.735c-7.559-5.408-17.37-4.586-24.286,0.94v-16.471l31.163,4.841
				V159.963z"/>
			<path d="M413.567,85.795c-5.608,0-10.165,14.827-10.165,33.116c0,18.29,4.557,33.118,10.165,33.118
				c5.607,0,10.165-14.829,10.165-33.118C423.732,100.622,419.174,85.795,413.567,85.795z"/>
		</svg>
   Notice
   </h1>
   <h6 class="animate__pulse" style="text-align: center; color: gray;">AcornStar 의 모든 공지사항을 알립니다!</h6>

   <table class="table table-striped table-bordered table-hover">
      <thead style="background-color: #a385cf; color: white;">
         <tr>
            <th>NO.</th>
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
            <li class="page-item">
               <a class="page-link" href="javascript:">Prev</a>
            </li>
         <%} %>
         <%for(int i=startPageNum; i<=endPageNum; i++) {%>
            <%if(i==pageNum){ %>
               <li class="page-item">
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
            <li class="page-item">
               <a class="page-link" href="javascript:">Next</a>
            </li>
         <%} %>
      </ul>
      
   <form action="info.jsp" method="get">
      <label for="condition"></label>
      <select name="condition" id="condition">
         <option value="title_content" <%=condition.equals("title_content") ? "selected" : ""%>>Title+Content</option>
         <option value="title" <%=condition.equals("title") ? "selected" : ""%>>Title</option>
         <option value="writer" <%=condition.equals("writer") ? "selected" : ""%>>Writer</option>
      </select>
      <input type="text" id="keyword" name="keyword" placeholder="Search..." value="<%=keyword%>"/>
      <button id="searchBtn">
      <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="50" height="50"
	  fill="#652dc1" viewBox="0 0 501.984 501.984" style="enable-background:new 0 0 501.984 501.984;" xml:space="preserve">
			<path d="M491.796,438.532L344.031,290.768c-12.194-12.195-15.791-30.451-9.163-46.511c9.052-21.934,13.449-45.194,13.069-69.134
				c-0.732-46.107-19.126-89.197-51.792-121.332C263.483,21.662,220.097,3.967,173.979,3.967
				c-45.889,0-89.187,17.709-121.919,49.864C19.372,85.944,0.895,128.836,0.032,174.605c-0.886,46.929,16.841,91.34,49.913,125.052
				c33.054,33.692,77.085,52.255,123.983,52.269c0.017,0,0.034,0,0.052,0c26.246,0,51.474-5.702,74.983-16.949
				c16.476-7.882,36.098-4.62,48.832,8.114l144.722,144.72c6.581,6.581,15.332,10.206,24.639,10.206
				c9.306,0,18.057-3.625,24.64-10.207C505.381,474.224,505.381,452.118,491.796,438.532z M477.654,473.668
				c-2.805,2.804-6.533,4.348-10.498,4.348c-3.965,0-7.693-1.544-10.497-4.348l-144.721-144.72
				c-11.937-11.936-27.961-18.224-44.258-18.224c-9.261,0-18.611,2.032-27.348,6.211c-20.795,9.948-43.116,14.991-66.352,14.991
				c-0.015,0-0.033,0-0.047,0c-41.486-0.012-80.449-16.446-109.712-46.275C34.94,255.803,19.244,216.5,20.027,174.982
				C21.598,91.712,90.66,23.967,173.979,23.967c84.983,0,152.611,66.535,153.96,151.473c0.336,21.2-3.552,41.786-11.56,61.187
				c-9.72,23.554-4.418,50.356,13.509,68.283l147.765,147.763C483.441,458.462,483.441,467.88,477.654,473.668z"/>
			<path d="M173.98,54.652c-67.985,0-123.295,55.31-123.295,123.295s55.31,123.295,123.295,123.295s123.295-55.31,123.295-123.295
				S241.965,54.652,173.98,54.652z M173.98,281.242c-56.957,0-103.295-46.338-103.295-103.295
				c0-56.957,46.338-103.295,103.295-103.295s103.295,46.338,103.295,103.295S230.937,281.242,173.98,281.242z"/>
			<path d="M207.418,91.691c-10.661-4.135-21.911-6.232-33.438-6.232c-50.998,0-92.487,41.489-92.487,92.487
				c0,16.034,4.17,31.835,12.06,45.695c1.844,3.239,5.222,5.055,8.7,5.055c1.676,0,3.376-0.423,4.939-1.312
				c4.799-2.732,6.475-8.838,3.743-13.638c-6.176-10.85-9.441-23.229-9.441-35.8c0-39.969,32.518-72.487,72.487-72.487
				c9.043,0,17.859,1.642,26.204,4.879c5.15,1.996,10.942-0.559,12.94-5.707C215.122,99.482,212.567,93.689,207.418,91.691z"/>
			<path d="M237.497,110.721c-4.013-3.794-10.342-3.615-14.136,0.399c-3.793,4.013-3.615,10.343,0.399,14.136
				c5.491,5.19,10.119,11.167,13.755,17.765c1.823,3.306,5.241,5.175,8.767,5.175c1.631,0,3.287-0.401,4.818-1.243
				c4.836-2.666,6.597-8.748,3.931-13.585C250.395,124.955,244.496,117.335,237.497,110.721z"/>
	  </svg>
	  </button>
   </form>   
   <%if(!condition.equals("")){ %>
      <p>
         <strong><%=totalRow %></strong> 개의 글이 검색 되었습니다.
      </p>
   <%} %>
</div>
<script>
document.querySelector("#newWrite").style.display="none";
</script>
</body>
</html>