<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/myProfile.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700&display=swap" rel="stylesheet">
<style>

	body {
		font-family: 'Nanum Gothic', sans-serif;
		font-size: 15px;
	}

	.profile_article {
		margin-top: 20px;
		display: flex;
		flex-direction: column;
		align-items: center;
		width: 70%;
	}
	
	.profile_list {
		list-style:none;
		float: left;
		border: 1px solid lightgray;
		width: 200px;
		height: 80%;
		padding-left: 0;
		margin-left: 60px;
		margin-bottom: 50px;
		margin-top: 30px;
		text-align: center;
	}
	
	.profile_list a {
		text-decoration:none;
		color: #313833;
		display: block;
		padding: 30px 0;
	}
	
	.profile_list a:hover {
		background-color: #c465f0;
		color: #fff;
		font-weight: 700;
	}
	
	
	.profile_form {
		margin-left: 20px;
		margin-top: 5px;
		display: flex;
		flex-direction: column;
	}
	
	.profile_form input {
		width: 300px;
		padding-left: 5px;
	}
	
	.profile_form input:hover {
		border: 2px solid #c465f0;
		border-radius: 5px;
	}
	
	.profile_form input:focus {
		border: none;
		outline: none;
		border-bottom: 2px solid #c465f0;
		border-radius: 0;
	}
	
	.profile_form > div {
		display: flex;
		flex-direction: row;
	}
	
	.profile_form > div > aside {
		width: 150px;
		padding: 15px;
		font-weight: 700;
	}
	
	.profile_form > div > div {
		padding: 15px;
	}
	
	.profile_header {
		margin: auto 0;
		display:flex;
		flex-direction:column;
		align-items: center;
		margin-bottom: 5px;
	}
	
	.profile_header > div {
		margin-top: 35px;
	}
	
	.profile_header svg {
		border-radius: 100%;
		border: 1px solid #fff;
		background-color: lightgray;
		color: #fff;
	}
			
	.profile_header svg:hover {
		opacity: 0.7;
	}
	
	.profile_border {
		width: 153px;
		height: 153px;
		display: flex;
	    justify-content: center;
	    align-items: center;
	    border-radius: 100%;
	    background: radial-gradient(circle at bottom left, #F58529 20%, #C42D91);
	    margin-bottom: 8px;
	}
	
	.profile_btn {
		width: 70px;
		height: 30px;
		border: none;
		border-radius: 10px;
		outline: none;
		background-color: #fff;
		margin-left: 650px;
		margin-bottom:20px;
		transition: all 0.2s ease-in; 
	}
	
	.profile_btn:hover {
		background-color: #c465f0;
		color: #fff;
	}
	
	.intro_area {
		padding-left: 5px;
		outline:none;
	}
	
	.intro_area:hover {
		border: 2px solid #c465f0;
		border-radius: 5px;
	}
	
	.intro_area:focus {
		border: none;
		outline: none;
		border-bottom: 2px solid #c465f0;
		border-radius: 0;
	}
	
</style>
</head>
<body>
<jsp:include page="../include/navbar.jsp"></jsp:include>
<section>
	<main>
		<div>
		
				<!-- 마이프로필 사이드바 마크업 -->
				
			<ul class="profile_list">
				<li><a  href="${pageContext.request.contextPath}/user/update_form.jsp">프로필 수정</a></li>
				<li><a style="letter-spacing:5px;" href="${pageContext.request.contextPath}/info/info.jsp">공지사항</a></li>
				<li><a style="letter-spacing:15px;" href="${pageContext.request.contextPath}/suggest/list.jsp">Q&A</a></li>
				<li><a style="letter-spacing:5px;" href="${pageContext.request.contextPath}/index.jsp">로그아웃</a></li>
				<li><a  href="#">이메일 및 SMS</a></li>
				<li><a  href="#">공개범위 및 보안</a></li>
				<li><a  href="#">연락처 관리</a></li>
			</ul>
			
				<!-- 마이프로필 수정 폼 (프로필 이미지, 소개글 포함) 마크업 -->
				
			<article class="profile_article">
				<div class="profile_header">
					<div class="profile_border">
						<svg xmlns="http://www.w3.org/2000/svg" width="145" height="145" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
						  <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
						  <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
						</svg>
					
					</div>
					<p style="font-weight:700; font-size:16px;">User ID</p>
					<a style="text-decoration:none;" href="#">프로필 사진 바꾸기</a>
				</div>
				<form class="profile_form" action="#">
					<div>
						<aside><label for="name"></label>이름</aside>
						<div>
							<div>
								<input placeholder="이름"/>
								<div style="margin-top:5px; font-size:13px; color:gray;" type="text">회원님의 알려진 이름을 사용하여 회원님의 계정을 찾을 수 있도록 도와주세요.</div>
							</div>
						</div>
					</div>
					<div>
						<aside><label for="id"></label>사용자 아이디</aside>
						<div>
							<div>
								<input placeholder="사용자 아이디"/>
								<div style="margin-top:5px; font-size:13px; color:gray;" type="text">대부분의 경우 14일 이내에 사용자 이름을 다시 (으)로 변경할 수 있습니다.</div>
							</div>
						</div>
					</div>
					<div>
						<aside><label for="introduce"></label>소개</aside>
						<div>
							<div>
								<textarea class="intro_area" type="text" placeholder="소개글" rows="2" cols="35"></textarea>
							</div>
						</div>
					</div>
					<div>
						<aside><label for="email"></label>이메일</aside>
						<div>
							<div>
								<input type="email" placeholder="이메일"/>
							</div>
						</div>
					</div>
					
							<!-- 경로 수정! 클릭하면 프로필 변경 -->
							
					<button class="profile_btn" type="button" onclick="location.href='#'">제출</button> 
				</form>
			</article>
		</div>
	</main>
</section>
</body>
</html>