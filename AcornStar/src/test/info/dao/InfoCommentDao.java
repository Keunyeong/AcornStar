package test.info.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.info.dto.InfoCommentDto;
import test.util.DbcpBean;

public class InfoCommentDao {
   private static InfoCommentDao dao;
   
   /*
    *    [static 초기화 블럭]
    *  - 이 class가 최초 사용될 때 한 번만 수행되는 블럭
    *  - static 자원을 초기화할 때 사용한다.
    */
   static {
      dao=new InfoCommentDao();
   }
   
   private InfoCommentDao() {
      
   }

   /*
   public static InfoCommentDao getInstance() {
      if(dao==null) {
         dao=new InfoCommentDao();
      }
      return dao;
   }
   */
   // 자신의 참조값을 return 해주는 method
   public static InfoCommentDao getInstance() {
      return dao;
   }
   
   // 댓글의 sequence 값을 미리 return해주는 method
   public int getSequence() {
      int seq=0;
      
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      try {
         // Connection 객체의 참조값 얻어오기
         conn = new DbcpBean().getConn();
         // 실행할 sql 문 작성
         String sql = "select info_comment_seq.nextval as seq"
               + " from dual";
         // PreparedStatement 객체의 참조값 얻어오기
         pstmt = conn.prepareStatement(sql);
         // ? 에 binding할 내용이 있으면 여기서 binding

         // select 문 수행하고 결과를 ResultSet으로 받아오기
         rs = pstmt.executeQuery();
         //  ResultSet 객체에 있는 내용을 추출해서
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
   
   // 댓글 추가
   public boolean insert(InfoCommentDto dto) {
      Connection conn = null;
      PreparedStatement pstmt = null;
      int flag = 0;
      try {
         conn = new DbcpBean().getConn();
         // 실행할 sql 문 작성
         String sql = "insert into info_comment"
               + " (num, writer, content, target_id, ref_group, comment_group, regdate)"
               + " values(?, ?, ?, ?, ?, ?, sysdate)";
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
   
   // 댓글 목록을 return하는 method
   public List<InfoCommentDto> getList(InfoCommentDto dto){
      List<InfoCommentDto> list=new ArrayList<>();
      
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      try {
         // Connection 객체의 참조값 얻어오기
         conn = new DbcpBean().getConn();
         // 실행할 sql 문 작성
      String sql = "select *" + 
            " from" + 
            "   (select result1.*, rownum as rnum\r\n" + 
            "   from" + 
            "      (select num, writer, content, target_id, ref_group," + 
            "      comment_group, deleted, info_comment.regdate, profile" + 
            "      from info_comment" + 
            "      inner join users" + 
            "      on info_comment.writer = users.id" + 
            "      where ref_group=?" + 
            "      order by comment_group asc, num asc) result1)" + 
            " where rnum between ? and ?";
         // PreparedStatement 객체의 참조값 얻어오기
         pstmt = conn.prepareStatement(sql);
         // ? 에 binding할 내용이 있으면 여기서 binding
         pstmt.setInt(1, dto.getRef_group());
         pstmt.setInt(2, dto.getStartRowNum());
         pstmt.setInt(3, dto.getEndRowNum());
         // select 문 수행하고 결과를 ResultSet으로 받아옥
         rs = pstmt.executeQuery();
         // 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
         // 원하는 Data type으로 포장하기
         while (rs.next()) {
            InfoCommentDto dto2=new InfoCommentDto();
            dto2.setNum(rs.getInt("num"));
            dto2.setWriter(rs.getString("writer"));
            dto2.setContent(rs.getString("content"));
            dto2.setTarget_id(rs.getString("target_id"));
            dto2.setRef_group(rs.getInt("ref_group"));
            dto2.setComment_group(rs.getInt("comment_group"));
            dto2.setDeleted(rs.getString("deleted"));
            dto2.setRegdate(rs.getString("regdate"));
            dto2.setProfile(rs.getString("profile"));
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
   
   // 댓글을 삭제하는 method
   public boolean delete(int num) {
      Connection conn = null;
      PreparedStatement pstmt = null;
      int flag = 0;
      try {
         conn = new DbcpBean().getConn();
         // 실행할 sql 문 작성
         String sql = "update info_comment"
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
   
   // 댓글 내용을 수정하는 method
   public boolean update(InfoCommentDto dto) {
      Connection conn = null;
      PreparedStatement pstmt = null;
      int flag = 0;
      try {
         conn = new DbcpBean().getConn();
         // 실행할 sql 문 작성
         String sql = "update info_comment"
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
   
   // 전체 댓글의 개수를 return하는 method
   public int getCount(int ref_group) {
      int count=0;
      
      Connection conn = null;
      PreparedStatement pstmt = null;
      ResultSet rs = null;
      try {
         // Connection 객체의 참조값 얻어오기
         conn = new DbcpBean().getConn();
         // 실행할 sql 문 작성
         String sql = "select nvl(max(rownum), 0) as count"
               + " from info_comment"
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
}