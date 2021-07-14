package test.musicfeed.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.musicfeed.dto.MusicCommentDto;
import test.util.DbcpBean;

public class MusicCommentDao {
	private static MusicCommentDao dao;
	
	private MusicCommentDao() {
		
	}
	
	public static MusicCommentDao getInstance() {
		if(dao==null) {
			dao=new MusicCommentDao();
		}
		return dao;
	}
	
	// sequence 숫자를 반환하는 method
	public int getSequence() {
		int seq=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select music_comment_seq.nextval as seq"
					+ " from dual";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding

			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				seq=rs.getInt("seq");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		return seq;
	}
	
	// 댓글을 추가하는 method
	public boolean insert(MusicCommentDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "insert into music_comment"
					+ " (num, writer, content, target_id, ref_group, comment_group, deleted, regdate)"
					+ " values(?, ?, ?, ?, ?, ?, 'no', sysdate)";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setInt(1, dto.getNum());
			pstmt.setString(2, dto.getWriter());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getTarget_id());
			pstmt.setInt(5, dto.getRef_group());
			pstmt.setInt(6, dto.getComment_group());
			// insert or update or delete 문 수행하고
			// 변화된 row의 개수 return 받기
			flag = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		if (flag > 0) {
			return true;
		} else {
			return false;
		}
	
	}
	
	// 해당 댓글을 불러오는 method
	public List<MusicCommentDto> getList(MusicCommentDto dto) {
		List<MusicCommentDto> list=new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select *"
					+ " from"
					+ 		" (select result1.*, rownum as rnum"
					+ 		" from"
					+ 			" (select *"
					+ 			" from music_comment"
					+ 			" where ref_group=?"
					+ 			" order by comment_group asc, num asc) result1)"
					+ " where rnum between ? and ?";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setInt(1, dto.getNum());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			while (rs.next()) {
				MusicCommentDto dto2=new MusicCommentDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setContent(rs.getString("content"));
				dto2.setTarget_id(rs.getString("target_id"));
				dto2.setRef_group(rs.getInt("ref_group"));
				dto2.setComment_group(rs.getInt("comment_group"));
				dto2.setDeleted(rs.getString("deleted"));
				dto2.setRegdate(rs.getString("regdate"));
				list.add(dto2);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		return list;
	}
	
	// 댓글의 총 수를 얻어내는 method
	public int getCount(int ref_group) {
		int count=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select nvl(max(rownum),0) as count"
					+ " from music_comment"
					+ " where ref_group=?";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setInt(1, ref_group);
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("count");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		return count;
	}	
	
	// 해당 댓글을 삭제하는 method
	// 사실 삭제하는게 아니라 deleted를 yes로
	public boolean delete(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "update music_comment"
					+ " set deleted='yes'"
					+ " where num=?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setInt(1, num);
			// insert or update or delete 문 수행하고
			// 변화된 row의 개수 return 받기
			flag = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		if (flag > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	// 해당 댓글을 수정하는 method
	public boolean update(MusicCommentDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "update music_comment"
					+ " set content=?"
					+ " where num=?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getContent());
			pstmt.setInt(2, dto.getNum());
			// insert or update or delete 문 수행하고
			// 변화된 row의 개수 return 받기
			flag = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		if (flag > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	// 본인이 방금 직전에 등록한 댓글을 불러오는 method
	public List<MusicCommentDto> getLast(String id) {
		List<MusicCommentDto> list=null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select *"
					+ " from"
					+ 	" (select result1.*, rownum as rnum" 
					+ 	" from"
					+ 		" (select *"
					+ 		" from music_comment"
					+ 		" where writer=?) result1)"
					+ " where rnum=(select nvl(max(rnum),0)"
					+ 				" from"
					+ 					" (select result1.*, rownum as rnum"
					+ 					" from"
					+ 					" (select *"
					+ 					" from music_comment"
					+ 					" where writer='test123') result1))";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setString(1, id);
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				list=new ArrayList<>();
				MusicCommentDto dto=new MusicCommentDto();
				dto=new MusicCommentDto();
				dto.setNum(rs.getInt("num"));
				dto.setWriter(rs.getString("writer"));
				dto.setContent(rs.getString("content"));
				dto.setTarget_id(rs.getString("target_id"));
				dto.setRef_group(rs.getInt("ref_group"));
				dto.setComment_group(rs.getInt("comment_group"));
				dto.setDeleted(rs.getString("deleted"));
				dto.setRegdate(rs.getString("regdate"));
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		return list;
	}
}
