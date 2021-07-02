<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    	// thisPage 라는 파라미터명으로 전달되는 문자열을 얻어와 본다. 
    	// null or "file" or "cafe"
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
<title>index.jsp</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');

</style>
</head>
<body>
	<nav class="navbar navbar-light bg-light navbar-expand-lg fixed-top">
		<div class="container-fluid">
		    <a class="navbar-brand d-flex align-items-center" href="<%=request.getContextPath() %>/">
			   <svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="currentColor" class="bi bi-instagram" viewBox="0 0 16 16">
	  				<path d="M8 0C5.829 0 5.556.01 4.703.048 3.85.088 3.269.222 2.76.42a3.917 3.917 0 0 0-1.417.923A3.927 3.927 0 0 0 .42 2.76C.222 3.268.087 3.85.048 4.7.01 5.555 0 5.827 0 8.001c0 2.172.01 2.444.048 3.297.04.852.174 1.433.372 1.942.205.526.478.972.923 1.417.444.445.89.719 1.416.923.51.198 1.09.333 1.942.372C5.555 15.99 5.827 16 8 16s2.444-.01 3.298-.048c.851-.04 1.434-.174 1.943-.372a3.916 3.916 0 0 0 1.416-.923c.445-.445.718-.891.923-1.417.197-.509.332-1.09.372-1.942C15.99 10.445 16 10.173 16 8s-.01-2.445-.048-3.299c-.04-.851-.175-1.433-.372-1.941a3.926 3.926 0 0 0-.923-1.417A3.911 3.911 0 0 0 13.24.42c-.51-.198-1.092-.333-1.943-.372C10.443.01 10.172 0 7.998 0h.003zm-.717 1.442h.718c2.136 0 2.389.007 3.232.046.78.035 1.204.166 1.486.275.373.145.64.319.92.599.28.28.453.546.598.92.11.281.24.705.275 1.485.039.843.047 1.096.047 3.231s-.008 2.389-.047 3.232c-.035.78-.166 1.203-.275 1.485a2.47 2.47 0 0 1-.599.919c-.28.28-.546.453-.92.598-.28.11-.704.24-1.485.276-.843.038-1.096.047-3.232.047s-2.39-.009-3.233-.047c-.78-.036-1.203-.166-1.485-.276a2.478 2.478 0 0 1-.92-.598 2.48 2.48 0 0 1-.6-.92c-.109-.281-.24-.705-.275-1.485-.038-.843-.046-1.096-.046-3.233 0-2.136.008-2.388.046-3.231.036-.78.166-1.204.276-1.486.145-.373.319-.64.599-.92.28-.28.546-.453.92-.598.282-.11.705-.24 1.485-.276.738-.034 1.024-.044 2.515-.045v.002zm4.988 1.328a.96.96 0 1 0 0 1.92.96.96 0 0 0 0-1.92zm-4.27 1.122a4.109 4.109 0 1 0 0 8.217 4.109 4.109 0 0 0 0-8.217zm0 1.441a2.667 2.667 0 1 1 0 5.334 2.667 2.667 0 0 1 0-5.334z"/>
				</svg>
		     	<h1 class="d-flex align-items-center mb-0 ps-3" style="font-family: 'Lobster', cursive; display:inline-block; ">AcornStar</h1>
		    </a>
		 	<button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
		    	data-bs-target="#navbarNav">
   					<span class="navbar-toggler-icon"></span>
    	 	</button>
    		<div class="collapse navbar-collapse " id="navbarNav">
      			<ul class="navbar-nav me-auto">
      				<li class="nav-item">
      					<div style="clear:both;"></div>
      					<form class="d-flex align-items-center " action="list.jsp" method="get"> 
							<label for="condition" style="visibility:hidden;">검색조건</label>
							<select name="condition" id="condition">
								<option value="title_content">제목+내용</option>
								<option value="title" >제목</option>
								<option value="writer">작성자</option>
							</select>
							<input type="text" id="keyword" name="keyword" placeholder="검색어..." value=""/>
							<button type="submit">검색</button>
						</form>	
      				</li>
      				<li class="nav-item">
	          			<a class="nav-link <%=thisPage.equals("file") ? "active" : "" %>" href="../cafe/private/insertform.jsp">
	          			<svg class="d-flex align-items-center" xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-pencil-square" viewBox="0 0 16 16">
						  <path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
						  <path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
						</svg>
	          			</a>
	        		</li>
	        		<li class="nav-item dropdown d-flex align-items-center">
	        			<a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
							  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
							  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
							</svg>
          				</a>
          				<ul class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
          					<li><a class="dropdown-item" href="../index.jsp">Logout</a></li>
	        		</li>
      			</ul>	
    		</div>
		</div>
	</nav>
	</body>
</html>
	
	
	
	
	
	
	
	
	
	