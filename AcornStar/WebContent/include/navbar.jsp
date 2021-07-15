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
<link href="https://fonts.googleapis.com/css2?family=Lobster&display=swap" rel="stylesheet">
<nav class="navbar navbar-expand-lg navbar-light bg-light">

<link href="https://fonts.googleapis.com/css2?family=Lobster&display=swap" rel="stylesheet">
	<div class="container-fluid">
		<h1 class="d-flex align-items-center mb-0 ps-5" style="font-family: 'Lobster', cursive; display:inline-block; color: #8540f5;">
			<a id="acornstar" href="${pageContext.request.contextPath}/main/main.jsp" style="text-decoration: none; color:#8540f5;">
				<span id="star" >
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-star-fill" viewBox="0 0 16 16">
				    	<path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z"/>
					</svg>
				</span>
				<span id="music">
					<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-music-note-beamed" viewBox="0 0 16 16">
					  <path d="M6 13c0 1.105-1.12 2-2.5 2S1 14.105 1 13c0-1.104 1.12-2 2.5-2s2.5.896 2.5 2zm9-2c0 1.105-1.12 2-2.5 2s-2.5-.895-2.5-2 1.12-2 2.5-2 2.5.895 2.5 2z"/>
					  <path fill-rule="evenodd" d="M14 11V2h1v9h-1zM6 3v10H5V3h1z"/>
					  <path d="M5 2.905a1 1 0 0 1 .9-.995l8-.8a1 1 0 0 1 1.1.995V3L5 4V2.905z"/>
					</svg>
				</span>
				AcornStar
			</a>
		</h1>
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        	<span class="navbar-toggler-icon"></span>
        </button>
      <div class="collapse navbar-collapse" id="navbarNav">
      	<!-- 검색기능 -->
         <form class="d-flex ms-4 searchForm">
       	  	<input type="hidden" name="condition" value="tag"/>
            <input class="form-control ml-2" name="keyword" type="search" placeholder="Search" aria-label="Search">
            <button class="btn" style="color: #6610f2" type="submit">
            	<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" x="0px" y="0px" viewBox="0 0 512 512" width="25px" height="25px" fill="#8540f5"  style="enable-background:new 0 0 512 512;" xml:space="preserve">
					<path d="M270.746,117.149c-20.516-20.514-47.79-31.812-76.802-31.811c-12.854,0-23.273,10.42-23.273,23.273    c0.002,12.854,10.42,23.273,23.274,23.273c16.578,0,32.163,6.454,43.886,18.178c11.723,11.723,18.178,27.308,18.178,43.885    c-0.002,12.853,10.418,23.274,23.271,23.274c0.002,0,0.002,0,0.002,0c12.851,0,23.271-10.418,23.273-23.271    C302.556,164.939,291.26,137.663,270.746,117.149z"/>
					<path d="M505.183,472.272L346.497,313.586c25.921-32.979,41.398-74.536,41.398-119.639C387.894,87.005,300.89,0,193.946,0    c-0.003,0,0,0-0.003,0C142.14,0,93.434,20.175,56.806,56.804C20.173,93.437,0,142.141,0,193.947    C0,300.89,87.004,387.894,193.946,387.894c45.103,0,86.661-15.476,119.639-41.396L472.27,505.184    c4.544,4.544,10.501,6.816,16.457,6.816c5.956,0,11.913-2.271,16.455-6.817C514.273,496.096,514.273,481.359,505.183,472.272z     M193.946,341.349c-81.276,0-147.4-66.124-147.4-147.402c0-39.373,15.332-76.389,43.172-104.229    c27.84-27.842,64.855-43.172,104.228-43.172c81.279,0,147.403,66.124,147.403,147.402S275.225,341.349,193.946,341.349z"/>
				</svg>
            </button>
         </form>
            
         <ul class="navbar-nav ms-auto mb-2 mb-lg-0 navbar_ul" style="margin-right: 20px;">

            <!-- DM 이동  -->
            <li>
               <div class="m-2">
                  <a href="private/chat.jsp">
                       <svg xmlns="http://www.w3.org/2000/svg" width="30" height="50" fill="#8540f5" class="bi bi-chat-dots" viewBox="0 0 16 16">
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
                     <svg xmlns="http://www.w3.org/2000/svg" width="30" height="50" fill="#8540f5" class="bi bi-suit-heart" viewBox="0 0 16 16">
                          <path d="m8 6.236-.894-1.789c-.222-.443-.607-1.08-1.152-1.595C5.418 2.345 4.776 2 4 2 2.324 2 1 3.326 1 4.92c0 1.211.554 2.066 1.868 3.37.337.334.721.695 1.146 1.093C5.122 10.423 6.5 11.717 8 13.447c1.5-1.73 2.878-3.024 3.986-4.064.425-.398.81-.76 1.146-1.093C14.446 6.986 15 6.131 15 4.92 15 3.326 13.676 2 12 2c-.777 0-1.418.345-1.954.852-.545.515-.93 1.152-1.152 1.595L8 6.236zm.392 8.292a.513.513 0 0 1-.784 0c-1.601-1.902-3.05-3.262-4.243-4.381C1.3 8.208 0 6.989 0 4.92 0 2.755 1.79 1 4 1c1.6 0 2.719 1.05 3.404 2.008.26.365.458.716.596.992a7.55 7.55 0 0 1 .596-.992C9.281 2.049 10.4 1 12 1c2.21 0 4 1.755 4 3.92 0 2.069-1.3 3.288-3.365 5.227-1.193 1.12-2.642 2.48-4.243 4.38z"/>
                     </svg>
                  </a>
               </div>
            </li>
            <!-- 새 글 작성 버튼  -->
            <li id="newWrite">
               <div class="m-2">
                  <a id="write" href="javascript:">
                     <svg xmlns="http://www.w3.org/2000/svg" width="30" height="50" fill="#8540f5" class="bi bi-pencil-square" viewBox="0 0 16 16">
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
                     <svg xmlns="http://www.w3.org/2000/svg" width="30" height="50" fill="#8540f5" class="bi bi-person-circle" viewBox="0 0 16 16">
                          <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                          <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
                     </svg>
                  </a>
               </div>
            </li>
            <li>
	         <div class="m-2">
	            <a class="" id="logout" href="${pageContext.request.contextPath}/user/logout.jsp">
	               <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Capa_1" x="0px" y="0px" width="30px" height="50px" fill="#8540f5" viewBox="0 0 262.85 262.85" style="enable-background:new 0 0 262.85 262.85; " xml:space="preserve">
					<path d="M16.61,185.391v25.813c0,2.637,2.137,4.779,4.779,4.779h66.054c2.641,0,4.779-2.143,4.779-4.779v-26.08l13.595,8.924    v39.554c0,2.637,2.138,4.778,4.779,4.778h24.297c1.278,0,2.492-0.508,3.393-1.409c0.901-0.9,1.396-2.123,1.386-3.397l-0.378-55.8    c-0.009-1.563-0.779-3.02-2.071-3.906l-26.325-18.09l3.122-4.289v1.265c0,2.643,2.135,4.779,4.779,4.779h52.913    c2.646,0,4.779-2.137,4.779-4.779v-23.536c0-2.639-2.133-4.779-4.779-4.779h-27.867v-19.896c0-1.554-0.747-3.005-2.021-3.904    l-28.474-20.12c-0.808-0.569-1.769-0.875-2.758-0.875H48.722c-2.644,0-4.779,2.142-4.779,4.779v54.283    c0,2.627,2.121,4.76,4.749,4.778l8.795,0.052c-0.42,0.732-0.646,1.577-0.637,2.427l0.331,34.653H21.389    C18.752,180.611,16.61,182.753,16.61,185.391z M77.478,110.453h3.388l-3.332,4.714L77.478,110.453z M26.168,190.169h35.838    c1.277,0,2.495-0.508,3.398-1.414c0.898-0.905,1.396-2.133,1.381-3.406l-0.362-37.939l27.58-38.972    c1.031-1.458,1.16-3.37,0.338-4.957c-0.817-1.586-2.457-2.585-4.245-2.585H72.641c-1.281,0-2.5,0.511-3.398,1.421    c-0.898,0.908-1.395,2.135-1.381,3.416l0.243,20.965l-5.528,7.309l-9.071-0.051V89.202h55.581l25.209,17.817v22.199    c0,2.637,2.138,4.779,4.779,4.779h27.867v13.978h-43.36v-11.164c0-2.072-1.33-3.904-3.299-4.546    c-1.944-0.634-4.119,0.059-5.342,1.732l-14.652,20.12c-0.756,1.041-1.066,2.353-0.847,3.617c0.214,1.273,0.938,2.398,2.002,3.136    l28.317,19.467l0.324,48.495h-14.706v-37.359c0-1.605-0.812-3.108-2.154-3.995L90.07,172.294    c-1.468-0.956-3.342-1.035-4.894-0.205c-1.545,0.836-2.504,2.45-2.504,4.205v30.149H26.168V190.169z"/>
					<path d="M118.109,66.104c0,15.87,12.912,28.784,28.786,28.784c15.868,0,28.782-12.914,28.782-28.784    c0-15.877-12.914-28.789-28.782-28.789C131.021,37.315,118.109,50.227,118.109,66.104z M127.667,66.104    c0-10.606,8.625-19.23,19.228-19.23c10.595,0,19.225,8.625,19.225,19.23c0,10.604-8.63,19.226-19.225,19.226    C136.292,85.331,127.667,76.703,127.667,66.104z"/>
					<path d="M81.429,226.923v28.758c0,3.963,3.211,7.169,7.168,7.169h150.474c3.957,0,7.168-3.206,7.168-7.169V7.168    c0-3.962-3.211-7.168-7.168-7.168H88.961c-3.958,0-7.168,3.206-7.168,7.168V69.57H96.13V14.337h135.772v234.176H95.766v-21.59    H81.429z"/>
				   </svg>
	            </a>
	         </div>          
            </li>
         </ul>
       </div>
   </div>

</nav>