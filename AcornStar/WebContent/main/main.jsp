
<%@page import="test.feed.dao.MainFeedDao"%>
<%@page import="test.feed.dto.MainFeedDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// session scope에서 id 정보 불러오기
	String id=(String)session.getAttribute("id");	
	
	// method를 이용, DB에서 data를 불러온다.
	List<MainFeedDto> list=MainFeedDao.getInstance().getList();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>main.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
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
	@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
	   .drag-area,.updrag-area{
      width: 200px;
      height: 300px;
      border: 2px dashed gray;
      border-radius: 20px;
   }
</style>
</head>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
<jsp:include page="../include/navbar.jsp"></jsp:include>
	<div class="container">
		<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
			<%for(MainFeedDto tmp:list){%>
				<div id="card<%=tmp.getNum() %>" class="col item front">
					<div class="card h-100" style="width: 18rem;">
						<ul class="list-group list-group-flush">
						    <li class="list-group-item"><%=tmp.getWriter() %>님이 작성한 글.</li>
						</ul>
					  <img src="<%=tmp.getImage() %>" class="card-img-top" style="
					         width: 100%;
					         height: 100%;
					         object-fit: contain;
					   " >
					  <div class="card-body">
					    <p class="card-text">
					    	<%=tmp.getContent() %>
					    </p>
					  </div>
					  <ul class="list-group list-group-flush">
					    <li class="list-group-item"><%=tmp.getTag() %></li>
					    <%if(tmp.getWriter().equals(id)){ %>
					    <li class="list-group-item">
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
					    <li class="list-group-item">
					    	<a data-num="<%=tmp.getNum() %>" class="comment" href="javascript:">댓글</a>
					    </li>
					  </ul>
					</div>
				</div>
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
				<button class="btn " style="color: #6610f2;" type="submit">SAVE</button>
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
				});				
			});
		}
		
		
		// 댓글버튼 누르면 댓글 보여주기
		let commentLinks=document.querySelectorAll(".comment");
		for(let i=0; i<commentLinks.length; i++){
			commentLinks[i].addEventListener("click", function(){
				let num=this.getAttribute("data-num");
				
				ajaxPromise("ajax_comment.jsp", "post", "num="+num)
				.then(function(response){
					return response.json();
				}).then(function(data){
					console.log(data);
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
	</script>
<script>
document.querySelector("#acornstar").addEventListener("click",function(){
	location.href="${pageContext.request.contextPath}/music/musicMain.jsp";
	let star = document.querySelector("#star");
	let music = document.querySelector("#music");
	document.getElementById("#star").style.display = "none";
});
</script>
</body>
</html>