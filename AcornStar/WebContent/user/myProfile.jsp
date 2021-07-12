<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/user/myProfile.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
	.profile_list {
		list-style:none;
	}
	.profile_list a {
		text-decoration:none;
		color: #313833;
	}
</style>
</head>
<body>
<jsp:include page="../include/navbar.jsp"></jsp:include>
<section>
	<main>
		<div class="container">
			<ul class="profile_list">
				<li><a href="${pageContext.request.contextPath}/user/update_form.jsp">프로필 수정</a></li>
				<li><a href="${pageContext.request.contextPath}/info/info.jsp">공지사항</a></li>
				<li><a href="${pageContext.request.contextPath}/suggest/list.jsp">Q&A</a></li>
				<li><a href="${pageContext.request.contextPath}/index.jsp">로그아웃</a></li>
				<li><a href="">이메일 및 SMS</a></li>
				<li><a href="">공개범위 및 보안</a></li>
				<li><a href="">연락처관리</a></li>
			</ul>
			<div class="container" style="margin: 20px;">
			<article>
				<form action="#">
					<div class="m-2">
						<aside>
						<label for="name">이름</label>
						</aside>
					</div>
						<input type="text" placeholder="이름"/>
						사람들이 이름, 별명 또는 비즈니스 이름 등 회원님의 알려진 이름을 사용하여 회원님의 계정을 찾을 수 있도록 도와주세요.		
						
					<div class="m-2">
						<aside>
						<label for="id">사용자 아이디</label>
						</aside>
					</div>
						<input type="text" placeholder="사용자 아이디"/>
						대부분의 경우 14일 이내에 사용자 이름을 다시 (으)로 변경할 수 있습니다.
						
					<div class="m-2">
						<aside>
						<label for="introduce">소개</label>
						</aside>
					</div>
						<input type="text" placeholder="소개글"/>
						
					<div class="m-2">
						<aside>
						<label for="email">이메일</label>
						</aside>
					</div>
						<input type="email" placeholder="이메일"/>
						
					<!-- 이 버튼 누르면 프로필 작성한거로 변경돼야함 아님말고 -->
					<div class="container">
					<button type="submit" style="margin-top: 30px; margin-right: 20px;">제출</button>
					</div>
				</form>
			</article>
			</div>
		</div>
	</main>
</section>
</body>
</html>