<%@page import="test.info.dao.InfoDao"%>
<%@page import="test.info.dto.InfoDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   int num=Integer.parseInt(request.getParameter("num"));
   InfoDto dto=InfoDao.getInstance().getData(num);
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/info/private/update_form.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<style>
	body {
		margin-top:30px;
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
		width: 100%;
		display:none;
	}
	
	.submitBtn{
		float: left;
		width: 80px;
		height: 50px;
		margin-bottom: 20px;
		border: 2px solid #a385cf;
		border-radius: 10px;
		outline: none;
		background-color: #fff;
	}
	.submitBtn:hover{
		background-color: #a385cf;
		color: #fff;
	}
	.resetBtn{
		float: right;
		width: 80px;
		height: 50px;
		margin-bottom: 20px;
		margin-left: 10px;
		border: 2px solid #a385cf;
		border-radius: 10px;
		outline: none;
		background-color: #fff;
	}
	.resetBtn:hover{
		background-color: #a385cf;
		color: #fff;
	}
	table{
		text-align: center;
	}
	#writer{
		border: none;
		width: 900px;
		text-align: center;
	}
	#writer:focus{
		outline: none;
	}
	#title{
		border: none;
		width: 900px;
		text-align: center;
	}
	#title:focus{
		outline: none;
	}
</style>
</head>
<body>
<jsp:include page="../../include/navbar.jsp"></jsp:include>
<div class="container">
   <form action="update.jsp" method="post">
          <input type="hidden" name="num" value="<%=num %>" />
          <div class="input-group input-group-sm" role="group" aria-label="...">
            <table class="table table-bordered">
               <thead>   
                  <tr>
                     <th style="color: #a385cf;">작성자</th>
                     <td width="70%"><input type="text" id="writer" value="<%=dto.getWriter() %>" disabled/></td>
                  </tr>
                  <tr>
                     <th style="color: #a385cf;">제목</th>
                     <td><input type="text" name="title" id="title" value="<%=dto.getTitle()%>"/></td>
                  </tr>
               </thead>
               <tbody>
                  <tr>
                     <td colspan="2">
                        <textarea name="content" id="content" ><%=dto.getContent() %></textarea>
                     </td>
                  </tr>
               </tbody>
            </table>
         </div>
         <button type="submit" onclick="submitContents(this);" class="submitBtn">수정하기</button>
         <button type="reset" onclick="location.href='../info.jsp'" class="resetBtn">취소</button>
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
			bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
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