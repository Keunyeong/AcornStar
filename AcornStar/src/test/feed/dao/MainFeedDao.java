package test.feed.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.feed.dto.MainFeedDto;
import test.util.DbcpBean;

public class MainFeedDao {
	private static MainFeedDao dao;

	private MainFeedDao() {
		
	}
	
	public static MainFeedDao getInstance() {
		if(dao==null) {
			dao=new MainFeedDao();
		}
		return dao;
	}
	
	// 새 글을 추가하는 method
	public boolean insert(MainFeedDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "insert into main_feed"
					+ " (num, writer, image, content, tag, upcount, upmember, regdate)"
					+ " values(main_feed_seq.nextval, ?, ?, ?, ?, 0, 0, sysdate)";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getWriter());
			pstmt.setString(2, dto.getImage());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getTag());
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
	// 글 리스트 출력하는 method
	public List<MainFeedDto> getList(){
		List<MainFeedDto> list=new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select num, writer, tag, image, content, upcount,upmember, main_feed.regdate as regdate, profile"
					+ " from main_feed"
					+ " INNER JOIN users" 
					+ " ON main_feed.writer = users.id"
					+ " order by num desc";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding할 내용이 있으면 여기서 binding
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			while (rs.next()) {
				MainFeedDto dto=new MainFeedDto();
				dto.setNum(rs.getInt("num"));
				dto.setWriter(rs.getString("writer"));
				dto.setImage(rs.getString("image"));
				dto.setContent(rs.getString("content"));
				dto.setTag(rs.getString("tag"));
				dto.setUpCount(rs.getInt("upCount"));
				dto.setUpMember(rs.getString("upMember"));
				dto.setRegdate(rs.getString("regdate"));
				dto.setProfile(rs.getString("profile"));
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
	// 글을 삭제하는 method
	public boolean delete(MainFeedDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "delete from main_feed"
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
	public boolean update(MainFeedDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "update main_feed"
					+ " SET content=?,tag=?"
					+ " where num=?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getContent());
			pstmt.setString(2, dto.getTag());
			pstmt.setInt(3, dto.getNum());
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
	public MainFeedDto getData(int num) {
		MainFeedDto dto=null;
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "select *"
					+ " from main_feed"
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
				dto=new MainFeedDto();
				dto.setNum(rs.getInt("num"));
				dto.setImage(rs.getString("image"));
				dto.setContent(rs.getString("content"));
				dto.setTag(rs.getString("tag"));
				dto.setUpCount(rs.getInt("upCount"));
				dto.setUpMember(rs.getString("upMember"));
				dto.setWriter(rs.getString("writer"));
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
	
	public boolean addCount(MainFeedDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "UPDATE Main_Feed"
					+ " SET upCount=upCount+1,upMember=?"
					+ " WHERE num=?";
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getUpMember());
			pstmt.setInt(2, dto.getNum());
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
	
	public boolean subtractCount(MainFeedDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "UPDATE Main_Feed"
					+ " SET upCount=upCount-1,upMember=?"
					+ " WHERE num=?";
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getUpMember());
			pstmt.setInt(2, dto.getNum());
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
	
	public MainFeedDto getDataT(MainFeedDto dto) {
		MainFeedDto dto2=null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num,writer, image, content,upCount,tag,upMember, main_feed.regdate as regdate, profile," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
					"	FROM MainFeed" + 
					"	INNER JOIN users" + 
					"	ON main_feed.writer = users.id" + 
					"   WHERE tag LIKE '%'||?||'%'" + 
					"	ORDER BY num DESC)" + 
					" WHERE num=?";
			
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTag());
			pstmt.setInt(2, dto.getNum());
			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if(rs.next()) {
				dto2=new MainFeedDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTag(rs.getString("tag"));
				dto2.setContent(rs.getString("content"));
				dto2.setImage(rs.getString("image"));
				dto2.setProfile(rs.getString("profile"));
				dto2.setUpCount(rs.getInt("upCount"));
				dto2.setUpMember(rs.getString("upMember"));
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
					+ " FROM Main_Feed";
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
	
	public List<MainFeedDto> getList(MainFeedDto dto){
		//글목록을 담을 ArrayList 객체 생성
		List<MainFeedDto> list=new ArrayList<MainFeedDto>();
		
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
					"		        (SELECT num,writer, image, content,upCount,tag,upMember, main_feed.regdate as regdate, profile" + 
					"		        FROM Main_feed" + 
					"				INNER JOIN users" +
					"				ON main_feed.writer = users.id" + 
					"		        ORDER BY num DESC) result1)" + 
					"		WHERE rnum BETWEEN ? AND ?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
			pstmt.setInt(1, dto.getStartRowNum());
			pstmt.setInt(2, dto.getEndRowNum());
			//select 문 수행하고 ResultSet 받아오기
			rs = pstmt.executeQuery();
			//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
			while (rs.next()) {
				MainFeedDto dto2=new MainFeedDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTag(rs.getString("tag"));
				dto2.setContent(rs.getString("content"));
				dto2.setImage(rs.getString("image"));
				dto2.setProfile(rs.getString("profile"));
				dto2.setUpCount(rs.getInt("upCount"));
				dto2.setUpMember(rs.getString("upMember"));
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
	
	public List<MainFeedDto> getListT(MainFeedDto dto){
		//글목록을 담을 ArrayList 객체 생성
		List<MainFeedDto> list=new ArrayList<MainFeedDto>();
		
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
					"		        (SELECT num,writer, image, content,upCount,tag,upMember, main_feed.regdate as regdate, profile" + 
					"		        FROM Main_Feed"+
					"				INNER JOIN users" +
					"				ON main_feed.writer = users.id" +
					"			    WHERE tag LIKE '%' || ? || '%' "+					
					"		        ORDER BY num DESC) result1)" + 
					"		WHERE rnum BETWEEN ? AND ?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
			pstmt.setString(1, dto.getTag());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			//select 문 수행하고 ResultSet 받아오기
			rs = pstmt.executeQuery();
			//while문 혹은 if문에서 ResultSet 으로 부터 data 추출
			while (rs.next()) {
				MainFeedDto dto2=new MainFeedDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setTag(rs.getString("tag"));
				dto2.setContent(rs.getString("content"));
				dto2.setImage(rs.getString("image"));
				dto2.setProfile(rs.getString("profile"));
				dto2.setUpCount(rs.getInt("upCount"));
				dto2.setUpMember(rs.getString("upMember"));
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
	
	public int getCountT(MainFeedDto dto) {
		//글의 갯수를 담을 지역변수 
		int count=0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = new DbcpBean().getConn();
			//select 문 작성
			String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
					+ " FROM Main_Feed"
					+ " WHERE tag LIKE '%'||?||'%' ";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할게 있으면 여기서 바인딩한다.
			pstmt.setString(1, dto.getTag());
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
