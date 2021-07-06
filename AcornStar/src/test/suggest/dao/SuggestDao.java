package test.suggest.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.suggest.dto.SuggestDto;
import test.util.DbcpBean;

	public class SuggestDao {
	private static SuggestDao dao;

	private SuggestDao() {
		
	}
	
	public static SuggestDao getInstance() {
		if(dao==null) {
			dao=new SuggestDao();
		}
		return dao;
	}

	//조회수 증가 시키는 메소드
	public boolean addViewCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "UPDATE suggest"
					+ " SET viewCount=viewCount+1"
					+ " WHERE num=?";
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, num);
			//insert or update or delete 문 수행하고 변화된 row 의 갯수 리턴 받기
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

	// 새 글을 추가하는 method
	public boolean insert(SuggestDto dto) {
	Connection conn = null;
	PreparedStatement pstmt = null;
	int flag = 0;
	try {
		conn = new DbcpBean().getConn();
		// 실행할 sql 문 작성
		String sql = "insert into suggest"
				+ " (num, writer, title, content, viewCount, regdate)"
				+ " values(suggest_seq.nextval, ?, ?, ?, ?, sysdate)";
		pstmt = conn.prepareStatement(sql);
		// ? 에 binding 할 내용이 있으면 여기서 binding
		pstmt.setString(1, dto.getWriter());
		pstmt.setString(2, dto.getTitle());
		pstmt.setString(3, dto.getContent());
		pstmt.setInt(4, dto.getViewCount());
		
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

	//글 목록을 리턴하는 메소드
	public List<SuggestDto> getList(){
	List<SuggestDto> list=new ArrayList<>();
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		// Connection 객체의 참조값 얻어오기
		conn = new DbcpBean().getConn();
		// 실행할 sql 문 작성
		String sql = "select *"
				+ " from Suggest"
				+ " order by num desc";
		// PreparedStatement 객체의 참조값 얻어오기
		pstmt = conn.prepareStatement(sql);
		// ? 에 binding할 내용이 있으면 여기서 binding
		// select 문 수행하고 결과를 ResultSet으로 받아옥
		rs = pstmt.executeQuery();
		// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
		// 원하는 Data type으로 포장하기
		while (rs.next()) {
			SuggestDto dto=new SuggestDto();
			dto.setNum(rs.getInt("num"));
			dto.setWriter(rs.getString("writer"));
			dto.setTitle(rs.getString("title"));
			dto.setContent(rs.getString("content"));
			dto.setViewCount(rs.getInt("viewCount"));
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

	//글을 삭제하는 method
	public boolean delete(SuggestDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "delete from suggest"
					+ " where num=?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setInt(1, dto.getNum());
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
	
	// 글을 수정하는 method
	public boolean update(SuggestDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "update suggest"
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
	
	// 해당 글에 대한 정보를 불러오는 method
	public SuggestDto getData(int num) {
		SuggestDto dto=null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select *"
					+ " from suggest"
					+ " where num=?";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setInt(1, num);
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				dto=new SuggestDto();
				dto.setNum(rs.getInt("num"));
				dto.setContent(rs.getString("content"));
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

		return dto;
	}
}

