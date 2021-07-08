<%@page import="test.musicfeed.dao.MusicCommentDao"%>
<%@page import="test.musicfeed.dto.MusicCommentDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	// 일단 id 정보를 불러와서 writer에 담는다.
	String writer=(String)session.getAttribute("id");

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
	dto.setWriter(writer);
	dto.setContent(content);
	dto.setTarget_id(target_id);
	dto.setRef_group(ref_group);
	if(comment_group==null){
		dto.setComment_group(seq);
	} else {
		dto.setComment_group(Integer.parseInt(comment_group));
	}

	
	// 응답
	boolean beInserted=MusicCommentDao.getInstance().insert(dto);
	
%>
{"beInserted":<%=beInserted %>, "content":"<%=content%>"}