<%@page import="test.suggest.dao.SuggestDao"%>
<%@page import="test.suggest.dto.SuggestDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   int num=Integer.parseInt(request.getParameter("num"));
   SuggestDto dto=SuggestDao.getInstance().getData(num);
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/suggest/private/update_form.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<style>
 #content {
 	height: 400px;
 	width: 600px;
 	display: none;
 }
 
	 /*Navbar 가로 정렬*/
	.navbar_ul {
		display:flex;
		flex-direction: row;
		justify-content:space-around;
		align-items:center;
	}
 
 .update_title {
 	font-weight: 700;
 	margin: 30px 0;
 }
 
 .update_btn {
	border: 2px solid #c465f0;
	border-radius: 5px;
	outline: none;
	background-color: #fff;
	width:100px;
	height:35px;
	margin: 20px 0;
	transition: all 0.3s ease-in;
	margin-left:12px;
 }
 
 .update_btn:hover {
	background-color: #c465f0;
	color: #fff;
 }
 
 .update_input {
 	border: none;
 	border-bottom: 1px solid gray;
 }
 
 .input_m {
 	margin-left : 15px;
 }
 
 .input_m:focus {
 	outline: none;
 }
 
 .update_wt {
 	border-left: 2px solid #c465f0;
 	padding-left: 10px;
 }
 
 .update_wt > label{
 	font-size: 14px;
 }
 
  .update_wt > label > input {
 	font-size: 14px;
 }
 
</style>
</head>
<body>
<jsp:include page="../../include/navbar.jsp"></jsp:include>
<div class="container">

<!-- update 상단 타이틀 -->
   <h2 class="update_title">Q&A</h2>
   <form class="update_form" action="update.jsp" method="post">
      <input type="hidden" name="num" value="<%=num %>" />
      
<!-- update 상단 작성자,제목 수정 -->
      <div class="update_wt">
         <label for="writer">작성자</label>
         <input class="update_input" style="width:200px;" type="text" id="writer" value="<%=dto.getWriter() %>" disabled/>
      </div>
      <div class="update_wt">
         <label for="title">제목</label>
         <input class="update_input input_m" style="width:200px;" type="text" name="title" id="title" value="<%=dto.getTitle()%>"/>
      </div>
      
<!-- update 내용 컨텐츠 -->
      <div>
         <label for="content" style="visibility:hidden;">내용</label>
         <textarea name="content" id="content"><%=dto.getContent() %></textarea>
      </div>
      <button class="update_btn" type="submit" onclick="submitContents(this);">수정확인</button>
      <button class="update_btn" type="reset" onclick="location.href='../list.jsp'">취소</button>
   </form>
</div>
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
   document.querySelector("#newWrite").style.display="none";
</script>
</body>
</html>