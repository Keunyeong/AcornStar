package test.chat.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.chat.dto.ChatDto;
import test.util.DbcpBean;

public class ChatDao {
	private static ChatDao dao;
	
	private ChatDao() {
		
	}
	
	public static ChatDao getInstance() {
		if(dao==null) {
			dao=new ChatDao();
		}
		return dao;
	}
	
	public boolean insert(ChatDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = "insert into chat"
					+ " (num, writer, content)"
					+ " values(chat_seq.nextval, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			// ? 에 binding 할 내용이 있으면 여기서 binding
			pstmt.setString(1, dto.getWriter());
			pstmt.setString(2, dto.getContent());
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
	
	public List<ChatDto> getList() {
		List<ChatDto> list=new ArrayList<>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			// 실행할 sql 문 작성
			String sql = " select *"
					+ " from"
					+ 		" (select result1.*, rownum as rnum"
					+		" from"
					+				" (select *"
					+				" from chat"
					+				" order by num desc) result1)"
					+ " where rnum<=6"
					+ " order by rnum desc";
			// PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			// select 문 수행하고 결과를 ResultSet으로 받아옥
			rs = pstmt.executeQuery();
			// 반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서
			// 원하는 Data type으로 포장하기
			while (rs.next()) {
				ChatDto dto=new ChatDto();
				dto.setNum(rs.getInt("num"));
				dto.setWriter(rs.getString("writer"));
				dto.setContent(rs.getString("content"));
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
