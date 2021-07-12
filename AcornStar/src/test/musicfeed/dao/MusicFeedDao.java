package test.musicfeed.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.musicfeed.dto.MusicFeedDto;
import test.util.DbcpBean;

public class MusicFeedDao {
	private static MusicFeedDao dao;
	
	private MusicFeedDao() {
		
	}
	
	public static MusicFeedDao getInstance() {
		if(dao==null) {
			dao=new MusicFeedDao();
		}
		return dao;
	}
	
	// 게시글을 추가하는 method
	public boolean insert(MusicFeedDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "insert into music_feed"
					+ " (num, writer, title, content, link, upCount, regdate)"
					+ " values(music_feed_seq.nextval, ?, ?, ?, ?, 0, sysdate)";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getWriter());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getLink());
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
	
	// 게시글 list를 불러오는 method
	public List<MusicFeedDto> getList(MusicFeedDto dto){
		List<MusicFeedDto> list=new ArrayList<>();
		
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
					+ 				" (select num, writer, title, content, link, upCount, tag, regdate"
					+ 				" from music_feed"
					+ 				" order by num desc) result1)"
					+ " where rnum between ? and ?";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setInt(1, dto.getStartRowNum());
			pstmt.setInt(2, dto.getEndRowNum());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			while (rs.next()) {
				MusicFeedDto dto2=new MusicFeedDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setLink(rs.getString("link"));
				dto2.setUpCount(rs.getInt("upCount"));
				dto2.setTag(rs.getString("tag"));
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
	
	// 글 전체의 개수를 return 하는 method
	public int getCount() {
		int count=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select nvl(max(rownum),0) as num"
					+ " from music_feed";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			// 없음
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("num");
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
	
	// 게시글을 삭제하는 method
	public boolean delete(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "delete from music_feed"
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
	
	// 게시글 하나의 정보를 불러오는 method (번호로)
		public MusicFeedDto getData(int num) {
			MusicFeedDto dto2=null;
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				// Connection 객체의 참조값 얻어오기
				conn = new DbcpBean().getConn();
				// 실행할 sql 문 작성
				String sql = "select *"
						+ " from music_feed"
						+ " where num=?";
				// PreparedStatement 객체의 참조값 얻어오기
				pstmt = conn.prepareStatement(sql);
				// ? 에 binding할 내용이 있으면 여기서 binding
				pstmt.setInt(1, num);
				// select 문 수행하고 결과를 ResultSet으로 받아옥
				rs = pstmt.executeQuery();
				// 변화하는 줄이 있다면
				// 원하는 Data type으로 포장하기
				if (rs.next()) {
					dto2=new MusicFeedDto();
					dto2.setNum(rs.getInt("num"));
					dto2.setWriter(rs.getString("writer"));
					dto2.setTitle(rs.getString("title"));
					dto2.setContent(rs.getString("content"));
					dto2.setLink(rs.getString("link"));
					dto2.setUpCount(rs.getInt("upCount"));
					dto2.setTag(rs.getString("tag"));
					dto2.setRegdate(rs.getString("regdate"));
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

			return dto2;
		}
	
	// 게시글 하나의 정보를 불러오는 method (dto로)
	public MusicFeedDto getData(MusicFeedDto dto) {
		MusicFeedDto dto2=null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select *"
					+ " from music_feed"
					+ " where num=?";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setInt(1, dto.getNum());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 변화하는 줄이 있다면
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				dto2=new MusicFeedDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setLink(rs.getString("link"));
				dto2.setUpCount(rs.getInt("upCount"));
				dto2.setTag(rs.getString("tag"));
				dto2.setRegdate(rs.getString("regdate"));
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

		return dto2;
	}
	
	public boolean update(MusicFeedDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "update music_feed"
					+ " set title=?, content=?, link=?"
					+ " where num=?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setString(3, dto.getLink());
			pstmt.setInt(4, dto.getNum());
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
	
	// 제목으로 게시글 list를 불러오는 method
	public List<MusicFeedDto> getListT(MusicFeedDto dto){
		List<MusicFeedDto> list=new ArrayList<>();
		
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
					+ 				" (select num, writer, title, content, link, upCount, tag, regdate"
					+ 				" from music_feed"
					+				" where title like '%' || ? || '%'"
					+ 				" order by num desc) result1)"
					+ " where rnum between ? and ?";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getTitle());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			while (rs.next()) {
				MusicFeedDto dto2=new MusicFeedDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setLink(rs.getString("link"));
				dto2.setUpCount(rs.getInt("upCount"));
				dto2.setTag(rs.getString("tag"));
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
	
	// 작성자로 게시글 list를 불러오는 method
	public List<MusicFeedDto> getListW(MusicFeedDto dto){
		List<MusicFeedDto> list=new ArrayList<>();
		
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
					+ 				" (select num, writer, title, content, link, upCount, tag, regdate"
					+ 				" from music_feed"
					+				" where writer like '%' || ? || '%'"
					+ 				" order by num desc) result1)"
					+ " where rnum between ? and ?";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getWriter());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			while (rs.next()) {
				MusicFeedDto dto2=new MusicFeedDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setLink(rs.getString("link"));
				dto2.setUpCount(rs.getInt("upCount"));
				dto2.setTag(rs.getString("tag"));
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
	
	// 제목, 내용으로 게시글 list를 불러오는 method
	public List<MusicFeedDto> getListTC(MusicFeedDto dto){
		List<MusicFeedDto> list=new ArrayList<>();
		
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
					+ 				" (select num, writer, title, content, link, upCount, tag, regdate"
					+ 				" from music_feed"
					+				" where title like '%' || ? || '%' or content like '%' || ? || '%'"
					+ 				" order by num desc) result1)"
					+ " where rnum between ? and ?";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getStartRowNum());
			pstmt.setInt(4, dto.getEndRowNum());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			while (rs.next()) {
				MusicFeedDto dto2=new MusicFeedDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setLink(rs.getString("link"));
				dto2.setUpCount(rs.getInt("upCount"));
				dto2.setTag(rs.getString("tag"));
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
	
	// 제목으로 글의 개수를 return 하는 method
	public int getCountT(MusicFeedDto dto) {
		int count=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select nvl(max(rownum),0) as num"
					+ " from music_feed"
					+ " where title like '%' || ? || '%'";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getTitle());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("num");
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
	
	// 작성자로 글의 개수를 return 하는 method
	public int getCountW(MusicFeedDto dto) {
		int count=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select nvl(max(rownum),0) as num"
					+ " from music_feed"
					+ " where writer like '%' || ? || '%'";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getWriter());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("num");
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
	
	// 제목으로 글의 개수를 return 하는 method
	public int getCountTC(MusicFeedDto dto) {
		int count=0;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select nvl(max(rownum),0) as num"
					+ " from music_feed"
					+ " where title like '%' || ? || '%' or content like '%' || ? || '%'";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("num");
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
}
