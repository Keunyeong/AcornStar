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
</style>
</head>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
	<h1>로그인 후 main page 입니다.</h1>
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