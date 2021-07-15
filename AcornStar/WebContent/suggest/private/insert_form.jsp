<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insert_form</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700&display=swap" rel="stylesheet">
<style>

	body {
		font-family: 'Nanum Gothic', sans-serif;
		font-size: 15px;
	}
	
	/*Navbar 가로 정렬*/
	.navbar_ul {
		display:flex;
		flex-direction: row;
		justify-content:space-around;
		align-items:center;
	}

	#content{
		height: 400px;
		display:none;
	}
	
	.form_title {
		font-weight:700;
		margin-top:10px;
	}
	
	.form_btn {
		border: 2px solid #c465f0;
		border-radius: 5px;
		outline: none;
		background-color: #fff;
		width:60px;
		height:35px;
		margin-bottom: 20px;
		transition: all 0.3s ease-in;
	}
	
	.form_btn:hover {
		background-color: #c465f0;
		color: #fff;
	}
	
</style>
</head>
<body>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
<jsp:include page="../../include/navbar.jsp"></jsp:include>
<div class="container">
   <h2 class="form_title">Q&A</h2>
   <form action="insert.jsp" method="post" id="insertForm">
      <div class="mb-3 mt-4">
         <label class="form-label" for="title">제목</label>
         <input class="form-control" type="text" name="title" id="title"/>
      </div>
      <div class="mb-3">
         <label class="form-label" for="content">내용</label>
         <textarea class="form-control"  name="content" id="content"></textarea>
      </div>
      <button class="form_btn" type="submit">저장</button>
   </form>
</div>
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
<!-- SmartEditor 에서 필요한 javascript 로딩  -->
<script src="${pageContext.request.contextPath }/SmartEditor/js/HuskyEZCreator.js"></script>
<script>
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

   
   function setDefaultFont() {
      var sDefaultFont = '궁서';
      var nFontSize = 24;
      oEditors.getById["content"].setDefaultFont(sDefaultFont, nFontSize);
   }
   
   //폼에 submit 이벤트가 일어났을때 실행할 함수 등록
   document.querySelector("#insertForm")
      .addEventListener("submit", function(e){
         //에디터에 입력한 내용이 textarea 의 value 값이 될수 있도록 변환한다. 
         oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
         //textarea 이외에 입력한 내용을 여기서 검증하고 
         const title=document.querySelector("#title").value;
         
         //만일 폼 제출을 막고 싶으면  
         //e.preventDefault();
         //을 수행하게 해서 폼 제출을 막아준다.
         if(title.length < 5){
            alert("제목을 5글자 이상 입력하세요!");
            e.preventDefault();
         }
         
      });
</script>
</body>
</html>



