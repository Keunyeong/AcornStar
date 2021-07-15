<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// session scope에 id라고 저장된 data를 불러옴
	String id=(String)session.getAttribute("id");
	// id에 저장된 값이 있으면
	if(id!=null){
		// main page로 redirect
		response.sendRedirect("main/main.jsp");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>AcornStar</title>
<jsp:include page="/include/resource.jsp"></jsp:include>

<style>
@import url('https://fonts.googleapis.com/css2?family=Lobster&display=swap');
body {
	background-image: url("image/bgPurple.png");
	background-size: cover;
}
</style>
</head>
<body>
<div class="text-center" style="margin-top:170px;">

   <h1 style="font-family: 'Lobster', cursive; display: inline-block; color: #c5b3e6;">AcornStar<span class="badge bg-secondary"></span></h1>

</div>

<div class="container" >
   <div style="margin:auto; text-align:center; margin-top:80px; rounded:50px;">
   <form id="loginForm" action="login.jsp" method="post" style="display:inline-block;">
	  <div class="row mb-3">
	    <label for="loginId" class="col-sm-5 col-form-label" style="color: #c5b3e6;">ID</label>
	    <div class="col-sm-7">
	      <input type="text" class="form-control" name="loginId" id="loginId">
	    </div>
	  </div>
	  <div class="row mb-3">
	    <label for="loginPwd" class="col-sm-5 col-form-label" style="color: #c5b3e6;">Password</label>
	    <div class="col-sm-7">
	      <input type="password" class="form-control" name="loginPwd" id="loginPwd">
	    </div>
	  </div>
    <div style="margin-top:50px;">
      <button type="submit" class="col-sm-5 me-2 btn" style="color: #c5b3e6;">LOGIN</button>
      <button type="button" class="btn" style="color: #c5b3e6;" data-bs-toggle="modal" data-bs-target="#exampleModal">
        JOIN
      </button>
	  </div>
	</form> 
	</div>
	
	<!-- Modal -->
	<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="exampleModalLabel">회원가입</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        <form action="signup.jsp" method="post" id="myForm" class="row">
		      <div>
		         <label class="control-label" for="id">아이디</label>
		         <input class="form-control" type="text" name="id" id="id"/>
		         <small class="form-text text-muted">영문자 소문자로 시작하고 5글자~10글자 이내로 입력하세요.</small>
		         <div class="invalid-feedback">사용할수 없는 아이디 입니다.</div>
		      </div>
		      <div>
		         <label class="control-label" for="pwd">비밀번호</label>
		         <input class="form-control" type="password" name="pwd" id="pwd"/>
		         <small class="form-text text-muted">5글자~10글자 이내로 입력하세요.</small>
		         <div class="invalid-feedback">비밀번호를 확인 하세요.</div>
		      </div>
		      <div>
		         <label class="control-label" for="pwd2">비밀번호 확인</label>
		         <input class="form-control" type="password" name="pwd2" id="pwd2"/>
		      </div>
		      <div>
		         <label class="control-label" for="email">이메일</label>
		         <input class="form-control" type="text" name="email" id="email"/>
		         <div class="invalid-feedback">이메일 형식을 확인 하세요.</div>
		      </div>
		      <div class="col-12">
			    <button class="btn btn-primary mt-2" type="submit">가입</button>
			  </div>
		   </form>
	      </div>
	    </div>
	  </div>
	</div>
</div>
<script src="<%=request.getContextPath() %>/js/gura_util.js"></script>
<script>
   //아이디, 비밀번호, 이메일의 유효성 여부를 관리한 변수 만들고 초기값 대입
   let isIdValid=false;
   let isPwdValid=false;
   let isEmailValid=false;
   //아이디를 입력했을때(input) 실행할 함수 등록 
   document.querySelector("#id").addEventListener("input", function(){
      //일단 is-valid,  is-invalid 클래스를 제거한다.
      document.querySelector("#id").classList.remove("is-valid");
      document.querySelector("#id").classList.remove("is-invalid");
      
      //1. 입력한 아이디 value 값 읽어오기  
      let inputId=this.value;
      //입력한 아이디를 검증할 정규 표현식
      const reg_id=/^[a-z].{4,9}$/;
      //만일 입력한 아이디가 정규표현식과 매칭되지 않는다면
      if(!reg_id.test(inputId)){
         isIdValid=false; //아이디가 매칭되지 않는다고 표시하고 
         // is-invalid 클래스를 추가한다. 
         document.querySelector("#id").classList.add("is-invalid");
         return; //함수를 여기서 끝낸다 (ajax 전송 되지 않도록)
      }
      
      //2. util 에 있는 함수를 이용해서 ajax 요청하기
      ajaxPromise("user/checkid.jsp", "get", "inputId="+inputId)
      .then(function(response){
         return response.json();
      })
      .then(function(data){
         console.log(data);
         //data 는 {isExist:true} or {isExist:false} 형태의 object 이다.
         if(data.isExist){//만일 존재한다면
            //사용할수 없는 아이디라는 피드백을 보이게 한다. 
            isIdValid=false;
            // is-invalid 클래스를 추가한다. 
            document.querySelector("#id").classList.add("is-invalid");
         }else{
            isIdValid=true;
            document.querySelector("#id").classList.add("is-valid");
         }
      });
   });
   
   //비밀 번호를 확인 하는 함수 
   function checkPwd(){
      document.querySelector("#pwd").classList.remove("is-valid");
      document.querySelector("#pwd").classList.remove("is-invalid");
      
      const pwd=document.querySelector("#pwd").value;
      const pwd2=document.querySelector("#pwd2").value;
      
      // 최소5글자 최대 10글자인지를 검증할 정규표현식
      const reg_pwd=/^.{5,10}$/;
      if(!reg_pwd.test(pwd)){
         isPwdValid=false;
         document.querySelector("#pwd").classList.add("is-invalid");
         return; //함수를 여기서 종료
      }
      
      if(pwd != pwd2){//비밀번호와 비밀번호 확인란이 다르면
         //비밀번호를 잘못 입력한것이다.
         isPwdValid=false;
         document.querySelector("#pwd").classList.add("is-invalid");
      }else{
         isPwdValid=true;
         document.querySelector("#pwd").classList.add("is-valid");
      }
   }
   
   //비밀번호 입력란에 input 이벤트가 일어 났을때 실행할 함수 등록
   document.querySelector("#pwd").addEventListener("input", checkPwd);
   document.querySelector("#pwd2").addEventListener("input", checkPwd);
   
   //이메일을 입력했을때 실행할 함수 등록
   document.querySelector("#email").addEventListener("input", function(){
	   document.querySelector("#email").classList.remove("is-valid");
	   document.querySelector("#email").classList.remove("is-invalid");
      //1. 입력한 이메일을 읽어와서
      const inputEmail=this.value;
      //2. 이메일을 검증할 정규 표현식 객체를 만들어서
      const reg_email=/@/;
      //3. 정규표현식 매칭 여부에 따라 분기하기
      if(reg_email.test(inputEmail)){//만일 매칭된다면
    	  document.querySelector("#email").classList.add("is-valid");
         isEmailValid=true;
      }else{
    	  document.querySelector("#email").classList.add("is-invalid");
         isEmailValid=false;
      }
   });
   
   
   //폼에 submit 이벤트가 발생했을때 실행할 함수 등록
   document.querySelector("#myForm").addEventListener("submit", function(e){
      /*
         입력한 아이디, 비밀번호, 이메일의 유효성 여부를 확인해서 하나라도 유효 하지 않으면
         e.preventDefault(); 
         가 수행 되도록 해서 폼의 제출을 막아야 한다. 
      */
      //폼 전체의 유효성 여부 알아내기 
      let isFormValid = isIdValid && isPwdValid && isEmailValid;
      if(!isFormValid){//폼이 유효하지 않으면
         //폼 전송 막기 
         e.preventDefault();
      }
      e.preventDefault();
      ajaxFormPromise(this)
      .then(function(response){
    	 return response.json();
      }).then(function(data){
    	 if(data.isSuccess){
    		 alert("회원가입 되었습니다. 로그인 후 이용해주세요.");
    		 location.href="${pageContext.request.contextPath}/index.jsp";
    	 } else {
    		 alert("회원가입에 실패 하였습니다. 다시 시도해주세요.");
    		 location.href="${pageContext.request.contextPath}/index.jsp";
    	 }
      });
   });
   
   document.querySelector("#loginForm").addEventListener("submit", function(e){
	   e.preventDefault();
	   
	   ajaxFormPromise(this)
	   .then(function(response){
		   return response.json();
	   }).then(function(data){
		   if(data.isValid){
			   alert("로그인 되었습니다.");
			   location.href="${pageContext.request.contextPath}/main/main.jsp";
		   } else {
			   alert("로그인에 실패 하였습니다.");		
		   }
	   });	   
   });
   
</script>
</body>
</html>