package test.musicfeed.dao;

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
	
	
}
