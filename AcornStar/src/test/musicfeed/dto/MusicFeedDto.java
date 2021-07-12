package test.musicfeed.dto;

public class MusicFeedDto {
	// fields
	private int num;
	private String writer;
	private String title;
	private String content;
	private String link;
	private int upCount;
	private String tag;
	private String regdate;
	private int startRowNum;
	private int endRowNum;
	
	// default constructor
	public MusicFeedDto() {
		
	}

	public MusicFeedDto(int num, String writer, String title, String content, String link, int upCount, String tag,
			String regdate, int startRowNum, int endRowNum) {
		super();
		this.num = num;
		this.writer = writer;
		this.title = title;
		this.content = content;
		this.link = link;
		this.upCount = upCount;
		this.tag = tag;
		this.regdate = regdate;
		this.startRowNum = startRowNum;
		this.endRowNum = endRowNum;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public int getUpCount() {
		return upCount;
	}

	public void setUpCount(int upCount) {
		this.upCount = upCount;
	}

	public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public String getRegdate() {
		return regdate;
	}

	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}

	public int getStartRowNum() {
		return startRowNum;
	}

	public void setStartRowNum(int startRowNum) {
		this.startRowNum = startRowNum;
	}

	public int getEndRowNum() {
		return endRowNum;
	}

	public void setEndRowNum(int endRowNum) {
		this.endRowNum = endRowNum;
	}
	
}
