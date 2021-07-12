<%@page import="test.users.dto.UsersDto"%>
<%@page import="test.users.dao.UsersDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String id = (String)session.getAttribute("id");
	
	UsersDto dto = new UsersDto();
	dto = UsersDao.getInstance().getData(id);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.drag-area,.updrag-area{
      width: 200px;
      height: 300px;
      border: 2px dashed gray;
      border-radius: 20px;
   }
</style>
</head>
<body>
<form action="signupUpdate.jsp" method="post" id="updatemyForm" class="row">
	<div class="drag-area">
		<img id="myImage" style="
		        width: 80%;
		        height: 80%;
		        object-fit: contain;
		        margin:25px;"/>
	</div>
	<label class="form-label" for="profile">PROFILE</label>
	<textarea style="display:none;" class="form-control"  name="profile" id="profile"></textarea>
				
   <div>
      <label class="control-label" for="id">아이디</label>
      <input class="form-control" type="text" name="id" id="id" value="<%=dto.getId() %>" disabled/>
      <small class="form-text text-muted">영문자 소문자로 시작하고 5글자~10글자 이내로 입력하세요.</small>
   </div>
   <div>
      <label class="control-label" for="email">이메일</label>
      <input class="form-control" type="text" name="email" id="email" value="<%=dto.getEmail() %>"/>
      <div class="invalid-feedback">이메일 형식을 확인 하세요.</div>
   </div>
	<div class="col-12">
	<button class="btn btn-primary mt-2" type="submit">수정</button>
	</div>
</form>
	
<script src="<%=request.getContextPath() %>/js/gura_util.js"></script>
			
<script>

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
   document.querySelector("#profile").files = files;
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
       
       document.querySelector("#profile").innerText=e.target.result;
    };
 };

   //아이디, 비밀번호, 이메일의 유효성 여부를 관리한 변수 만들고 초기값 대입
   
   //아이디를 입력했을때(input) 실행할 함수 등록 

   
   //폼에 submit 이벤트가 발생했을때 실행할 함수 등록
   document.querySelector("#updatemyForm").addEventListener("submit", function(e){
      e.preventDefault();
      ajaxFormPromise(this)
      .then(function(response){
    	 return response.json();
     })
      .then(function(data){
    	 if(data.isSuccess){
    		 alert("회원정보가 수정 되었습니다.");
    		 location.href="${pageContext.request.contextPath}/user/myProfile.jsp";
    	 } else {
    		 alert("회원정보 수정에 실패 하였습니다.");
    		 location.href="${pageContext.request.contextPath}/user/update_form.jsp";
    	 }
      });
});
</script>
</body>
</html>