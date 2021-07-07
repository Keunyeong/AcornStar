<%@page import="test.feed.dao.FeedCommentDao"%>
<%@page import="test.feed.dto.FeedCommentDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//폼 전송되는 파라미터 추출 
	int ref_group=Integer.parseInt(request.getParameter("ref_group"));
	String target_id=request.getParameter("target_id");
	String content=request.getParameter("content");
	/*
	 *  원글의 댓글은 comment_group 번호가 전송이 안되고
	 *  댓글의 댓글은 comment_group 번호가 전송이 된다.
	 *  따라서 null 여부를 조사하면 원글의 댓글인지 댓글의 댓글인지 판단할수 있다. 
	 */
	String comment_group=request.getParameter("comment_group");
	
	//댓글 작성자는 session 영역에서 얻어내기
	String writer=(String)session.getAttribute("id");
	//댓글의 시퀀스 번호 미리 얻어내기
	int seq=FeedCommentDao.getInstance().getSequence();
	//저장할 댓글의 정보를 dto 에 담기
	FeedCommentDto dto=new FeedCommentDto();
	dto.setNum(seq);
	dto.setWriter(writer);
	dto.setTarget_id(target_id);
	dto.setContent(content);
	dto.setRef_group(ref_group);
	//원글의 댓글인경우
	if(comment_group == null){
		//댓글의 글번호를 comment_group 번호로 사용한다.
		dto.setComment_group(seq);
	}else{
		//전송된 comment_group 번호를 숫자로 바꾸서 dto 에 넣어준다. 
		dto.setComment_group(Integer.parseInt(comment_group));
	}
	//댓글 정보를 DB 에 저장하기
	boolean isSuccess = FeedCommentDao.getInstance().insert(dto);
%>    
{"isSuccess":<%=isSuccess %>} 
