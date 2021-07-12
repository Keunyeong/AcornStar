<%@page import="test.musicfeed.dao.MusicCommentDao"%>
<%@page import="test.musicfeed.dto.MusicCommentDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 로그인 id 정보 받아오기
	String id=(String)session.getAttribute("id");
	
	// pageNum && num 정보 받아오기
	int comment_pageNum=Integer.parseInt(request.getParameter("pageNum"));
	int num=Integer.parseInt(request.getParameter("num"));

	/*
	댓글 paging 처리
	*/
	
	// 한 번에 몇 개 씩 보이게 할 것인지
	final int comment_row_count=5;
	
	// 보여줄 댓글 page의 시작 rownum
	int comment_startRowNum=1+(comment_pageNum-1)*comment_row_count;
	// 보여줄 댓글 page의 끝 rownum
	int comment_endRowNum=comment_pageNum*comment_row_count;
	
	MusicCommentDto comment_dto=new MusicCommentDto();
	comment_dto.setNum(num);
	comment_dto.setStartRowNum(comment_startRowNum);
	comment_dto.setEndRowNum(comment_endRowNum);
	
	// 댓글 전체의 개수 얻어내기
	int comment_totalRow=MusicCommentDao.getInstance().getCount(num);
	
	// 전체 page의 수
	int comment_totalPageCount=(int)Math.ceil(comment_totalRow/(double)comment_row_count);
%>
	<!-- 댓글의 data를 불러온다. -->
	<%List<MusicCommentDto> commentList=MusicCommentDao.getInstance().getList(comment_dto); %>
	<%for(MusicCommentDto tmp2:commentList) {%>
		<%if(tmp2.getDeleted().equals("yes")){ %>
			<li>삭제된 댓글입니다.</li>
		<% // continue; 아래의 코드를 수행하지 않고 for문으로 실행 순서를 다시 보내기
			continue;
		}%>
		<%if(tmp2.getComment_group()==tmp2.getNum()) {%>
			<li id="comment<%=tmp2.getNum()%>">
		<%} else {%>
			<li id="comment<%=tmp2.getNum()%>" style="padding-left:50px;">
		<%} %>
			<dl>
				<dt>
					<span><%=tmp2.getWriter() %></span>
					<a data-num="<%=tmp2.getNum() %>" class="recomment-link" href="javascript;">댓글</a>
					<%if(tmp2.getWriter().equals(id)){ %>
						<a data-num="<%=tmp2.getNum() %>" class="comment-update-link" href="javascript:">수정</a>
						<a data-num="<%=tmp2.getNum() %>" class="comment-delete-link" href="javascript:">삭제</a>
					<%} %>
					<span><%=tmp2.getRegdate() %></span>
				</dt>
				<dd>
					<pre><%=tmp2.getContent() %></pre>
				</dd>
			</dl>
			<!-- 댓글 수정하는 form(hidden) -->
			<%if(tmp2.getWriter().equals(id)){ %>
				<form data-num="<%=tmp2.getNum() %>" id="commentUpdateForm<%=tmp2.getNum() %>" class="commentUpdate" style="display:none;" action="update_comment.jsp" method="post">
					<input type="hidden" name="num" value="<%=tmp2.getNum() %>"/>
					<textarea name="commentUpdate" id="commentUpdate"><%=tmp2.getContent() %></textarea>
					<button type="submit">수정하기</button>
				</form>
			<%} %>
			<!-- 대댓글 form(hidden) -->
			<form data-num="<%=tmp2.getNum() %>" id="recommentForm<%=tmp2.getNum() %>" class="comment" style="display:none;" action="insert_comment.jsp" method="post">
				<input type="hidden" name="target_id" value="<%=tmp2.getWriter() %>"/>
				<input type="hidden" name="ref_group" value="<%=num %>"/>
				<input type="hidden" name="comment_group" value="<%=tmp2.getComment_group()%>"/>
				<textarea name="comment" id="recomment"></textarea>
				<button type="submit">댓글 달기</button>
			</form>
		</li>
	<%} %>
	<%if(comment_totalPageCount > comment_pageNum){ %>
		<a data-num="<%=num %>" data-num2="<%=comment_totalPageCount %>" class="moreComment" href="javascript:">더보기</a>
	<%} %>