<%@page import="java.util.List"%>
<%@page import="test.musicfeed.dao.MusicCommentDao"%>
<%@page import="test.musicfeed.dto.MusicCommentDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 일단 id 정보를 불러와서 writer에 담는다.
	String id=(String)session.getAttribute("id");
	int num=Integer.parseInt(request.getParameter("num"));
	int comment_pageNum=1+Integer.parseInt(request.getParameter("currentPage"));
	
	// 글 번호, target_id, 댓글에 대한 정보를 받아오고
	String content=request.getParameter("comment");
	String target_id=request.getParameter("target_id");
	int ref_group=Integer.parseInt(request.getParameter("ref_group"));
	String comment_group=request.getParameter("comment_group");
	// ㄴ 0인 경우 글에 직접 달린 댓글이다
	// ㄴ 대댓글에서는 이 정보를 따로 전달해서 댓글 아래 댓글을 출력할 수 있다.
	
	// sequence 숫자 정보
	int seq=MusicCommentDao.getInstance().getSequence();
	
	// dto에 넣고
	MusicCommentDto dto= new MusicCommentDto();
	dto.setNum(seq);
	dto.setWriter(id);
	dto.setContent(content);
	dto.setTarget_id(target_id);
	dto.setRef_group(ref_group);
	if(comment_group==null){
		dto.setComment_group(seq);
	} else {
		dto.setComment_group(Integer.parseInt(comment_group));
	}
	
	// 한 번에 몇 개 씩 보이게 할 것인지
	final int comment_row_count=5;
	// 댓글 전체의 개수 얻어내기
	int comment_totalRow=MusicCommentDao.getInstance().getCount(num);
	// 전체 page의 수
	int comment_totalPageCount=(int)Math.ceil(comment_totalRow/(double)comment_row_count);
	// 응답
	boolean beInserted=MusicCommentDao.getInstance().insert(dto);
	
%>
	<%if(beInserted){%>
		<!-- 댓글의 data를 불러온다. -->
		<%List<MusicCommentDto> commentList=MusicCommentDao.getInstance().getLast(id); %>
		<%for(MusicCommentDto tmp2:commentList) {%>
			<%if(tmp2.getDeleted().equals("yes")){ %>
				<li>삭제된 댓글입니다.</li>
			<% // continue; 아래의 코드를 수행하지 않고 for문으로 실행 순서를 다시 보내기
				continue;
			}%>
			<%if(tmp2.getComment_group()==tmp2.getNum()) {%>
				<li id="comment<%=tmp2.getNum()%>" class="page-<%=comment_pageNum%>">
			<%} else {%>
				<li id="comment<%=tmp2.getNum()%>" class="page-<%=comment_pageNum%>" style="padding-left:50px;">
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
				<form data-num="<%=tmp2.getNum() %>" data-num3="<%=comment_pageNum %>" id="recommentForm<%=tmp2.getNum() %>" class="comment" style="display:none;" action="insert_comment2.jsp" method="post">
					<input type="hidden" name="target_id" value="<%=tmp2.getWriter() %>"/>
					<input type="hidden" name="ref_group" value="<%=num %>"/>
					<input type="hidden" name="comment_group" value="<%=tmp2.getComment_group()%>"/>
					<textarea name="comment" id="recomment"></textarea>
					<button type="submit">댓글 달기</button>
				</form>
			</li>
		<%} %>
		
	<%}%>