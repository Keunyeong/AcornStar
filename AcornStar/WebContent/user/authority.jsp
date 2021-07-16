<%@page import="java.util.List"%>
<%@page import="test.users.dto.UsersDto"%>
<%@page import="test.users.dao.UsersDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	List<UsersDto> list = UsersDao.getInstance().getList();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
<jsp:include page="../include/navbar.jsp"></jsp:include>
<div class="container">
	<table class="table">
		<thead>
			<tr >
				<th scope="col">아이디</th>
				<th scope="col">이름</th>
				<th scope="col">권한</th>
			</tr>
		</thead>
		<tbody>
			<%for(UsersDto tmp:list){%>
				<tr>
					<td><%=tmp.getId()%></td>
					<td><%=tmp.getName()%></td>
					<td>
						<%if((tmp.getAutority()).equals("yes")){ %>
							<select name="autority" class="autority">
								<option value="<%=tmp.getId()%>,yes" selected>yes</option>
								<option value="<%=tmp.getId()%>,no">no</option>
							</select>
						<%}else{ %>
							<select name="autority" class="autority">
								<option value="<%=tmp.getId()%>,yes">yes</option>
								<option value="<%=tmp.getId()%>,no" selected>no</option>
							</select>
					<%} %>
					</td>
				</tr>
			<%} %>
		</tbody>
	</table>
</div>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
<script>
let select=document.querySelectorAll(".autority");
for(let i=0; i<select.length; i++){
	select[i].addEventListener("change", function(){
		let idAuth = this.value;
		let obj = idAuth.split(",");
		let id = obj[0];
		let auth = obj[1];
		console.log(this.value);
		ajaxPromise("authorize.jsp", "post", "id="+id+"&auth="+auth)
		.then(function(response){
			return response.json();
		})
		.then(function(data){
			if(data.isSuccess){
				alert("권한이 변경되었습니다.");
			}else{
				alert("권한 변경에 실패 하였습니다.");
			}
		});
	});
};
document.querySelector("#newWrite").style.display="none";
document.querySelector("#searchForm").style.display="none";
</script>
</body>
</html>