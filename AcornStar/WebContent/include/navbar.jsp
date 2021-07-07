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
<nav class="navbar navbar-expand-lg navbar-light bg-light">
<link href="https://fonts.googleapis.com/css2?family=Lobster&display=swap" rel="stylesheet">
	<div class="container-fluid">
		<h1 id="acornstar"  class="d-flex align-items-center mb-0 ps-5" style="font-family: 'Lobster', cursive; display:inline-block; color: #6610f2;">
			<span id="logo"></span>
			<div id="star" >
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star-fill" viewBox="0 0 16 16">
			    	<path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"/>
				</svg>
			</div>
			<span id="music">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-music-note-beamed" viewBox="0 0 16 16">
				  <path d="M6 13c0 1.105-1.12 2-2.5 2S1 14.105 1 13c0-1.104 1.12-2 2.5-2s2.5.896 2.5 2zm9-2c0 1.105-1.12 2-2.5 2s-2.5-.895-2.5-2 1.12-2 2.5-2 2.5.895 2.5 2z"/>
				  <path fill-rule="evenodd" d="M14 11V2h1v9h-1zM6 3v10H5V3h1z"/>
				  <path d="M5 2.905a1 1 0 0 1 .9-.995l8-.8a1 1 0 0 1 1.1.995V3L5 4V2.905z"/>
				</svg>
			</span>
			AcornStar
		</h1>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        	<span class="navbar-toggler-icon"></span>
        </button>
		<div class="collapse navbar-collapse" id="navbarNav">
			<form class="d-flex ms-4">
        		<input class="form-control ml-2" type="search" placeholder="Search" aria-label="Search">
        		<button class="btn" style="color: #6610f2" type="submit">Search</button>
	      	</form>
			<ul class="navbar-nav ms-auto mb-2 mb-lg-0" style="margin-right: 20px;">
				<!-- main 이동  -->
				<li>
					<div class="m-2">
						<a href="${pageContext.request.contextPath}/main/main.jsp">
		          			<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-house-door-fill" viewBox="0 0 16 16">
		  						<path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
							</svg>
						</a>
					</div>
				</li>
				<!-- DM 이동  -->
				<li>
					<div class="m-2">
						<a href="private/chat.jsp">
		        			<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-chat-dots" viewBox="0 0 16 16">
								<path d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
						  		<path d="m2.165 15.803.02-.004c1.83-.363 2.948-.842 3.468-1.105A9.06 9.06 0 0 0 8 15c4.418 0 8-3.134 8-7s-3.582-7-8-7-8 3.134-8 7c0 1.76.743 3.37 1.97 4.6a10.437 10.437 0 0 1-.524 2.318l-.003.011a10.722 10.722 0 0 1-.244.637c-.079.186.074.394.273.362a21.673 21.673 0 0 0 .693-.125zm.8-3.108a1 1 0 0 0-.287-.801C1.618 10.83 1 9.468 1 8c0-3.192 3.004-6 7-6s7 2.808 7 6c0 3.193-3.004 6-7 6a8.06 8.06 0 0 1-2.088-.272 1 1 0 0 0-.711.074c-.387.196-1.24.57-2.634.893a10.97 10.97 0 0 0 .398-2z"/>
							</svg>
						</a>
					</div>
				</li>
				<!-- info 이동  -->
				<li>
					<div class="m-2">
						<a href="info.jsp">
							<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-suit-heart" viewBox="0 0 16 16">
		  						<path d="m8 6.236-.894-1.789c-.222-.443-.607-1.08-1.152-1.595C5.418 2.345 4.776 2 4 2 2.324 2 1 3.326 1 4.92c0 1.211.554 2.066 1.868 3.37.337.334.721.695 1.146 1.093C5.122 10.423 6.5 11.717 8 13.447c1.5-1.73 2.878-3.024 3.986-4.064.425-.398.81-.76 1.146-1.093C14.446 6.986 15 6.131 15 4.92 15 3.326 13.676 2 12 2c-.777 0-1.418.345-1.954.852-.545.515-.93 1.152-1.152 1.595L8 6.236zm.392 8.292a.513.513 0 0 1-.784 0c-1.601-1.902-3.05-3.262-4.243-4.381C1.3 8.208 0 6.989 0 4.92 0 2.755 1.79 1 4 1c1.6 0 2.719 1.05 3.404 2.008.26.365.458.716.596.992a7.55 7.55 0 0 1 .596-.992C9.281 2.049 10.4 1 12 1c2.21 0 4 1.755 4 3.92 0 2.069-1.3 3.288-3.365 5.227-1.193 1.12-2.642 2.48-4.243 4.38z"/>
							</svg>
						</a>
					</div>
				</li>
				<!-- 새 글 작성 버튼  -->
				<li>
					<div class="m-2">
						<a id="write" href="javascript:">
							<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-pencil-square" viewBox="0 0 16 16">
		  						<path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
		  						<path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
							</svg>
						</a>
					</div>
				</li>
				<!-- MyProfile 버튼  -->
				<li>
					<div class="m-2">
						<a href="${pageContext.request.contextPath}/user/myProfile.jsp">
							<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-person-circle" viewBox="0 0 16 16">
		  						<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
		  						<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
							</svg>
						</a>
					</div>
				</li>	
			</ul>
			<div class="m-2">
				<a class="" id="logout" href="${pageContext.request.contextPath}/user/logout.jsp">
					Logout

				</a>
			</div>
    	</div>
	</div>
</nav>

	
	
	
	
	
	
	
	
	
	