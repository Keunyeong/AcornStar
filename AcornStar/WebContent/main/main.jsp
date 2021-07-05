<%@page import="test.feed.dto.FeedDto"%>
<%@page import="java.util.List"%>
<%@page import="test.feed.dao.FeedDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// session scope에서 id 정보 불러오기
	String id=(String)session.getAttribute("id");	
	
	// method를 이용, DB에서 data를 불러온다.
	List<FeedDto> list=FeedDao.getInstance().getList();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>

	@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
	.right-box {
		float: right;
		margin-right: 30px;
	}
	.container {
		margin-top: 30px;
	}
	.center-box {
		margin-top: 30px;
	}
</style>
</head>
<body>
<div style="margin-top:30px;" class="right-box">
	<h1 class="d-flex align-items-center mb-0 ps-5" style="font-family: 'Lobster', cursive; display:inline-block; color: #6610f2;">AcornStar</h1>
</div>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    	<div class="collapse navbar-collapse" id="navbarSupportedContent">
      		<ul class="navbar-nav me-auto mb-2 mb-lg-0">
      		<div class="container">
        		<a href="main.jsp">
          			<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-house-door-fill" viewBox="0 0 16 16">
  						<path d="M6.5 14.5v-3.505c0-.245.25-.495.5-.495h2c.25 0 .5.25.5.5v3.5a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5v-7a.5.5 0 0 0-.146-.354L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.354 1.146a.5.5 0 0 0-.708 0l-6 6A.5.5 0 0 0 1.5 7.5v7a.5.5 0 0 0 .5.5h4a.5.5 0 0 0 .5-.5z"/>
					</svg>
				</a>
			</div>
			<div class="container">
				<a href="private/chat.jsp">
        			<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-chat-dots" viewBox="0 0 16 16">
						<path d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
				  		<path d="m2.165 15.803.02-.004c1.83-.363 2.948-.842 3.468-1.105A9.06 9.06 0 0 0 8 15c4.418 0 8-3.134 8-7s-3.582-7-8-7-8 3.134-8 7c0 1.76.743 3.37 1.97 4.6a10.437 10.437 0 0 1-.524 2.318l-.003.011a10.722 10.722 0 0 1-.244.637c-.079.186.074.394.273.362a21.673 21.673 0 0 0 .693-.125zm.8-3.108a1 1 0 0 0-.287-.801C1.618 10.83 1 9.468 1 8c0-3.192 3.004-6 7-6s7 2.808 7 6c0 3.193-3.004 6-7 6a8.06 8.06 0 0 1-2.088-.272 1 1 0 0 0-.711.074c-.387.196-1.24.57-2.634.893a10.97 10.97 0 0 0 .398-2z"/>
					</svg>
				</a>
			</div>
			<div class="container">
				<a href="info.jsp">
					<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-suit-heart" viewBox="0 0 16 16">
  						<path d="m8 6.236-.894-1.789c-.222-.443-.607-1.08-1.152-1.595C5.418 2.345 4.776 2 4 2 2.324 2 1 3.326 1 4.92c0 1.211.554 2.066 1.868 3.37.337.334.721.695 1.146 1.093C5.122 10.423 6.5 11.717 8 13.447c1.5-1.73 2.878-3.024 3.986-4.064.425-.398.81-.76 1.146-1.093C14.446 6.986 15 6.131 15 4.92 15 3.326 13.676 2 12 2c-.777 0-1.418.345-1.954.852-.545.515-.93 1.152-1.152 1.595L8 6.236zm.392 8.292a.513.513 0 0 1-.784 0c-1.601-1.902-3.05-3.262-4.243-4.381C1.3 8.208 0 6.989 0 4.92 0 2.755 1.79 1 4 1c1.6 0 2.719 1.05 3.404 2.008.26.365.458.716.596.992a7.55 7.55 0 0 1 .596-.992C9.281 2.049 10.4 1 12 1c2.21 0 4 1.755 4 3.92 0 2.069-1.3 3.288-3.365 5.227-1.193 1.12-2.642 2.48-4.243 4.38z"/>
					</svg>
				</a>
			</div>
			<div class="container">
				<a href="private/insertform.jsp">
					<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-pencil-square" viewBox="0 0 16 16">
  						<path d="M15.502 1.94a.5.5 0 0 1 0 .706L14.459 3.69l-2-2L13.502.646a.5.5 0 0 1 .707 0l1.293 1.293zm-1.75 2.456-2-2L4.939 9.21a.5.5 0 0 0-.121.196l-.805 2.414a.25.25 0 0 0 .316.316l2.414-.805a.5.5 0 0 0 .196-.12l6.813-6.814z"/>
  						<path fill-rule="evenodd" d="M1 13.5A1.5 1.5 0 0 0 2.5 15h11a1.5 1.5 0 0 0 1.5-1.5v-6a.5.5 0 0 0-1 0v6a.5.5 0 0 1-.5.5h-11a.5.5 0 0 1-.5-.5v-11a.5.5 0 0 1 .5-.5H9a.5.5 0 0 0 0-1H2.5A1.5 1.5 0 0 0 1 2.5v11z"/>
					</svg>
				</a>
			</div>
			<div class="container">
				<a href="private/profile.jsp">
					<svg xmlns="http://www.w3.org/2000/svg" width="40" height="50" fill="indigo" class="bi bi-person-circle" viewBox="0 0 16 16">
  						<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
  						<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
					</svg>
				</a>
			</div>
      		</ul>
      		<div class="center-box">
      		<form class="d-flex">
        		<input class="form-control ml-2" type="search" placeholder="Search" aria-label="Search">
        		<button class="btn" style="color: #6610f2" type="submit">Search</button>
      		</form>
      		</div>
      		
    	</div>
 </nav>

</style>
</head>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>

	<h1>여기에 Navbar 추가</h1>
	<a href="${pageContext.request.contextPath}/user/logout.jsp">로그아웃</a>
	<div class="container">
		<div class="border">
		
		</div>
		<div class="border float-end">
			<a href="myProfile.jsp">
				My Profile
			</a>	
			<button id="writeBtn" type="button" class="btn" style="color: #6610f2">
	     		새 글 작성
	   		</button>
	   		<a class="" id="logout" href="${pageContext.request.contextPath}/user/logout.jsp">
				로그아웃
			</a>		
		</div>
		<br>	
		<br>
		
		<div class="border">
			<form id="insertForm" action="insert.jsp" method="post"> 
				<textarea name="content" id="content"></textarea>
				<button type="submit">새 글 등록</button>
			</form>
		</div>		
		<br>
		
		<div id="feed" class="border">
			<ul>
				<%for(FeedDto tmp:list){%>
					<li class="form-control">
						<%=tmp.getContent() %>
						<%if(tmp.getWriter().equals(id)) {%>
							<a data-num="<%=tmp.getNum() %>" class="update" href="javascript:">
								글 수정
							</a>
							<a data-num="<%=tmp.getNum() %>" class="delete" href="javascript:">
								글 삭제
							</a>
						<%} %>
					</li>
				<%} %>
			</ul>
		</div>
	</div>
	<!-- SmartEditor 에서 필요한 javascript 로딩  -->
	<script src="${pageContext.request.contextPath }/SmartEditor/js/HuskyEZCreator.js"></script>
	
	<script>
		// 로그아웃 버튼을 눌렀을 때 수행되는 기능
		document.querySelector("#logout").addEventListener("click", function(){
			let logout=confirm("정말로 로그아웃하시겠습니까?");
			if(!logout){
				e.preventDefault();
			}
		});
		
		// 새 글 작성 버튼을 눌렀을 때 진행되는 과정
		document.querySelector("#writeBtn").addEventListener("click", function(){		
			let insertForm=document.querySelector("#insertForm");
			if(insertForm.style.display=="none"){
				insertForm.style.display="block";
				document.querySelector("#content").style.right="0px";
			} else if(insertForm.style.display="block"){
				insertForm.style.display="none";
			}
		});
		
		// 새 글 등록 버튼을 눌렀을 때 진행되는 ajax
		document.querySelector("#insertForm").addEventListener("submit", function(e){
			e.preventDefault();
			
			oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
			
			ajaxFormPromise(this)
			.then(function(response){
				return response.json();
			}).then(function(data){
				if(data.isSuccess){
					alert("새 글을 성공적으로 등록했습니다.");
					location.href="${pageContext.request.contextPath}/main/main.jsp"
				} else {
					alert("새 글 등록에 실패했습니다. 다시 작성해주세요.");
					location.href="${pageContext.request.contextPath}/main/main.jsp"
				}
			});
			
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
							//location.href="${pageContext.request.contextPath}/main/main.jsp";
						} else {
							alert("게시글을 삭제하지 못했습니다.");
							//location.href="${pageContext.request.contextPath}/main/main.jsp";
						}
					});
				}				
			});
		}
		
		// 글 수정 버튼을 눌렀을 때 진행되는 ajax가 일어나는 event listener 달아주기
		let updateLinks=document.querySelectAll(".update");
		for(let i=0; i<updateLinks.length; i++){
			updateLinks[i].addEventListener("click", function(){
				let num=this.getAttribute("data-num");
				ajaxPromise(this)
				.then(function(response){
					return response.json();
				}).then(function(data){
					console.log(data);
				});
			});
		}
		
<%--
  	[ SmartEditor 를 사용하기 위한 설정 ]
  
  	1. WebContent 에 SmartEditor  폴더를 복사해서 붙여 넣기
  	2. WebContent 에 upload 폴더 만들어 두기
  	3. WebContent/WEB-INF/lib 폴더에 
     commons-io.jar 파일과 commons-fileupload.jar 파일 붙여 넣기
  	4. <textarea id="content" name="content"> 
     content 가 아래의 javascript 에서 사용 되기때문에 다른 이름으로 바꾸고 
        싶으면 javascript 에서  content 를 찾아서 모두 다른 이름으로 바꿔주면 된다. 
  	5. textarea 의 크기가 SmartEditor  의 크기가 된다.
  	6. 폼을 제출하고 싶으면  submitContents(this) 라는 javascript 가 
        폼 안에 있는 버튼에서 실행되면 된다.
--%>
		var oEditors = [];
		   
	   	//추가 글꼴 목록
	   	//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
	   
	   	nhn.husky.EZCreator.createInIFrame({
	      	oAppRef: oEditors,
	      	elPlaceHolder: "content",
	      	sSkinURI: "${pageContext.request.contextPath}/SmartEditor/SmartEditor2Skin.html",   
	      	htParams : {
	        bUseToolbar : true,            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseVerticalResizer : true,      // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
	        bUseModeChanger : true,         // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
	        //aAdditionalFontList : aAdditionalFontSet,      // 추가 글꼴 목록
	        fOnBeforeUnload : function(){
	        	//alert("완료!");
	        }
		}, //boolean
	      	fOnAppLoad : function(){
	        	//예제 코드
	         	//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
	        	document.querySelector("#insertForm").style.display="none";
	      	},
	    fCreator: "createSEditor2"
	   	});
	   
	   	function pasteHTML() {
	      	var sHTML = "<span style='color:#FF0000;'>이미지도 같은 방식으로 삽입합니다.<\/span>";
	      	oEditors.getById["content"].exec("PASTE_HTML", [sHTML]);
	   	}
	   
	   	function showHTML() {
	      	var sHTML = oEditors.getById["content"].getIR();
	      	alert(sHTML);
	   	}
	    
	   	// 위의 form 제출 버튼을 누르면 호출되는 함수
	   	function submitContents(elClickedObj) {
	      	oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);   // 에디터의 내용이 textarea에 적용됩니다.
	      
	      	// 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("content").value를 이용해서 처리하면 됩니다.
	      
	      	try {
	         	elClickedObj.form.submit();
	      	} catch(e) {}
	   	}
	   
	   	function setDefaultFont() {
	      	var sDefaultFont = '궁서';
	      	var nFontSize = 24;
	      	oEditors.getById["content"].setDefaultFont(sDefaultFont, nFontSize);
	   	}
		
	</script>

</body>
</html>