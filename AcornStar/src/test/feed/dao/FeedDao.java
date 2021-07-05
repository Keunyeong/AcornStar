package test.feed.dao;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.feed.dto.FeedDto;
import test.feed.dto.FeedDto;
import test.util.DbcpBean;

public class FeedDao {
	private static FeedDao dao;
	private FeedDao() {}
	public static FeedDao getInstance() {
		if(dao==null) {
			dao=new FeedDao();
		}
		return dao;
	}
	
	public List<FeedDto> getListW(FeedDto dto){
	      //글목록을 담을 ArrayList 객체 생성
	      List<FeedDto> list=new ArrayList<FeedDto>();
	      
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         conn = new DbcpBean().getConn();
	         //select 문 작성
	         String sql = "SELECT *" + 
	               "      FROM" + 
	               "          (SELECT result1.*, ROWNUM AS rnum" + 
	               "          FROM" + 
	               "              (SELECT num,writer,tag,upCount,regdate" + 
	               "              FROM feed"+ 
	               "             WHERE writer LIKE '%' || ? || '%' "+               
	               "              ORDER BY num DESC) result1)" + 
	               "      WHERE rnum BETWEEN ? AND ?";
	         pstmt = conn.prepareStatement(sql);
	         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
	         pstmt.setString(1, dto.getWriter());
	         pstmt.setInt(2, dto.getStartRowNum());
	         pstmt.setInt(3, dto.getEndRowNum());
	         //select 문 수행하고 ResultSet 받아오기
	         rs = pstmt.executeQuery();
	         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
	         while (rs.next()) {
	            FeedDto dto2=new FeedDto();
	            dto2.setNum(rs.getInt("num"));
	            dto2.setWriter(rs.getString("writer"));
	            dto2.setTag(rs.getString("tag"));
	            dto2.setUpCount(rs.getInt("upCount"));
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
	               + " FROM feed";
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

	//제목, 내용 검색했을때 전체 row 의 갯수 리턴
	   public int getCountTC(FeedDto dto) {
	      //글의 갯수를 담을 지역변수 
	      int count=0;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         conn = new DbcpBean().getConn();
	         //select 문 작성
	         String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
	               + " FROM feed"
	               + " WHERE tag LIKE '%'||?||'%' OR content LIKE '%'||?||'%'";
	         pstmt = conn.prepareStatement(sql);
	         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
	         pstmt.setString(1, dto.getTag());
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
	   public int getCountT(FeedDto dto) {
		      //글의 갯수를 담을 지역변수 
		      int count=0;
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
		               + " FROM feed"
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
	//글 목록을 리턴하는 메소드 
	   public List<FeedDto> getList(FeedDto dto){
	      //글목록을 담을 ArrayList 객체 생성
	      List<FeedDto> list=new ArrayList<FeedDto>();
	      
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         conn = new DbcpBean().getConn();
	         //select 문 작성
	         String sql = "SELECT *" + 
	               "      FROM" + 
	               "          (SELECT result1.*, ROWNUM AS rnum" + 
	               "          FROM" + 
	               "              (SELECT num,writer,tag,upCount,regdate" + 
	               "              FROM board_cafe" + 
	               "              ORDER BY num DESC) result1)" + 
	               "      WHERE rnum BETWEEN ? AND ?";
	         pstmt = conn.prepareStatement(sql);
	         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
	         pstmt.setInt(1, dto.getStartRowNum());
	         pstmt.setInt(2, dto.getEndRowNum());
	         //select 문 수행하고 ResultSet 받아오기
	         rs = pstmt.executeQuery();
	         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
	         while (rs.next()) {
	            FeedDto dto2=new FeedDto();
	            dto2.setNum(rs.getInt("num"));
	            dto2.setWriter(rs.getString("writer"));
	            dto2.setTag(rs.getString("tag"));
	            dto2.setUpCount(rs.getInt("upCount"));
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
	   public List<FeedDto> getListTC(FeedDto dto){
		      //글목록을 담을 ArrayList 객체 생성
		      List<FeedDto> list=new ArrayList<FeedDto>();
		      
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT *" + 
		               "      FROM" + 
		               "          (SELECT result1.*, ROWNUM AS rnum" + 
		               "          FROM" + 
		               "              (SELECT num,writer,tag,upCount,regdate" + 
		               "              FROM feed"+ 
		               "             WHERE tag LIKE '%'||?||'%' OR content LIKE '%'||?||'%' "+               
		               "              ORDER BY num DESC) result1)" + 
		               "      WHERE rnum BETWEEN ? AND ?";
		         pstmt = conn.prepareStatement(sql);
		         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
		         pstmt.setString(1, dto.getTag());
		         pstmt.setString(2, dto.getContent());
		         pstmt.setInt(3, dto.getStartRowNum());
		         pstmt.setInt(4, dto.getEndRowNum());
		         //select 문 수행하고 ResultSet 받아오기
		         rs = pstmt.executeQuery();
		         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
		         while (rs.next()) {
		            FeedDto dto2=new FeedDto();
		            dto2.setNum(rs.getInt("num"));
		            dto2.setWriter(rs.getString("writer"));
		            dto2.setTag(rs.getString("tag"));
		            dto2.setUpCount(rs.getInt("upCount"));
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
	   public List<FeedDto> getListT(FeedDto dto){
		      //글목록을 담을 ArrayList 객체 생성
		      List<FeedDto> list=new ArrayList<FeedDto>();
		      
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT *" + 
		               "      FROM" + 
		               "          (SELECT result1.*, ROWNUM AS rnum" + 
		               "          FROM" + 
		               "              (SELECT num,writer,tag,upCount,regdate" + 
		               "              FROM feed"+ 
		               "             WHERE tag LIKE '%' || ? || '%' "+               
		               "              ORDER BY num DESC) result1)" + 
		               "      WHERE rnum BETWEEN ? AND ?";
		         pstmt = conn.prepareStatement(sql);
		         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
		         pstmt.setString(1, dto.getTag());
		         pstmt.setInt(2, dto.getStartRowNum());
		         pstmt.setInt(3, dto.getEndRowNum());
		         //select 문 수행하고 ResultSet 받아오기
		         rs = pstmt.executeQuery();
		         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
		         while (rs.next()) {
		            FeedDto dto2=new FeedDto();
		            dto2.setNum(rs.getInt("num"));
		            dto2.setWriter(rs.getString("writer"));
		            dto2.setTag(rs.getString("tag"));
		            dto2.setUpCount(rs.getInt("upCount"));
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
	//글 하나의 정보를 삭제하는 메소드
	public boolean delete(int num) {
		Connection conn = null;
	      PreparedStatement pstmt = null;
	      int flag = 0;
	      try {
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "DELETE FROM feed"
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
	
	//글 하나의 정보를 수정하는 메소드
	public boolean update(FeedDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "UPDATE feed"
					+ " SET tag=?,content=?"
					+ " WHERE num=?";
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTag());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getNum());
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
	
	//조회수 증가 시키는 메소드
	public boolean addUpCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "UPDATE feed"
					+ " SET UpCount=UpCount+1"
					+ " WHERE num=?";
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
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
}
