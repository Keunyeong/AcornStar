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
				+ " (num, writer, title, content, regdate)"
				+ " values(suggest_seq.nextval, ?, ?, ?, sysdate)";
		pstmt = conn.prepareStatement(sql);
		// ? 에 binding 할 내용이 있으면 여기서 binding
		pstmt.setString(1, dto.getWriter());
		pstmt.setString(2, dto.getTitle());
		pstmt.setString(3, dto.getContent());
		
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
	public List<SuggestDto> getList(SuggestDto dto){
	List<SuggestDto> list=new ArrayList<SuggestDto>();
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	try {
		// Connection 객체의 참조값 얻어오기
		conn = new DbcpBean().getConn();
		// 실행할 sql 문 작성
		String sql = "select *"
				+ " from suggest"
				+ " order by num desc";
		// PreparedStatement 객체의 참조값 얻어오기
		pstmt = conn.prepareStatement(sql);
		// ? 에 binding할 내용이 있으면 여기서 binding
		// select 문 수행하고 결과를 ResultSet으로 받아옥
		rs = pstmt.executeQuery();
		// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
		// 원하는 Data type으로 포장하기
		while (rs.next()) {
			SuggestDto dto2=new SuggestDto();
			dto.setNum(rs.getInt("num"));
			dto.setWriter(rs.getString("writer"));
			dto.setTitle(rs.getString("title"));
			dto.setContent(rs.getString("content"));
			dto.setRegdate(rs.getString("regdate"));
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
	
	
	//글하나의 정보를 리턴하는 메소드
	public SuggestDto getData(int num) {
		SuggestDto dto2=null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT num,title,writer,content,viewCount,regdate"
					+ " FROM suggest"
					+ " WHERE num=?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, num);
			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if(rs.next()) {
				dto2=new SuggestDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setRegdate(rs.getString("regdate"));
				dto2.setPrevNum(rs.getInt("prevNum"));
				dto2.setNextNum(rs.getInt("nextNum"));
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
	
	//글하나의 정보를 리턴하는 메소드
	public SuggestDto getData(SuggestDto dto) {
		SuggestDto dto2=null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num,title,writer,content,viewCount,regdate," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
					"	FROM board_cafe" + 
					"	ORDER BY num DESC)" + 
					" WHERE num=?";
			
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getNum());
			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if(rs.next()) {
				dto2=new SuggestDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setRegdate(rs.getString("regdate"));
				dto2.setPrevNum(rs.getInt("prevNum"));
				dto2.setNextNum(rs.getInt("nextNum"));
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
	
	public SuggestDto getDataT(SuggestDto dto) {
		SuggestDto dto2=null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num,title,writer,content,viewCount,regdate," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
					"	FROM board_cafe"+ 
					"   WHERE title LIKE '%'||?||'%'" + 
					"	ORDER BY num DESC)" + 
					" WHERE num=?";
			
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());
			pstmt.setInt(2, dto.getNum());
			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if(rs.next()) {
				dto2=new SuggestDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setRegdate(rs.getString("regdate"));
				dto2.setPrevNum(rs.getInt("prevNum"));
				dto2.setNextNum(rs.getInt("nextNum"));
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
	public SuggestDto getDataW(SuggestDto dto) {
		SuggestDto dto2=null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num,title,writer,content,viewCount,regdate," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
					"	FROM board_cafe"+ 
					"   WHERE writer LIKE '%'||?||'%'" + 
					"	ORDER BY num DESC)" + 
					" WHERE num=?";
			
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getWriter());
			pstmt.setInt(2, dto.getNum());
			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if(rs.next()) {
				dto2=new SuggestDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setRegdate(rs.getString("regdate"));
				dto2.setPrevNum(rs.getInt("prevNum"));
				dto2.setNextNum(rs.getInt("nextNum"));
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
	public SuggestDto getDataTC(SuggestDto dto) {
		SuggestDto dto2=null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num,title,writer,content,viewCount,regdate," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
					"	FROM board_cafe"+ 
					"   WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%'" + 
					"	ORDER BY num DESC)" + 
					" WHERE num=?";
			
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getNum());
			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if(rs.next()) {
				dto2=new SuggestDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTitle(rs.getString("title"));
				dto2.setContent(rs.getString("content"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setRegdate(rs.getString("regdate"));
				dto2.setPrevNum(rs.getInt("prevNum"));
				dto2.setNextNum(rs.getInt("nextNum"));
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
	
	//전체 글의 갯수를 리턴하는 메소드
		public int getCount() {
			//글의 갯수를 담을 지역변수 
			int count=0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//select 문 작성
				String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
						+ " FROM suggest";
				pstmt = conn.prepareStatement(sql);
				// ? 에 바인딩 할게 있으면 여기서 바인딩한다.

				//select 문 수행하고 ResultSet 받아오기
				rs = pstmt.executeQuery();
				//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
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
		/*
		 *  Title 검색일때 실행할 메소드
		 *  SuggestDto 의 title 이라는 필드에 검색 키워드가 들어 있다.
		 */
		public List<SuggestDto> getListT(SuggestDto dto){
			//글목록을 담을 ArrayList 객체 생성
			List<SuggestDto> list=new ArrayList<SuggestDto>();
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//select 문 작성
				String sql = "SELECT *" + 
						"		FROM" + 
						"		    (SELECT result1.*, ROWNUM AS rnum" + 
						"		    FROM" + 
						"		        (SELECT num,writer,title,viewCount,regdate" + 
						"		        FROM board_cafe"+ 
						"			    WHERE title LIKE '%' || ? || '%' "+					
						"		        ORDER BY num DESC) result1)" + 
						"		WHERE rnum BETWEEN ? AND ?";
				pstmt = conn.prepareStatement(sql);
				// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
				pstmt.setString(1, dto.getTitle());
				pstmt.setInt(2, dto.getStartRowNum());
				pstmt.setInt(3, dto.getEndRowNum());
				//select 문 수행하고 ResultSet 받아오기
				rs = pstmt.executeQuery();
				//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
				while (rs.next()) {
					SuggestDto dto2=new SuggestDto();
					dto2.setNum(rs.getInt("num"));
					dto2.setWriter(rs.getString("writer"));
					dto2.setTitle(rs.getString("title"));
					dto2.setViewCount(rs.getInt("viewCount"));
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
		/*
		 *  Writer 검색일때 실행할 메소드
		 *   writer 이라는 필드에 검색 키워드가 들어 있다.
		 */
		public List<SuggestDto> getListW(SuggestDto dto){
			//글목록을 담을 ArrayList 객체 생성
			List<SuggestDto> list=new ArrayList<SuggestDto>();
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//select 문 작성
				String sql = "SELECT *" + 
						"		FROM" + 
						"		    (SELECT result1.*, ROWNUM AS rnum" + 
						"		    FROM" + 
						"		        (SELECT num,writer,title,viewCount,regdate" + 
						"		        FROM suggest"+ 
						"			    WHERE writer LIKE '%' || ? || '%' "+					
						"		        ORDER BY num DESC) result1)" + 
						"		WHERE rnum BETWEEN ? AND ?";
				pstmt = conn.prepareStatement(sql);
				// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
				pstmt.setString(1, dto.getWriter());
				pstmt.setInt(2, dto.getStartRowNum());
				pstmt.setInt(3, dto.getEndRowNum());
				//select 문 수행하고 ResultSet 받아오기
				rs = pstmt.executeQuery();
				//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
				while (rs.next()) {
					SuggestDto dto2=new SuggestDto();
					dto2.setNum(rs.getInt("num"));
					dto2.setWriter(rs.getString("writer"));
					dto2.setTitle(rs.getString("title"));
					dto2.setViewCount(rs.getInt("viewCount"));
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
		/*
		 *  Title, Content 검색일때 실행할 메소드
		 *  SuggestDto 의 title, content 이라는 필드에 검색 키워드가 들어 있다.
		 */
		public List<SuggestDto> getListTC(SuggestDto dto){
			//글목록을 담을 ArrayList 객체 생성
			List<SuggestDto> list=new ArrayList<SuggestDto>();
			
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//select 문 작성
				String sql = "SELECT *" + 
						"		FROM" + 
						"		    (SELECT result1.*, ROWNUM AS rnum" + 
						"		    FROM" + 
						"		        (SELECT num,writer,title,viewCount,regdate" + 
						"		        FROM suggest"+ 
						"			    WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%' "+					
						"		        ORDER BY num DESC) result1)" + 
						"		WHERE rnum BETWEEN ? AND ?";
				pstmt = conn.prepareStatement(sql);
				// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
				pstmt.setString(1, dto.getTitle());
				pstmt.setString(2, dto.getContent());
				pstmt.setInt(3, dto.getStartRowNum());
				pstmt.setInt(4, dto.getEndRowNum());
				//select 문 수행하고 ResultSet 받아오기
				rs = pstmt.executeQuery();
				//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
				while (rs.next()) {
					SuggestDto dto2=new SuggestDto();
					dto2.setNum(rs.getInt("num"));
					dto2.setWriter(rs.getString("writer"));
					dto2.setTitle(rs.getString("title"));
					dto2.setViewCount(rs.getInt("viewCount"));
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
		//제목 검색했을때 전체 row 의 갯수 리턴
		public int getCountT(SuggestDto dto) {
			//글의 갯수를 담을 지역변수 
			int count=0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//select 문 작성
				String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
						+ " FROM suggest"
						+ " WHERE title LIKE '%'||?||'%' ";
				pstmt = conn.prepareStatement(sql);
				// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
				pstmt.setString(1, dto.getTitle());
				//select 문 수행하고 ResultSet 받아오기
				rs = pstmt.executeQuery();
				//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
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
		//작성자 검색했을때 전체 row 의 갯수 리턴
		public int getCountW(SuggestDto dto) {
			//글의 갯수를 담을 지역변수 
			int count=0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//select 문 작성
				String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
						+ " FROM suggest"
						+ " WHERE writer LIKE '%'||?||'%' ";
				pstmt = conn.prepareStatement(sql);
				// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
				pstmt.setString(1, dto.getWriter());
				//select 문 수행하고 ResultSet 받아오기
				rs = pstmt.executeQuery();
				//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
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
		//제목, 내용 검색했을때 전체 row 의 갯수 리턴
		public int getCountTC(SuggestDto dto) {
			//글의 갯수를 담을 지역변수 
			int count=0;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				conn = new DbcpBean().getConn();
				//select 문 작성
				String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
						+ " FROM suggest"
						+ " WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%'";
				pstmt = conn.prepareStatement(sql);
				// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
				pstmt.setString(1, dto.getTitle());
				pstmt.setString(2, dto.getContent());
				//select 문 수행하고 ResultSet 받아오기
				rs = pstmt.executeQuery();
				//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
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

